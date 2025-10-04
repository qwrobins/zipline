# Parallel Development Orchestration Guide

This document explains how the scrum-master agent creates user stories optimized for parallel development by multiple AI agents working simultaneously.

## Overview

The scrum-master agent now generates user stories specifically designed for an **orchestrator agent** that manages multiple development agents in parallel. This enables:

- **Faster Development**: Multiple agents work on independent stories simultaneously
- **Efficient Resource Use**: No agent sits idle waiting for dependencies
- **Clear Workflow**: Unambiguous status tracking and dependency management
- **Predictable Progress**: Well-defined story sizing and dependency chains

## Key Features

### 1. Four-State Status System

Every story uses exactly one of these four status values:

| Status | Meaning | Who Sets It | Next Action |
|--------|---------|-------------|-------------|
| **Draft** | Story drafted but not approved | Scrum Master | Product Owner reviews and approves |
| **Approved** | Ready for development agent to claim | Product Owner | Orchestrator assigns to available agent |
| **Ready for Review** | Code complete and committed | Development Agent | QA Agent tests the implementation |
| **Done** | QA passed, story complete | QA Agent | Story is finished |

**Why four states?**
- Simple and unambiguous
- Clear handoffs between roles
- Easy for orchestrator to monitor
- No confusion about "who does what next"

### 2. Explicit Dependencies

Every story includes a **Dependencies** section that lists:
- All prerequisite stories (by number and name)
- Required status for each dependency
- Rationale for the dependency (optional but recommended)

**Example with dependencies**:
```markdown
## Dependencies
- Story 1.1 (Project Initialization) - Must be in "Done" status
  (Critical: Need verified working project before any feature work)
- Story 1.3 (API Client Setup) - Must be in "Ready for Review" status
  (Can start once code is committed, don't need to wait for QA)
```

**Example with no dependencies**:
```markdown
## Dependencies
None - This story can be started immediately
```

**Why explicit dependencies?**
- Orchestrator knows exactly when a story can be assigned
- Prevents starting work that will fail due to missing prerequisites
- Enables maximum parallelism by identifying independent work
- Documents the reasoning for future reference

### 3. Story Sizing for Parallelism

Stories are sized based on whether they can be parallelized:

#### Parallelizable Stories (Most Feature Work)
**Target**: 2-4 hours of work per story

**When to break down**:
- Feature can be split into independent components
- UI and business logic can be separated
- Different pages/routes can be built independently
- CRUD operations can be split (Create, Read, Update, Delete)

**Example**:
Instead of one large story:
```
❌ Story 2.1: User Profile Feature (3 days)
```

Break into smaller, parallel stories:
```
✅ Story 2.1: User Profile - Basic Information Display (4 hours)
✅ Story 2.2: User Profile - Posts Tab (4 hours)
✅ Story 2.3: User Profile - Activity Tab (4 hours)
✅ Story 2.4: User Profile - Edit Functionality (6 hours)
```

All four can be worked on simultaneously by different agents.

#### Non-Parallelizable Stories (Foundation/Setup)
**Keep atomic** even if 1-2 days of work

**Examples**:
- Project initialization (Next.js, Rust, Python setup)
- Database schema setup
- Authentication scaffolding
- Design system foundation (shadcn/ui, theme config)
- Core routing structure

**Why keep these atomic?**
- Other stories depend on them being complete
- They establish patterns that other code must follow
- Splitting them creates merge conflicts
- They're the foundation everything else builds on

### 4. Dependency Minimization

The scrum-master agent is instructed to minimize dependencies for maximum parallelism.

**Bad** (sequential, slow):
```
Story 2.1: User Profile Complete (depends on 1.x)
    ↓
Story 2.2: User Settings (depends on 2.1)
    ↓
Story 2.3: User Activity (depends on 2.2)
```
Only one story can be worked on at a time. Total time: 3 × story duration.

**Good** (parallel, fast):
```
Story 2.1: User Profile - Basic Info (depends on 1.x)
Story 2.2: User Profile - Posts Tab (depends on 1.x)
Story 2.3: User Profile - Activity Tab (depends on 1.x)
Story 2.4: User Settings Page (depends on 1.x)
```
All four can be worked on simultaneously. Total time: max(story durations).

## Orchestrator Workflow

The orchestrator agent manages parallel development using these stories:

### 1. Monitor Status
Continuously scans all story files for status changes:
```
docs/
└── stories/
    ├── 1.1.project-init.md (Status: Done)
    ├── 1.2.shadcn-ui.md (Status: Approved)
    ├── 1.3.api-client.md (Status: Approved)
    ├── 1.4.navigation.md (Status: Draft)
    └── 1.5.posts-feed.md (Status: Draft)
```

### 2. Check Dependencies
Before assigning a story, verify all dependencies are met:

For Story 1.2 (shadcn/ui Setup):
```markdown
## Dependencies
- Story 1.1 (Project Initialization) - Must be in "Done" status
```

Orchestrator checks: Is Story 1.1 in "Done" status? ✅ Yes → Can assign Story 1.2

For Story 1.5 (Posts Feed):
```markdown
## Dependencies
- Story 1.3 (API Client Setup) - Must be in "Ready for Review" status
- Story 1.2 (shadcn/ui Setup) - Must be in "Done" status
```

