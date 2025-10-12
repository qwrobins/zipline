# Cleanup Git Worktrees Command

This command helps manage and cleanup git worktrees used by development agents.

## USAGE

```bash
# List all active worktrees
/cleanup-worktrees list

# Cleanup abandoned worktrees (older than 24 hours)
/cleanup-worktrees auto

# Cleanup a specific worktree
/cleanup-worktrees <worktree-path>

# Force cleanup all worktrees (use with caution)
/cleanup-worktrees force
```

## DESCRIPTION

When multiple agents work on stories simultaneously using git worktrees, worktrees may be left behind due to:
- Agent failures or crashes
- Merge conflicts that weren't resolved
- Manual interruption of work
- Forgotten cleanup steps

This command provides tools to manage and cleanup these worktrees.

## COMMANDS

### List Active Worktrees

```bash
/cleanup-worktrees list
```

**What it does:**
- Lists all active git worktrees
- Shows worktree registry information
- Displays story ID, agent name, and creation time for each worktree

**Example output:**
```
Active worktrees:
/path/to/repo/.worktrees/agent-javascript-developer-1-1-20240107-120000  abc123 [agent-javascript-developer-1-1-20240107-120000]
/path/to/repo                                                             def456 [main]

Registry information:
  Story: 1.1 | Agent: javascript-developer | Branch: agent-javascript-developer-1-1-20240107-120000 | Created: 2024-01-07T12:00:00Z
```

### Auto Cleanup Abandoned Worktrees

```bash
/cleanup-worktrees auto
```

**What it does:**
- Scans for worktrees older than 24 hours
- Removes abandoned worktrees automatically
- Deletes associated branches
- Updates the worktree registry

**When to use:**
- Regular maintenance (daily or weekly)
- After a batch of stories is complete
- When disk space is running low
- After agent failures or crashes

**Safety:**
- Only removes worktrees older than 24 hours
- Preserves worktrees with uncommitted changes (warns instead)
- Logs all cleanup actions

### Cleanup Specific Worktree

```bash
/cleanup-worktrees <worktree-path>
```

**What it does:**
- Removes the specified worktree
- Deletes the associated branch
- Updates the worktree registry

**Example:**
```bash
/cleanup-worktrees .worktrees/agent-javascript-developer-1-1-20240107-120000
```

**When to use:**
- After manually resolving merge conflicts
- When you know a specific worktree is no longer needed
- To cleanup a failed story implementation

### Force Cleanup All Worktrees

```bash
/cleanup-worktrees force
```

**⚠️ WARNING: Use with extreme caution!**

**What it does:**
- Removes ALL worktrees (except main working directory)
- Deletes all associated branches
- Clears the worktree registry

**When to use:**
- Only when you're absolutely sure no agents are working
- After a major failure or system reset
- When starting fresh with a clean slate

**Safety checks:**
- Prompts for confirmation before proceeding
- Lists all worktrees that will be removed
- Warns about uncommitted changes

## IMPLEMENTATION

When invoked, execute the following steps:

### For `list` command:

```bash
./.claude/agents/lib/git-worktree-manager.sh list
```

### For `auto` command:

```bash
./.claude/agents/lib/git-worktree-manager.sh cleanup-abandoned
```

### For specific worktree cleanup:

```bash
./.claude/agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
```

### For `force` command:

1. **Confirm with user:**
   ```
   ⚠️  WARNING: This will remove ALL worktrees and delete their branches.
   
   Active worktrees:
   - .worktrees/agent-javascript-developer-1-1-20240107-120000 (Story: 1.1)
   - .worktrees/agent-python-developer-1-2-20240107-130000 (Story: 1.2)
   
   Are you absolutely sure you want to proceed? (yes/no)
   ```

2. **If confirmed, cleanup all worktrees:**
   ```bash
   # Get list of all worktrees (excluding main)
   git worktree list --porcelain | grep "worktree" | grep ".worktrees" | cut -d' ' -f2 | while read worktree_path; do
       ./.claude/agents/lib/git-worktree-manager.sh cleanup "$worktree_path"
   done
   ```

## ERROR HANDLING

### Error: Git Not Initialized

**Symptom:** Commands fail with "not a git repository"

**Solution:**
```
❌ Error: Not a git repository
💡 This command must be run from within a git repository
📍 Current directory: <path>
```

### Error: Worktree Has Uncommitted Changes

**Symptom:** Cleanup fails due to uncommitted changes

**Solution:**
```
⚠️  Warning: Worktree has uncommitted changes
📁 Worktree: <path>
📝 Uncommitted files:
   - src/components/Button.tsx
   - src/utils/helpers.ts

Options:
1. Commit the changes in the worktree
2. Force cleanup (changes will be lost): ./.claude/agents/lib/git-worktree-manager.sh cleanup "<path>" --force
3. Cancel cleanup
```

### Error: Merge Conflicts Exist

**Symptom:** Worktree has unresolved merge conflicts

**Solution:**
```
⚠️  Warning: Worktree has merge conflicts
📁 Worktree: <path>
🔀 Conflicting files:
   - src/App.tsx
   - package.json

You must resolve conflicts before cleanup:
1. cd <worktree-path>
2. Resolve conflicts in the listed files
3. git add <resolved-files>
4. git commit
5. cd ../../
6. ./.claude/agents/lib/git-worktree-manager.sh merge "<worktree-path>"
7. ./.claude/agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
```

## BEST PRACTICES

### Regular Maintenance

Run auto cleanup regularly:
```bash
# Daily or weekly
/cleanup-worktrees auto
```

### Before Starting New Work

Check for abandoned worktrees:
```bash
/cleanup-worktrees list
```

### After Story Completion

Verify cleanup happened:
```bash
# Should not show the completed story's worktree
/cleanup-worktrees list
```

### Disk Space Management

Monitor worktree disk usage:
```bash
du -sh .worktrees/*
```

## INTEGRATION WITH ORCHESTRATION

The `/implement-stories` command should:

1. **Before starting:** Check for abandoned worktrees
2. **During execution:** Track active worktrees
3. **After completion:** Verify cleanup
4. **On error:** Cleanup failed worktrees

**Example integration:**
```bash
# At start of /implement-stories
/cleanup-worktrees auto

# After each story
if story_failed:
    /cleanup-worktrees <worktree-path>
```

## TROUBLESHOOTING

### Worktree Won't Delete

**Try:**
```bash
# Force remove
git worktree remove <path> --force

# If that fails, manual cleanup
rm -rf <worktree-path>
git worktree prune
git branch -D <branch-name>
```

### Registry Out of Sync

**Fix:**
```bash
# Rebuild registry from actual worktrees
git worktree list --porcelain > /tmp/worktrees.txt
# Manually update .agent-orchestration/worktree-registry.json
```

### Disk Space Issues

**Quick cleanup:**
```bash
# Remove all worktrees immediately
/cleanup-worktrees force

# Or manually
rm -rf .worktrees/*
git worktree prune
```

## RELATED COMMANDS

- `/implement-stories` - Main orchestration command that creates worktrees
- `/story-status` - Check story status (may show worktree info)
- `/next-story` - Get next story to implement (checks worktree availability)

## SEE ALSO

- `.claude/agents/directives/git-worktree-workflow.md` - Complete worktree workflow guide
- `.claude/agents/lib/git-worktree-manager.sh` - Core worktree management script
- `.agent-orchestration/worktree-registry.json` - Worktree tracking registry

