# User Story Template

## Standard Story Structure

Each story file must follow this exact structure:

```markdown
# Story [Epic].[Number]: [Story Title]

## Status
[Draft | Approved | Ready for Review | Done]

**Status Definitions**:
- **Draft**: Story drafted but not approved for work yet (initial state)
- **Approved**: Story approved and ready for a development agent to claim
- **Ready for Review**: Implementation complete, code committed, ready for QA testing
- **Done**: QA has signed off and story is fully completed

## Story
**As a** [user role],
**I want** [goal/desire],
**so that** [benefit/value].

## Dependencies
[List prerequisite stories that must be completed before this story can begin]

**Format**:
- Story [Epic].[Number] ([Story Name]) - Must be in "[Required Status]" status

**Example**:
- Story 1.4 (API Client Setup) - Must be in "Ready for Review" status
- Story 1.2 (shadcn/ui Setup) - Must be in "Done" status

**For stories with no dependencies**:
None - This story can be started immediately

## Design Reference (if applicable)
**Note**: Include this section only for stories involving UI implementation.

**Reference Strategy**: Use the most specific document available:

**If sharded design docs exist**:
- **Design System**: `docs/design/design-system.md` - Design tokens
- **Component Spec**: `docs/design/components/[component-name].md` - Specific component
- **Feature Design**: `docs/design/features/[feature-name].md` - Feature-specific design
- **Accessibility**: `docs/design/accessibility.md` - WCAG requirements

**If only full design spec exists**:
- **Design System**: Section 3 - Design tokens (colors, typography, spacing)
- **Component Specifications**: Section 5.[X] - [Component Name]
- **Accessibility Requirements**: Section 9 - WCAG 2.1 AA compliance
- **Responsive Design**: Section 8 - Breakpoints and mobile-first approach

## Acceptance Criteria
1. [Specific, testable criterion]
2. [Specific, testable criterion]
3. [Specific, testable criterion]

**For UI stories, add**:
- Follows design specification (Section [X])
- Meets accessibility requirements (Section 9)
- Implements responsive behavior (Section 8)
- Uses design tokens consistently (Section 3)

## Tasks / Subtasks
- [ ] [Task description] (AC: [AC number])
  - [ ] [Subtask description]
  - [ ] [Subtask description]
- [ ] [Task description] (AC: [AC number])
  - [ ] [Subtask description]

## Dev Notes

**Reference Strategy**: Use the most specific, focused documents available.

**If sharded architecture docs exist** (Preferred):
```markdown
### Tech Stack
[Source: docs/architecture/tech-stack.md]
- Framework: Next.js 15 (App Router)
- Language: TypeScript (strict mode)
- Styling: Tailwind CSS + shadcn/ui

### Data Fetching Pattern
[Source: docs/architecture/data-fetching.md]
- Use React Query for server state
- Implement optimistic updates for mutations

### Component Architecture
[Source: docs/architecture/components/[component-type].md]
- Server vs Client component boundaries
- Props interface definitions
```

**If only full architecture doc exists** (Fallback):
```markdown
### Tech Stack
[Source: docs/architecture.md - Section 2]
[Extract relevant tech stack details]

### Data Fetching Pattern
[Source: docs/architecture.md - Section 4.2]
[Extract data fetching patterns]
```

## Definition of Done

### Design System Compliance (for UI stories)
- [ ] All colors use design tokens (no hardcoded values)
- [ ] Component works in both light and dark themes
- [ ] Semantic colors used appropriately
- [ ] Typography uses design system scales
- [ ] Spacing uses design system tokens
- [ ] Visual appearance matches design specifications

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
| YYYY-MM-DD | 1.0 | Initial story creation | [Your Name] (Scrum Master) |

## Dev Agent Record
_To be filled by Implementation Agent_

## QA Results
_To be filled by QA Agent_
```

## Foundation Story Dependencies

**ALL feature stories (1.1+) MUST depend on foundation stories:**

**IF Story 0.0 was generated:**
```markdown
## Dependencies
- Story 0.0 (Project Initialization and Setup) - Must be in "Done" status
- Story 0.1 (Design System Foundation Setup) - Must be in "Done" status
[... other dependencies ...]
```

