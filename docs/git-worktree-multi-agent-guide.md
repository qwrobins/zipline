# Git Worktree Multi-Agent Development Guide

## Overview

This guide explains how the Zipline agent system uses git worktrees to enable multiple AI agents to work on the same codebase simultaneously without conflicts.

## The Problem

When multiple AI agents work on the same codebase at the same time, they can create conflicts:

- **File Conflicts**: Two agents editing the same file simultaneously
- **Test Conflicts**: Agents running tests that interfere with each other
- **Build Conflicts**: Concurrent builds causing resource contention
- **Merge Conflicts**: Changes from different agents conflicting when merged

**Traditional Solution:** Sequential execution - one agent at a time (slow)

**Our Solution:** Git worktrees - isolated workspaces for each agent (fast)

## What Are Git Worktrees?

Git worktrees allow you to have multiple working directories from the same repository:

```
my-project/                          # Main working directory (main branch)
├── .worktrees/                      # Worktree directory
│   ├── agent-js-dev-1-1-20240107/  # Agent 1's isolated workspace
│   └── agent-py-dev-1-2-20240107/  # Agent 2's isolated workspace
├── src/
├── tests/
└── package.json
```

Each worktree:
- Has its own working directory
- Can be on a different branch
- Shares the same git repository
- Doesn't interfere with other worktrees

## How It Works

### 1. Pre-Work Setup

**Before an agent starts work:**

```bash
# Orchestrator creates a worktree for the agent
./agents/lib/git-worktree-manager.sh create "1.1" "javascript-developer"

# Output: .worktrees/agent-javascript-developer-1-1-20240107-120000
```

**What happens:**
- Unique branch created: `agent-javascript-developer-1-1-20240107-120000`
- Worktree directory created: `.worktrees/agent-javascript-developer-1-1-20240107-120000/`
- Worktree registered in tracking system
- Agent receives the worktree path

### 2. During Work

**Agent works in isolation:**

```bash
# Agent switches to their worktree
cd .worktrees/agent-javascript-developer-1-1-20240107-120000

# Agent makes changes
# - Edit files
# - Run tests
# - Commit changes

# All work happens in isolation - no conflicts with other agents
```

**Meanwhile, other agents can work in their own worktrees:**

```
Agent 1: .worktrees/agent-javascript-developer-1-1-20240107-120000/
         Working on Story 1.1 (User Authentication)

Agent 2: .worktrees/agent-python-developer-1-2-20240107-130000/
         Working on Story 1.2 (API Client Setup)

Agent 3: .worktrees/agent-rust-developer-1-3-20240107-140000/
         Working on Story 1.3 (Database Schema)
```

**No conflicts!** Each agent has their own isolated workspace.

### 3. Post-Work Integration

**After agent completes work:**

```bash
# Agent returns to repo root
cd ../../

# Merge agent's changes into main
./agents/lib/git-worktree-manager.sh merge ".worktrees/agent-javascript-developer-1-1-20240107-120000"

# Cleanup the worktree
./agents/lib/git-worktree-manager.sh cleanup ".worktrees/agent-javascript-developer-1-1-20240107-120000"
```

**What happens:**
- Agent's branch is merged into main with `--no-ff` (creates merge commit)
- If conflicts exist, merge fails and reports to user
- Worktree directory is removed
- Branch is deleted
- Registry is updated

## Benefits

### 1. Parallel Development

**Without worktrees (sequential):**
```
Story 1.1 (4 hours) → Story 1.2 (4 hours) → Story 1.3 (4 hours)
Total: 12 hours
```

**With worktrees (parallel):**
```
Story 1.1 (4 hours) ┐
Story 1.2 (4 hours) ├─ All running simultaneously
Story 1.3 (4 hours) ┘
Total: 4 hours (3x faster!)
```

### 2. Conflict Prevention

- Each agent works in isolation
- No file locking issues
- No test interference
- No build conflicts
- Clean merge history

### 3. Easy Rollback

If an agent's work fails:
```bash
# Just delete the worktree - main branch is unaffected
./agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
```

### 4. Clear History

Each story gets its own merge commit:
```
* Merge worktree: agent-javascript-developer-1-1-20240107-120000
* Merge worktree: agent-python-developer-1-2-20240107-130000
* Merge worktree: agent-rust-developer-1-3-20240107-140000
```

## Workflow for Agents

### Step-by-Step Process

**1. Receive Worktree Assignment**

Orchestrator tells you:
```
Your worktree: .worktrees/agent-javascript-developer-1-1-20240107-120000
Story: 1.1 - User Authentication
```

**2. Switch to Worktree**

```bash
cd .worktrees/agent-javascript-developer-1-1-20240107-120000
```

**3. Verify You're in the Worktree**

```bash
git branch --show-current
# Should show: agent-javascript-developer-1-1-20240107-120000

pwd
# Should show: /path/to/repo/.worktrees/agent-javascript-developer-1-1-20240107-120000
```

**4. Do Your Work**

```bash
# Edit files
# Run tests
# Commit changes
git add .
git commit -m "Implement user authentication"
```

**5. Return to Repo Root**

```bash
cd ../../
```

**6. Merge Your Changes**

```bash
./agents/lib/git-worktree-manager.sh merge ".worktrees/agent-javascript-developer-1-1-20240107-120000"
```

**7. Cleanup**

```bash
./agents/lib/git-worktree-manager.sh cleanup ".worktrees/agent-javascript-developer-1-1-20240107-120000"
```

## Workflow for Orchestrator

### Managing Multiple Agents

**1. Before Assigning Stories**

