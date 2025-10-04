# Trigger Code Review for Story

This command triggers a code review for a specific story using the code-reviewer agent.

**Usage**: `/review-story [story-id]`

**Example**: `/review-story 1.1`

---

## WORKFLOW

### Step 1: Validate Input

1. **Check story ID parameter**:
   - If `$ARGUMENTS` is empty, show error:
     ```
     Error: Story ID required.
     
     Usage: /review-story [story-id]
     Example: /review-story 1.1
     ```
   - Extract story ID from `$ARGUMENTS`

2. **Verify orchestration is initialized**:
   - Check if `.agent-orchestration/` exists
   - If not, suggest running `/implement-stories` first

### Step 2: Read Story State

1. **Load task state file** from `.agent-orchestration/tasks/{story-id}-task.json`
   - If file doesn't exist:
     ```
     Error: Story {story-id} not found in orchestration system.
     
     Available stories:
     {list all story IDs from tasks/ directory}
     
     Did you mean one of these?
     ```

2. **Verify story is ready for review**:
   - Check `status` field
   - Valid statuses for review: `"ready_for_review"` or `"changes_requested"`
   - If status is wrong:
     ```
     Error: Story {story-id} is not ready for review.
     
     Current status: {status}
     
     Story must have status "Ready for Review" before code review can begin.
     
     If development is complete, please ensure:
     1. All tests are passing
     2. Story file has been updated with Dev Agent Record
     3. Story status field is set to "Ready for Review"
     ```

3. **Read story file** to get context

### Step 3: Update State to In Review

1. **Update task state file**:
   ```json
   {
     "status": "in_review",
     "review_started_at": "<current timestamp>",
     "last_updated": "<current timestamp>"
   }
   ```

2. **Update progress.json**:
   - Update counters as needed
   - Update `last_updated` timestamp

### Step 4: Invoke Code Reviewer

1. **Call the code-reviewer agent**:
   ```
   @agent-code-reviewer, please review the implementation for story $ARGUMENTS.
   
   Story file: {story_file}
   Story ID: {story_id}
   
   Please perform a comprehensive code review following your agent definition:
   
   1. Read and analyze the story file
   2. Review the acceptance criteria
   3. Check the Dev Agent Record to see what was implemented
   4. Review all code files that were created or modified
   5. Check for:
      - Security vulnerabilities (CRITICAL - check first)
      - Code quality issues
      - Performance concerns
      - Best practice violations
      - Test coverage
   6. Verify acceptance criteria are met
   7. Save the review to: docs/code_reviews/{story_id}-code-review.md
   8. Add a brief reference to the story file
   
   Technology stack: {tech_stack}
   Assigned dev agent: {assigned_agent}
   ```

2. **Report to user**:
   ```
   🔍 Code review started for Story {story_id}
   
   Story: {story_title}
   Reviewer: @agent-code-reviewer
   
   The code reviewer will:
   1. Analyze the story and acceptance criteria
   2. Review all implemented code
   3. Check for security, quality, and performance issues
   4. Save detailed review to: docs/code_reviews/{story_id}-code-review.md
   
   Please wait for the review to complete...
   ```

### Step 5: Process Review Results

1. **Wait for review completion**:
   - Monitor for new file: `docs/code_reviews/{story_id}-code-review.md`
   - Or wait for user confirmation

2. **Read review file** and extract:
   - Review status (Approved / Approved with Comments / Changes Requested / Rejected)
   - Critical issue count
   - High priority issue count
   - Summary of findings

3. **Update task state file**:
   ```json
   {
     "status": "<based on review outcome>",
     "review_status": "<Approved|Changes Requested|etc>",
     "review_file": "docs/code_reviews/{story_id}-code-review.md",
     "review_completed_at": "<timestamp>",
     "last_updated": "<timestamp>"
   }
   ```

4. **Determine next status**:
   - **If Approved or Approved with Comments (no critical issues)**:
     - Set `status: "done"`
     - Set `completed_at: <timestamp>`
     - Update progress.json: increment `completed`, decrement `in_progress`
   
   - **If Changes Requested or Rejected (critical/high issues found)**:
     - Set `status: "changes_requested"`
     - Increment `iteration_count`
     - Keep in `in_progress` counter

### Step 6: Report Results

**If Approved:**
```
✅ Code Review APPROVED for Story {story_id}

Review Status: {review_status}
Review File: docs/code_reviews/{story_id}-code-review.md

Summary:
- Critical issues: 0
- High priority issues: {count}
- Medium/Low issues: {count}

Story {story_id} is now COMPLETE! 🎉

Next steps:
- Run /next-story to continue with the next story
- Or run /story-status to see overall progress
```

**If Changes Requested:**
```
⚠️  Code Review found issues for Story {story_id}

Review Status: Changes Requested
Review File: docs/code_reviews/{story_id}-code-review.md

Issues found:
- Critical: {count}
- High priority: {count}
- Medium/Low: {count}

The development agent needs to address these issues.

Next steps:
1. Review the detailed findings in: docs/code_reviews/{story_id}-code-review.md
2. Re-invoke the dev agent to fix issues:
   
   @agent-{assigned_agent}, please address the code review findings for story {story_id}.
   
   Review file: docs/code_reviews/{story_id}-code-review.md
   
   Please fix all critical and high-priority issues, then update the story
   status back to "Ready for Review".

3. After fixes, run /review-story {story_id} again
```

---

## ERROR HANDLING

**Missing story ID:**
```
Error: Story ID required.

Usage: /review-story [story-id]
Example: /review-story 1.1
```

**Story not found:**
```
Error: Story {story-id} not found.

Available stories: {list}
```

**Wrong status:**
```
Error: Story {story-id} cannot be reviewed yet.

Current status: {status}
Expected: "Ready for Review"

Please complete development first.
```

**Review file already exists:**
```
Warning: Review file already exists for story {story_id}.

Existing review: docs/code_reviews/{story_id}-code-review.md
Created: {timestamp}
Status: {review_status}

Do you want to:
1. View the existing review
2. Create a new review (will overwrite)
3. Cancel

Please specify your choice.
```

---

## USAGE EXAMPLES

**Review a specific story:**
```
/review-story 1.1
```

**After development completes:**
```
Story 1.1 development complete!
Status: Ready for Review

→ /review-story 1.1
```

**After addressing review feedback:**
```
Fixed all critical issues from code review.
Status: Ready for Review (iteration 2)

→ /review-story 1.1
```

---

## INTEGRATION WITH WORKFLOW

This command integrates with the full orchestration workflow:

1. `/implement-stories` - Runs full workflow (includes automatic reviews)
2. `/next-story` - Starts next story (manual review trigger)
3. **`/review-story`** - Triggers review for specific story
4. `/story-status` - Shows which stories need review

Use this command when:
- You want manual control over when reviews happen
- A story is ready for review but you're not running full workflow
- You need to re-review after addressing feedback
- You want to review a specific story out of sequence

