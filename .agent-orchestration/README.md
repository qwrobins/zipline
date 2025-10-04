# Agent Orchestration State Directory

This directory contains runtime state for the Story Orchestration System.

## 📁 Files

### `progress.json`
Overall progress metrics and counters.

**Created by**: `/implement-stories` command  
**Updated by**: All orchestration commands  
**Purpose**: Track high-level progress across all stories

### `dependency-graph.json`
Story dependency relationships and implementation order.

**Created by**: `/implement-stories` command  
**Updated by**: Rarely (only if stories change)  
**Purpose**: Determine which stories can start and in what order

### `roadmap.md`
Human-readable implementation plan.

**Created by**: `/implement-stories` command  
**Updated by**: As stories complete  
**Purpose**: Visual guide to implementation sequence

### `tasks/{story-id}-task.json`
Individual task state for each story.

**Created by**: `/implement-stories` command  
**Updated by**: All orchestration commands  
**Purpose**: Track detailed state for each story

## 🔄 State Lifecycle

1. **Initialization**: `/implement-stories` creates all state files
2. **Updates**: Commands update state as work progresses
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

# Re-initialize
/implement-stories
```

**Warning**: This will lose all progress tracking. Only do this if you want to start fresh.

## 📖 Documentation

For full documentation, see: `docs/orchestration-system.md`

For command usage, see:
- `.claude/commands/implement-stories.md`
- `.claude/commands/next-story.md`
- `.claude/commands/review-story.md`
- `.claude/commands/story-status.md`

