# Universal Design System Documentation

## Overview

This document defines the visual design standards and guidelines for **all types of applications** in this project: web applications, desktop applications, and CLI tools. All development agents MUST follow these standards to ensure consistent, professional-quality user interfaces across all platforms.

## Design Principles

### 1. Professional Quality
- Applications must look as polished as professional tools like btop, lazygit, k9s
- Visual hierarchy must be clear and intuitive
- Information must be scannable and well-organized

### 2. Semantic Design
- Colors must convey meaning (red=error, green=success, yellow=warning)
- Visual elements must have clear purpose and function
- Interactive elements must provide clear feedback

### 3. Accessibility First
- All color combinations must meet WCAG 2.1 Level AA contrast ratios (4.5:1 minimum)
- Information must be conveyed through multiple visual cues, not color alone
- Layouts must be readable in 80-column terminals

### 4. Cross-Platform Compatibility
- **Web**: Responsive design for different screen sizes and browsers
- **Desktop**: UI scaling for different DPI settings and window sizes
- **CLI**: Graceful degradation for limited color terminals and ASCII fallbacks

## Color Palette

### Status Colors (Semantic)
```
Success/Good:    #4CAF50 (Green)    - Normal operation, healthy status
Warning/Caution: #FF9800 (Orange)   - Elevated usage, attention needed  
Error/Critical:  #F44336 (Red)      - High usage, errors, failures
Info/Neutral:    #2196F3 (Blue)     - Information, headers, navigation
```

### Data Visualization
```
CPU Low:         #4CAF50 (Green)    - < 30% usage
CPU Medium:      #FF9800 (Orange)   - 30-70% usage  
CPU High:        #F44336 (Red)      - > 70% usage

Memory Low:      #2196F3 (Blue)     - < 50% usage
Memory Medium:   #FFC107 (Yellow)   - 50-80% usage
Memory High:     #E91E63 (Pink)     - > 80% usage
```

### UI Elements
```
Text Primary:    #E0E0E0 (Light Gray) - Main text content
Text Secondary:  #B0B0B0 (Gray)       - Secondary information
Background:      #1A1A1A (Dark)       - Main background
Border:          #444444 (Dark Gray)  - Component borders
Highlight:       #00D9FF (Cyan)       - Focus, selection, emphasis
```

## Typography

### Text Styles
```
Header:          Bold, Primary Color
Subheader:       Bold, Text Primary
Body Text:       Normal, Text Primary  
Secondary Text:  Normal, Text Secondary
Emphasis:        Bold, Highlight Color
Data Values:     Monospace when appropriate
```

### Information Hierarchy
1. **Primary Information**: Most important data (CPU %, memory usage)
2. **Secondary Information**: Supporting details (process names, timestamps)
3. **Tertiary Information**: Additional context (full command paths)

## Layout Standards

### Spacing
```
Component Padding:    1 space
Component Margin:     1 space  
Section Spacing:      2 spaces
Progress Bar Width:   20-30 characters
Table Column Padding: 1 space
```

### Borders and Separators
```
Component Borders:    Rounded borders preferred (╭─╮│╰─╯)
Section Separators:   Horizontal lines (─) or spacing
Table Borders:        Box drawing characters (┌┬┐├┼┤└┴┘)
```

### Responsive Breakpoints
```
SSH-Safe Mode:    80-99 columns  - Minimal UI, essential info only
Compact Mode:     100-119 columns - Condensed layout, reduced spacing
Full Mode:        120+ columns    - Full features, optimal spacing
```

## Component Standards

### Progress Bars
```
Format: [████████░░] 80.5% [Status]
- Filled: █ (U+2588)
- Empty:  ░ (U+2591)  
- Width:  20-30 characters
- Color:  Based on percentage thresholds
```

### Status Indicators
```
Good:     🟢 or ✅ or [OK]
Warning:  🟡 or ⚠️  or [WARN]
Error:    🔴 or ❌ or [ERR]
Info:     🔵 or ℹ️  or [INFO]
```

### Sparklines
```
Characters: ▁▂▃▄▅▆▇█ (U+2581-U+2588)
Length:     15-60 characters
Colors:     Based on value ranges
Context:    Always include time period label
```

### Tables
```
- Headers: Bold, centered, distinct background
- Rows: Alternating colors for readability
- Selected: Highlighted background
- Sorting: Visual indicator for current sort column
- Alignment: Numbers right-aligned, text left-aligned
```

## Accessibility Requirements