Orchestrator checks:
- Is Story 1.3 in "Ready for Review" or better? ❌ No (still "Approved")
- Is Story 1.2 in "Done" status? ❌ No (still "Approved")

Cannot assign Story 1.5 yet.

### 3. Assign Work
Assign "Approved" stories to available development agents:

```
Available Agents: [Agent 1, Agent 2]
Approved Stories with Met Dependencies: [Story 1.2, Story 1.3]

Assignments:
- Agent 1 → Story 1.2 (shadcn/ui Setup)
- Agent 2 → Story 1.3 (API Client Setup)
```

Both agents work in parallel.

### 4. Track Progress
Monitor as agents update story status:

```
Agent 1 completes Story 1.2:
- Updates status to "Ready for Review"
- Commits code
- QA Agent tests and marks "Done"

Agent 2 completes Story 1.3:
- Updates status to "Ready for Review"
- Commits code
- Now Story 1.5 can be assigned (dependency met)
```

### 5. Continuous Cycle
Repeat the process:
- Monitor for status changes
- Check dependencies for newly approved stories
- Assign work to available agents
- Track progress

## Parallel Development Example

Here's a realistic timeline showing parallel execution:

```
Time: 0h
┌─────────────────────────────────────────────────────────────┐
│ Story 1.1 (Project Init) [Agent 1]                          │
│ Status: Approved → In Progress                              │
└─────────────────────────────────────────────────────────────┘

Time: 8h (Story 1.1 complete)
┌─────────────────────────────────────────────────────────────┐
│ Story 1.1: Done ✓                                           │
└─────────────────────────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────────────────────────┐
│ Story 1.2 (shadcn/ui) [Agent 1]  │ Story 1.3 (API) [Agent 2]│
│ Status: Approved → In Progress   │ Status: Approved → In Prog│
└─────────────────────────────────────────────────────────────┘

Time: 12h (Stories 1.2 and 1.3 complete)
┌─────────────────────────────────────────────────────────────┐
│ Story 1.2: Done ✓                │ Story 1.3: Ready for Rev ✓│
└─────────────────────────────────────────────────────────────┘
              ↓                                    ↓
┌─────────────────────────────────────────────────────────────┐
│ Story 1.4 (Nav) [Agent 1]        │ Story 1.5 (Feed) [Agent 2]│
│ Depends on: 1.2 (Done) ✓         │ Depends on: 1.3 (RFR) ✓   │
│ Status: Approved → In Progress   │ Status: Approved → In Prog│
└─────────────────────────────────────────────────────────────┘

Time: 16h (Stories 1.4 and 1.5 complete)
┌─────────────────────────────────────────────────────────────┐
│ Story 1.4: Done ✓                │ Story 1.5: Done ✓         │
└─────────────────────────────────────────────────────────────┘
```

**Total Time**: 16 hours with 2 agents in parallel
**Sequential Time**: Would be 32 hours with 1 agent
**Speedup**: 2x faster

## Best Practices

### For Scrum Masters (Using the Agent)

1. **Review Dependencies**: Ensure dependencies are accurate and minimal
2. **Check Sizing**: Verify stories are appropriately sized (2-4 hours for features)
3. **Validate Status**: All stories should start in "Draft" status
4. **Test Parallelism**: Look for opportunities to break down large stories
5. **Document Rationale**: Add notes explaining why foundation stories are atomic

### For Orchestrator Developers

1. **Parse Dependencies**: Extract and validate dependency format
2. **Check Status**: Verify status is one of the four allowed values
3. **Validate Chains**: Detect circular dependencies
4. **Monitor Files**: Watch for status changes in story files
5. **Assign Fairly**: Distribute work evenly across available agents

### For Development Agents

1. **Check Dependencies**: Verify all dependencies are met before starting
2. **Update Status**: Change status to "Ready for Review" when code is committed
3. **Document Work**: Fill in "Dev Agent Record" section
4. **Run Tests**: Ensure all tests pass before marking ready for review

### For QA Agents

1. **Test Thoroughly**: Verify all acceptance criteria are met
2. **Update Status**: Change status to "Done" only when all tests pass
3. **Document Results**: Fill in "QA Results" section
4. **Report Issues**: If tests fail, document issues and return to development

## Migration from Traditional Stories

If you have existing user stories without these features:

1. **Add Dependencies Section**: Review each story and add dependencies
2. **Update Status Values**: Change to one of the four allowed values
3. **Review Sizing**: Break down large stories for parallelism
4. **Add Rationale**: Document why foundation stories are atomic
5. **Create README**: Add stories/README.md explaining the workflow

## Summary

The scrum-master agent now creates user stories optimized for parallel development:

✅ **Four-state status system** for clear workflow
✅ **Explicit dependencies** with required status
✅ **Optimal sizing** for parallel execution (2-4 hours)
✅ **Foundation stories** kept atomic when necessary
✅ **Dependency minimization** for maximum parallelism
✅ **Orchestrator-ready** format for automated assignment

This enables multiple AI development agents to work simultaneously, dramatically reducing overall development time while maintaining code quality and preventing integration issues.

