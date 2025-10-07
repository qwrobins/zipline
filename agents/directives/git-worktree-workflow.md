# Git Worktree Workflow Directive

## ⚠️ MANDATORY: Multi-Agent Conflict Prevention ⚠️

**CRITICAL**: This workflow is **MANDATORY** for ALL development agents to prevent conflicts when multiple agents work on the same codebase simultaneously.

**Failure to follow this workflow will result in:**
- Merge conflicts between agents
- Lost work and code overwrites
- Build failures and test conflicts
- Coordination issues and delays

## Overview

When multiple AI agents work on the same codebase simultaneously, they can create conflicts by modifying the same files. Git worktrees provide isolated working directories where each agent can work independently without interfering with others.

**Key Benefits:**
- ✅ **Isolation**: Each agent works in their own directory
- ✅ **No Conflicts**: Changes don't interfere until intentionally merged
- ✅ **Parallel Work**: 2-3 agents can work simultaneously
- ✅ **Clean History**: Organized merge commits for each story
- ✅ **Easy Rollback**: Failed work can be discarded without affecting others

## When to Use This Workflow

**ALWAYS use this workflow when:**
- Implementing user stories from `docs/stories/`
- Making any code changes to the project
- Working as part of a multi-agent orchestration
- Modifying files that other agents might also modify

**You MAY skip this workflow when:**
- Only reading files (no modifications)
- Creating documentation in isolated directories
- Running read-only analysis or reviews

## Workflow Steps

### Phase 1: Pre-Work Setup (REQUIRED)

**Before making ANY file modifications, you MUST:**

#### Step 1.1: Verify Git Initialization

```bash
# Check if git is initialized
git rev-parse --git-dir
```

**If this fails:**
- ❌ **STOP immediately**
- 🚨 Report error to user: "Git repository not initialized. Please run 'git init' before proceeding."
- ⛔ **DO NOT proceed** with any file modifications

#### Step 1.2: Create Isolated Worktree

Use the git-worktree-manager script to create your isolated workspace:

```bash
# Create worktree for your story
./agents/lib/git-worktree-manager.sh create "<story-id>" "<your-agent-name>"

# Example:
./agents/lib/git-worktree-manager.sh create "1.1" "javascript-developer"
```

**The script will:**
- Generate a unique branch name: `agent-<agent-name>-<story-id>-<timestamp>`
- Create worktree directory: `.worktrees/agent-<agent-name>-<story-id>-<timestamp>/`
- Checkout a new branch in the worktree
- Register the worktree in the tracking registry
- Output the worktree path

**Save the worktree path** - you'll need it for cleanup later.

**Example output:**
```
[INFO] Creating worktree for story: 1.1, agent: javascript-developer
[INFO] Creating worktree at: .worktrees/agent-javascript-developer-1-1-20240107-120000
[SUCCESS] Worktree created successfully
.worktrees/agent-javascript-developer-1-1-20240107-120000
```

#### Step 1.3: Switch to Worktree Directory

**CRITICAL**: Change your working directory to the worktree:

```bash
cd .worktrees/agent-<agent-name>-<story-id>-<timestamp>
```

**Verify you're in the worktree:**
```bash
# Should show your worktree branch name
git branch --show-current

# Should show the worktree path
pwd
```

**⚠️ ALL SUBSEQUENT OPERATIONS MUST HAPPEN IN THIS DIRECTORY ⚠️**

### Phase 2: During Work (REQUIRED)

#### Step 2.1: Work in Isolation

**While in the worktree directory:**

1. **Make all file modifications** using your normal tools:
   - `str-replace-editor` for editing files
   - `save-file` for creating new files
   - `launch-process` for running commands

2. **Commit changes regularly:**
   ```bash
   git add .
   git commit -m "Implement feature X for story 1.1"
   ```

3. **Run tests in the worktree:**
   ```bash
   npm test
   # or
   pnpm test
   # or
   pytest
   ```

4. **Update story status** in the worktree:
   - Edit `docs/stories/<story-id>.md`
   - Update status to "Ready for Review"
   - Add your Dev Agent Record

#### Step 2.2: Ensure All Changes Are Committed

**Before proceeding to merge, verify:**

```bash
# Should show "nothing to commit, working tree clean"
git status
```

**If there are uncommitted changes:**
```bash
git add .
git commit -m "Final changes for story <story-id>"
```

### Phase 3: Post-Work Integration (REQUIRED)

#### Step 3.1: Return to Repository Root

```bash
# Go back to the repository root
cd ../../
```

**Verify you're in the repo root:**
```bash
# Should show "main" or your base branch
git branch --show-current
```

#### Step 3.2: Merge Worktree Changes

Use the git-worktree-manager script to merge your changes:

