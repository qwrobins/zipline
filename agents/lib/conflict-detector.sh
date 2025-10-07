#!/bin/bash

# Conflict Detector
# Detects potential merge conflicts before attempting merge

set -euo pipefail

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

# Detect conflicts before merge
detect_conflicts() {
    local worktree_path="$1"
    local base_branch="${2:-main}"
    
    log_info "Detecting potential conflicts for worktree: $worktree_path"
    
    # Get the branch name from worktree
    local branch_name=$(basename "$worktree_path")
    
    # Get worktree creation time
    local worktree_created=$(git log -1 --format=%ct "$branch_name" 2>/dev/null || echo "0")
    
    # Get files changed in worktree
    local worktree_files=$(git diff --name-only "$base_branch...$branch_name" 2>/dev/null | sort)
    
    if [ -z "$worktree_files" ]; then
        log_info "No files changed in worktree"
        echo '{"conflicts": [], "severity": "none"}'
        return 0
    fi
    
    # Get files changed in base branch since worktree creation
    local base_files=$(git log "$base_branch" --since="@$worktree_created" --name-only --pretty=format: 2>/dev/null | sort -u | grep -v '^$' || echo "")
    
    if [ -z "$base_files" ]; then
        log_success "No changes in base branch since worktree creation"
        echo '{"conflicts": [], "severity": "none"}'
        return 0
    fi
    
    # Find overlapping files
    local overlapping_files=$(comm -12 <(echo "$worktree_files") <(echo "$base_files"))
    
    if [ -z "$overlapping_files" ]; then
        log_success "No overlapping file changes detected"
        echo '{"conflicts": [], "severity": "none"}'
        return 0
    fi
    
    # Analyze each overlapping file
    log_warning "Potential conflicts detected in ${#overlapping_files[@]} files"
    
    local conflicts=()
    local max_severity="low"
    
    while IFS= read -r file; do
        if [ -z "$file" ]; then
            continue
        fi
        
        log_info "Analyzing: $file"
        
        # Get the severity of the conflict
        local severity=$(analyze_conflict_severity "$file" "$branch_name" "$base_branch")
        
        # Update max severity
        if [ "$severity" = "critical" ]; then
            max_severity="critical"
        elif [ "$severity" = "high" ] && [ "$max_severity" != "critical" ]; then
            max_severity="high"
        elif [ "$severity" = "medium" ] && [ "$max_severity" = "low" ]; then
            max_severity="medium"
        fi
        
        conflicts+=("{\"file\": \"$file\", \"severity\": \"$severity\"}")
        
        log_warning "  - $file (severity: $severity)"
    done <<< "$overlapping_files"
    
    # Build JSON output
    local conflicts_json=$(printf '%s\n' "${conflicts[@]}" | jq -s '.')
    local output=$(jq -n \
        --argjson conflicts "$conflicts_json" \
        --arg severity "$max_severity" \
        '{conflicts: $conflicts, severity: $severity}')
    
    echo "$output"
    
    if [ "$max_severity" = "critical" ] || [ "$max_severity" = "high" ]; then
        log_error "High-risk conflicts detected. Manual review recommended."
        return 1
    else
        log_warning "Low-risk conflicts detected. Proceed with caution."
        return 0
    fi
}