**IF Story 0.0 was NOT generated:**
```markdown
## Dependencies
- Story 0.1 (Design System Foundation Setup) - Must be in "Done" status
[... other dependencies ...]
```

**For stories using specific components or infrastructure:**
```markdown
## Dependencies
- Story 0.1 (Design System Foundation Setup) - Must be in "Done" status
- Story 0.2 (Component Library Configuration) - Must be in "Done" status
[... other dependencies ...]
```

## Design Token Usage in Acceptance Criteria

**For ANY story involving UI elements, colors, or styling:**

### 1. Read Design System Documentation

Before writing acceptance criteria, use `view` tool to read:
- `docs/design/design-system.md` - For color tokens and values
- `docs/design/components.md` - For component specifications

### 2. Use Specific Tokens

❌ **WRONG (Generic):**
```markdown
- Validation errors displayed inline with red text
- Delete button has destructive styling
- Primary actions use blue color
```

✅ **CORRECT (Specific with tokens):**
```markdown
- [ ] Validation errors use `text-destructive` token (HSL: 0 84.2% 60.2%)
- [ ] Error field borders use `border-destructive` token
- [ ] Delete button uses `variant="destructive"` from design system
- [ ] Primary action buttons use `bg-primary` token (HSL: 221.2 83.2% 53.3%)
```

## Story Sizing Guidelines

### Parallelizable Stories (Most Feature Work)

**Target**: 2-4 hours of implementation time

**Characteristics**:
- Single, focused feature or component
- Clear acceptance criteria
- Minimal dependencies
- Can be tested independently

**Examples**:
- Implement user profile display component
- Add search functionality to list view
- Create API endpoint for data retrieval

### Non-Parallelizable Stories (Foundation/Setup)

**Target**: May be larger (4-8 hours) if necessary

**Characteristics**:
- Sets up infrastructure or foundation
- Required by multiple other stories
- Cannot be easily split
- Blocks other work

**Examples**:
- Project initialization
- Design system setup
- Database schema creation
- Authentication framework

## File Naming Convention

**Format**: `[Epic].[Number].[story-name].md`

**Examples**:
- `0.0.project-initialization.md`
- `0.1.design-system-foundation.md`
- `1.1.user-authentication.md`
- `1.2.user-profile-display.md`
- `2.1.post-creation-form.md`

**Rules**:
- Use lowercase
- Use hyphens for spaces
- Be descriptive but concise
- Match epic and story numbers from PRD

## File Location

**CRITICAL**: All story files go in `docs/stories/` in a **FLAT** structure:

✅ **CORRECT**:
```
docs/stories/
├── README.md
├── 0.0.project-initialization.md
├── 0.1.design-system-foundation.md
├── 1.1.user-authentication.md
├── 1.2.user-profile-display.md
└── 2.1.post-creation-form.md
```

❌ **WRONG**:
```
docs/stories/
├── epic-1/
│   ├── 1.1.user-authentication.md
│   └── 1.2.user-profile-display.md
└── epic-2/
    └── 2.1.post-creation-form.md
```

## Quality Standards

### Completeness
- [ ] All required sections present
- [ ] Acceptance criteria are specific and testable
- [ ] Dependencies clearly identified
- [ ] Tasks reference AC numbers
- [ ] Dev notes include technical details

### Clarity
- [ ] Story format is correct (As a...I want...so that...)
- [ ] Acceptance criteria are unambiguous
- [ ] Tasks are actionable
- [ ] Technical requirements are clear

### Implementability
- [ ] Developer has all information needed
- [ ] No ambiguous requirements
- [ ] Technical approach is clear
- [ ] Testing requirements specified

### Traceability
- [ ] Story maps to PRD requirements
- [ ] Dependencies are accurate
- [ ] Design references are correct
- [ ] Architecture citations are present

## See Also

- **Story Examples**: `agents/guides/story-examples.md`
- **Foundation Stories**: See scrum-master agent definition for Story 0.0 and 0.1 templates
- **Dependency Management**: See scrum-master agent definition for parallel execution guidelines

