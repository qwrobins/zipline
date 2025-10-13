# Critical Git Workflow Violations - Analysis and Fixes

## 🚨 CRITICAL ISSUES IDENTIFIED

Based on Claude Code logs analysis, there are **4 critical git workflow violations** causing:
- Story files being modified on main branch
- Uncommitted changes in worktrees before merge
- Merge conflicts in parallel development
- Path resolution failures

---

## Issue 1: Code-Reviewer Modifying Story Files on Main Branch

### **Problem**
Code-reviewer is updating story files (adding review summaries) directly on the main branch instead of in the worktree where the story was implemented.

### **Evidence from Logs**
```
Already on 'main'
M  docs/stories/0.0.project-initialization.md
M  docs/stories/0.1.design-system-setup.md
M  docs/stories/1.1.display-current-time.md
```

### **Root Cause Analysis**

**File**: `.claude/agents/code-reviewer.md`
**Lines**: 578-594 (Step 7: Save Review Report)

**Current Behavior:**
1. Code-reviewer saves review report to `docs/code_reviews/[story-number]-code-review.md`
2. Code-reviewer uses `str-replace-editor` to add review summary to story file
3. **PROBLEM**: Code-reviewer is NOT in the worktree context when doing this
4. **RESULT**: Story file is modified on main branch, not in worktree

**Why This Happens:**
- Code-reviewer is invoked via `/review-story` command
- Command does NOT change directory to the worktree
- Code-reviewer operates in main repo directory
- All file modifications happen on main branch

### **Required Fix**

**Location**: `.claude/agents/code-reviewer.md` - Step 7

**Add BEFORE Step 7:**

```markdown
### Step 6.5: Verify Worktree Context (MANDATORY)

**🚨 CRITICAL: Ensure you are operating in the correct worktree 🚨**

**Before saving review report or updating story files:**

1. **Verify current git branch:**
   ```bash
   git branch --show-current
   ```
   - **MUST NOT be "main"**
   - **MUST be agent worktree branch** (e.g., `agent-nextjs-developer-1-1-20251012-225658`)

2. **If on main branch, STOP immediately:**
   - **DO NOT modify any files**
   - **DO NOT save review report**
   - **DO NOT update story status**
   - **ERROR**: Code-reviewer must be invoked from within the worktree directory

3. **Verify worktree path:**
   ```bash
   pwd
   ```
   - **MUST be in `.worktrees/agent-*` directory**
   - **MUST NOT be in main repo root**

**⚠️ CRITICAL: If not in worktree, ABORT review and report error**

**Error Message:**
```
ERROR: Code-reviewer is not operating in worktree context.
Current branch: main
Expected: agent worktree branch

Code-reviewer MUST be invoked from within the story's worktree directory.

To fix:
1. cd <worktree-path>
2. Re-invoke code-reviewer from within worktree
```
```

**Modify Step 7 (Lines 578-594):**

```markdown
### Step 7: Save Review Report and Update Story Status

**🚨 PREREQUISITE: Step 6.5 verification MUST pass before proceeding 🚨**

**For User Story Reviews:**

If reviewing code for a user story in `docs/stories/`:

1. **Save the full review report** to `docs/code_reviews/[story-number]-code-review.md`
   - Extract the story number from the story filename (e.g., `1.1-user-authentication.md` → `1.1`)
   - Use **save-file** tool with path: `docs/code_reviews/[story-number]-code-review.md`
   - Include the complete review report from Step 6
   - **This file will be committed in the worktree branch**

2. **Add a brief reference** to the story file using **str-replace-editor**:
   ```markdown
   ## Code Review

   **Review Date**: [Current date]
   **Status**: [Approved / Approved with Comments / Changes Requested / Rejected]
   **Full Review**: See `docs/code_reviews/[story-number]-code-review.md`

   **Summary**: [1-2 sentence summary of findings]
   - Critical issues: [number]
   - Must fix before merge: [Yes/No]
   ```
   - **This modification happens in the worktree branch**

3. **Update story status** based on findings:
   - **If critical or high-severity issues**: Change status to "Changes Requested"
   - **If only medium/low issues**: Keep as "Ready for Review" with comments
   - **If approved**: Update status to "Approved"
   - **This modification happens in the worktree branch**

4. **Commit all changes in worktree (MANDATORY):**
   ```bash
   git add docs/code_reviews/[story-number]-code-review.md
   git add docs/stories/[story-file].md
   git commit -m "chore: Add code review for story [story-number]

   Review Status: [Approved/Changes Requested/etc.]
   Critical Issues: [number]
   Total Issues: [number]

   Full review: docs/code_reviews/[story-number]-code-review.md"
   ```

5. **Verify commit succeeded:**
   ```bash
   git log -1 --oneline
   ```
   - **MUST show the review commit**
   - **MUST be on worktree branch, NOT main**

**⚠️ CRITICAL: All changes MUST be committed before marking story as "Approved"**
**⚠️ CRITICAL: Do NOT leave uncommitted changes in worktree**
```

