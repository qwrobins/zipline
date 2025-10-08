#!/bin/bash

# Visual Testing Script
# Compares current application output with expected visual designs
# Usage: ./scripts/visual-test.sh <command> [options]

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

# Capture application output
capture_output() {
    local app_path="$1"
    local output_file="$2"
    local timeout_seconds="${3:-5}"
    
    log_info "Capturing application output..."
    
    if [[ ! -f "$app_path" ]]; then
        log_error "Application not found: $app_path"
        return 1
    fi
    
    if [[ ! -x "$app_path" ]]; then
        log_error "Application not executable: $app_path"
        return 1
    fi
    
    # Capture output with timeout
    if timeout "$timeout_seconds" "$app_path" > "$output_file" 2>&1; then
        log_success "Output captured to: $output_file"
        return 0
    else
        log_warning "Application exited or timed out after $timeout_seconds seconds"
        if [[ -f "$output_file" ]]; then
            log_info "Partial output captured to: $output_file"
            return 0
        else
            log_error "No output captured"
            return 1
        fi
    fi
}

# Compare with expected output
compare_with_expected() {
    local expected_dir="$1"
    local current_dir="$2"
    
    log_info "Comparing current output with expected designs..."
    
    if [[ ! -d "$expected_dir" ]]; then
        log_error "Expected output directory not found: $expected_dir"
        log_info "Create expected output files in this directory for comparison"
        return 1
    fi
    
    if [[ ! -d "$current_dir" ]]; then
        log_error "Current output directory not found: $current_dir"
        return 1
    fi
    
    local differences_found=0
    local files_compared=0
    
    # Compare each expected file with current output
    for expected_file in "$expected_dir"/*.txt; do
        if [[ ! -f "$expected_file" ]]; then
            log_warning "No expected output files found in $expected_dir"
            break
        fi
        
        local filename=$(basename "$expected_file")
        local current_file="$current_dir/$filename"
        
        files_compared=$((files_compared + 1))
        
        if [[ ! -f "$current_file" ]]; then
            log_warning "Current output file not found: $current_file"
            differences_found=$((differences_found + 1))
            continue
        fi
        
        log_info "Comparing: $filename"
        
        # Create diff output
        local diff_file="/tmp/visual_diff_$filename"
        if diff -u "$expected_file" "$current_file" > "$diff_file"; then
            log_success "✓ $filename matches expected output"
        else
            log_warning "✗ $filename differs from expected output"
            log_info "Diff saved to: $diff_file"
            differences_found=$((differences_found + 1))
            
            # Show first few lines of diff
            log_info "First 10 lines of differences:"
            head -10 "$diff_file" | sed 's/^/  /'
        fi
    done
    
    # Summary
    if [[ $files_compared -eq 0 ]]; then
        log_warning "No files were compared"
        return 1
    elif [[ $differences_found -eq 0 ]]; then
        log_success "All $files_compared files match expected output"
        return 0
    else
        log_warning "$differences_found of $files_compared files differ from expected output"
        return 1
    fi
}

# Generate expected output from current state
generate_expected() {
    local app_path="$1"
    local expected_dir="$2"
    
    log_info "Generating expected output files..."
    
    # Create expected directory
    mkdir -p "$expected_dir"
    
    # Capture different scenarios
    local scenarios=(
        "default:default.txt"
        "dark:dark_theme.txt"
        "light:light_theme.txt"
        "compact:compact_layout.txt"
    )
    
    for scenario in "${scenarios[@]}"; do
        local name=$(echo "$scenario" | cut -d: -f1)
        local file=$(echo "$scenario" | cut -d: -f2)
        local output_path="$expected_dir/$file"
        
        log_info "Capturing $name scenario..."
        
        case "$name" in
            "default")
                capture_output "$app_path" "$output_path" 3
                ;;
            "dark")
                THEME=dark capture_output "$app_path" "$output_path" 3
                ;;
            "light")
                THEME=light capture_output "$app_path" "$output_path" 3
                ;;
            "compact")
                # Simulate smaller terminal
                COLUMNS=80 LINES=24 capture_output "$app_path" "$output_path" 3
                ;;
        esac
    done
    
    log_success "Expected output files generated in: $expected_dir"
    log_info "Review and commit these files to establish visual baselines"
}

# Analyze visual elements
analyze_visual_elements() {
    local output_file="$1"
    
    log_info "Analyzing visual elements in: $output_file"
    
    if [[ ! -f "$output_file" ]]; then
        log_error "Output file not found: $output_file"
        return 1
    fi
    
    # Count different visual elements
    local total_lines=$(wc -l < "$output_file")
    local color_codes=$(grep -o '\x1b\[[0-9;]*m' "$output_file" | wc -l)
    local unicode_chars=$(grep -o '[^\x00-\x7F]' "$output_file" | wc -l)
    local progress_bars=$(grep -o '[█▉▊▋▌▍▎▏░▒▓]' "$output_file" | wc -l)
    
    log_info "Visual analysis results:"
    log_info "  Total lines: $total_lines"
    log_info "  Color codes: $color_codes"
    log_info "  Unicode characters: $unicode_chars"
    log_info "  Progress bar elements: $progress_bars"
    
    # Check for common visual patterns
    if grep -q '┌\|┐\|└\|┘\|├\|┤\|┬\|┴\|┼' "$output_file"; then
        log_success "✓ Box drawing characters detected"
    else
        log_info "○ No box drawing characters found"
    fi
    
    if grep -q '█\|▉\|▊\|▋\|▌\|▍\|▎\|▏' "$output_file"; then
        log_success "✓ Progress bar elements detected"
    else
        log_info "○ No progress bar elements found"
    fi
    
    if [[ $color_codes -gt 0 ]]; then
        log_success "✓ Color coding detected"
    else
        log_warning "⚠ No color codes found - may lack visual appeal"
    fi
}

# Show usage
show_usage() {
    echo "Visual Testing Script"
    echo
    echo "Usage: $0 <command> [options]"
    echo
    echo "Commands:"
    echo "  compare <expected-dir> <current-dir>    Compare current with expected output"
    echo "  capture <app-path> <output-file>        Capture application output"
    echo "  generate <app-path> <expected-dir>      Generate expected output files"
    echo "  analyze <output-file>                   Analyze visual elements"
    echo "  help                                    Show this help message"
    echo
    echo "Examples:"
    echo "  $0 compare design/expected/ current/"
    echo "  $0 capture ./pulsetui /tmp/current.txt"
    echo "  $0 generate ./pulsetui design/expected/"
    echo "  $0 analyze /tmp/current.txt"
    echo
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    
    case "$command" in
        compare)
            if [[ $# -lt 3 ]]; then
                log_error "Usage: $0 compare <expected-dir> <current-dir>"
                exit 1
            fi
            compare_with_expected "$2" "$3"
            ;;
        capture)
            if [[ $# -lt 3 ]]; then
                log_error "Usage: $0 capture <app-path> <output-file>"
                exit 1
            fi
            capture_output "$2" "$3" "${4:-5}"
            ;;
        generate)
            if [[ $# -lt 3 ]]; then
                log_error "Usage: $0 generate <app-path> <expected-dir>"
                exit 1
            fi
            generate_expected "$2" "$3"
            ;;
        analyze)
            if [[ $# -lt 2 ]]; then
                log_error "Usage: $0 analyze <output-file>"
                exit 1
            fi
            analyze_visual_elements "$2"
            ;;
        help|*)
            show_usage
            ;;
    esac
}

# Make script executable and run
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
