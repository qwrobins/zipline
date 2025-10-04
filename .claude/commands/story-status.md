# Story Implementation Status Report

This command generates a comprehensive status report showing progress across all user stories.

---

## WORKFLOW

### Step 1: Verify Orchestration Initialized

1. **Check if `.agent-orchestration/` exists**:
   - If not found:
     ```
     Orchestration system not initialized.
     
     To get started, run: /implement-stories
     
     This will analyze all stories in docs/stories/ and set up
     the orchestration system.
     ```
   - Stop execution

### Step 2: Read All State Files

1. **Read `progress.json`** for overall metrics

2. **Read all task state files** from `.agent-orchestration/tasks/`

3. **Read `dependency-graph.json`** for dependency information

4. **Read `roadmap.md`** for planned sequence

### Step 3: Analyze Current State

1. **Categorize stories by status**:
   - **Done**: `status: "done"` AND `review_status: "Approved"`
   - **In Progress**: `status: "in_progress"` OR `status: "ready_for_review"` OR `status: "in_review"`
   - **Changes Requested**: `status: "changes_requested"`
   - **Blocked**: `status: "not_started"` AND dependencies not met
   - **Ready to Start**: `status: "not_started"` AND all dependencies met
   - **Not Started**: `status: "not_started"` (general)

2. **Calculate metrics**:
   - Total stories
   - Completion percentage
   - Average iteration count
   - Stories with multiple review cycles
   - Blocked stories count

3. **Identify next actions**:
   - Which stories can start now
   - Which stories are waiting for review
   - Which stories need rework

### Step 4: Generate Status Report

Create comprehensive report with the following sections:

```markdown
# 📊 Story Implementation Status Report

**Generated**: {current timestamp}
**Last Updated**: {from progress.json}

---

## 📈 Overall Progress

**Total Stories**: {total}
**Completed**: {completed} ({percentage}%)
**In Progress**: {in_progress}
**Blocked**: {blocked}
**Not Started**: {not_started}

Progress Bar:
[████████████░░░░░░░░] {percentage}%

---

## ✅ Completed Stories ({count})

| Story ID | Title | Agent | Iterations | Completed |
|----------|-------|-------|------------|-----------|
| 1.1 | User Authentication | javascript-developer | 1 | 2025-10-02 |
| 1.5 | Error Logging | javascript-developer | 2 | 2025-10-02 |

---

## 🔄 In Progress ({count})

| Story ID | Title | Status | Agent | Started |
|----------|-------|--------|-------|---------|
| 1.2 | User Profile | in_review | javascript-developer | 2025-10-02 10:30 |

**Details**:
- **Story 1.2**: Currently in code review (started 30 minutes ago)

---

## ⚠️  Changes Requested ({count})

| Story ID | Title | Issues | Iteration | Review File |
|----------|-------|--------|-----------|-------------|
| 1.3 | Password Reset | 3 critical, 2 high | 2 | docs/code_reviews/1.3-code-review.md |

**Details**:
- **Story 1.3**: Code review found critical issues, needs rework

---

## 🚫 Blocked Stories ({count})

| Story ID | Title | Waiting For | Agent |
|----------|-------|-------------|-------|
| 1.4 | Admin Dashboard | 1.2 (in_review), 1.3 (changes_requested) | javascript-developer |

**Details**:
- **Story 1.4**: Cannot start until Stories 1.2 and 1.3 are approved

---

## 🎯 Ready to Start ({count})

| Story ID | Title | Agent | Dependencies |
|----------|-------|-------|--------------|
| 1.6 | User Settings | javascript-developer | 1.1 ✅, 1.2 ✅ |

**Details**:
- **Story 1.6**: All dependencies met, ready to begin implementation

---

## 📋 Not Started ({count})

| Story ID | Title | Agent | Dependencies |
|----------|-------|-------|--------------|
| 1.7 | Notifications | javascript-developer | 1.1, 1.6 |
| 1.8 | Analytics | javascript-developer | 1.4 |

---

## 🔍 Detailed Breakdown

### Stories by Agent
- **javascript-developer**: {count} stories ({completed} done, {in_progress} in progress)
- **python-developer**: {count} stories ({completed} done, {in_progress} in progress)
- **rust-developer**: {count} stories ({completed} done, {in_progress} in progress)

### Review Statistics
- **Average iterations per story**: {average}
- **Stories requiring rework**: {count}
- **Stories approved first try**: {count}

### Time Metrics
- **First story started**: {timestamp}
- **Latest story completed**: {timestamp}
- **Total time span**: {duration}
- **Average time per story**: {duration}

---

## 🎯 Next Actions

### Immediate Actions Available:

1. **Continue in-progress work**:
   - Story 1.2 is in code review - wait for results or check status

2. **Start new stories** (dependencies met):
   - Run `/next-story` to start Story 1.6
   
3. **Address review feedback**:
   - Story 1.3 needs rework - review findings and fix issues

### Recommended Next Steps:

{if stories ready to start}
✅ **Run `/next-story`** to start Story {next_story_id}

{if stories in review}
⏳ **Wait for code review** on Story {story_id} to complete

{if stories need rework}
🔧 **Address review feedback** for Story {story_id}:
   - Read review: docs/code_reviews/{story_id}-code-review.md
   - Fix critical and high-priority issues
   - Re-run tests
   - Update status to "Ready for Review"
   - Run `/review-story {story_id}` again

{if all complete}
🎉 **All stories complete!** Consider:
   - Running full test suite
   - Deploying to staging
   - Preparing for QA testing

---

## 📁 State Files

- **Progress**: `.agent-orchestration/progress.json`
- **Roadmap**: `.agent-orchestration/roadmap.md`
- **Dependencies**: `.agent-orchestration/dependency-graph.json`
- **Task States**: `.agent-orchestration/tasks/*.json`

---

## 🔄 Refresh Status

To update this report, run: `/story-status`

To continue implementation, run: `/implement-stories` or `/next-story`
```

### Step 5: Display Report

1. **Output the formatted report** to the user

2. **Highlight urgent items**:
   - Stories stuck in review for too long
   - Stories with high iteration counts
   - Critical blockers

3. **Provide actionable recommendations**:
   - Specific commands to run next
   - Which stories to focus on
   - What's blocking progress

---

## ERROR HANDLING

**No orchestration state:**
```
Error: Orchestration system not initialized.

Run /implement-stories to set up the orchestration system.
```

**No stories found:**
```
Warning: No stories found in docs/stories/

Please create user story files in the docs/stories/ directory,
then run /implement-stories to analyze them.
```

**Corrupted state files:**
```
Warning: Some state files appear corrupted:
- {file_path}: {error}

You may need to:
1. Manually fix the JSON file
2. Delete the file and re-run /implement-stories
3. Check the file for syntax errors
```

---

## USAGE

```
/story-status
```

Run this command:
- **Anytime** to check progress
- **Before starting work** to see what's ready
- **After completing a story** to see what's next
- **When resuming work** after a break
- **To identify blockers** and plan next steps

---

## INTEGRATION WITH WORKFLOW

This command complements the other orchestration commands:

- **`/implement-stories`** - Full automated workflow
- **`/next-story`** - Start next available story
- **`/review-story`** - Trigger code review
- **`/story-status`** - Check progress (this command)

Use `/story-status` frequently to:
- Monitor overall progress
- Identify what needs attention
- Plan your next actions
- Track completion metrics
- Spot potential issues early

