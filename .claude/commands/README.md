# Slash Commands

This directory contains slash commands for workflow automation and document generation using Claude Code.

## 📋 Available Commands

### Planning & Requirements

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

### Story Orchestration

### `/implement-stories [scope]`
**Full automated orchestration workflow**

Analyzes stories in `docs/stories/`, builds dependency graph, creates roadmap, and coordinates implementation from start to finish.

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
2. Scans and analyzes stories (filtered by scope)
3. Builds dependency graph and validates
4. Warns about out-of-scope dependencies
5. Determines implementation order
6. Matches stories to appropriate agents
7. Creates implementation roadmap
8. Executes stories in dependency order
9. Coordinates code reviews
10. Handles review feedback loops
11. Tracks progress in state files

**When to use**:
- Starting a new project
- Implementing multiple stories
- Want fully automated coordination
- Need dependency resolution
- Working on a specific epic or feature set
- Testing orchestration with a subset of stories

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

### First Time Setup

1. **Create user stories** in `docs/stories/` directory:
   ```
   docs/stories/
   ├── 1.1-user-authentication.md
   ├── 1.2-user-profile.md
   └── 1.3-password-reset.md
   ```

2. **Initialize orchestration**:
   ```
   /implement-stories
   ```

3. **Monitor progress**:
   ```
   /story-status
   ```

### Typical Workflow

**Automated Approach** (Recommended for multiple stories):
```bash
# Start full workflow (all stories)
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

**Manual Approach** (More control):
```bash
# Initialize and analyze
/implement-stories  # Let it analyze, then Escape to stop

# Work on stories one at a time
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

