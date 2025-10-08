#!/bin/bash

# Terminal Compatibility Testing Script
# Tests application across different terminal emulators and configurations
# Usage: ./scripts/terminal-test.sh [options]

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

# Test terminal capabilities
test_terminal_capabilities() {
    local terminal_name="$1"
    
    log_info "Testing capabilities for: $terminal_name"
    
    # Test color support
    local colors=$(tput colors 2>/dev/null || echo "0")
    log_info "  Color support: $colors colors"
    
    # Test true color support
    if [[ -n "${COLORTERM:-}" ]] && [[ "$COLORTERM" == "truecolor" ]]; then
        log_success "  True color: ✓"
    else
        log_info "  True color: ✗"
    fi
    
    # Test terminal size
    local cols=$(tput cols 2>/dev/null || echo "unknown")
    local lines=$(tput lines 2>/dev/null || echo "unknown")
    log_info "  Terminal size: ${cols}x${lines}"
    
    # Test Unicode support
    if echo "█▉▊▋▌▍▎▏░▒▓" | grep -q '[█▉▊▋▌▍▎▏░▒▓]'; then
        log_success "  Unicode blocks: ✓"
    else
        log_warning "  Unicode blocks: ✗"
    fi
    
    # Test box drawing characters
    if echo "┌┬┐├┼┤└┴┘" | grep -q '[┌┬┐├┼┤└┴┘]'; then
        log_success "  Box drawing: ✓"
    else
        log_warning "  Box drawing: ✗"
    fi
    
    echo
}

# Test application in specific terminal
test_in_terminal() {
    local terminal_cmd="$1"
    local app_path="$2"
    local terminal_name="$3"
    
    log_info "Testing application in: $terminal_name"
    
    # Check if terminal is available
    if ! command -v "$terminal_cmd" >/dev/null 2>&1; then
        log_warning "$terminal_name not available (command: $terminal_cmd)"
        return 1
    fi
    
    # Check if application exists
    if [[ ! -f "$app_path" ]]; then
        log_error "Application not found: $app_path"
        return 1
    fi
    
    if [[ ! -x "$app_path" ]]; then
        log_error "Application not executable: $app_path"
        return 1
    fi
    
    # Create output file
    local output_file="/tmp/terminal_test_${terminal_name}.txt"
    
    # Test application in terminal
    case "$terminal_cmd" in
        "xterm")
            if timeout 5s xterm -e "bash -c '$app_path > $output_file 2>&1; sleep 1'" >/dev/null 2>&1; then
                log_success "$terminal_name: Application ran successfully"
            else
                log_warning "$terminal_name: Application may have issues"
            fi
            ;;
        "alacritty")
            if timeout 5s alacritty -e bash -c "$app_path > $output_file 2>&1; sleep 1" >/dev/null 2>&1; then
                log_success "$terminal_name: Application ran successfully"
            else
                log_warning "$terminal_name: Application may have issues"
            fi
            ;;
        "kitty")
            if timeout 5s kitty -e bash -c "$app_path > $output_file 2>&1; sleep 1" >/dev/null 2>&1; then
                log_success "$terminal_name: Application ran successfully"
            else
                log_warning "$terminal_name: Application may have issues"
            fi
            ;;
        "gnome-terminal")
            if timeout 5s gnome-terminal -- bash -c "$app_path > $output_file 2>&1; sleep 1" >/dev/null 2>&1; then
                log_success "$terminal_name: Application ran successfully"
            else
                log_warning "$terminal_name: Application may have issues"
            fi
            ;;
        *)
            log_warning "Unknown terminal type: $terminal_cmd"
            return 1
            ;;
    esac
    
    # Analyze output if available
    if [[ -f "$output_file" ]]; then
        local lines=$(wc -l < "$output_file" 2>/dev/null || echo "0")
        local size=$(wc -c < "$output_file" 2>/dev/null || echo "0")
        log_info "$terminal_name output: $lines lines, $size bytes"
        
        # Check for color codes
        if grep -q '\x1b\[[0-9;]*m' "$output_file"; then
            log_success "$terminal_name: Color codes detected"
        else
            log_info "$terminal_name: No color codes found"
        fi
        
        # Check for Unicode characters
        if grep -q '[^\x00-\x7F]' "$output_file"; then
            log_success "$terminal_name: Unicode characters detected"
        else
            log_info "$terminal_name: ASCII only output"
        fi
    else
        log_warning "$terminal_name: No output captured"
    fi
    
    echo
    return 0
}

