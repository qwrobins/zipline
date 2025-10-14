#!/bin/bash
# Git Worktree Manager
# Manages git worktrees for multi-agent development to prevent conflicts
# Version: 1.0.0

set -euo pipefail

# Configuration
WORKTREE_BASE_DIR=".worktrees"
REGISTRY_FILE=".agent-orchestration/worktree-registry.json"
MAX_WORKTREE_AGE_HOURS=24

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

# Check if git is initialized
is_git_initialized() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Sanitize story ID for use in branch names
sanitize_story_id() {
    local story_id="$1"
    # Replace spaces and special characters with hyphens
    # Convert to lowercase
    # Remove consecutive hyphens
    echo "$story_id" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//'
}

# Generate unique branch name
generate_branch_name() {
    local agent_name="$1"
    local story_id="$2"
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local sanitized_story=$(sanitize_story_id "$story_id")
    local sanitized_agent=$(sanitize_story_id "$agent_name")
    
    echo "agent-${sanitized_agent}-${sanitized_story}-${timestamp}"
}

# Check if branch name exists
branch_exists() {
    local branch_name="$1"
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        return 0
    else
        return 1
    fi
}

# Get worktree path from branch name
get_worktree_path() {
    local branch_name="$1"
    echo "${WORKTREE_BASE_DIR}/${branch_name}"
}

# Initialize registry file if it doesn't exist
init_registry() {
    if [ ! -f "$REGISTRY_FILE" ]; then
        mkdir -p "$(dirname "$REGISTRY_FILE")"
        echo '{"worktrees": []}' > "$REGISTRY_FILE"
        log_info "Initialized worktree registry at $REGISTRY_FILE"
    fi
}

# Add worktree to registry
register_worktree() {
    local branch_name="$1"
    local story_id="$2"
    local agent_name="$3"
    local worktree_path="$4"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    init_registry
    
    # Create temporary file with updated registry
    local temp_file=$(mktemp)
    jq --arg branch "$branch_name" \
       --arg story "$story_id" \
       --arg agent "$agent_name" \
       --arg path "$worktree_path" \
       --arg time "$timestamp" \
       '.worktrees += [{
           "branch": $branch,
           "story_id": $story,
           "agent_name": $agent,
           "path": $path,
           "created_at": $time,
           "status": "active"
       }]' "$REGISTRY_FILE" > "$temp_file"
    
    mv "$temp_file" "$REGISTRY_FILE"
    log_info "Registered worktree in registry"
}

# Remove worktree from registry
unregister_worktree() {
    local branch_name="$1"
    
    if [ ! -f "$REGISTRY_FILE" ]; then
        return 0
    fi
    
    local temp_file=$(mktemp)
    jq --arg branch "$branch_name" \
       '.worktrees = [.worktrees[] | select(.branch != $branch)]' \
       "$REGISTRY_FILE" > "$temp_file"
    
    mv "$temp_file" "$REGISTRY_FILE"
    log_info "Unregistered worktree from registry"
}

# Create worktree
create_worktree() {
    local story_id="$1"
    local agent_name="$2"
    local base_branch="${3:-main}"
    
    log_info "Creating worktree for story: $story_id, agent: $agent_name"
    
    # Check if git is initialized
    if ! is_git_initialized; then
        log_error "Git repository not initialized. Please run 'git init' first."
        return 1
    fi
    
    # Generate branch name
    local branch_name=$(generate_branch_name "$agent_name" "$story_id")
    
    # Check if branch already exists (shouldn't happen with timestamp, but be safe)
    local counter=1
    local original_branch_name="$branch_name"
    while branch_exists "$branch_name"; do
        branch_name="${original_branch_name}-${counter}"
        counter=$((counter + 1))
    done
    
    # Get worktree path
    local worktree_path=$(get_worktree_path "$branch_name")
    
    # Create worktree base directory if it doesn't exist
    mkdir -p "$WORKTREE_BASE_DIR"
    
    # Get repository root for absolute path
    local repo_root=$(git rev-parse --show-toplevel)

    # Create the worktree
    log_info "Creating worktree at: $worktree_path"
    if git worktree add "$worktree_path" -b "$branch_name" "$base_branch" 2>&1; then
        log_success "Worktree created successfully"

        # Register in registry
        register_worktree "$branch_name" "$story_id" "$agent_name" "$worktree_path"

        # Output the ABSOLUTE worktree path for the caller
        echo "$repo_root/$worktree_path"
        return 0
    else
        log_error "Failed to create worktree"
        return 1
    fi
}

# List active worktrees
list_worktrees() {
    log_info "Active worktrees:"
    git worktree list
    
    if [ -f "$REGISTRY_FILE" ]; then
        echo ""
        log_info "Registry information:"
        jq -r '.worktrees[] | "  Story: \(.story_id) | Agent: \(.agent_name) | Branch: \(.branch) | Created: \(.created_at)"' "$REGISTRY_FILE"
    fi
}