# Analyze conflict severity for a specific file
analyze_conflict_severity() {
    local file="$1"
    local branch1="$2"
    local branch2="$3"
    
    # Get the merge base
    local merge_base=$(git merge-base "$branch1" "$branch2" 2>/dev/null || echo "")
    
    if [ -z "$merge_base" ]; then
        echo "medium"
        return 0
    fi
    
    # Get diff ranges for both branches
    local diff1=$(git diff "$merge_base..$branch1" -- "$file" 2>/dev/null || echo "")
    local diff2=$(git diff "$merge_base..$branch2" -- "$file" 2>/dev/null || echo "")
    
    if [ -z "$diff1" ] || [ -z "$diff2" ]; then
        echo "low"
        return 0
    fi
    
    # Extract changed line numbers
    local lines1=$(echo "$diff1" | grep '^@@' | sed 's/@@ -[0-9,]* +\([0-9,]*\) @@.*/\1/' || echo "")
    local lines2=$(echo "$diff2" | grep '^@@' | sed 's/@@ -[0-9,]* +\([0-9,]*\) @@.*/\1/' || echo "")
    
    # Simple heuristic: if line ranges overlap, it's high severity
    # This is a simplified check - real implementation would be more sophisticated
    
    # For now, use a simple heuristic based on diff size
    local diff1_size=$(echo "$diff1" | wc -l)
    local diff2_size=$(echo "$diff2" | wc -l)
    
    if [ "$diff1_size" -gt 50 ] || [ "$diff2_size" -gt 50 ]; then
        echo "high"
    elif [ "$diff1_size" -gt 20 ] || [ "$diff2_size" -gt 20 ]; then
        echo "medium"
    else
        echo "low"
    fi
}

# Test if merge would succeed
test_merge() {
    local worktree_path="$1"
    local base_branch="${2:-main}"
    
    log_info "Testing merge for worktree: $worktree_path"
    
    # Get the branch name
    local branch_name=$(basename "$worktree_path")
    
    # Get current branch
    local current_branch=$(git branch --show-current)
    
    # Create a temporary branch for testing
    local test_branch="test-merge-$(date +%s)"
    
    # Checkout base branch
    git checkout "$base_branch" -q 2>/dev/null || {
        log_error "Failed to checkout $base_branch"
        return 1
    }
    
    # Create test branch
    git checkout -b "$test_branch" -q 2>/dev/null || {
        log_error "Failed to create test branch"
        git checkout "$current_branch" -q 2>/dev/null
        return 1
    }
    
    # Try merge
    if git merge "$branch_name" --no-commit --no-ff 2>/dev/null; then
        log_success "Test merge succeeded - no conflicts"
        
        # Abort the merge
        git merge --abort 2>/dev/null || true
        
        # Cleanup
        git checkout "$current_branch" -q 2>/dev/null
        git branch -D "$test_branch" -q 2>/dev/null
        
        echo '{"success": true, "conflicts": []}'
        return 0
    else
        log_warning "Test merge failed - conflicts detected"
        
        # Get conflicting files
        local conflicts=$(git diff --name-only --diff-filter=U 2>/dev/null || echo "")
        
        # Abort the merge
        git merge --abort 2>/dev/null || true
        
        # Cleanup
        git checkout "$current_branch" -q 2>/dev/null
        git branch -D "$test_branch" -q 2>/dev/null
        
        # Build JSON output
        local conflicts_array=()
        while IFS= read -r file; do
            if [ -n "$file" ]; then
                conflicts_array+=("\"$file\"")
            fi
        done <<< "$conflicts"
        
        local conflicts_json="[$(IFS=,; echo "${conflicts_array[*]}")]"
        echo "{\"success\": false, \"conflicts\": $conflicts_json}"
        return 1
    fi
}

# Show help
show_help() {
    cat << EOF
Conflict Detector

Usage: $0 <command> [arguments]

Commands:
  detect <worktree-path> [base-branch]
                                    Detect potential conflicts before merge
  
  test-merge <worktree-path> [base-branch]
                                    Test if merge would succeed
  
  help                             Show this help message

Examples:
  $0 detect .worktrees/agent-javascript-developer-1-1-20240107-120000
  $0 test-merge .worktrees/agent-javascript-developer-1-1-20240107-120000 main
EOF
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    
    case "$command" in
        detect)
            if [ $# -lt 2 ]; then
                log_error "Usage: $0 detect <worktree-path> [base-branch]"
                exit 1
            fi
            detect_conflicts "$2" "${3:-main}"
            ;;
        test-merge)
            if [ $# -lt 2 ]; then
                log_error "Usage: $0 test-merge <worktree-path> [base-branch]"
                exit 1
            fi
            test_merge "$2" "${3:-main}"
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