# Test in tmux session
test_in_tmux() {
    local app_path="$1"
    
    log_info "Testing application in tmux..."
    
    if ! command -v tmux >/dev/null 2>&1; then
        log_warning "tmux not available"
        return 1
    fi
    
    # Create temporary tmux session
    local session_name="terminal_test_$$"
    local output_file="/tmp/terminal_test_tmux.txt"
    
    # Start tmux session and run application
    if tmux new-session -d -s "$session_name" "bash -c '$app_path > $output_file 2>&1; sleep 2'" >/dev/null 2>&1; then
        sleep 3  # Give it time to run
        
        # Kill the session
        tmux kill-session -t "$session_name" >/dev/null 2>&1 || true
        
        if [[ -f "$output_file" ]]; then
            local lines=$(wc -l < "$output_file" 2>/dev/null || echo "0")
            log_success "tmux: Application ran successfully ($lines lines captured)"
            
            # Check tmux-specific issues
            if grep -q '\x1b\[[0-9;]*m' "$output_file"; then
                log_success "tmux: Color codes preserved"
            else
                log_warning "tmux: Color codes may be stripped"
            fi
        else
            log_warning "tmux: No output captured"
        fi
    else
        log_error "tmux: Failed to create session"
        return 1
    fi
    
    echo
    return 0
}

# Test different color modes
test_color_modes() {
    local app_path="$1"
    
    log_info "Testing different color modes..."
    
    # Test with different TERM values
    local term_types=(
        "xterm:Basic xterm"
        "xterm-256color:256-color xterm"
        "screen:Screen/tmux"
        "screen-256color:Screen with 256 colors"
    )
    
    for term_type in "${term_types[@]}"; do
        local term_value=$(echo "$term_type" | cut -d: -f1)
        local term_desc=$(echo "$term_type" | cut -d: -f2)
        local output_file="/tmp/terminal_test_${term_value}.txt"
        
        log_info "Testing TERM=$term_value ($term_desc)"
        
        # Run with specific TERM value
        if TERM="$term_value" timeout 3s "$app_path" > "$output_file" 2>&1; then
            local colors=$(TERM="$term_value" tput colors 2>/dev/null || echo "0")
            log_info "  Reported colors: $colors"
            
            if [[ -f "$output_file" ]]; then
                local color_codes=$(grep -o '\x1b\[[0-9;]*m' "$output_file" | wc -l)
                log_info "  Color codes used: $color_codes"
                
                if [[ $color_codes -gt 0 ]]; then
                    log_success "  ✓ Colors working"
                else
                    log_warning "  ⚠ No colors detected"
                fi
            fi
        else
            log_warning "  Application failed with TERM=$term_value"
        fi
        echo
    done
}

# Test different terminal sizes
test_terminal_sizes() {
    local app_path="$1"
    
    log_info "Testing different terminal sizes..."
    
    # Test different sizes
    local sizes=(
        "80x24:SSH-safe minimum"
        "120x30:Compact mode"
        "160x40:Full mode"
        "200x50:Large display"
    )
    
    for size in "${sizes[@]}"; do
        local dimensions=$(echo "$size" | cut -d: -f1)
        local description=$(echo "$size" | cut -d: -f2)
        local width=$(echo "$dimensions" | cut -dx -f1)
        local height=$(echo "$dimensions" | cut -dx -f2)
        local output_file="/tmp/terminal_test_${width}x${height}.txt"
        
        log_info "Testing ${width}x${height} ($description)"
        
        # Set terminal size and run application
        if COLUMNS="$width" LINES="$height" timeout 3s "$app_path" > "$output_file" 2>&1; then
            if [[ -f "$output_file" ]]; then
                local lines=$(wc -l < "$output_file")
                local max_width=$(awk '{print length}' "$output_file" | sort -n | tail -1)
                
                log_info "  Output: $lines lines, max width: $max_width chars"
                
                if [[ $max_width -le $width ]]; then
                    log_success "  ✓ Fits within terminal width"
                else
                    log_warning "  ⚠ Content exceeds terminal width ($max_width > $width)"
                fi
                
                if [[ $lines -le $height ]]; then
                    log_success "  ✓ Fits within terminal height"
                else
                    log_info "  ℹ Content uses $lines lines (scrolling expected)"
                fi
            fi
        else
            log_warning "  Application failed at ${width}x${height}"
        fi
        echo
    done
}