### Color Contrast
- **Normal Text**: 4.5:1 minimum contrast ratio
- **Large Text**: 3:1 minimum contrast ratio  
- **UI Elements**: 3:1 minimum contrast ratio
- **High Contrast Mode**: 7:1 minimum for all text

### Visual Cues
- Never rely on color alone to convey information
- Use shapes, icons, or text labels alongside colors
- Provide alternative representations for color-coded data

### Screen Reader Support
- Use semantic markup where possible
- Provide text alternatives for visual elements
- Ensure logical reading order

## Implementation Guidelines

### Before Starting Development
1. **Create visual mockups** using ASCII art
2. **Define color usage** for all UI elements  
3. **Plan responsive behavior** for different terminal sizes
4. **Document accessibility considerations**

### During Development
1. **Test visual appearance** frequently
2. **Validate color contrast** ratios
3. **Check terminal compatibility** (xterm, alacritty, kitty, tmux)
4. **Verify responsive behavior** at different sizes

### Before Merging
1. **Compare with professional reference applications**
2. **Validate accessibility requirements**
3. **Test cross-terminal compatibility**
4. **Document any new patterns or components**

## Platform-Specific Guidelines

### Web Applications
- **Responsive Design**: Mobile-first approach with breakpoints at 768px, 1024px, 1440px
- **Browser Compatibility**: Support modern browsers (Chrome, Firefox, Safari, Edge)
- **Performance**: Core Web Vitals compliance (LCP < 2.5s, FID < 100ms, CLS < 0.1)
- **Accessibility**: WCAG 2.1 Level AA compliance with semantic HTML

### Desktop Applications
- **DPI Scaling**: Support 100%, 125%, 150%, 200% scaling factors
- **Window Management**: Proper resize behavior, minimum/maximum sizes
- **Native Feel**: Follow platform-specific design guidelines (Material Design, Human Interface Guidelines, etc.)
- **Performance**: Smooth 60fps animations, responsive UI thread

### CLI Applications
- **Terminal Compatibility**: Support xterm, alacritty, kitty, tmux
- **Color Degradation**: Graceful fallback from true color → 256 color → 16 color → monochrome
- **Size Adaptation**: Responsive layouts for 80-column minimum up to wide terminals
- **Unicode Fallbacks**: ASCII alternatives for all Unicode characters

## Reference Applications

Study these applications for visual inspiration and standards:

### Web Applications
- **GitHub**: Clean interface with excellent information hierarchy
- **Linear**: Modern design with smooth animations and interactions
- **Vercel Dashboard**: Minimalist design with effective use of whitespace

### Desktop Applications
- **VS Code**: Professional interface with excellent theming system
- **Discord**: Modern desktop app with consistent visual language
- **Figma**: Clean design tools with intuitive interactions

### CLI Applications
- **btop**: Modern, colorful system monitor with excellent visual hierarchy
- **bottom**: Clean Rust-based system monitor with great UX
- **lazygit**: Clean Git TUI with excellent visual design
- **k9s**: Professional Kubernetes TUI with consistent styling

## Tools and Testing

### Color Testing
```bash
# Test 256-color support
tput colors

# Test true color support  
printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"

# Test contrast ratios
# Use online tools: webaim.org/resources/contrastchecker/
```

### Terminal Testing
```bash
# Test in different terminals
alacritty -e your-app
kitty -e your-app  
xterm -e your-app

# Test different sizes
resize -s 24 80 && your-app    # Minimum
resize -s 40 120 && your-app   # Medium  
resize -s 60 160 && your-app   # Large
```

## Validation Checklist

Before merging any UI changes, verify:

- [ ] **Visual hierarchy** is clear and logical
- [ ] **Color usage** follows semantic standards
- [ ] **Spacing and alignment** are consistent
- [ ] **Typography** is readable and well-structured
- [ ] **Progress bars** use standard format and colors
- [ ] **Status indicators** are clear and consistent
- [ ] **Tables** have proper formatting and alternating rows
- [ ] **Accessibility** requirements are met
- [ ] **Terminal compatibility** is verified
- [ ] **Responsive behavior** works at all sizes
- [ ] **Professional appearance** comparable to reference apps

## Updates and Maintenance

This design system is a living document. When adding new components or patterns:

1. **Document the new pattern** with examples
2. **Update color palette** if new colors are needed
3. **Add to validation checklist** if new requirements emerge
4. **Update reference applications** if better examples are found

## Questions and Support

For design questions or clarification:
1. Review this document and reference applications
2. Create visual mockups before asking for feedback
3. Test with multiple terminals and accessibility tools
4. Document your design decisions and rationale
