# Continue with Next Story

This command identifies the next story ready for implementation and starts work on it.

## WORKFLOW

### Step 1: Read Current State

1. **Check if orchestration is initialized**:
   - Verify `.agent-orchestration/` directory exists
   - If not, suggest running `/implement-stories` first

2. **Read progress.json** to understand current state

3. **Read all task state files** from `.agent-orchestration/tasks/`

### Step 2: Find Next Story

1. **Use sequential_thinking** to identify next story:
   - Filter stories where `status: "not_started"`
   - For each candidate, check if ALL dependencies are met:
     - Read dependency list from task state
     - Verify each dependency has `status: "done"` AND `review_status: "Approved"`
   - Select first story where dependencies are satisfied

2. **If no story is ready**:
   - Report which stories are blocked and why
   - Show what needs to complete before they can start
   - Example output:
     ```
     No stories are ready to start.
     
     Blocked stories:
     - Story 1.2: Waiting for 1.1 to be approved (currently: in_review)
     - Story 1.3: Waiting for 1.1 to be approved (currently: in_review)
     - Story 1.4: Waiting for 1.2, 1.3 to be approved
     
     In progress:
     - Story 1.1: Currently in code review
     
     Suggestion: Wait for Story 1.1 review to complete, or use /review-story 1.1
     to check review status.
     ```
   - Stop execution

3. **If story is found**:
   - Report which story will be started
   - Show its dependencies (all satisfied)
   - Show assigned agent

### Step 3: Start Implementation

1. **Update task state file**:
   ```json
   {
     "status": "in_progress",
     "started_at": "<current timestamp>",
     "last_updated": "<current timestamp>"
   }
   ```

2. **Update progress.json**:
   - Increment `in_progress` counter
   - Decrement `not_started` counter
   - Update `last_updated` timestamp

3. **Invoke development agent**:
   ```
   @agent-{assigned_agent}, please implement story {story_id}.
   
   Story file: {story_file}
   
   Please read the story file carefully, review the acceptance criteria,
   and implement the required functionality following the critical workflow
   requirements in your agent definition.
   
   Key requirements:
   - Read and understand all acceptance criteria
   - Implement the functionality
   - Write and run tests (ALL tests must pass)
   - Update the story file with a Dev Agent Record section
   - Change story status to "Ready for Review" only after all tests pass
   
   Dependencies (already completed):
   {list of dependency stories that are done}
   ```

4. **Report to user**:
   ```
   ✅ Started Story {story_id}: {story_title}
   
   Agent: @agent-{assigned_agent}
   Dependencies: {list or "None"}
   Tech Stack: {detected tech stack}
   
   The agent is now working on implementation. When complete, the story
   status will change to "Ready for Review" and you can run:
   
   /review-story {story_id}
   
   Or continue with the full workflow using /implement-stories
   ```

### Step 4: Monitor Progress

Remind the user:
- The dev agent will update the story file when complete
- Story status should change to "Ready for Review"
- Tests must all pass before review
- Use `/story-status` to check overall progress
- Use `/review-story {story_id}` when ready for code review

---

## ERROR HANDLING

**No orchestration state found:**
```
Error: Orchestration system not initialized.

Please run /implement-stories first to set up the orchestration system
and analyze all stories.
```

**Story already in progress:**
```
Story {story_id} is already in progress (started at {timestamp}).

Current status: {status}

If this is stuck, you can manually update the task state file at:
.agent-orchestration/tasks/{story_id}-task.json
```

**All stories complete:**
```
🎉 All stories are complete!

Summary:
- Total stories: {total}
- Completed: {completed}
- All code reviews passed

Run /story-status for detailed report.
```

---

## USAGE

```
/next-story
```

This command is useful when:
- You want to continue implementation after a break
- A story just completed and you want to start the next one
- You're working through stories one at a time
- You want more control than the full `/implement-stories` workflow

