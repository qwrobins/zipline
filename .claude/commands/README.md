# Slash Commands

This directory contains slash commands for workflow automation and document generation using Claude Code.

## 📋 Available Commands

### Planning & Requirements

#### `/automate-planning [product-brief-path]`
**Automate the complete planning process from requirements to implementation-ready state**

Orchestrates the entire planning workflow by calling appropriate agents in sequence, and prepares all orchestration infrastructure for implementation.

**Usage**:
```bash
/automate-planning docs/product-brief.md
/automate-planning  # Interactive mode
```

**What it does**:
1. Gathers initial requirements (product brief or user input)
2. Asks for planning preferences (architecture, design spec)
3. Generates PRD using `/create-prd` functionality
4. Generates architecture document (if requested)
5. Generates frontend design specification (if requested)
6. Shards large documents using `planning-analyst` functionality
7. Creates epics and stories using `scrum-master` functionality
8. **Initializes orchestration infrastructure** (`.agent-orchestration/`)
9. **Analyzes story dependencies** and builds dependency graph
10. **Matches stories to development agents**
11. **Generates implementation roadmap** with parallel execution strategy

**When to use**:
- Starting a new project from scratch
- Want complete planning automation
- Need consistent document structure across all planning phases
- Working with multiple planning documents
- Want to ensure all planning steps are completed
- **Want implementation-ready orchestration state**

**Output**:
- `docs/prd.md` (and `docs/prd/` if sharded)
- `docs/architecture.md` (and `docs/architecture/` if sharded) - conditional
- `docs/design/` directory with design specification - conditional
- `docs/stories/` directory with individual story files
- **`.agent-orchestration/` directory with:**
  - `dependency-graph.json` - Story dependencies and parallel waves
  - `progress.json` - Progress tracking
  - `roadmap.md` - Human-readable implementation plan
  - `tasks/*.json` - Individual task state files
  - `worktree-registry.json` - Worktree tracking

---

#### `/create-prd [product-brief-path]`
**Transform a product brief into a comprehensive PRD**

Creates a detailed Product Requirements Document from a product brief.

**Usage**:
```bash
/create-prd docs/product-brief.md
```

**What it does**:
1. Reads the product brief
2. Analyzes requirements and goals
3. Creates comprehensive PRD at `docs/prd.md`
4. Includes all 14 essential sections

**When to use**:
- Starting a new project
- Need formal requirements documentation
- Want structured PRD with epics and user stories
- Faster than using the product-manager agent

---

#### `/create-design-spec [prd-or-brief-path]`
**Transform a PRD or product brief into a comprehensive frontend design specification**

Creates a detailed frontend design specification with design system, components, and implementation guidelines.

**Usage**:
```bash
/create-design-spec docs/prd.md
/create-design-spec docs/product-brief.md
```

**What it does**:
1. Reads the PRD or product brief
2. Analyzes design requirements and user needs
3. Researches design best practices and trends
4. Creates comprehensive design spec at `docs/design/frontend-design-spec.md`
5. Includes design system, components, accessibility, and implementation guidelines

**When to use**:
- After creating a PRD
- Need comprehensive design documentation
- Want structured design system and component specifications
- Faster than using the frontend-design agent

---

### Story Orchestration

### `/implement-stories [scope]`
**Execute implementation using pre-built orchestration state**

Loads orchestration state created by `/automate-planning` and coordinates implementation from start to finish.

**Prerequisites**:
- **MUST run `/automate-planning` first** to create orchestration infrastructure
- Requires `.agent-orchestration/` directory with dependency graph, task states, and roadmap

**Usage**:
```bash
# Implement all stories
/implement-stories

# Implement a range of stories
/implement-stories 1.1-1.5

# Implement specific stories
/implement-stories 1.1 1.3 1.5

# Implement stories in an epic
/implement-stories epic:auth

# Implement stories matching a pattern
/implement-stories 1.*
```

**What it does**:
1. Parses scope arguments (if provided)
2. **Loads orchestration state** from `.agent-orchestration/`
3. Filters stories based on scope
4. Warns about out-of-scope dependencies
5. Executes stories in parallel waves (based on dependency graph)
6. Coordinates code reviews after each story
7. Handles review feedback loops
8. Manages git worktrees for parallel execution
9. Tracks progress in state files

