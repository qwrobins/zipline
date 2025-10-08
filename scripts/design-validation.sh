#!/bin/bash

# CLI Design Validation Script
# Validates visual design quality and accessibility requirements for CLI applications
# Usage: ./scripts/design-validation.sh [command] [options]
#
# Note: Web and desktop applications should use industry-standard tools:
# - Web: Playwright, Lighthouse, axe-core (npm run test:design)
# - Desktop: Spectron, platform-specific frameworks (npm run test:desktop)

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



# Test terminal color support
test_color_support() {
    log_info "Testing terminal color support..."
    
    # Test 256-color support
    local colors=$(tput colors 2>/dev/null || echo "0")
    log_info "Terminal supports $colors colors"
    
    if [[ $colors -ge 256 ]]; then
        log_success "256-color support: ✓"
    else
        log_warning "256-color support: ✗ (fallback colors will be used)"
    fi
    
    # Test true color support
    if [[ -n "${COLORTERM:-}" ]] && [[ "$COLORTERM" == "truecolor" ]]; then
        log_success "True color support: ✓"
    else
        log_warning "True color support: ✗ (256-color fallback will be used)"
    fi
    
    return 0
}

# Test application in different terminal sizes
test_responsive_layout() {
    local app_path="$1"
    log_info "Testing responsive layout..."
    
    # Test different terminal sizes
    local sizes=(
        "24 80"   # SSH-Safe mode
        "40 120"  # Compact mode  
        "60 160"  # Full mode
    )
    
    for size in "${sizes[@]}"; do
        local height=$(echo $size | cut -d' ' -f1)
        local width=$(echo $size | cut -d' ' -f2)
        
        log_info "Testing ${width}x${height} layout..."
        
        # Resize terminal and capture output
        if command -v resize >/dev/null 2>&1; then
            resize -s "$height" "$width" >/dev/null 2>&1 || true
        fi
        
        # Run app briefly and capture output
        timeout 2s "$app_path" > "/tmp/layout_${width}x${height}.txt" 2>&1 || true
        
        if [[ -f "/tmp/layout_${width}x${height}.txt" ]]; then
            local lines=$(wc -l < "/tmp/layout_${width}x${height}.txt")
            log_success "Layout ${width}x${height}: $lines lines captured"
        else
            log_warning "Layout ${width}x${height}: No output captured"
        fi
    done
    
    return 0
}

# Test different themes
test_themes() {
    local app_path="$1"
    log_info "Testing theme support..."
    
    local themes=("dark" "light" "high-contrast")
    
    for theme in "${themes[@]}"; do
        log_info "Testing $theme theme..."
        
        # Test theme if app supports theme flag
        if timeout 2s "$app_path" --theme="$theme" > "/tmp/theme_${theme}.txt" 2>&1; then
            log_success "Theme $theme: ✓"
        else
            # Try environment variable
            if THEME="$theme" timeout 2s "$app_path" > "/tmp/theme_${theme}.txt" 2>&1; then
                log_success "Theme $theme: ✓ (via environment)"
            else
                log_warning "Theme $theme: Could not test (app may not support theme switching)"
            fi
        fi
    done
    
    return 0
}

# Validate color contrast (basic check)
validate_color_contrast() {
    log_info "Validating color contrast..."
    
    # This is a basic validation - in a real implementation,
    # you would parse the application output and check actual color values
    log_info "Checking design system color definitions..."
    
    if [[ -f "docs/design-system.md" ]]; then
        log_success "Design system documentation found"
        
        # Check if WCAG compliance is mentioned
        if grep -q "WCAG 2.1 Level AA" "docs/design-system.md"; then
            log_success "WCAG 2.1 Level AA compliance documented"
        else
            log_warning "WCAG compliance not documented in design system"
        fi
    else
        log_warning "Design system documentation not found"
    fi
    
    return 0
}

# Check for accessibility features
check_accessibility() {
    local app_path="$1"
    log_info "Checking accessibility features..."
    
    # Test high contrast mode if supported
    if timeout 2s "$app_path" --theme="high-contrast" > "/tmp/accessibility.txt" 2>&1; then
        log_success "High contrast theme: ✓"
    else
        log_warning "High contrast theme: Not available or not testable"
    fi
    
    # Check for keyboard navigation
    log_info "Keyboard navigation should be tested manually"
    log_info "Verify: Tab/Shift+Tab, arrow keys, vim keys (hjkl), shortcuts"
    
    # Check for help system
    if timeout 2s "$app_path" --help > "/tmp/help.txt" 2>&1; then
        log_success "Help system: ✓"
    else
        log_info "Help system: Test manually with '?' key"
    fi
    
    return 0
}

# Compare with reference applications (manual check)
compare_with_references() {
    log_info "Reference application comparison..."
    log_info "Manual comparison required with:"
    log_info "  - btop: Modern system monitor with excellent visual hierarchy"
    log_info "  - bottom: Clean Rust-based system monitor"
    log_info "  - lazygit: Clean Git TUI with excellent visual design"
    log_info "  - k9s: Professional Kubernetes TUI"
    
    log_info "Verify your application has:"
    log_info "  ✓ Clear visual hierarchy"
    log_info "  ✓ Effective color coding"
    log_info "  ✓ Professional appearance"
    log_info "  ✓ Intuitive navigation"
    log_info "  ✓ Consistent styling"
    
    return 0
}