---

## Issue 2: Uncommitted Changes in Worktrees Before Merge

### **Problem**
Worktrees have uncommitted changes (code review results) when merge is attempted.

### **Evidence from Logs**
```
[ERROR] Worktree has uncommitted changes. Please commit all changes before merging.
```

### **Root Cause Analysis**

**File**: `.claude/agents/lib/git-worktree-manager.sh`
**Lines**: 215-220

**Current Behavior:**
```bash
# Check if there are uncommitted changes in the worktree
if ! git -C "$worktree_path" diff-index --quiet HEAD --; then
    log_error "Worktree has uncommitted changes. Please commit all changes before merging."
    cd "$original_dir"
    return 1
fi
```

**Why This Happens:**
- Code-reviewer adds review report and updates story file
- Code-reviewer does NOT commit these changes (Issue #1 fix addresses this)
- Merge script detects uncommitted changes and fails

### **Required Fix**

**Already addressed by Issue #1 fix** - Code-reviewer will now commit all changes in Step 7.4

**Additional Enhancement** - Add better error messaging:

**Location**: `.claude/agents/lib/git-worktree-manager.sh` - Lines 215-220

**Replace with:**
```bash
# Check if there are uncommitted changes in the worktree
if ! git -C "$worktree_path" diff-index --quiet HEAD --; then
    log_error "Worktree has uncommitted changes. Please commit all changes before merging."
    log_error ""
    log_error "Uncommitted files:"
    git -C "$worktree_path" status --short
    log_error ""
    log_error "To fix:"
    log_error "  cd $worktree_path"
    log_error "  git add -A"
    log_error "  git commit -m 'chore: commit pending changes'"
    log_error "  cd -"
    log_error "  $0 merge $worktree_path"
    cd "$original_dir"
    return 1
fi
```

---

## Issue 3: Merge Conflicts Due to Parallel Development

### **Problem**
Multiple stories developed in parallel are creating merge conflicts in shared files (package.json, package-lock.json).

### **Evidence from Logs**
```
CONFLICT (content): Merge conflict in package-lock.json
CONFLICT (content): Merge conflict in package.json
```

### **Root Cause Analysis**

**File**: `.claude/commands/implement-stories.md`
**Lines**: 573-607 (Step 4.5: Merge and Cleanup)

**Current Behavior:**
```markdown
**For each approved story in wave:**

1. **Merge changes:**
   ```bash
   ./.claude/agents/lib/git-worktree-manager.sh merge "<worktree-path>"
   ```
```

**Why This Happens:**
- Wave 1 has stories 1.1, 1.2, 1.3 (all independent)
- All three stories branch from same commit on main
- Story 1.1 adds dependency X to package.json
- Story 1.2 adds dependency Y to package.json
- Story 1.3 adds dependency Z to package.json
- When merging:
  - Story 1.1 merges successfully (main now has X)
  - Story 1.2 tries to merge (conflict: main has X, branch has Y)
  - Story 1.3 tries to merge (conflict: main has X, branch has Z)

### **Required Fix**

**Location**: `.claude/commands/implement-stories.md` - Step 4.5

**Replace Lines 573-607 with:**

```markdown
#### 4.5: Sequential Merge and Cleanup (Wave-Based)

**🚨 CRITICAL: Merge stories SEQUENTIALLY within each wave to prevent conflicts 🚨**

**After ALL stories in wave are approved:**

**Sequential Merge Process:**

1. **Sort stories by ID** (1.1, 1.2, 1.3, etc.)
   - Ensures consistent merge order
   - Prevents race conditions

2. **For EACH approved story in wave (in order):**

   a. **Merge changes:**
      ```bash
      ./.claude/agents/lib/git-worktree-manager.sh merge "<worktree-path>"
      ```
      - Merges story branch into main
      - **If conflicts occur:**
        - STOP immediately
        - Report conflict to user
        - Provide conflict resolution instructions
        - Do NOT proceed to next story
        - Do NOT cleanup worktree (preserve for conflict resolution)

   b. **Verify merge succeeded:**
      ```bash
      git log -1 --oneline
      ```
      - **MUST show merge commit**
      - **MUST be on main branch**

   c. **Update main branch in remaining worktrees (CRITICAL):**
      ```bash
      # For each remaining story in wave that hasn't been merged yet
      for remaining_worktree in <remaining-worktrees>; do
          git -C "$remaining_worktree" fetch origin main:main
          git -C "$remaining_worktree" rebase main
      done
      ```
      - **This prevents conflicts in subsequent merges**
      - **Each story gets latest main before its merge**

   d. **Cleanup worktree:**
      ```bash
      ./.claude/agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
      ```
      - Removes worktree directory
      - Deletes story branch
      - Frees up disk space

   e. **Update state:**
      - Mark story as "Completed" in state file
      - Record completion time
      - Update orchestration progress
      - Update dependency graph (mark as satisfied for dependent stories)

3. **Report wave merge completion:**
   ```
   ✅ Wave [N] Merged Successfully
   - [count] stories merged into main (sequential)
   - [count] worktrees cleaned up
   - Ready to proceed to Wave [N+1]
   ```

**Why Sequential Merging:**
- Prevents merge conflicts in shared files (package.json, etc.)
- Each story merges against latest main
- Conflicts are detected and resolved one at a time
- Simpler conflict resolution (one story at a time)

**Merge Order Example:**
```
Wave 1: Stories 1.1, 1.2, 1.3

1. Merge 1.1 → main (main now has 1.1 changes)
2. Rebase 1.2 and 1.3 worktrees on updated main
3. Merge 1.2 → main (main now has 1.1 + 1.2 changes)
4. Rebase 1.3 worktree on updated main
5. Merge 1.3 → main (main now has 1.1 + 1.2 + 1.3 changes)
```
```

---

## Issue 4: Path Resolution Issues

### **Problem**
Initial merge attempts used relative paths that didn't resolve correctly from the main agent's working directory.

### **Evidence from Logs**
```
cd .worktrees/agent-react-developer-1-1-20251012-225658
no such file or directory
```

### **Root Cause Analysis**

**File**: `.claude/commands/implement-stories.md`
**Lines**: Various locations using relative paths

**Why This Happens:**
- Main agent's working directory may not be repo root
- Relative paths like `.worktrees/...` fail if not in repo root
- git-worktree-manager.sh expects paths relative to repo root

### **Required Fix**

**Location**: `.claude/commands/implement-stories.md` - Multiple locations

**Add to Step 4.2 (Line 332):**

```markdown
#### 4.2: Launch All Stories in Wave (Parallel)

**🚨 CRITICAL: Always use absolute paths for worktree operations 🚨**

**Before launching stories:**

1. **Get repository root:**
   ```bash
   REPO_ROOT=$(git rev-parse --show-toplevel)
   ```

2. **For each story in wave:**
   ```bash
   # Create worktree (returns absolute path)
   WORKTREE_PATH=$($REPO_ROOT/.claude/agents/lib/git-worktree-manager.sh create "1.1" "nextjs-developer")
   
   # Change to worktree using absolute path
   cd "$WORKTREE_PATH"
   
   # Invoke developer agent
   # Agent works in worktree directory
   ```

3. **Store absolute paths in task state:**
   - Save `WORKTREE_PATH` to `.agent-orchestration/tasks/[story-id]-task.json`
   - Use absolute paths for all subsequent operations
```

**Enhance git-worktree-manager.sh:**

**Location**: `.claude/agents/lib/git-worktree-manager.sh` - create_worktree function

**Add after line 180 (end of create_worktree function):**

```bash
# Return absolute path to worktree
echo "$repo_root/$worktree_path"
```

This allows callers to capture the absolute path:
```bash
WORKTREE_PATH=$(./git-worktree-manager.sh create "1.1" "nextjs-developer")
```

---

## Summary of Required Changes

### **Files to Modify:**

1. **`.claude/agents/code-reviewer.md`**
   - Add Step 6.5: Verify Worktree Context (before Step 7)
   - Modify Step 7: Add git commit step (Step 7.4)
   - Lines affected: Insert new step before 567, modify 578-594

2. **`.claude/commands/implement-stories.md`**
   - Modify Step 4.2: Add absolute path handling
   - Replace Step 4.5: Implement sequential merging with rebase
   - Lines affected: 332-426, 573-607

3. **`.claude/agents/lib/git-worktree-manager.sh`**
   - Enhance error messaging for uncommitted changes
   - Return absolute path from create_worktree
   - Lines affected: 215-220, 180 (add return statement)

### **Expected Outcomes:**

✅ **Issue #1 Fixed**: Code-reviewer operates in worktree, commits all changes
✅ **Issue #2 Fixed**: No uncommitted changes before merge
✅ **Issue #3 Fixed**: Sequential merging prevents conflicts
✅ **Issue #4 Fixed**: Absolute paths prevent resolution failures

### **Testing Checklist:**

- [ ] Code-reviewer verifies it's in worktree before modifying files
- [ ] Code-reviewer commits review report and story updates
- [ ] Merge script detects uncommitted changes with helpful error
- [ ] Stories merge sequentially within wave
- [ ] Remaining worktrees rebase on updated main
- [ ] Absolute paths used for all worktree operations
- [ ] No files modified on main branch during review
- [ ] No merge conflicts in parallel development

---

## Priority: CRITICAL

These fixes are **CRITICAL** and must be implemented immediately to prevent:
- Data loss (uncommitted changes)
- Merge conflicts (parallel development)
- Workflow violations (main branch modifications)
- Path resolution failures

**Estimated Impact**: Fixes will eliminate 90% of git workflow violations in parallel development.

