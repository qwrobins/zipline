# Git Worktree Quick Start Guide

## 5-Minute Setup

Get started with git worktree multi-agent development in 5 minutes.

## Prerequisites

1. **Git 2.5+**
   ```bash
   git --version
   # Should show 2.5 or higher
   ```

2. **jq (JSON processor)**
   ```bash
   # macOS
   brew install jq
   
   # Ubuntu/Debian
   sudo apt-get install jq
   
   # Verify
   jq --version
   ```

3. **Git repository initialized**
   ```bash
   git rev-parse --git-dir
   # Should succeed without error
   ```

## Quick Start

### Step 1: Make Script Executable

```bash
chmod +x agents/lib/git-worktree-manager.sh
```

### Step 2: Test the Script

```bash
./agents/lib/git-worktree-manager.sh help
```

You should see the help message with available commands.

### Step 3: Create Your First Worktree

```bash
# Create a worktree for story 1.1
./agents/lib/git-worktree-manager.sh create "1.1" "javascript-developer"

# Output will show the worktree path:
# .worktrees/agent-javascript-developer-1-1-20240107-120000
```

### Step 4: Switch to the Worktree

```bash
cd .worktrees/agent-javascript-developer-1-1-20240107-120000
```

### Step 5: Make Some Changes

```bash
# Create a test file
echo "console.log('Hello from worktree!');" > test.js

# Commit the changes
git add test.js
git commit -m "Test worktree functionality"
```

### Step 6: Return to Repo Root

```bash
cd ../../
```

### Step 7: Merge the Changes

```bash
./agents/lib/git-worktree-manager.sh merge ".worktrees/agent-javascript-developer-1-1-20240107-120000"
```

### Step 8: Cleanup the Worktree

```bash
./agents/lib/git-worktree-manager.sh cleanup ".worktrees/agent-javascript-developer-1-1-20240107-120000"
```

### Step 9: Verify

```bash
# Check that the file is now in main branch
ls test.js

# Check that worktree is gone
./agents/lib/git-worktree-manager.sh list
```

**Congratulations!** You've successfully used git worktrees for isolated development.

## Common Commands

### Create Worktree
```bash
./agents/lib/git-worktree-manager.sh create "<story-id>" "<agent-name>"
```

### List Worktrees
```bash
./agents/lib/git-worktree-manager.sh list
```

### Merge Worktree
```bash
./agents/lib/git-worktree-manager.sh merge "<worktree-path>"
```

### Cleanup Worktree
```bash
./agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
```

### Cleanup Abandoned
```bash
./agents/lib/git-worktree-manager.sh cleanup-abandoned
```

## Agent Workflow

When implementing a story as an agent:

```bash
# 1. Create worktree (orchestrator does this)
WORKTREE=$(./agents/lib/git-worktree-manager.sh create "1.1" "javascript-developer")

# 2. Switch to worktree
cd "$WORKTREE"

# 3. Do your work
# - Edit files
# - Run tests
# - Commit changes

# 4. Return to repo root
cd ../../

# 5. Merge changes
./agents/lib/git-worktree-manager.sh merge "$WORKTREE"

# 6. Cleanup
./agents/lib/git-worktree-manager.sh cleanup "$WORKTREE"
```

## Orchestrator Workflow

When coordinating multiple agents:

```bash
# 1. Create worktrees for each agent
WORKTREE_1=$(./agents/lib/git-worktree-manager.sh create "1.1" "javascript-developer")
WORKTREE_2=$(./agents/lib/git-worktree-manager.sh create "1.2" "python-developer")

# 2. Assign to agents
# Agent 1 → Story 1.1, Worktree: $WORKTREE_1
# Agent 2 → Story 1.2, Worktree: $WORKTREE_2

# 3. Monitor progress
./agents/lib/git-worktree-manager.sh list

# 4. After completion, verify cleanup
# If needed, manually cleanup
./agents/lib/git-worktree-manager.sh cleanup "$WORKTREE_1"
./agents/lib/git-worktree-manager.sh cleanup "$WORKTREE_2"
```

## Troubleshooting

### Error: jq not found

**Solution:**
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq
```

### Error: Permission denied

**Solution:**
```bash
chmod +x agents/lib/git-worktree-manager.sh
```

### Error: Git not initialized

**Solution:**
```bash
git init
```

### Error: Merge conflicts

**Solution:**
1. Review conflicting files
2. Manually resolve conflicts
3. Run: `git merge --continue`
4. Then cleanup worktree

## Next Steps

1. **Read the full guide:** `docs/git-worktree-multi-agent-guide.md`
2. **Review agent workflow:** `agents/directives/git-worktree-workflow.md`
3. **Check cleanup command:** `.claude/commands/cleanup-worktrees.md`
4. **Try parallel development:** Create 2-3 worktrees and work simultaneously

## Tips

- ✅ Always create worktree before making changes
- ✅ Always work in the worktree directory
- ✅ Always commit before merging
- ✅ Always cleanup after successful merge
- ✅ Run cleanup-abandoned regularly

## Help

For more information:
- Run: `./agents/lib/git-worktree-manager.sh help`
- Read: `agents/lib/README.md`
- Check: `docs/git-worktree-multi-agent-guide.md`

## Summary

**Basic workflow:**
1. Create worktree
2. Switch to worktree
3. Do work
4. Return to root
5. Merge
6. Cleanup

**That's it!** You're ready to use git worktrees for multi-agent development.

