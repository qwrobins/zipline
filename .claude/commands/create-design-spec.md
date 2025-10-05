---
description: Transform a PRD or product brief into a comprehensive frontend design specification
---

You are creating a comprehensive frontend design specification from a Product Requirements Document (PRD) or product brief.

# Instructions

## Step 1: Read the Input Document

Read the PRD or product brief file provided by the user (or ask for the path if not provided).

**Supported inputs**:
- `docs/prd.md` - Product Requirements Document
- `docs/product-brief.md` - Product brief
- Any other requirements document

## Step 2: Analyze Design Requirements (REQUIRED - Use sequential_thinking)

**CRITICAL**: You MUST use the `sequential_thinking` tool to analyze the design requirements before creating the specification.

Use sequential_thinking to think through:
- Product vision and user experience goals
- Target users and their design needs
- Key features requiring UI/UX design
- Brand personality and design principles
- Accessibility and responsive requirements
- Design system needs (colors, typography, components)
- User flows and interaction patterns
- Visual hierarchy and information architecture

**Example sequential_thinking usage**:
```
sequential_thinking:
  thought: "Analyzing the PRD for [Product Name]. The target users are [X], and they need [Y]. The key design challenge is [Z]..."
  thoughtNumber: 1
  totalThoughts: 8
  nextThoughtNeeded: true
```

Continue thinking through all design aspects until you have a complete understanding (typically 6-10 thoughts).

## Step 3: Research Design Best Practices (REQUIRED - Use context7)

**CRITICAL**: You MUST use research tools to inform your design decisions.

**Required research** (streamlined to prevent response size issues):

1. **Design System Best Practices**:
```
resolve-library-id: "design system best practices"
get-library-docs: [Use the library ID from resolve-library-id]
```

2. **Accessibility Standards**:
```
resolve-library-id: "WCAG accessibility guidelines"
get-library-docs: [Use the library ID from resolve-library-id]
```

3. **Technology-Specific Design Guidelines** (if mentioned in PRD):
```
resolve-library-id: "[framework] design guidelines"
# Examples: "React design patterns", "Next.js UI best practices"
```

**Use the research to inform**:
- Design system structure and tokens
- Component specifications and patterns
- Accessibility requirements and implementation
- Technology-specific design considerations

## Step 4: Create Modular Design Specification

**IMPORTANT**: Base your design specification on:
- ✅ Insights from sequential_thinking analysis (Step 2)
- ✅ Best practices from research (Step 3)
- ✅ Requirements from the PRD/brief

**MODULAR APPROACH**: To prevent response size issues, create multiple focused files instead of one large file.

### 4.1: Create Main Overview File

Create `docs/design/README.md` with navigation and overview:

```markdown
# [Product Name] - Frontend Design Specification

## Overview

This directory contains the complete frontend design specification for [Product Name], organized into focused documents for better navigation and implementation.

## 📁 Design Documentation

### Core Design Files
- **[Design System](./design-system.md)** - Design tokens, colors, typography, spacing
- **[Components](./components.md)** - Component specifications and patterns
- **[Implementation](./implementation.md)** - Technical guidelines and accessibility

### Quick Reference
- **Product Name**: [Name from PRD]
- **Design Goals**: [Primary design objectives]
- **Target Users**: [User personas from PRD]
- **Technology Stack**: [Based on PRD - e.g., Next.js, Tailwind CSS, shadcn/ui]

## 🎯 Design Principles

1. **[Principle 1]** - [Brief description]
2. **[Principle 2]** - [Brief description]
3. **[Principle 3]** - [Brief description]
4. **Accessibility First** - WCAG 2.1 AA compliance throughout

## 🚀 Getting Started

### For Developers
1. Start with [Design System](./design-system.md) for tokens and foundations
2. Review [Components](./components.md) for UI component specifications
3. Follow [Implementation](./implementation.md) for technical guidelines

### For Designers
1. Review design principles and brand direction above
2. Use design tokens from [Design System](./design-system.md)
3. Follow component patterns in [Components](./components.md)

### For QA
1. Use [Implementation](./implementation.md) for testing guidelines
2. Validate accessibility requirements across all documents
3. Check responsive behavior specifications

## 📋 Implementation Status

- [ ] Design system tokens implemented
- [ ] Core components (Button, Input, Card) implemented
- [ ] Layout system and responsive design implemented
- [ ] Accessibility requirements validated
- [ ] Cross-browser testing completed

## 🔗 Related Documents

- **PRD**: [Link to PRD]
- **Architecture**: [Link to technical architecture]
- **User Stories**: [Link to user stories]

---

*This design specification was generated from the PRD and follows modern design system best practices.*
```

