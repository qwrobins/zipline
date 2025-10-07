#!/bin/bash

# File Ownership Tracker
# Tracks which files are being modified by which stories/agents to detect conflicts early

set -euo pipefail

# Configuration
REGISTRY_FILE=".agent-orchestration/file-ownership-registry.json"
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Initialize registry if it doesn't exist
initialize_registry() {
    if [ ! -f "$REGISTRY_FILE" ]; then
        mkdir -p "$(dirname "$REGISTRY_FILE")"
        echo '{
  "file_ownership": {},
  "potential_conflicts": [],
  "last_updated": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
}' > "$REGISTRY_FILE"
        log_info "Initialized file ownership registry at $REGISTRY_FILE"
    fi
}

# Register files for a story
register_files() {
    local story_id="$1"
    local agent_name="$2"
    local worktree_path="$3"
    shift 3
    local files=("$@")
    
    initialize_registry
    
    log_info "Registering ${#files[@]} files for story $story_id"
    
    # Check for conflicts before registering
    local conflicts=()
    for file in "${files[@]}"; do
        # Check if file is already owned by another story
        local existing_owner=$(jq -r ".file_ownership[\"$file\"].story_id // empty" "$REGISTRY_FILE")
        if [ -n "$existing_owner" ] && [ "$existing_owner" != "$story_id" ]; then
            conflicts+=("$file:$existing_owner")
        fi
    done
    
    # Report conflicts if any
    if [ ${#conflicts[@]} -gt 0 ]; then
        log_warning "Potential conflicts detected:"
        for conflict in "${conflicts[@]}"; do
            IFS=':' read -r file existing_story <<< "$conflict"
            log_warning "  - $file (already owned by story $existing_story)"
            
            # Add to potential_conflicts in registry
            local conflict_entry=$(jq -n \
                --arg file "$file" \
                --arg story1 "$existing_story" \
                --arg story2 "$story_id" \
                --arg severity "high" \
                --arg detected_at "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
                '{
                    file: $file,
                    stories: [$story1, $story2],
                    severity: $severity,
                    detected_at: $detected_at
                }')
            
            # Add to registry
            jq ".potential_conflicts += [$conflict_entry]" "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp"
            mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"
        done
    fi
    
    # Register files
    for file in "${files[@]}"; do
        local file_entry=$(jq -n \
            --arg story_id "$story_id" \
            --arg agent "$agent_name" \
            --arg status "in_progress" \
            --arg worktree "$worktree_path" \
            --arg registered_at "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
            '{
                story_id: $story_id,
                agent: $agent,
                status: $status,
                worktree: $worktree,
                registered_at: $registered_at
            }')
        
        jq ".file_ownership[\"$file\"] = $file_entry | .last_updated = \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"" "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp"
        mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"
    done
    
    log_success "Registered ${#files[@]} files for story $story_id"
    
    # Return conflict count
    echo "${#conflicts[@]}"
}

# Unregister files for a story
unregister_files() {
    local story_id="$1"
    
    if [ ! -f "$REGISTRY_FILE" ]; then
        log_warning "Registry file not found"
        return 0
    fi
    
    log_info "Unregistering files for story $story_id"
    
    # Remove files owned by this story
    jq "del(.file_ownership[] | select(.story_id == \"$story_id\")) | .last_updated = \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"" "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp"
    mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"
    
    # Remove conflicts involving this story
    jq "del(.potential_conflicts[] | select(.stories[] == \"$story_id\")) | .last_updated = \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"" "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp"
    mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"
    
    log_success "Unregistered files for story $story_id"
}

# List file ownership
list_ownership() {
    if [ ! -f "$REGISTRY_FILE" ]; then
        log_info "No file ownership registry found"
        return 0
    fi
    
    log_info "File Ownership:"
    echo ""
    
    # List owned files
    jq -r '.file_ownership | to_entries[] | "  \(.key) → Story \(.value.story_id) (\(.value.agent))"' "$REGISTRY_FILE"
    
    echo ""
    log_info "Potential Conflicts:"
    echo ""
    
    # List conflicts
    local conflict_count=$(jq '.potential_conflicts | length' "$REGISTRY_FILE")
    if [ "$conflict_count" -eq 0 ]; then
        echo "  None"
    else
        jq -r '.potential_conflicts[] | "  \(.file) → Stories: \(.stories | join(", ")) [\(.severity) severity]"' "$REGISTRY_FILE"
    fi
}

# Check for conflicts with a list of files
check_conflicts() {
    local story_id="$1"
    shift
    local files=("$@")
    
    if [ ! -f "$REGISTRY_FILE" ]; then
        echo "0"
        return 0
    fi
    
    local conflicts=0
    for file in "${files[@]}"; do
        local existing_owner=$(jq -r ".file_ownership[\"$file\"].story_id // empty" "$REGISTRY_FILE")
        if [ -n "$existing_owner" ] && [ "$existing_owner" != "$story_id" ]; then
            ((conflicts++))
            log_warning "Conflict: $file is owned by story $existing_owner"
        fi
    done
    
    echo "$conflicts"
}

# Detect files changed in a worktree
detect_changed_files() {
    local worktree_path="$1"
    local base_branch="${2:-main}"
    
    if [ ! -d "$worktree_path" ]; then
        log_error "Worktree path not found: $worktree_path"
        return 1
    fi
    
    # Get the branch name from worktree
    local branch_name=$(basename "$worktree_path")
    
    # Get files changed in the worktree
    git diff --name-only "$base_branch...$branch_name" 2>/dev/null || echo ""
}

# Auto-register files from worktree
auto_register() {
    local story_id="$1"
    local agent_name="$2"
    local worktree_path="$3"
    local base_branch="${4:-main}"
    
    log_info "Auto-detecting changed files in worktree: $worktree_path"
    
    # Detect changed files
    local changed_files=$(detect_changed_files "$worktree_path" "$base_branch")
    
    if [ -z "$changed_files" ]; then
        log_info "No changed files detected"
        return 0
    fi
    
    # Convert to array
    local files_array=()
    while IFS= read -r file; do
        files_array+=("$file")
    done <<< "$changed_files"
    
    log_info "Detected ${#files_array[@]} changed files"
    
    # Register files
    register_files "$story_id" "$agent_name" "$worktree_path" "${files_array[@]}"
}

# Get conflicts for a story
get_conflicts() {
    local story_id="$1"
    
    if [ ! -f "$REGISTRY_FILE" ]; then
        echo "[]"
        return 0
    fi
    
    jq ".potential_conflicts | map(select(.stories[] == \"$story_id\"))" "$REGISTRY_FILE"
}

# Clear all conflicts
clear_conflicts() {
    if [ ! -f "$REGISTRY_FILE" ]; then
        log_info "No registry to clear"
        return 0
    fi
    
    log_info "Clearing all potential conflicts"
    jq '.potential_conflicts = [] | .last_updated = "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"' "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp"
    mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"
    log_success "Cleared all conflicts"
}

# Show help
show_help() {
    cat << EOF
File Ownership Tracker

Usage: $0 <command> [arguments]

Commands:
  register <story-id> <agent-name> <worktree-path> <file1> [file2...]
                                    Register files for a story
  
  unregister <story-id>            Unregister all files for a story
  
  list                             List all file ownership and conflicts
  
  check <story-id> <file1> [file2...]
                                    Check if files conflict with other stories
  
  auto-register <story-id> <agent-name> <worktree-path> [base-branch]
                                    Auto-detect and register changed files
  
  get-conflicts <story-id>         Get conflicts for a specific story
  
  clear-conflicts                  Clear all potential conflicts
  
  help                             Show this help message

Examples:
  $0 register 1.1 javascript-developer .worktrees/agent-js-1-1 src/auth/login.ts
  $0 auto-register 1.1 javascript-developer .worktrees/agent-js-1-1
  $0 list
  $0 check 1.2 src/auth/login.ts
  $0 unregister 1.1
EOF
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    
    case "$command" in
        register)
            if [ $# -lt 5 ]; then
                log_error "Usage: $0 register <story-id> <agent-name> <worktree-path> <file1> [file2...]"
                exit 1
            fi
            register_files "$2" "$3" "$4" "${@:5}"
            ;;
        unregister)
            if [ $# -lt 2 ]; then
                log_error "Usage: $0 unregister <story-id>"
                exit 1
            fi
            unregister_files "$2"
            ;;
        list)
            list_ownership
            ;;
        check)
            if [ $# -lt 3 ]; then
                log_error "Usage: $0 check <story-id> <file1> [file2...]"
                exit 1
            fi
            check_conflicts "$2" "${@:3}"
            ;;
        auto-register)
            if [ $# -lt 4 ]; then
                log_error "Usage: $0 auto-register <story-id> <agent-name> <worktree-path> [base-branch]"
                exit 1
            fi
            auto_register "$2" "$3" "$4" "${5:-main}"
            ;;
        get-conflicts)
            if [ $# -lt 2 ]; then
                log_error "Usage: $0 get-conflicts <story-id>"
                exit 1
            fi
            get_conflicts "$2"
            ;;
        clear-conflicts)
            clear_conflicts
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"

