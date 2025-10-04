# Documentation Directory Convention

All planning agents now follow a standardized convention for output file locations.

## Overview

**All planning documents are saved to the `docs/` directory** in the project root. This keeps all planning and design documentation organized in a central location separate from source code.

## Directory Structure

```
project-root/
├── docs/                              # All planning documentation
│   ├── prd.md                        # Product Requirements Document (monolithic)
│   ├── prd/                          # Segmented PRD (optional)
│   │   ├── index.md                  # Table of contents
│   │   ├── goals-and-background-context.md
│   │   ├── requirements.md
│   │   ├── user-interface-design-goals.md
│   │   ├── technical-assumptions.md
│   │   ├── epic-list.md
│   │   ├── epic-1-[name].md
│   │   └── ...
│   ├── architecture.md               # Architecture Document (monolithic)
│   ├── architecture/                 # Segmented architecture (optional)
│   │   ├── index.md                  # Table of contents
│   │   ├── introduction.md
│   │   ├── high-level-architecture.md
│   │   ├── tech-stack.md
│   │   ├── data-models.md
│   │   ├── api-specification.md
│   │   └── ...
│   └── stories/                      # User stories
│       ├── README.md                 # Orchestrator workflow guide
│       ├── 1.1.project-initialization.md
│       ├── 1.2.shadcn-ui-setup.md
│       ├── 2.1.user-directory.md
│       └── ...
├── src/                              # Source code (separate from docs)
├── tests/                            # Test files
└── ...
```

## Agent Output Locations

### product-manager
**Outputs to**: `docs/prd.md`

Creates a comprehensive Product Requirements Document with:
- Goals and background context
- Functional requirements (FR1, FR2, ...)
- Non-functional requirements (NFR1, NFR2, ...)
- User interface design goals
- Technical assumptions
- Epic list
- Detailed epic descriptions with user stories

### software-architect
**Outputs to**: `docs/architecture.md`

Creates a comprehensive architecture document with:
- Introduction and project overview
- High-level architecture with diagrams
- Tech stack with rationales
- Data models
- API specifications
- Component architecture
- Testing strategy
- Coding standards
- And more...

### planning-analyst
**Outputs to**: `docs/prd/` or `docs/architecture/`

Breaks down monolithic documents into organized directories:
- **Input**: `docs/prd.md` → **Output**: `docs/prd/` (with index.md and segmented files)
- **Input**: `docs/architecture.md` → **Output**: `docs/architecture/` (with index.md and segmented files)

Each segmented directory includes:
- `index.md` - Master table of contents with links
- Individual files for each major section
- 100% content preservation (no summarization)

### scrum-master
**Outputs to**: `docs/stories/`

Creates individual user story files:
- `docs/stories/README.md` - Overview and orchestrator workflow
- `docs/stories/1.1.project-initialization.md` - Epic 1, Story 1
- `docs/stories/1.2.shadcn-ui-setup.md` - Epic 1, Story 2
- `docs/stories/2.1.user-directory.md` - Epic 2, Story 1
- And so on...

Each story file includes:
- Status (Draft, Approved, Ready for Review, Done)
- Story in Agile format
- Dependencies with required status
- Acceptance criteria
- Tasks and subtasks
- Dev Notes with technical details
- Change log
- Dev Agent Record (filled by implementation agent)
- QA Results (filled by QA agent)

## Workflow with docs/ Directory

### Complete Planning Workflow

```
1. Product Brief (provided by user)
        ↓
2. product-manager agent
        ↓
   docs/prd.md created
        ↓
3. planning-analyst agent (optional)
        ↓
   docs/prd/ directory created
        ↓
4. software-architect agent
        ↓
   docs/architecture.md created
        ↓
5. planning-analyst agent (optional)
        ↓
   docs/architecture/ directory created
        ↓
6. scrum-master agent
        ↓
   docs/stories/ directory created
        ↓
7. Ready for Implementation
```