```bash
./agents/lib/git-worktree-manager.sh merge "<worktree-path>"

# Example:
./agents/lib/git-worktree-manager.sh merge ".worktrees/agent-javascript-developer-1-1-20240107-120000"
```

**The script will:**
- Verify all changes are committed
- Switch to the main branch
- Merge your worktree branch with `--no-ff` (creates merge commit)
- Report success or failure

**If merge succeeds:**
- ✅ Your changes are now in the main branch
- ✅ Proceed to cleanup

**If merge fails (conflicts):**
- ❌ **STOP and report to user**
- 🚨 Error message: "Merge conflicts detected. Manual resolution required."
- 📋 Provide conflict details
- ⏸️ **DO NOT cleanup** - user needs to resolve conflicts first

#### Step 3.3: Cleanup Worktree

**After successful merge, cleanup the worktree:**

```bash
./agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"

# Example:
./agents/lib/git-worktree-manager.sh cleanup ".worktrees/agent-javascript-developer-1-1-20240107-120000"
```

**The script will:**
- Remove the worktree directory
- Delete the worktree branch
- Unregister from the tracking registry

**Verify cleanup:**
```bash
# Should not show your worktree anymore
git worktree list
```

## Error Handling

### Error: Git Not Initialized

**Symptom:** `git rev-parse --git-dir` fails

**Solution:**
1. ❌ **STOP immediately**
2. 🚨 Report to user: "Git repository not initialized"
3. 📋 Suggest: "Please run 'git init' in the project root"
4. ⛔ **DO NOT proceed** with any work

### Error: Worktree Creation Fails

**Symptom:** `git-worktree-manager.sh create` fails

**Possible causes:**
- Disk space full
- Permission issues
- Git repository corrupted

**Solution:**
1. ❌ **STOP immediately**
2. 🚨 Report error to user with full error message
3. 📋 Suggest checking disk space and permissions
4. ⛔ **DO NOT proceed** with any work

### Error: Merge Conflicts

**Symptom:** `git-worktree-manager.sh merge` reports conflicts

**Solution:**
1. ⏸️ **PAUSE work**
2. 🚨 Report to user: "Merge conflicts detected in the following files:"
3. 📋 List conflicting files
4. 💡 Suggest: "Please resolve conflicts manually, then run cleanup"
5. ⚠️ **DO NOT cleanup worktree** - user needs to resolve conflicts

### Error: Uncommitted Changes During Merge

**Symptom:** Merge fails due to uncommitted changes

**Solution:**
1. Return to worktree directory
2. Commit all changes:
   ```bash
   git add .
   git commit -m "Final changes"
   ```
3. Return to repo root and retry merge

## Best Practices

### DO:
- ✅ Always create a worktree before making changes
- ✅ Work exclusively in the worktree directory
- ✅ Commit changes regularly
- ✅ Run tests in the worktree before merging
- ✅ Cleanup worktrees after successful merge
- ✅ Report errors clearly to the user

### DON'T:
- ❌ Make changes in the main working directory
- ❌ Skip worktree creation "just this once"
- ❌ Leave uncommitted changes when merging
- ❌ Cleanup worktrees with merge conflicts
- ❌ Reuse worktree directories across stories
- ❌ Manually create worktrees (use the script)

## Troubleshooting

### List Active Worktrees

```bash
./agents/lib/git-worktree-manager.sh list
```

### Cleanup Abandoned Worktrees

If worktrees are left behind (older than 24 hours):

```bash
./agents/lib/git-worktree-manager.sh cleanup-abandoned
```

### Manual Cleanup (Emergency)

If the script fails, you can manually cleanup:

```bash
# Remove worktree
git worktree remove .worktrees/<worktree-name> --force

# Delete branch
git branch -D <branch-name>
```

## Integration with Story Implementation

When implementing a story from `docs/stories/`:

1. **Read the story** in the main directory
2. **Create worktree** for the story
3. **Switch to worktree** directory
4. **Implement the story** in isolation
5. **Update story status** in the worktree
6. **Commit all changes**
7. **Return to repo root**
8. **Merge worktree** to main
9. **Cleanup worktree**
10. **Report completion** to user

## Summary

**This workflow is MANDATORY for all development agents.**

**Quick Reference:**
```bash
# 1. Create worktree
./agents/lib/git-worktree-manager.sh create "<story-id>" "<agent-name>"

# 2. Switch to worktree
cd .worktrees/agent-<agent-name>-<story-id>-<timestamp>

# 3. Do your work, commit changes
git add . && git commit -m "Your changes"

# 4. Return to repo root
cd ../../

# 5. Merge changes
./agents/lib/git-worktree-manager.sh merge "<worktree-path>"

# 6. Cleanup
./agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
```

**Remember:** This workflow prevents conflicts and enables multiple agents to work simultaneously. Always follow it!