# Run visual regression test
visual_regression_test() {
    local app_path="$1"
    local expected_dir="${2:-design/expected}"
    
    log_info "Running visual regression test..."
    
    if [[ ! -d "$expected_dir" ]]; then
        log_warning "Expected output directory not found: $expected_dir"
        log_info "Create expected output files for automated comparison"
        return 0
    fi
    
    # Capture current output
    timeout 2s "$app_path" > "/tmp/current_output.txt" 2>&1 || true
    
    # Compare with expected output
    local expected_files=("$expected_dir"/*.txt)
    if [[ -f "${expected_files[0]}" ]]; then
        for expected_file in "${expected_files[@]}"; do
            local filename=$(basename "$expected_file")
            if diff -u "$expected_file" "/tmp/current_output.txt" > "/tmp/diff_$filename"; then
                log_success "Visual regression: $filename matches"
            else
                log_warning "Visual regression: $filename differs"
                log_info "See /tmp/diff_$filename for details"
            fi
        done
    else
        log_info "No expected output files found for comparison"
    fi
    
    return 0
}

# Validate CLI application binary
validate_cli_app() {
    local app_path="$1"

    if [[ -z "$app_path" ]]; then
        log_error "CLI application path required"
        log_info "Usage: $0 <command> <app-path>"
        return 1
    fi

    if [[ ! -f "$app_path" ]]; then
        log_error "CLI application not found: $app_path"
        return 1
    fi

    if [[ ! -x "$app_path" ]]; then
        log_error "CLI application not executable: $app_path"
        return 1
    fi

    log_success "CLI application validated: $app_path"
    return 0
}

# Run full CLI validation
run_full_validation() {
    local app_path="$1"

    log_info "Running CLI application design validation..."
    echo

    # Validate CLI application
    validate_cli_app "$app_path" || return 1
    echo

    # Run CLI-specific tests
    test_color_support
    echo

    test_responsive_layout "$app_path"
    echo

    test_themes "$app_path"
    echo

    validate_color_contrast
    echo

    check_accessibility "$app_path"
    echo

    compare_with_references
    echo

    visual_regression_test "$app_path"
    echo

    log_success "CLI design validation completed"
    log_info "Review all warnings and manually verify reference comparisons"

    return 0
}

# Show usage
show_usage() {
    echo "CLI Design Validation Script"
    echo
    echo "Usage: $0 <command> [options]"
    echo
    echo "Commands:"
    echo "  full <app-path>                  Run full CLI design validation"
    echo "  colors                           Test terminal color support"
    echo "  responsive <app-path>            Test responsive layout"
    echo "  themes <app-path>                Test theme support"
    echo "  contrast                         Validate color contrast"
    echo "  accessibility <app-path>         Check accessibility features"
    echo "  references                       Show reference comparison guide"
    echo "  regression <app-path> [dir]      Run visual regression test"
    echo "  help                             Show this help message"
    echo
    echo "Examples:"
    echo "  $0 full ./pulsetui"
    echo "  $0 colors"
    echo "  $0 responsive ./pulsetui"
    echo "  $0 regression ./pulsetui design/expected"
    echo
    echo "Note: For web and desktop applications, use industry-standard tools:"
    echo "  Web apps:     npm run test:design  (Playwright + Lighthouse + axe-core)"
    echo "  Desktop apps: npm run test:desktop (Spectron + platform frameworks)"
    echo
}

# Main command dispatcher
main() {
    local command="${1:-help}"
    
    case "$command" in
        full)
            if [[ $# -lt 2 ]]; then
                log_error "Usage: $0 full <app-path>"
                exit 1
            fi
            run_full_validation "$2"
            ;;
        colors)
            test_color_support
            ;;
        responsive)
            if [[ $# -lt 2 ]]; then
                log_error "Usage: $0 responsive <app-path>"
                exit 1
            fi
            validate_cli_app "$2" && test_responsive_layout "$2"
            ;;
        themes)
            if [[ $# -lt 2 ]]; then
                log_error "Usage: $0 themes <app-path>"
                exit 1
            fi
            validate_cli_app "$2" && test_themes "$2"
            ;;
        contrast)
            validate_color_contrast
            ;;
        accessibility)
            if [[ $# -lt 2 ]]; then
                log_error "Usage: $0 accessibility <app-path>"
                exit 1
            fi
            validate_cli_app "$2" && check_accessibility "$2"
            ;;
        references)
            compare_with_references
            ;;
        regression)
            if [[ $# -lt 2 ]]; then
                log_error "Usage: $0 regression <app-path> [expected-dir]"
                exit 1
            fi
            validate_cli_app "$2" && visual_regression_test "$2" "${3:-design/expected}"
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
