# Orchestrator Workflow Quick Reference

## 🚨 CRITICAL: Code Review Before Merge

### Developer Agent - Initial Implementation

**What Developer Does:**
1. ✅ Implement story in worktree
2. ✅ Commit all changes
3. ✅ Update status to "Ready for Review"
4. ✅ Add Dev Agent Record
5. ✅ **STOP HERE** - Leave worktree intact

**What Developer Does NOT Do:**
- ❌ Merge worktree
- ❌ Cleanup worktree
- ❌ Update status to "Done"

### Orchestrator - Code Review Phase

**What Orchestrator Does:**
1. ✅ Wait for all stories in wave to be "Ready for Review"
2. ✅ Invoke code review agent for each story
3. ✅ Wait for all code reviews to complete
4. ✅ Read review results
5. ✅ Proceed to review outcome handling

### Code Review Agent

**What Code Review Agent Does:**
1. ✅ Review changes in worktree (NOT merged yet)
2. ✅ Create comprehensive review report
3. ✅ Categorize issues (Critical/High/Medium/Low)
4. ✅ Provide overall assessment (Approved/Changes Requested/Rejected)
5. ✅ Save review to `docs/code_reviews/{story_id}-code-review.md`

### Orchestrator - Handle Review Outcomes

**If Review APPROVED:**
1. ✅ Re-invoke developer agent for merge
2. ✅ Developer detects conflicts
3. ✅ Developer merges worktree (if no conflicts)
4. ✅ Developer cleans up worktree
5. ✅ Developer updates status to "Done"
6. ✅ Proceed to next wave

**If Review CHANGES REQUESTED:**
1. ✅ Re-invoke developer agent with feedback
2. ✅ Developer implements fixes in worktree
3. ✅ Developer updates status to "Ready for Review"
4. ✅ Trigger another code review cycle
5. ✅ Repeat until approved

**If Review REJECTED:**
1. ✅ Escalate to user with rejection reason
2. ✅ Wait for user decision (re-scope/abandon/manual review)
3. ✅ Do NOT proceed to next wave

---

## Git Initialization

### Default Branch: "main"

**Sequence:**
1. `git init`
2. Create `.gitignore`
3. `git add .`
4. `git commit -m "Initial commit"`
5. **`git branch -M main`** ← Sets default branch to "main"
6. Verify initialization succeeded

---

## Dependency Optimization

### Story 1.1 (Project Initialization)

**Developer Agent Should:**
- ✅ Install ALL core project dependencies
- ✅ Include: package managers, frameworks, testing libraries, linting tools
- ✅ Commit `package.json` and lock files
- ✅ Document all installed dependencies in Dev Agent Record

### Stories 1.2+ (Subsequent Stories)

**Developer Agent Should:**
- ✅ Check if dependencies already exist in `package.json`/lock file
- ✅ If dependencies exist, run install command (`npm install`, `pip install -r`, etc.)
- ✅ Only add new dependencies if NOT already in lock file
- ✅ This saves tokens and ensures consistent versions

---

## Conflict Resolution

### When Conflicts Detected During Merge

**Orchestrator Actions:**

**For Low/Medium Severity:**
1. Invoke conflict-resolver agent
2. Automatically apply proposed resolution
3. Notify developer agent to retry merge

**For High/Critical Severity:**
1. Invoke conflict-resolver agent
2. Present proposed resolution to user
3. Wait for user approval
4. Apply approved resolution
5. Notify developer agent to retry merge

---

## Phase-by-Phase Workflow

### Phase 7: Parallel Execution Loop

**Step 1:** Git Initialization Check
- Check if git is initialized
- If not, initialize automatically with "main" branch
- Enforce worktree workflow (MANDATORY)

**Step 2:** Identify Ready Stories
- Find stories with satisfied dependencies
- Group into current wave

**Step 3:** Verify Git Before Wave
- Double-check git is initialized
- STOP if not initialized

**Step 4:** Start Wave Implementation
- Create worktree for each story
- Launch ALL agents in wave simultaneously
- Agents implement stories
- Agents commit changes
- Agents update status to "Ready for Review"
- Agents STOP (do NOT merge)

**Step 5:** Monitor Wave for Completion
- Wait for ALL agents to complete
- Verify all stories are "Ready for Review"
- Verify all worktrees are intact (not merged)

**Step 6:** Code Review Phase
- Invoke code review agent for each story
- Wait for ALL reviews to complete
- Read review results

**Step 7:** Handle Review Outcomes and Merge
- For APPROVED: Re-invoke developer to merge
- For CHANGES REQUESTED: Re-invoke developer to fix
- For REJECTED: Escalate to user

**Step 7a:** Conflict Detection and Resolution (if needed)
- Detect conflicts during merge
- Invoke conflict-resolver
- Apply resolution
- Retry merge

### Phase 8: Completion & Reporting

**Step 1:** Verify Code Review Compliance
- Confirm ALL stories have approved reviews
- Verify ALL review files exist

