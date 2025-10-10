# Agent Orchestration State Directory

This directory contains runtime state for the Story Orchestration System.

## 📁 Files

### `progress.json`
Overall progress metrics and counters.

**Created by**: `/automate-planning` command
**Updated by**: `/implement-stories` and other orchestration commands
**Purpose**: Track high-level progress across all stories

### `dependency-graph.json`
Story dependency relationships and implementation order.

**Created by**: `/automate-planning` command
**Updated by**: Rarely (only if stories change)
**Purpose**: Determine which stories can start and in what order, identify parallel execution waves

### `roadmap.md`
Human-readable implementation plan.

**Created by**: `/automate-planning` command
**Updated by**: `/implement-stories` as stories complete
**Purpose**: Visual guide to implementation sequence with parallel execution strategy

### `worktree-registry.json`
Active git worktree tracking.

**Created by**: `/automate-planning` command
**Updated by**: `/implement-stories` during execution
**Purpose**: Track active worktrees for parallel story implementation

### `tasks/{story-id}-task.json`
Individual task state for each story.

**Created by**: `/automate-planning` command
**Updated by**: `/implement-stories` and other orchestration commands
**Purpose**: Track detailed state for each story including assigned agent, dependencies, and review status

## 🔄 State Lifecycle

1. **Planning**: `/automate-planning` creates all state files and orchestration infrastructure
2. **Execution**: `/implement-stories` loads state and updates as work progresses
3. **Resume**: State files allow resuming work after interruption
4. **Completion**: State files archived when all stories done

## 📊 Example State Files

See the `examples/` subdirectory for sample state files showing:
- A project with 5 stories
- Various states (done, in_progress, blocked)
- Dependency relationships
- Review cycles

## 🔒 Version Control

**Recommendation**: Commit state files to track team progress

**Pros**:
- Team members can see overall progress
- Progress is preserved across machines
- Historical record of implementation

**Cons**:
- Merge conflicts if multiple people work simultaneously
- State files change frequently

**Alternative**: Add state files to `.gitignore` and use for local tracking only

## 🧹 Cleanup

To reset the orchestration system:

```bash
# Remove all state files
rm -rf .agent-orchestration/

# Re-initialize (requires re-running planning)
/automate-planning
```

**Warning**: This will lose all progress tracking. Only do this if you want to start fresh.

## 🔄 Workflow

**Recommended workflow**:

1. **Planning Phase**: Run `/automate-planning` to create all orchestration state
2. **Execution Phase**: Run `/implement-stories` to execute implementation
3. **Monitoring**: Use `/story-status` to check progress
4. **Resume**: Run `/implement-stories` again if interrupted

**Key Principle**:
- `/automate-planning` = Planning & scaffolding (run once)
- `/implement-stories` = Execution & orchestration (run as needed)

## 📖 Documentation

For full documentation, see: `docs/orchestration-system.md`

For command usage, see:
- `.claude/commands/automate-planning.md` - Planning and orchestration setup
- `.claude/commands/implement-stories.md` - Implementation execution
- `.claude/commands/next-story.md` - Manual story-by-story execution
- `.claude/commands/review-story.md` - Manual code review triggering
- `.claude/commands/story-status.md` - Progress monitoring

