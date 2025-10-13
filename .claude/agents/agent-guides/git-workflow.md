# Git Worktree Workflow for Multi-Agent Development

## Overview

This workflow prevents conflicts when multiple agents work simultaneously by isolating each agent's work in separate directories.

**Key Benefits:**
- ✅ Technical isolation - each agent works in their own directory
- ✅ No conflicts - changes don't interfere until intentionally merged
- ✅ Clean history - organized commits per feature
- ✅ Easy rollback - can discard worktree without affecting main branch

## When to Use

**ALWAYS use this workflow when:**
- Implementing user stories from `docs/stories/`
- Making code changes as part of multi-agent orchestration
- Working on features that might conflict with other agents

## Quick Start

### 1. Create Worktree

```bash
# Create isolated workspace for your story
./.claude/agents/lib/git-worktree-manager.sh create "<story-id>" "<agent-name>"

# Example:
./.claude/agents/lib/git-worktree-manager.sh create "1.2" "python-developer"
```

### 2. Switch to Worktree

```bash
# Navigate to your isolated workspace
cd .worktrees/agent-<agent-name>-<story-id>-<timestamp>
```

### 3. Do Your Work

```bash
# Make changes, commit as normal
git add .
git commit -m "Implement story 1.2: Feature name"
```

### 4. Return and Merge

```bash
# Return to repo root
cd ../../

# Merge your changes
./.claude/agents/lib/git-worktree-manager.sh merge "<worktree-path>"

# Cleanup
./.claude/agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
```

## Detailed Workflow

### Pre-Work Verification

**Before creating worktree, verify git is initialized:**

```bash
git rev-parse --git-dir
```

**If this fails:**
- ❌ STOP immediately
- 🚨 Report: "Git repository not initialized. Please run 'git init' first."
- ⛔ DO NOT proceed with file modifications

### Worktree Creation

The `git-worktree-manager.sh` script handles:
- Branch creation from current HEAD
- Worktree directory setup
- Proper naming conventions
- Error handling

**Script location:** `.claude/agents/lib/git-worktree-manager.sh`

### Working in Worktree

Once in your worktree:

1. **Make changes** - edit files as needed
2. **Commit frequently** - small, focused commits
3. **Test thoroughly** - run tests before merging
4. **Document changes** - clear commit messages

### Merging Back

**Before merging:**
- ✅ All tests pass
- ✅ Code follows project standards
- ✅ Commits are clean and descriptive

**Merge process:**
```bash
# The script handles:
# 1. Switching to main branch
# 2. Merging worktree branch
# 3. Resolving any conflicts
# 4. Pushing changes (if configured)
./.claude/agents/lib/git-worktree-manager.sh merge "<worktree-path>"
```

### Cleanup

**After successful merge:**
```bash
./.claude/agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
```

This removes:
- Worktree directory
- Associated branch
- Temporary files

## Error Handling

### Common Issues

**1. Git not initialized**
```
Error: Not a git repository
Solution: Run 'git init' in project root
```

**2. Worktree already exists**
```
Error: Worktree already exists at path
Solution: Use different story-id or cleanup existing worktree
```

**3. Merge conflicts**
```
Error: Merge conflict in file.py
Solution: Resolve conflicts manually, then continue merge
```

### Recovery

**If something goes wrong:**

1. **Don't panic** - worktrees are isolated
2. **Check status** - `git worktree list`
3. **Remove problematic worktree** - `git worktree remove <path>`
4. **Start fresh** - create new worktree

## Best Practices

### Naming Conventions

- **Story ID**: Use epic.number format (e.g., "1.2", "2.3")
- **Agent name**: Use your agent identifier (e.g., "python-developer")
- **Branch names**: Auto-generated as `feature/<agent>-<story>-<timestamp>`

### Commit Messages

```bash
# Good commit messages
git commit -m "feat: Add user authentication endpoint"
git commit -m "fix: Resolve async context manager issue"
git commit -m "test: Add integration tests for auth flow"

# Bad commit messages
git commit -m "updates"
git commit -m "fix stuff"
git commit -m "wip"
```

### Testing Before Merge

**Always run tests in worktree before merging:**

```bash
# In worktree directory
pytest                    # Python
npm test                  # JavaScript/TypeScript
cargo test                # Rust
go test ./...             # Go
```

### Cleanup Discipline

**Clean up worktrees promptly:**
- After successful merge
- After abandoning work
- Before starting new stories

**Check for orphaned worktrees:**
```bash
git worktree list
```

## Integration with User Stories

When implementing stories from `docs/stories/`:

1. **Read story file** - understand requirements
2. **Create worktree** - isolate your work
3. **Implement features** - follow acceptance criteria
4. **Run tests** - ensure quality
5. **Update story status** - mark as "Ready for Review"
6. **Merge and cleanup** - integrate changes

## Advanced Usage

### Multiple Worktrees

You can have multiple worktrees simultaneously:

```bash
# Agent 1 working on story 1.2
cd .worktrees/agent-python-developer-1.2-<timestamp>

# Agent 2 working on story 2.1
cd .worktrees/agent-react-developer-2.1-<timestamp>
```

### Long-Running Worktrees

For complex features:
- Keep worktree active across sessions
- Commit frequently
- Sync with main branch periodically
- Merge when feature is complete

### Worktree Inspection

```bash
# List all worktrees
git worktree list

# Check worktree status
cd <worktree-path>
git status
git log --oneline -10
```

## Reference

**Full documentation:** `.claude/agents/directives/git-worktree-workflow.md`
**Script source:** `.claude/agents/lib/git-worktree-manager.sh`
**Design integration:** See design validation section in full docs

## Quick Reference Card

```bash
# Create
./.claude/agents/lib/git-worktree-manager.sh create "<story-id>" "<agent>"

# Navigate
cd .worktrees/agent-<agent>-<story>-<timestamp>

# Work
git add . && git commit -m "message"

# Return
cd ../../

# Merge
./.claude/agents/lib/git-worktree-manager.sh merge "<worktree-path>"

# Cleanup
./.claude/agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
```