# Run comprehensive terminal testing
run_comprehensive_test() {
    local app_path="$1"
    local terminals_list="$2"
    
    log_info "Running comprehensive terminal compatibility test..."
    echo
    
    # Test current terminal capabilities
    test_terminal_capabilities "current"
    
    # Test different terminal emulators
    if [[ -n "$terminals_list" ]]; then
        IFS=',' read -ra terminals <<< "$terminals_list"
        for terminal in "${terminals[@]}"; do
            case "$terminal" in
                "xterm")
                    test_in_terminal "xterm" "$app_path" "xterm"
                    ;;
                "alacritty")
                    test_in_terminal "alacritty" "$app_path" "alacritty"
                    ;;
                "kitty")
                    test_in_terminal "kitty" "$app_path" "kitty"
                    ;;
                "gnome-terminal")
                    test_in_terminal "gnome-terminal" "$app_path" "gnome-terminal"
                    ;;
                "tmux")
                    test_in_tmux "$app_path"
                    ;;
                *)
                    log_warning "Unknown terminal: $terminal"
                    ;;
            esac
        done
    fi
    
    # Test color modes
    test_color_modes "$app_path"
    
    # Test terminal sizes
    test_terminal_sizes "$app_path"
    
    log_success "Comprehensive terminal testing completed"
    log_info "Review warnings for potential compatibility issues"
}

# Show usage
show_usage() {
    echo "Terminal Compatibility Testing Script"
    echo
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  --terminals=LIST         Comma-separated list of terminals to test"
    echo "                          (xterm,alacritty,kitty,gnome-terminal,tmux)"
    echo "  --app=PATH              Path to application binary"
    echo "  --capabilities          Test current terminal capabilities only"
    echo "  --colors                Test different color modes"
    echo "  --sizes                 Test different terminal sizes"
    echo "  --help                  Show this help message"
    echo
    echo "Examples:"
    echo "  $0 --terminals=xterm,alacritty,kitty,tmux --app=./pulsetui"
    echo "  $0 --capabilities"
    echo "  $0 --colors --app=./pulsetui"
    echo "  $0 --sizes --app=./pulsetui"
    echo
}

# Main command dispatcher
main() {
    local terminals_list=""
    local app_path=""
    local test_capabilities=false
    local test_colors=false
    local test_sizes=false
    local run_comprehensive=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --terminals=*)
                terminals_list="${1#*=}"
                run_comprehensive=true
                shift
                ;;
            --app=*)
                app_path="${1#*=}"
                shift
                ;;
            --capabilities)
                test_capabilities=true
                shift
                ;;
            --colors)
                test_colors=true
                shift
                ;;
            --sizes)
                test_sizes=true
                shift
                ;;
            --help|*)
                show_usage
                exit 0
                ;;
        esac
    done
    
    # If no specific tests requested, show usage
    if [[ "$test_capabilities" == false && "$test_colors" == false && "$test_sizes" == false && "$run_comprehensive" == false ]]; then
        show_usage
        exit 0
    fi
    
    # Run requested tests
    if [[ "$run_comprehensive" == true ]]; then
        if [[ -z "$app_path" ]]; then
            log_error "Application path required for comprehensive testing"
            log_info "Use --app=PATH to specify application binary"
            exit 1
        fi
        run_comprehensive_test "$app_path" "$terminals_list"
    else
        if [[ "$test_capabilities" == true ]]; then
            test_terminal_capabilities "current"
        fi
        
        if [[ "$test_colors" == true ]]; then
            if [[ -z "$app_path" ]]; then
                log_error "Application path required for color testing"
                log_info "Use --app=PATH to specify application binary"
                exit 1
            fi
            test_color_modes "$app_path"
        fi
        
        if [[ "$test_sizes" == true ]]; then
            if [[ -z "$app_path" ]]; then
                log_error "Application path required for size testing"
                log_info "Use --app=PATH to specify application binary"
                exit 1
            fi
            test_terminal_sizes "$app_path"
        fi
    fi
}

# Make script executable and run
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