**When to use**:
- After running `/automate-planning`
- Implementing multiple stories
- Want fully automated coordination
- Need parallel execution of independent stories
- Working on a specific epic or feature set
- Testing orchestration with a subset of stories
- Resuming interrupted implementation

---

### `/next-story`
**Start the next available story**

Identifies the next story ready for implementation (dependencies met) and starts work on it.

**Usage**:
```
/next-story
```

**What it does**:
1. Reads current orchestration state
2. Finds next story with dependencies satisfied
3. Invokes appropriate development agent
4. Updates state files

**When to use**:
- Continuing work after a break
- Want manual control over pacing
- One story at a time approach
- Resuming interrupted work

---

### `/review-story [story-id]`
**Trigger code review for a specific story**

Invokes the code-reviewer agent for a story that's ready for review.

**Usage**:
```
/review-story 1.1
```

**What it does**:
1. Validates story is ready for review
2. Invokes @agent-code-reviewer
3. Processes review results
4. Updates story status based on outcome
5. Handles approval or requests changes

**When to use**:
- Story development is complete
- Need to re-review after fixes
- Manual review workflow
- Checking specific story quality

---

### `/story-status`
**Show comprehensive progress report**

Generates detailed status report showing progress across all stories.

**Usage**:
```
/story-status
```

**What it does**:
1. Reads all orchestration state files
2. Categorizes stories by status
3. Calculates metrics and progress
4. Identifies blockers and next actions
5. Provides actionable recommendations

**When to use**:
- Check overall progress
- Identify what's blocking work
- Plan next actions
- Resume after interruption
- Monitor team progress

---

## 🚀 Quick Start Guide

### First Time Setup (Complete Planning + Implementation)

1. **Create a product brief** at `docs/product-brief.md` with your project requirements

2. **Run automated planning** to generate all planning docs and orchestration state:
   ```bash
   /automate-planning docs/product-brief.md
   ```

   This creates:
   - `docs/prd.md` - Product Requirements Document
   - `docs/stories/` - Individual user story files
   - `.agent-orchestration/` - Dependency graph, roadmap, task states
   - (Optional) `docs/architecture.md` - Architecture document
   - (Optional) `docs/design/` - Design specification

3. **Review generated artifacts**:
   - Review PRD and stories for accuracy
   - Review implementation roadmap: `.agent-orchestration/roadmap.md`
   - Verify dependency graph makes sense

4. **Execute implementation**:
   ```bash
   /implement-stories
   ```

5. **Monitor progress**:
   ```bash
   /story-status
   ```

### Alternative: Manual Story Creation

If you prefer to create stories manually:

1. **Create user stories** in `docs/stories/` directory:
   ```
   docs/stories/
   ├── 0.0-project-initialization.md
   ├── 0.1-design-system-foundation.md
   ├── 1.1-user-authentication.md
   ├── 1.2-user-profile.md
   └── 1.3-password-reset.md
   ```

2. **Run planning to build orchestration state**:
   ```bash
   /automate-planning
   ```
   (Skip PRD/architecture/design generation, just build orchestration infrastructure)

3. **Execute implementation**:
   ```bash
   /implement-stories
   ```

### Typical Workflow

**Complete Workflow** (From requirements to implementation):
```bash
# Step 1: Planning (creates all planning docs + orchestration state)
/automate-planning docs/product-brief.md

# Step 2: Review generated planning artifacts
# - Review docs/prd.md
# - Review docs/stories/
# - Review .agent-orchestration/roadmap.md

# Step 3: Execute implementation (all stories)
/implement-stories

# Or scope to specific stories
/implement-stories 1.1-1.5

# Or work on an epic
/implement-stories epic:auth

# Check progress anytime
/story-status

# Resume if interrupted
/implement-stories
```

**Automated Approach** (When planning already done):
```bash
# If /automate-planning was already run, just execute
/implement-stories

# Or scope to specific stories
/implement-stories 1.1-1.5

# Check progress anytime
/story-status

# Resume if interrupted
/implement-stories
```

**Manual Approach** (More control):
```bash
# After /automate-planning, work on stories one at a time
/next-story
# ... wait for completion ...
/review-story 1.1
# ... wait for review ...

# Continue with next
/next-story
/review-story 1.2

# Check progress
/story-status
```