### Example Agent Invocations

**Step 1: Create PRD**
```
/agents product-manager

I have a product brief for a task management app. Please create a PRD.
[paste product brief]

Output: docs/prd.md
```

**Step 2: Segment PRD (optional)**
```
/agents planning-analyst

Please break down docs/prd.md into organized sections.

Output: docs/prd/ directory with index.md and segmented files
```

**Step 3: Create Architecture**
```
/agents software-architect

Create architecture document from docs/prd.md (or docs/prd/)

Output: docs/architecture.md
```

**Step 4: Segment Architecture (optional)**
```
/agents planning-analyst

Please break down docs/architecture.md into organized sections.

Output: docs/architecture/ directory with index.md and segmented files
```

**Step 5: Create User Stories**
```
/agents scrum-master

Create user stories from:
- PRD: docs/prd/ (or docs/prd.md)
- Architecture: docs/architecture/ (or docs/architecture.md)

Output: docs/stories/ directory with README.md and story files
```

## Benefits

### 1. Centralized Documentation
All planning and design documentation in one predictable location:
- Easy to find: Always check `docs/` directory
- Easy to navigate: Clear structure and naming
- Easy to maintain: All docs together

### 2. Separation of Concerns
Planning documentation separate from source code:
- `docs/` - Planning, design, requirements, architecture
- `src/` - Implementation code
- `tests/` - Test code

This separation makes it clear what's "what we're building" vs. "how we built it".

### 3. Version Control Benefits
Documentation changes tracked separately:
- PRD changes don't clutter code commit history
- Architecture updates are clearly visible
- Story status changes are easy to track
- Can review planning evolution over time

### 4. Consistent Convention
All agents follow the same pattern:
- No confusion about where to save files
- No need to specify output locations
- Predictable structure across all projects
- Easy to onboard new team members

### 5. Orchestrator Integration
Orchestrator knows exactly where to find stories:
- Always looks in `docs/stories/` directory
- Scans all `.md` files for status
- Checks dependencies by story number
- Assigns work based on status and dependencies

## Migration from Other Conventions

If you have existing planning documents in other locations:

### Option 1: Move Files
```bash
# Create docs directory
mkdir -p docs/stories

# Move existing files
mv prd.md docs/
mv architecture.md docs/
mv stories/* docs/stories/
```

### Option 2: Regenerate with Agents
Use the planning agents to regenerate documents in the correct location:
1. Use product-manager to create `docs/prd.md`
2. Use software-architect to create `docs/architecture.md`
3. Use scrum-master to create `docs/stories/`

## Best Practices

### 1. Always Use docs/ Directory
- Never save planning docs to project root
- Never save planning docs to src/ directory
- Always use `docs/` as the base directory

### 2. Follow Naming Conventions
- PRD: `docs/prd.md` or `docs/prd/`
- Architecture: `docs/architecture.md` or `docs/architecture/`
- Stories: `docs/stories/`
- Use kebab-case for file names

### 3. Keep Monolithic and Segmented Versions
You can have both:
- `docs/prd.md` - Easy to read as one document
- `docs/prd/` - Easy to navigate by section

Same for architecture:
- `docs/architecture.md` - Complete overview
- `docs/architecture/` - Detailed sections

### 4. Update README
Add a section to your project README:
```markdown
## Documentation

All planning and design documentation is in the `docs/` directory:
- `docs/prd.md` - Product Requirements Document
- `docs/architecture.md` - Architecture Document
- `docs/stories/` - User Stories for implementation
```

## Summary

✅ **All planning agents** now output to `docs/` directory
✅ **Consistent convention** across all agents
✅ **Centralized documentation** in one location
✅ **Separation of concerns** from source code
✅ **Orchestrator-ready** for parallel development
✅ **Easy to navigate** and maintain

This convention ensures that all planning documentation is organized, accessible, and separate from implementation code.