# Merge worktree back to target branch
merge_worktree() {
    local worktree_path="$1"
    local target_branch="${2:-main}"
    
    log_info "Merging worktree: $worktree_path into $target_branch"
    
    # Extract branch name from worktree path
    local branch_name=$(basename "$worktree_path")
    
    # Get current directory
    local original_dir=$(pwd)
    
    # Ensure we're in the repo root
    local repo_root=$(git rev-parse --show-toplevel)
    cd "$repo_root"
    
    # Check if there are uncommitted changes in the worktree
    if ! git -C "$worktree_path" diff-index --quiet HEAD --; then
        log_error "CRITICAL: Worktree has uncommitted changes. Cannot merge until working directory is clean."
        log_error ""
        log_error "This indicates the post-review handoff step (Step 4.4.2) was not completed properly."
        log_error "The developer agent should have committed all changes before merge operations."
        log_error ""
        log_error "Uncommitted files:"
        git -C "$worktree_path" status --short
        log_error ""
        log_error "REQUIRED FIX - Hand back to developer agent:"
        log_error "  1. Identify the developer agent from task state file"
        log_error "  2. Invoke the agent in this worktree: cd $worktree_path"
        log_error "  3. Agent must commit all changes: git add -A && git commit -m 'chore: finalize implementation'"
        log_error "  4. Verify clean working directory: git status"
        log_error "  5. Only then retry merge: $0 merge $worktree_path"
        log_error ""
        log_error "DO NOT manually commit changes - the developer agent must handle this."
        cd "$original_dir"
        return 1
    fi
    
    # Checkout target branch
    log_info "Switching to $target_branch"
    if ! git checkout "$target_branch" 2>&1; then
        log_error "Failed to checkout $target_branch"
        cd "$original_dir"
        return 1
    fi
    
    # Merge the worktree branch
    log_info "Merging $branch_name into $target_branch"
    if git merge "$branch_name" --no-ff -m "Merge worktree: $branch_name" 2>&1; then
        log_success "Merge completed successfully"
        cd "$original_dir"
        return 0
    else
        log_error "Merge failed. Please resolve conflicts manually."
        log_warning "After resolving conflicts, run: git merge --continue"
        log_warning "Then cleanup the worktree with: $0 cleanup $worktree_path"
        cd "$original_dir"
        return 1
    fi
}

# Cleanup worktree
cleanup_worktree() {
    local worktree_path="$1"
    
    log_info "Cleaning up worktree: $worktree_path"
    
    # Extract branch name from worktree path
    local branch_name=$(basename "$worktree_path")
    
    # Get repo root
    local repo_root=$(git rev-parse --show-toplevel)
    
    # Remove the worktree
    log_info "Removing worktree"
    if git worktree remove "$worktree_path" --force 2>&1; then
        log_success "Worktree removed"
    else
        log_warning "Failed to remove worktree, it may have been already removed"
    fi
    
    # Delete the branch
    log_info "Deleting branch: $branch_name"
    if git branch -D "$branch_name" 2>&1; then
        log_success "Branch deleted"
    else
        log_warning "Failed to delete branch, it may have been already deleted"
    fi
    
    # Unregister from registry
    unregister_worktree "$branch_name"
    
    log_success "Cleanup completed"
}

# Cleanup abandoned worktrees (older than MAX_WORKTREE_AGE_HOURS)
cleanup_abandoned() {
    log_info "Checking for abandoned worktrees (older than ${MAX_WORKTREE_AGE_HOURS}h)"
    
    if [ ! -f "$REGISTRY_FILE" ]; then
        log_info "No registry file found, nothing to cleanup"
        return 0
    fi
    
    local current_time=$(date +%s)
    local max_age_seconds=$((MAX_WORKTREE_AGE_HOURS * 3600))
    
    # Get list of worktrees to cleanup
    local worktrees_to_cleanup=$(jq -r --arg current_time "$current_time" --arg max_age "$max_age_seconds" \
        '.worktrees[] | select(
            (($current_time | tonumber) - (.created_at | fromdateiso8601)) > ($max_age | tonumber)
        ) | .path' "$REGISTRY_FILE")
    
    if [ -z "$worktrees_to_cleanup" ]; then
        log_info "No abandoned worktrees found"
        return 0
    fi
    
    echo "$worktrees_to_cleanup" | while read -r worktree_path; do
        log_warning "Found abandoned worktree: $worktree_path"
        cleanup_worktree "$worktree_path"
    done
    
    log_success "Abandoned worktree cleanup completed"
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    
    case "$command" in
        create)
            if [ $# -lt 3 ]; then
                log_error "Usage: $0 create <story-id> <agent-name> [base-branch]"
                exit 1
            fi
            create_worktree "$2" "$3" "${4:-main}"
            ;;
        list)
            list_worktrees
            ;;
        merge)
            if [ $# -lt 2 ]; then
                log_error "Usage: $0 merge <worktree-path> [target-branch]"
                exit 1
            fi
            merge_worktree "$2" "${3:-main}"
            ;;
        cleanup)
            if [ $# -lt 2 ]; then
                log_error "Usage: $0 cleanup <worktree-path>"
                exit 1
            fi
            cleanup_worktree "$2"
            ;;
        cleanup-abandoned)
            cleanup_abandoned
            ;;
        help|*)
            echo "Git Worktree Manager"
            echo ""
            echo "Usage: $0 <command> [arguments]"
            echo ""
            echo "Commands:"
            echo "  create <story-id> <agent-name> [base-branch]  Create a new worktree"
            echo "  list                                           List all active worktrees"
            echo "  merge <worktree-path> [target-branch]         Merge worktree back to target branch"
            echo "  cleanup <worktree-path>                       Remove worktree and delete branch"
            echo "  cleanup-abandoned                              Cleanup worktrees older than ${MAX_WORKTREE_AGE_HOURS}h"
            echo "  help                                           Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 create 1.1 javascript-developer"
            echo "  $0 list"
            echo "  $0 merge .worktrees/agent-javascript-developer-1-1-20240107-120000"
            echo "  $0 cleanup .worktrees/agent-javascript-developer-1-1-20240107-120000"
            ;;
    esac
}

# Run main function
main "$@"

