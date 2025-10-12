# User Story Examples

## Complete Story Example

### Story 1.3: User Profile Display Component

**File**: `docs/stories/1.3.user-profile-display.md`

```markdown
# Story 1.3: User Profile Display Component

## Status
Approved

## Story
**As a** logged-in user,
**I want** to view my profile information in a dedicated component,
**so that** I can see my account details and settings at a glance.

## Dependencies
- Story 0.1 (Design System Foundation Setup) - Must be in "Done" status
- Story 1.1 (User Authentication) - Must be in "Done" status
- Story 1.2 (API Client Setup) - Must be in "Ready for Review" status

## Design Reference
- **Design System**: `docs/design/design-system.md` - Color tokens and typography
- **Component Spec**: `docs/design/components/user-profile.md` - Profile component design
- **Accessibility**: `docs/design/accessibility.md` - WCAG 2.1 AA requirements

## Acceptance Criteria
1. [ ] Component displays user's full name, email, and avatar
2. [ ] Avatar shows user initials if no image is uploaded
3. [ ] Component is responsive and works on mobile, tablet, and desktop
4. [ ] Loading state shows skeleton UI while fetching data
5. [ ] Error state displays user-friendly message if data fetch fails
6. [ ] Component uses `text-primary` token for name (HSL: 222.2 47.4% 11.2%)
7. [ ] Component uses `text-muted-foreground` for email (HSL: 215.4 16.3% 46.9%)
8. [ ] Avatar background uses `bg-primary` token (HSL: 221.2 83.2% 53.3%)
9. [ ] Component works in both light and dark themes
10. [ ] Meets WCAG 2.1 AA contrast requirements

## Tasks / Subtasks
- [ ] Create UserProfile component (AC: 1, 2)
  - [ ] Define TypeScript interface for user data
  - [ ] Implement component structure
  - [ ] Add avatar with initials fallback
- [ ] Implement responsive design (AC: 3)
  - [ ] Add mobile styles (< 640px)
  - [ ] Add tablet styles (640px - 1024px)
  - [ ] Add desktop styles (> 1024px)
- [ ] Add loading and error states (AC: 4, 5)
  - [ ] Create skeleton UI component
  - [ ] Implement error boundary
  - [ ] Add retry mechanism
- [ ] Apply design tokens (AC: 6, 7, 8, 9)
  - [ ] Use semantic color tokens
  - [ ] Test light and dark themes
  - [ ] Verify no hardcoded colors
- [ ] Ensure accessibility (AC: 10)
  - [ ] Add ARIA labels
  - [ ] Test with screen reader
  - [ ] Verify keyboard navigation
  - [ ] Check color contrast ratios

## Dev Notes

### Tech Stack
[Source: docs/architecture/tech-stack.md]
- Framework: Next.js 15 (App Router)
- Language: TypeScript (strict mode)
- Styling: Tailwind CSS + shadcn/ui
- State Management: React Query for server state

### Data Fetching Pattern
[Source: docs/architecture/data-fetching.md]
- Use React Query's `useQuery` hook
- Implement stale-while-revalidate caching
- Cache time: 5 minutes
- Stale time: 1 minute

### Component Architecture
[Source: docs/architecture/components/profile.md]
- Client component (uses hooks)
- Props: `userId: string`
- Exports: `UserProfile`, `UserProfileSkeleton`, `UserProfileError`

### File Structure
```
components/
└── user-profile/
    ├── user-profile.tsx          # Main component
    ├── user-profile-skeleton.tsx # Loading state
    ├── user-profile-error.tsx    # Error state
    └── user-profile.test.tsx     # Tests
```

### Testing Requirements
- Unit tests for component rendering
- Test loading and error states
- Test responsive behavior
- Test accessibility with jest-axe
- Snapshot tests for visual regression

## Definition of Done

### Design System Compliance
- [ ] All colors use design tokens (no hardcoded values like bg-red-600)
- [ ] Component works in both light and dark themes
- [ ] Semantic colors used appropriately (primary/muted-foreground)
- [ ] Typography uses design system scales
- [ ] Spacing uses design system tokens (p-4, gap-2, etc.)
- [ ] No ESLint warnings for hardcoded colors
- [ ] Visual appearance matches design specifications

### General
- [ ] All acceptance criteria met
- [ ] Code follows TypeScript strict mode
- [ ] Component is fully typed
- [ ] Tests written and passing (>90% coverage)
- [ ] Accessibility tested with screen reader
- [ ] Responsive design verified on all breakpoints
- [ ] Code reviewed by peer
- [ ] No console errors or warnings
- [ ] Documentation updated

## Change Log
| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2025-01-15 | 1.0 | Initial story creation | Sarah Chen (Scrum Master) |

## Dev Agent Record
_To be filled by Implementation Agent_

## QA Results
_To be filled by QA Agent_
```

## Foundation Story Example: Story 0.1

### Story 0.1: Design System Foundation Setup

**File**: `docs/stories/0.1.design-system-foundation.md`