**Hybrid Approach** (Best of both):
```bash
# Start automated workflow
/implement-stories

# Pause when needed (press Escape)
# Check status
/story-status

# Continue manually
/next-story

# Or resume automated
/implement-stories
```

---

## 📁 State Management

All commands use state files in `.agent-orchestration/`:

```
.agent-orchestration/
├── progress.json              # Overall metrics
├── dependency-graph.json      # Story relationships
├── roadmap.md                 # Implementation plan
└── tasks/
    ├── 1.1-task.json         # Story 1.1 state
    ├── 1.2-task.json         # Story 1.2 state
    └── ...
```

**State Persistence**:
- State is automatically saved after each operation
- Work can be paused and resumed at any time
- Progress is preserved across sessions
- State files can be committed to git for team visibility

---

## 🔄 Workflow Integration

### How Commands Work Together

```
/implement-stories
    ↓
Analyzes stories → Builds graph → Creates roadmap
    ↓
Starts first story → Invokes dev agent
    ↓
Story complete → Triggers review
    ↓
Review approved → Marks done → Starts next story
    ↓
Repeat until all stories complete
```

### Manual Control Points

You can interrupt and take control at any point:

```
/implement-stories
    ↓
[Press Escape to pause]
    ↓
/story-status  ← Check what's happening
    ↓
/next-story    ← Continue manually
    ↓
/review-story 1.1  ← Manual review trigger
    ↓
/implement-stories ← Resume automation
```

---

## 🎯 Best Practices

### Story File Format

Ensure story files include:
- **Story ID** in filename (e.g., `1.1-user-authentication.md`)
- **Status** field
- **Dependencies** section (if any)
- **Acceptance Criteria**
- **Technology stack** mentions

Example:
```markdown
# Story 1.2: User Profile

**Status**: Not Started
**Dependencies**: 1.1

## Description
...

## Technology Stack
- React, TypeScript, Next.js

## Acceptance Criteria
1. ...
2. ...
```

### Dependency Management

- Use clear, explicit dependencies
- Follow consistent numbering (1.1, 1.2, 2.1, etc.)
- Avoid circular dependencies
- Document why dependencies exist

### Progress Tracking

- Run `/story-status` regularly
- Check state files for detailed info
- Commit state files to track team progress
- Review roadmap before starting work

### Error Recovery

If something goes wrong:
1. Run `/story-status` to see current state
2. Check `.agent-orchestration/tasks/` for details
3. Manually fix state files if needed
4. Resume with `/next-story` or `/implement-stories`

---

## 🔧 Troubleshooting

### "Orchestration system not initialized"
**Solution**: Run `/implement-stories` to initialize

### "No stories ready to start"
**Solution**: Check `/story-status` to see what's blocking progress

### "Story stuck in 'in_progress'"
**Solution**: 
1. Check if dev agent completed work
2. Verify story status was updated
3. Manually update state file if needed

### "Circular dependency detected"
**Solution**: 
1. Review dependency graph in `.agent-orchestration/dependency-graph.json`
2. Identify the cycle
3. Remove one dependency to break the cycle

### "Review never completes"
**Solution**:
1. Check if review file was created in `docs/code_reviews/`
2. Verify code-reviewer agent finished
3. Manually update task state if needed

---

## 📚 Additional Resources

- **Full Documentation**: `docs/orchestration-system.md`
- **State File Examples**: `.agent-orchestration/examples/`
- **Agent Definitions**: `agents/definitions/`

---

## 🆘 Getting Help

1. **Check documentation**: `docs/orchestration-system.md`
2. **Review state files**: `.agent-orchestration/`
3. **Run status command**: `/story-status`
4. **Check agent definitions**: `agents/definitions/`

---

## 🎉 Tips for Success

✅ **Write clear acceptance criteria** - Makes reviews more effective  
✅ **Use consistent story IDs** - Easier to track and reference  
✅ **Check status frequently** - Stay aware of progress  
✅ **Address review feedback promptly** - Keeps workflow moving  
✅ **Commit state files** - Track progress across team  
✅ **Review roadmap first** - Understand the plan before starting  

---

## 🚧 Future Enhancements

Planned features:
- QA testing integration
- Parallel execution support
- Custom workflow phases
- Metrics dashboard
- Notification system

---

**Version**: 1.0.0  
**Last Updated**: 2025-10-02  
**Maintained by**: Story Orchestration System

