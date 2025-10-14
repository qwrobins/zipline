#!/bin/bash
# Worktree Readiness Checker
# Verifies that all worktrees in a wave are ready for merge (clean working directories)
# Version: 1.0.0

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

# Check if a single worktree is ready for merge
check_worktree_readiness() {
    local worktree_path="$1"
    local story_id="$2"
    
    if [ ! -d "$worktree_path" ]; then
        log_error "Worktree directory does not exist: $worktree_path"
        return 1
    fi
    
    # Check if there are uncommitted changes
    if ! git -C "$worktree_path" diff-index --quiet HEAD --; then
        log_error "Story $story_id: Worktree has uncommitted changes"
        log_error "  Path: $worktree_path"
        log_error "  Uncommitted files:"
        git -C "$worktree_path" status --short | sed 's/^/    /'
        return 1
    fi
    
    # Check if there are untracked files
    if [ -n "$(git -C "$worktree_path" ls-files --others --exclude-standard)" ]; then
        log_warning "Story $story_id: Worktree has untracked files (may be intentional)"
        log_warning "  Path: $worktree_path"
        log_warning "  Untracked files:"
        git -C "$worktree_path" ls-files --others --exclude-standard | sed 's/^/    /'
        # Don't fail for untracked files, just warn
    fi
    
    log_success "Story $story_id: Worktree is ready for merge"
    return 0
}

# Check readiness for multiple stories
check_wave_readiness() {
    local story_ids=("$@")
    local all_ready=true
    local ready_count=0
    local total_count=${#story_ids[@]}
    
    log_info "Checking readiness for ${total_count} stories..."
    echo ""
    
    for story_id in "${story_ids[@]}"; do
        local task_file=".agent-orchestration/tasks/${story_id}-task.json"
        
        if [ ! -f "$task_file" ]; then
            log_error "Story $story_id: Task state file not found: $task_file"
            all_ready=false
            continue
        fi
        
        # Extract worktree path from task state file
        local worktree_path
        if command -v jq >/dev/null 2>&1; then
            worktree_path=$(jq -r '.worktree_path // empty' "$task_file")
        else
            log_error "jq is required but not installed"
            return 1
        fi
        
        if [ -z "$worktree_path" ] || [ "$worktree_path" = "null" ]; then
            log_error "Story $story_id: No worktree path found in task state"
            all_ready=false
            continue
        fi
        
        if check_worktree_readiness "$worktree_path" "$story_id"; then
            ((ready_count++))
        else
            all_ready=false
        fi
        echo ""
    done
    
    echo "=========================================="
    if [ "$all_ready" = true ]; then
        log_success "ALL STORIES READY FOR MERGE ($ready_count/$total_count)"
        log_success "All worktrees have clean working directories"
        log_success "Safe to proceed with sequential merge operations"
        return 0
    else
        log_error "STORIES NOT READY FOR MERGE ($ready_count/$total_count ready)"
        log_error "Some worktrees have uncommitted changes"
        log_error "MUST complete post-review handoff (Step 4.4.2) before merge"
        echo ""
        log_error "Required actions:"
        log_error "1. Hand stories with uncommitted changes back to their developer agents"
        log_error "2. Developer agents must commit all changes in their worktrees"
        log_error "3. Re-run this check to verify all worktrees are clean"
        log_error "4. Only then proceed with merge operations"
        return 1
    fi
}

# Get story IDs from task files in a directory
get_story_ids_from_tasks() {
    local task_dir=".agent-orchestration/tasks"

    if [ ! -d "$task_dir" ]; then
        # Don't log here, let the caller handle it
        return 1
    fi

    # Find all task files and extract story IDs
    local task_files
    mapfile -t task_files < <(find "$task_dir" -name "*-task.json" -type f 2>/dev/null)

    if [ ${#task_files[@]} -eq 0 ]; then
        # Don't log here, let the caller handle it
        return 1
    fi

    for task_file in "${task_files[@]}"; do
        local filename=$(basename "$task_file")
        local story_id="${filename%-task.json}"
        echo "$story_id"
    done | sort
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    
    case "$command" in
        check)
            if [ $# -lt 2 ]; then
                log_error "Usage: $0 check <story-id1> [story-id2] [story-id3] ..."
                log_error "   or: $0 check-all"
                exit 1
            fi
            shift
            check_wave_readiness "$@"
            ;;
        check-all)
            local story_ids
            if ! mapfile -t story_ids < <(get_story_ids_from_tasks); then
                log_warning "Task directory not found or no task files exist"
                log_info "No stories found to check (orchestration not initialized)"
                log_success "ALL STORIES READY FOR MERGE (0/0)"
                exit 0
            fi
            if [ ${#story_ids[@]} -eq 0 ]; then
                log_info "No stories found to check"
                log_success "ALL STORIES READY FOR MERGE (0/0)"
                exit 0
            fi
            check_wave_readiness "${story_ids[@]}"
            ;;
        help|*)
            echo "Worktree Readiness Checker"
            echo ""
            echo "Usage: $0 <command> [arguments]"
            echo ""
            echo "Commands:"
            echo "  check <story-id1> [story-id2] ...  Check specific stories for merge readiness"
            echo "  check-all                          Check all stories in task directory"
            echo "  help                               Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 check 1.1 1.2 1.3              Check stories 1.1, 1.2, and 1.3"
            echo "  $0 check-all                       Check all stories"
            echo ""
            echo "Exit codes:"
            echo "  0 = All stories ready for merge"
            echo "  1 = Some stories not ready or error occurred"
            ;;
    esac
}

# Run main function with all arguments
main "$@"