```markdown
# Story 0.1: Design System Foundation Setup

## Status
Draft

## Story
**As a** developer,
**I want** a properly configured design system with theme support,
**so that** the application has consistent styling and supports light/dark modes.

## Dependencies
- Story 0.0 (Project Initialization and Setup) - Must be in "Done" status
  (Only if Story 0.0 was generated; otherwise: None - This story can be started immediately)

## Acceptance Criteria
1. [ ] Design tokens extracted from design documentation
2. [ ] Light theme colors configured in CSS variables
3. [ ] Dark theme colors configured in CSS variables
4. [ ] Tailwind configuration updated with design tokens
5. [ ] Theme provider component implemented
6. [ ] Theme switcher component created
7. [ ] All components use design tokens (no hardcoded colors)
8. [ ] Theme persists across page reloads
9. [ ] Theme switcher accessible via keyboard
10. [ ] No console errors when switching themes

## Tasks / Subtasks
- [ ] Extract design tokens from documentation (AC: 1)
  - [ ] Read design system documentation
  - [ ] Document color palette
  - [ ] Document typography scale
  - [ ] Document spacing scale
- [ ] Configure light theme (AC: 2)
  - [ ] Add CSS variables to globals.css
  - [ ] Define primary, secondary, accent colors
  - [ ] Define semantic colors (success, warning, destructive)
- [ ] Configure dark theme (AC: 3)
  - [ ] Add dark mode CSS variables
  - [ ] Ensure proper contrast ratios
  - [ ] Test readability
- [ ] Update Tailwind configuration (AC: 4)
  - [ ] Extend theme with design tokens
  - [ ] Configure dark mode strategy
  - [ ] Add custom utilities if needed
- [ ] Implement theme provider (AC: 5, 8)
  - [ ] Create ThemeProvider component
  - [ ] Add localStorage persistence
  - [ ] Handle system preference detection
- [ ] Create theme switcher (AC: 6, 9)
  - [ ] Build toggle component
  - [ ] Add keyboard support
  - [ ] Add ARIA labels
- [ ] Validate implementation (AC: 7, 10)
  - [ ] Audit for hardcoded colors
  - [ ] Test theme switching
  - [ ] Check console for errors

## Dev Notes

### Files to Create/Modify
```
app/
├── globals.css                    # Design tokens as CSS variables
├── layout.tsx                     # Add ThemeProvider
components/
└── theme/
    ├── theme-provider.tsx         # Theme context and provider
    └── theme-switcher.tsx         # Toggle component
tailwind.config.ts                 # Extend with design tokens
```

### Design Token Structure
```css
:root {
  /* Light theme */
  --background: 0 0% 100%;
  --foreground: 222.2 47.4% 11.2%;
  --primary: 221.2 83.2% 53.3%;
  --primary-foreground: 210 40% 98%;
  /* ... more tokens */
}

.dark {
  /* Dark theme */
  --background: 224 71% 4%;
  --foreground: 213 31% 91%;
  --primary: 217.2 91.2% 59.8%;
  --primary-foreground: 222.2 47.4% 1.2%;
  /* ... more tokens */
}
```

### Reference Documentation
- Design System: `docs/design/design-system.md`
- shadcn/ui theming: https://ui.shadcn.com/docs/theming

## Testing Requirements

### Manual Testing
1. Toggle between light and dark themes
2. Verify colors change appropriately
3. Check localStorage persistence
4. Test system preference detection
5. Verify keyboard accessibility

### Automated Testing
- Unit tests for ThemeProvider
- Integration tests for theme switching
- Accessibility tests with jest-axe

### Visual Testing
- Screenshot comparison for light/dark themes
- Verify contrast ratios meet WCAG AA

## Definition of Done

### Design System Compliance
- [ ] All design tokens defined as CSS variables
- [ ] Light and dark themes fully configured
- [ ] Tailwind config uses design tokens
- [ ] No hardcoded color values in codebase
- [ ] Theme switcher works correctly
- [ ] Theme persists across sessions

### General
- [ ] All acceptance criteria met
- [ ] Code follows project standards
- [ ] Tests written and passing
- [ ] Documentation updated
- [ ] Code reviewed
- [ ] No known bugs

## Change Log
| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2025-01-15 | 1.0 | Initial story creation | Sarah Chen (Scrum Master) |

## Dev Agent Record
_To be filled by Implementation Agent_

## QA Results
_To be filled by QA Agent_
```

## Common Patterns

### API Integration Story

**Key Elements**:
- Clear endpoint specifications
- Request/response type definitions
- Error handling requirements
- Loading states
- Caching strategy

### UI Component Story

**Key Elements**:
- Design token usage
- Responsive behavior
- Accessibility requirements
- Theme support
- Loading/error states

### Data Processing Story

**Key Elements**:
- Input validation
- Transformation logic
- Error handling
- Performance requirements
- Test data examples

## Anti-Patterns to Avoid

### ❌ Vague Acceptance Criteria
```markdown
- Component looks good
- Works on mobile
- Handles errors
```

### ✅ Specific Acceptance Criteria
```markdown
- Component uses `bg-primary` token (HSL: 221.2 83.2% 53.3%)
- Responsive breakpoints: mobile (<640px), tablet (640-1024px), desktop (>1024px)
- Error state displays "Failed to load data. Please try again." with retry button
```

### ❌ Missing Dependencies
```markdown
## Dependencies
None
```

### ✅ Clear Dependencies
```markdown
## Dependencies
- Story 0.1 (Design System Foundation Setup) - Must be in "Done" status
- Story 1.1 (User Authentication) - Must be in "Done" status
```

### ❌ Generic Dev Notes
```markdown
## Dev Notes
Use React and TypeScript.
```

### ✅ Specific Dev Notes
```markdown
## Dev Notes

### Tech Stack
[Source: docs/architecture/tech-stack.md]
- Framework: Next.js 15 (App Router)
- Language: TypeScript (strict mode)
- Styling: Tailwind CSS + shadcn/ui

### Component Architecture
[Source: docs/architecture/components/profile.md]
- Client component (uses hooks)
- Props: `userId: string`
- Exports: `UserProfile`, `UserProfileSkeleton`, `UserProfileError`
```