### 4.2: Create Design System File

Create `docs/design/design-system.md` with design tokens and foundations:

```markdown
# Design System

## Design Tokens

### Colors
- **Primary**: [Primary color palette]
- **Secondary**: [Secondary colors]
- **Semantic**: Success, Warning, Error, Info
- **Neutral**: Gray scale for text and backgrounds

### Typography
- **Primary Font**: [Font family]
- **Scale**: xs, sm, base, lg, xl, 2xl, 3xl, 4xl
- **Weights**: 400 (normal), 500 (medium), 600 (semibold), 700 (bold)

### Spacing
- **Scale**: 1, 2, 4, 6, 8, 12, 16, 20, 24, 32, 40, 48, 64
- **Usage**: Consistent spacing throughout the interface

### Layout
- **Container**: Max-width 1200px, centered
- **Grid**: 12-column system with 24px gutters
- **Breakpoints**: Mobile (320px+), Tablet (768px+), Desktop (1024px+)
```

### 4.3: Create Components File

Create `docs/design/components.md` with component specifications:

```markdown
# Component Specifications

## Core Components

### Button
- **Variants**: Primary, Secondary, Outline, Ghost
- **Sizes**: Small (32px), Medium (40px), Large (48px)
- **States**: Default, Hover, Active, Disabled, Loading

### Input
- **Types**: Text, Email, Password, Search, Textarea
- **States**: Default, Focus, Error, Disabled
- **Validation**: Real-time with error messages

### Card
- **Variants**: Default, Elevated, Outlined
- **Usage**: Content containers, feature highlights

[Continue for 3-5 core components based on PRD requirements]
```

### 4.4: Create Implementation File

Create `docs/design/implementation.md` with technical guidelines:

```markdown
# Implementation Guidelines

## Accessibility (WCAG 2.1 AA)
- Color contrast: 4.5:1 minimum for normal text
- Keyboard navigation for all interactive elements
- Screen reader support with proper ARIA labels
- Focus indicators and logical tab order

## Technology Integration
- **Framework**: [Based on PRD]
- **Component Library**: [e.g., shadcn/ui]
- **Styling**: [e.g., Tailwind CSS]

## Quality Assurance
- Cross-browser testing
- Mobile responsiveness validation
- Accessibility testing with screen readers
- Performance impact assessment

## Developer Handoff
- Design tokens as CSS custom properties
- Component APIs and props documentation
- Responsive behavior specifications
```

## Step 5: Save the Design Files

Use the `save-file` tool to create the three design files:

1. **Main Overview**: `docs/design/README.md`
2. **Design System**: `docs/design/design-system.md`
3. **Components**: `docs/design/components.md`
4. **Implementation**: `docs/design/implementation.md`

**Important**:
- Save to `docs/design/` directory (NOT project root)
- save-file automatically creates the docs/design/ directory
- Do NOT use bash or mkdir commands
- Create files in order: README.md first, then the others

## Quality Checklist

**CRITICAL - Verify you completed all required steps**:
- ✅ **Used sequential_thinking** to analyze design requirements (Step 2)
- ✅ **Used research tools** to inform design decisions (Step 3)
- ✅ **Created modular design files** to prevent response size issues (Step 4)

**Ensure your design specification**:
- ✅ Created README.md with overview and navigation
- ✅ Created design-system.md with tokens and foundations
- ✅ Created components.md with core component specifications
- ✅ Created implementation.md with technical guidelines
- ✅ Addresses WCAG 2.1 AA accessibility requirements
- ✅ Maps to technology stack from PRD
- ✅ Addresses insights from sequential_thinking analysis

## Output

After creating the design files, provide a brief summary:
- Paths where design files were saved
- Number of components specified
- Key design principles identified
- Technology stack considerations
- Any assumptions made

# Example Usage

User: `/create-design-spec docs/prd.md`

You:
1. **Read** the PRD using `view` tool
2. **Analyze** design requirements using `sequential_thinking` tool (REQUIRED)
3. **Research** design best practices using research tools (REQUIRED)
4. **Create** modular design specification files in docs/design/
5. **Confirm** completion with summary

# Critical Requirements

**YOU MUST**:
- ✅ Use `sequential_thinking` in Step 2 (not optional)
- ✅ Use research tools in Step 3 (not optional)
- ✅ Create modular files to prevent response size issues
- ✅ Base design spec on research and analysis (not just template)
- ✅ Address accessibility requirements (WCAG 2.1 AA)

**DO NOT**:
- ❌ Skip sequential_thinking
- ❌ Skip research phase
- ❌ Create one large file (causes response size errors)
- ❌ Write implementation code (this is specification only)
- ❌ Use bash/mkdir commands