**Step 2:** Generate Final Report
- Total stories completed
- Code review compliance metrics
- Review cycle statistics

---

## Critical Rules

### ❌ NEVER Do These:

1. ❌ Skip code review for any story
2. ❌ Merge before code review is approved
3. ❌ Proceed to next wave without approved reviews
4. ❌ Mark story as done without code review documentation
5. ❌ Let developer agents merge during initial implementation
6. ❌ Cleanup worktree before code review

### ✅ ALWAYS Do These:

1. ✅ Wait for code review completion before merge
2. ✅ Re-invoke developer agent to handle merge after approval
3. ✅ Address code review feedback before proceeding
4. ✅ Document code review results in story file
5. ✅ Keep worktree intact until after code review approval
6. ✅ Use "main" as default branch name
7. ✅ Install dependencies once in Story 1.1
8. ✅ Check for existing dependencies in Stories 1.2+

---

## Developer Agent Message Templates

### Initial Implementation

```
@agent-{assigned_agent}, please implement story {story_id}.

🚨 CRITICAL: DO NOT MERGE OR CLEANUP - Code review happens FIRST 🚨

Follow these steps EXACTLY:
1-9. [Implementation steps]
10. Update story status to "Ready for Review"
11. Add Dev Agent Record
12. STOP HERE - Do NOT merge or cleanup worktree

⚠️ LEAVE THE WORKTREE INTACT - The orchestrator will handle merge after code review
```

### After Review APPROVED

```
@agent-{assigned_agent}, congratulations! The code review for story {story_id} has been APPROVED.

✅ Your implementation passed code review!

Now you must merge your changes to the main branch:
1. Review the code review feedback
2. Return to repo root
3. Detect potential conflicts
4. Merge worktree (if no conflicts)
5. Unregister files
6. Cleanup worktree
7. Update story status to "Done"
8. Document merge in Dev Agent Record
```

### After Review CHANGES REQUESTED

```
@agent-{assigned_agent}, the code review for story {story_id} found issues
that need to be addressed before merging.

⚠️ Your implementation requires changes before it can be merged.

Please:
1. Read the complete code review
2. Switch to your worktree
3. Address ALL critical and high-priority issues
4. Commit your fixes
5. Return to repo root
6. Update story status back to "Ready for Review"
7. Update Dev Agent Record with fixes made

⚠️ DO NOT merge or cleanup the worktree - keep it intact for re-review
```

---

## Verification Checkpoints

### After Initial Implementation
- [ ] Story status is "Ready for Review"
- [ ] Dev Agent Record is present
- [ ] Worktree is intact (not merged)
- [ ] All changes committed to worktree

### After Code Review
- [ ] Review file exists
- [ ] Review status extracted (Approved/Changes Requested/Rejected)
- [ ] Task state updated with review information

### After Merge (if Approved)
- [ ] Worktree merged to main
- [ ] Worktree cleaned up
- [ ] Story status is "Done"
- [ ] Dev Agent Record updated with review results
- [ ] Progress tracking updated

### After Fixes (if Changes Requested)
- [ ] Fixes implemented in worktree
- [ ] Fixes committed
- [ ] Story status is "Ready for Review"
- [ ] Dev Agent Record updated with fixes
- [ ] Worktree still intact (not merged)

---

## Common Scenarios

### Scenario 1: First-Pass Approval ✅
```
Implement → Ready for Review → Code Review → APPROVED → Merge → Done
Time: ~1 cycle
```

### Scenario 2: One Round of Fixes 🔄
```
Implement → Ready for Review → Code Review → CHANGES REQUESTED
→ Fix → Ready for Review → Code Review → APPROVED → Merge → Done
Time: ~2 cycles
```

### Scenario 3: Multiple Rounds of Fixes 🔄🔄
```
Implement → Ready for Review → Code Review → CHANGES REQUESTED
→ Fix → Ready for Review → Code Review → CHANGES REQUESTED
→ Fix → Ready for Review → Code Review → APPROVED → Merge → Done
Time: ~3+ cycles
```

### Scenario 4: Merge Conflicts ⚠️
```
Implement → Ready for Review → Code Review → APPROVED
→ Merge Attempt → CONFLICTS DETECTED → Resolve Conflicts
→ Retry Merge → Success → Done
```

### Scenario 5: Rejection ❌
```
Implement → Ready for Review → Code Review → REJECTED
→ Escalate to User → User Decision → Re-scope/Abandon/Manual Review
```

---

## Summary

**Key Changes:**
1. ✅ Default branch is "main" (not "master")
2. ✅ Code review happens BEFORE merge
3. ✅ Developer agents re-invoked after code review
4. ✅ Merge only happens after approval
5. ✅ Dependencies installed once in Story 1.1
6. ✅ Conflict resolution integrated into merge phase

**Benefits:**
- Quality gate enforced (no untested code in main)
- Clear separation of concerns (implement → review → merge)
- Efficient dependency management
- Modern Git best practices
- Better conflict resolution