```bash
# Create worktrees for each agent
WORKTREE_1=$(./agents/lib/git-worktree-manager.sh create "1.1" "javascript-developer")
WORKTREE_2=$(./agents/lib/git-worktree-manager.sh create "1.2" "python-developer")
WORKTREE_3=$(./agents/lib/git-worktree-manager.sh create "1.3" "rust-developer")
```

**2. Assign Stories to Agents**

```
Agent 1: Story 1.1, Worktree: $WORKTREE_1
Agent 2: Story 1.2, Worktree: $WORKTREE_2
Agent 3: Story 1.3, Worktree: $WORKTREE_3
```

**3. Monitor Progress**

```bash
# List active worktrees
./agents/lib/git-worktree-manager.sh list
```

**4. After Completion**

```bash
# Verify each agent merged and cleaned up
# If not, manually cleanup
./agents/lib/git-worktree-manager.sh cleanup "$WORKTREE_1"
```

**5. Regular Maintenance**

```bash
# Cleanup abandoned worktrees (daily/weekly)
./agents/lib/git-worktree-manager.sh cleanup-abandoned
```

## Common Scenarios

### Scenario 1: Successful Parallel Development

```
Time 0:00 - Orchestrator creates 3 worktrees
Time 0:01 - Agent 1, 2, 3 start work simultaneously
Time 4:00 - Agent 1 completes, merges, cleans up
Time 4:15 - Agent 2 completes, merges, cleans up
Time 4:30 - Agent 3 completes, merges, cleans up
Result: 3 stories done in 4.5 hours (vs 12 hours sequential)
```

### Scenario 2: Merge Conflict

```
Time 0:00 - Agent 1 and Agent 2 both modify same file
Time 4:00 - Agent 1 merges successfully
Time 4:15 - Agent 2 tries to merge → CONFLICT!
Action: Orchestrator reports conflict to user
User: Manually resolves conflict
User: Completes merge and cleanup
```

### Scenario 3: Agent Failure

```
Time 0:00 - Agent 1 starts work
Time 2:00 - Agent 1 crashes/fails
Action: Orchestrator detects failure
Action: Cleanup worktree (no merge needed)
Result: Main branch unaffected, can retry story
```

### Scenario 4: Abandoned Worktrees

```
Time 0:00 - Agent 1 starts work
Time 4:00 - Agent 1 completes but forgets cleanup
Time 24:00+ - Worktree is now "abandoned"
Action: Run cleanup-abandoned command
Result: Old worktree removed automatically
```

## Troubleshooting

### Problem: Merge Conflicts

**Symptom:** Merge fails with conflict errors

**Solution:**
1. Don't panic - main branch is safe
2. Review conflicting files
3. Manually resolve conflicts
4. Complete merge: `git merge --continue`
5. Then cleanup worktree

### Problem: Worktree Won't Delete

**Symptom:** Cleanup fails

**Solution:**
```bash
# Force remove
git worktree remove <path> --force

# If that fails
rm -rf <worktree-path>
git worktree prune
git branch -D <branch-name>
```

### Problem: Disk Space Running Low

**Symptom:** Worktree creation fails

**Solution:**
```bash
# Cleanup abandoned worktrees
./agents/lib/git-worktree-manager.sh cleanup-abandoned

# Check disk usage
du -sh .worktrees/*

# If needed, force cleanup all
/cleanup-worktrees force
```

### Problem: Agent Forgot to Cleanup

**Symptom:** Worktree still exists after story completion

**Solution:**
```bash
# Manual cleanup
./agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
```

## Best Practices

### For Agents

1. ✅ **Always** create worktree before making changes
2. ✅ **Always** work in the worktree directory
3. ✅ **Always** commit changes before merging
4. ✅ **Always** cleanup after successful merge
5. ❌ **Never** make changes in main working directory
6. ❌ **Never** skip worktree creation

### For Orchestrator

1. ✅ **Always** create worktrees before assigning stories
2. ✅ **Always** track worktree paths in task state
3. ✅ **Always** verify cleanup after completion
4. ✅ **Always** run cleanup-abandoned regularly
5. ❌ **Never** assign same story to multiple agents
6. ❌ **Never** skip conflict detection

### For Users

1. ✅ **Always** resolve conflicts promptly
2. ✅ **Always** monitor disk space
3. ✅ **Always** review merge commits
4. ❌ **Never** manually edit worktree registry
5. ❌ **Never** delete .worktrees directory manually

## Advanced Topics

### Custom Worktree Age Limit

Edit `agents/lib/git-worktree-manager.sh`:
```bash
MAX_WORKTREE_AGE_HOURS=48  # Change from 24 to 48 hours
```

### Worktree on Different Branch

```bash
./agents/lib/git-worktree-manager.sh create "1.1" "javascript-developer" "develop"
# Creates worktree from 'develop' branch instead of 'main'
```

### Manual Worktree Operations

```bash
# Create manually (not recommended)
git worktree add .worktrees/my-feature -b my-feature

# List all worktrees
git worktree list

# Remove manually (not recommended)
git worktree remove .worktrees/my-feature
```

## Related Documentation

- `agents/directives/git-worktree-workflow.md` - Detailed workflow for agents
- `agents/lib/README.md` - Git worktree manager documentation
- `.claude/commands/cleanup-worktrees.md` - Cleanup command reference
- `.claude/commands/implement-stories.md` - Orchestration system integration

## Summary

Git worktrees enable multiple AI agents to work simultaneously without conflicts:

- ✅ **Isolation**: Each agent has their own workspace
- ✅ **Parallel**: 2-3 agents work at the same time
- ✅ **Safe**: Main branch protected from failures
- ✅ **Fast**: 2-3x faster than sequential development
- ✅ **Clean**: Organized merge history

**Remember:** Always use the git-worktree-manager script - don't create worktrees manually!

