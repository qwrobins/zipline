# Story Implementation Orchestration Workflow

You are orchestrating the implementation of user stories from the `docs/stories/` directory. Follow this comprehensive workflow to analyze, plan, and coordinate the implementation of all stories in the correct dependency order.

## 🚨 CRITICAL: Mandatory Code Review Enforcement 🚨

**EVERY story implementation MUST be followed by an immediate code review.**

**The workflow is:**
1. Implement Story N
2. **STOP** → Trigger code review for Story N
3. **WAIT** → Wait for code review completion
4. **FIX** → Address any issues found
5. **DOCUMENT** → Add review results to story
6. **ONLY THEN** → Proceed to Story N+1

**This is NON-NEGOTIABLE. No exceptions. No shortcuts.**

See the "CRITICAL REQUIREMENT - Code Review After Every Story" section below for complete details.

## USAGE

```bash
# Implement all stories
/implement-stories

# Implement a range of stories
/implement-stories 1.1-1.5

# Implement specific stories
/implement-stories 1.1 1.3 1.5

# Implement stories in an epic
/implement-stories epic:auth

# Implement stories matching a pattern
/implement-stories 1.*
```

## ARGUMENTS

The command accepts optional `$ARGUMENTS` to scope which stories to implement:

### **No Arguments** (Default)
```
/implement-stories
```
Implements ALL stories in `docs/stories/`

### **Range Syntax**
```
/implement-stories 1.1-1.5
```
Implements stories 1.1, 1.2, 1.3, 1.4, 1.5 (inclusive range)

### **Specific Stories**
```
/implement-stories 1.1 1.3 1.5
```
Implements only the specified stories

### **Epic Scope**
```
/implement-stories epic:auth
```
Implements all stories tagged with epic "auth". Detects epics from:
- Epic field in story: `**Epic**: auth`
- YAML frontmatter: `epic: auth`
- Directory structure: `docs/stories/epic-auth/`
- Story ID prefix: `auth-1.1-login.md`

### **Pattern Matching**
```
/implement-stories 1.*
```
Implements all stories matching the pattern (e.g., all stories starting with "1.")

## CRITICAL REQUIREMENTS

1. **ALWAYS use sequential_thinking** for complex planning and dependency resolution
2. **ALWAYS use context7** when uncertain about algorithms or best practices
3. **ALWAYS update state files** in `.agent-orchestration/` to track progress
4. **NEVER skip dependency checks** - stories must wait for dependencies to be approved
5. **ALWAYS verify test results** before marking stories as complete
6. **ALWAYS check for out-of-scope dependencies** and warn the user

## ⚠️ CRITICAL REQUIREMENT - Code Review After Every Story ⚠️

**MANDATORY CODE REVIEW ENFORCEMENT:**

After implementing EACH individual story, you MUST:

1. **Immediately trigger a code review** using the `code-reviewer` agent
2. **Wait for code review completion** before proceeding to the next story
3. **Address any issues** identified in the code review
4. **Document the code review** in the story's "Dev Agent Record" section

**This is NON-NEGOTIABLE and applies to EVERY story without exception.**

**Workflow Enforcement:**
- [ ] Story N implemented → STOP
- [ ] Trigger code review for Story N → WAIT for completion
- [ ] Address code review feedback for Story N
- [ ] Document code review results in Story N
- [ ] ONLY THEN proceed to Story N+1

**Never skip code reviews**, even if:
- Multiple stories are being implemented in sequence
- Stories seem simple or small
- Time pressure exists
- Previous stories had clean reviews

**Code Review Trigger Format:**
After completing each story implementation, explicitly invoke:
```
/agents code-reviewer

Please review the implementation for story [story-id] in [file paths].
Focus on: [specific areas based on story requirements]
```

**Verification Checklist:**
Before moving to the next story, confirm:
- [ ] Code review was triggered
- [ ] Code review feedback was received
- [ ] All issues were addressed or documented
- [ ] Code review results added to Dev Agent Record

This ensures consistent code quality and prevents technical debt accumulation across multiple story implementations.

---

## WORKFLOW PHASES

### Phase 1: Parse Arguments & Determine Scope

1. **Parse `$ARGUMENTS`** to determine which stories to implement:
   - If empty: scope = "all stories"
   - If range (e.g., "1.1-1.5"): scope = stories in range
   - If epic (e.g., "epic:auth"): scope = stories in epic
   - If pattern (e.g., "1.*"): scope = stories matching pattern
   - If list (e.g., "1.1 1.3 1.5"): scope = specific stories

2. **Store scope information** for later filtering

3. **Report scope to user**:
   ```
   📋 Story Implementation Scope

   Mode: Range
   Scope: Stories 1.1 through 1.5

   Analyzing stories in docs/stories/...
   ```

### Phase 2: Initialization & Setup

1. **Create orchestration directory structure** if it doesn't exist:
   ```
   .agent-orchestration/
   ├── roadmap.md
   ├── progress.json
   ├── dependency-graph.json
   └── tasks/
   ```

2. **Initialize progress.json** with:
   ```json
   {
     "initialized_at": "<current timestamp>",
     "last_updated": "<current timestamp>",
     "scope": "<scope description>",
     "total_stories": 0,
     "completed": 0,
     "in_progress": 0,
     "blocked": 0,
     "not_started": 0
   }
   ```

### Phase 3: Story Discovery & Analysis

1. **Scan `docs/stories/` directory** for all story files

2. **For each story file**, extract:
   - **Story ID**: From filename (e.g., "1.1" from "1.1-user-authentication.md")
   - **Epic**: From story content or directory structure:
     - Epic field: `**Epic**: auth`
     - YAML frontmatter: `epic: auth`
     - Directory: `docs/stories/epic-auth/1.1-login.md`
     - Prefix: `auth-1.1-login.md`
   - **Current Status**: Look for "Status:" field in the story
   - **Dependencies**: Look for "Dependencies:" section or field
   - **Technology Stack**: Scan content for keywords:
     - JavaScript/TypeScript/React/Next.js/Node.js
     - Python/Django/Flask/FastAPI
     - Rust/Cargo
     - Database mentions (PostgreSQL, MongoDB, etc.)
   - **Acceptance Criteria**: Extract from story content
   - **File Paths**: Look for mentioned files or directories

3. **Filter stories based on scope** (from Phase 1):
   - If scope is "all": include all stories
   - If scope is range: include only stories in range
   - If scope is epic: include only stories with matching epic
   - If scope is pattern: include only stories matching pattern
   - If scope is list: include only specified stories

4. **Check for out-of-scope dependencies**:
   - For each in-scope story, check if dependencies are also in scope
   - If dependencies are out of scope, warn the user:
     ```
     ⚠️  Warning: Story 1.3 depends on Story 1.1, which is not in scope.

     Options:
     1. Add Story 1.1 to scope (recommended)
     2. Continue anyway (Story 1.3 will be blocked)
     3. Cancel and adjust scope

     What would you like to do?
     ```

5. **Create task state file** for each in-scope story at `.agent-orchestration/tasks/{story-id}-task.json`:
   ```json
   {
     "story_id": "1.1",
     "story_file": "docs/stories/1.1-user-authentication.md",
     "epic": "auth",
     "status": "not_started",
     "assigned_agent": null,
     "dependencies": [],
     "tech_stack": [],
     "started_at": null,
     "completed_at": null,
     "review_status": null,
     "review_file": null,
     "iteration_count": 0,
     "last_updated": "<timestamp>",
     "in_scope": true
   }
   ```

### Phase 4: Dependency Resolution

1. **Use sequential_thinking** to build dependency graph:
   - Create adjacency list of story dependencies (only in-scope stories)
   - Validate no circular dependencies exist
   - If circular dependencies found, report error and stop

2. **Perform topological sort** to determine implementation order:
   - Use context7 if uncertain about topological sort algorithm
   - Generate ordered list of stories

3. **Save dependency graph** to `.agent-orchestration/dependency-graph.json`:
   ```json
   {
     "scope": "Range: 1.1-1.5",
     "nodes": ["1.1", "1.2", "1.3", "1.4", "1.5"],
     "edges": [
       {"from": "1.1", "to": "1.2"},
       {"from": "1.1", "to": "1.3"},
       {"from": "1.2", "to": "1.4"},
       {"from": "1.3", "to": "1.4"}
     ],
     "implementation_order": ["1.1", "1.5", "1.2", "1.3", "1.4"],
     "parallel_opportunities": [
       ["1.2", "1.3"]
     ],
     "out_of_scope_dependencies": []
   }
   ```

### Phase 5: Agent Matching

For each in-scope story, determine the appropriate development agent:

**Technology Detection Rules:**
- **JavaScript/TypeScript/React/Next.js** → `@agent-javascript-developer`
- **Python/Django/Flask** → `@agent-python-developer` (if exists, else javascript-developer)
- **Rust** → `@agent-rust-developer` (if exists, else javascript-developer)
- **Backend/API** → Check for framework-specific agent first

**Agent Discovery:**
1. Scan `.claude/agents/` directory for available agents
2. Read each agent's YAML frontmatter to understand capabilities
3. Match story requirements to agent capabilities
4. Update task state file with `assigned_agent` field

### Phase 6: Create Implementation Roadmap

Generate `.agent-orchestration/roadmap.md` with:

```markdown
# Story Implementation Roadmap

**Generated**: <timestamp>
**Scope**: <scope description>
**Total Stories**: X (in scope)
**Estimated Sequence**: Y stories can be done in parallel

## Scope

<Description of what stories are included>

Examples:
- "All stories in docs/stories/"
- "Stories 1.1 through 1.5"
- "Stories in epic: auth"
- "Stories matching pattern: 1.*"

## Implementation Order

### Wave 1 (No Dependencies)
- [ ] Story 1.1: User Authentication (@agent-javascript-developer)
- [ ] Story 1.5: Error Logging (@agent-javascript-developer)

### Wave 2 (Depends on Wave 1)
- [ ] Story 1.2: User Profile (@agent-javascript-developer) - Depends on: 1.1
- [ ] Story 1.3: Password Reset (@agent-javascript-developer) - Depends on: 1.1

### Wave 3 (Depends on Wave 2)
- [ ] Story 1.4: Admin Dashboard (@agent-javascript-developer) - Depends on: 1.2, 1.3

## Dependency Graph

[Visual representation or description of dependencies]

## Out of Scope

<If any stories were excluded, list them here>

## Notes
- Stories in the same wave CAN be implemented in parallel (manually)
- **⚠️ CRITICAL: Each story MUST pass code review before proceeding to the next story**
- Code reviews are MANDATORY and CANNOT be skipped under any circumstances
- Out-of-scope dependencies will block stories from starting

## Code Review Enforcement
- ✅ Every story implementation triggers immediate code review
- ✅ No story can be marked "done" without approved code review
- ✅ Next story cannot start until current story's code review is approved
- ✅ Code review results must be documented in story's Dev Agent Record
```

### Phase 7: Execution Loop

**⚠️ CRITICAL: Each story MUST complete code review before proceeding to the next story ⚠️**

For each in-scope story in implementation order:

1. **Check Dependencies**:
   - Read task state files for all dependencies
   - Verify ALL dependencies have `status: "done"` and `review_status: "Approved"`
   - If dependencies not met, skip to next story

2. **Start Story Implementation**:
   - Update task state: `status: "in_progress"`, `started_at: <timestamp>`
   - Update progress.json counters
   - Invoke appropriate dev agent:
     ```
     @agent-{assigned_agent}, please implement story {story_id}.

     Story file: {story_file}

     Please read the story file carefully, review the acceptance criteria,
     and implement the required functionality following the critical workflow
     requirements in your agent definition.

     When complete, update the story status to "Ready for Review" and add
     a Dev Agent Record section documenting your implementation.
     ```

3. **Monitor for Completion**:
   - Wait for user confirmation that dev work is complete
   - Verify story status changed to "Ready for Review"
   - Verify Dev Agent Record section was added
   - Update task state: `status: "ready_for_review"`

4. **⚠️ MANDATORY CODE REVIEW - DO NOT SKIP ⚠️**:

   **STOP HERE - Code review is REQUIRED before proceeding**

   - Update task state: `status: "in_review"`
   - **IMMEDIATELY** invoke code reviewer (no exceptions):
     ```
     @agent-code-reviewer, please review the implementation for story {story_id}.

     Story file: {story_file}
     Files modified: [list all modified files from Dev Agent Record]

     Please perform a comprehensive code review following your agent definition,
     focusing on:
     - Code quality and best practices
     - Test coverage and correctness
     - Security vulnerabilities
     - Performance considerations
     - Adherence to acceptance criteria

     Save the review to docs/code_reviews/{story_id}-code-review.md
     ```

   **Verification Checkpoint:**
   - [ ] Code review agent invoked
   - [ ] Waiting for code review completion
   - [ ] DO NOT proceed to next story until review is complete

5. **Process Review Results**:
   - **WAIT** for review completion (do not proceed without it)
   - Read review file from `docs/code_reviews/{story_id}-code-review.md`
   - Extract review status (Approved / Changes Requested / etc.)
   - Update task state with `review_status` and `review_file` path

   **Verification Checkpoint:**
   - [ ] Review file exists and was read
   - [ ] Review status extracted
   - [ ] Task state updated with review information

6. **Handle Review Outcome**:

   **If Approved:**
   - Update task state: `status: "done"`, `completed_at: <timestamp>`
   - Update progress.json counters
   - Update roadmap.md to check off the story
   - **Document code review in story file**:
     - Add review status to Dev Agent Record
     - Link to review file
     - Note any follow-up items
   - **ONLY NOW** continue to next story

   **Verification Checkpoint:**
   - [ ] Story marked as done
   - [ ] Code review documented in story file
   - [ ] Progress tracking updated
   - [ ] Ready to proceed to next story

   **If Changes Requested:**
   - Update task state: `status: "in_progress"`, `iteration_count: +1`
   - **DO NOT proceed to next story**
   - Re-invoke dev agent with review feedback:
     ```
     @agent-{assigned_agent}, the code review for story {story_id} found issues
     that need to be addressed.

     Review file: {review_file}

     Critical issues to address:
     [List critical and high-priority issues from review]

     Please read the code review, address all critical and high-priority issues,
     and update the story status back to "Ready for Review" when complete.

     IMPORTANT: You must address these issues before this story can be marked
     as complete and before we can proceed to the next story.
     ```
   - Return to step 3 (Monitor for Completion)
   - **REPEAT code review process** (step 4) after fixes are complete

   **Verification Checkpoint:**
   - [ ] Dev agent re-invoked with feedback
   - [ ] Waiting for fixes to be completed
   - [ ] Will trigger another code review after fixes
   - [ ] NOT proceeding to next story until approved

**CRITICAL ENFORCEMENT RULES:**
- ❌ **NEVER skip code review** for any story
- ❌ **NEVER proceed to next story** without approved code review
- ❌ **NEVER mark story as done** without code review documentation
- ✅ **ALWAYS wait** for code review completion
- ✅ **ALWAYS address** code review feedback before proceeding
- ✅ **ALWAYS document** code review results in story file

### Phase 8: Completion & Reporting

When all stories are done:

1. **Verify Code Review Compliance**:
   - Confirm ALL stories have `review_status: "Approved"`
   - Verify ALL stories have code review documentation
   - Check that ALL review files exist in `docs/code_reviews/`
   - **If any story lacks code review, STOP and require review**

2. **Generate final report**:
   ```markdown
   # Story Implementation Complete! 🎉

   **Total Stories**: X
   **Successfully Completed**: Y
   **Total Iterations**: Z (including review cycles)
   **Time Span**: <start> to <end>

   ## Code Review Compliance ✅
   - **Total Code Reviews**: X (one per story)
   - **First-Pass Approvals**: Y stories
   - **Required Revisions**: Z stories
   - **Average Review Cycles**: N per story
   - **Code Review Coverage**: 100% (MANDATORY)

   ## Summary
   - All stories implemented and approved
   - All code reviews passed (100% coverage)
   - All acceptance criteria met
   - All review documentation complete

   ## Code Review Files
   [List all code review files in docs/code_reviews/]

   ## Next Steps
   - Run full test suite
   - Deploy to staging environment
   - Prepare for QA testing (when QA agent is available)
   ```

3. **Update progress.json** with final metrics including:
   - Total code reviews performed
   - Average review cycles per story
   - Stories requiring revisions
   - Code review compliance: 100%

4. **Archive roadmap** with completion timestamp

5. **Verify Code Review Artifacts**:
   - All review files saved in `docs/code_reviews/`
   - All stories have review documentation
   - All review statuses are "Approved"

---

## ERROR HANDLING

**Circular Dependencies Detected:**
- Report which stories form the cycle
- Suggest breaking the cycle
- Stop execution until resolved

**Missing Dependencies:**
- Report which story depends on non-existent story
- List all missing story IDs
- Stop execution until resolved

**Agent Not Found:**
- Report which agent is missing
- Suggest using fallback agent
- Ask user for confirmation before proceeding

**Story File Not Found:**
- Report which story file is missing
- Skip the story and continue
- Log warning in progress.json

**Review Never Completes:**
- If story stuck in "in_review" for too long
- Prompt user to check what happened
- Offer to retry review
- **CRITICAL**: Do NOT proceed to next story until review completes

**Code Review Skipped (CRITICAL ERROR):**
- If attempting to proceed to next story without code review
- **IMMEDIATELY STOP** the workflow
- Report critical error to user
- Require explicit confirmation to continue
- Log violation in progress.json

**Code Review Not Documented:**
- If story marked "done" without code review documentation
- **IMMEDIATELY STOP** the workflow
- Require code review documentation before proceeding
- Update story file with review information
- Verify review file exists

**Proceeding Without Approval:**
- If attempting to start next story while current story has "Changes Requested"
- **IMMEDIATELY STOP** the workflow
- Report that current story must be fixed and re-reviewed
- Do not allow next story to start

---

## RESUME CAPABILITY

If this workflow is interrupted:

1. **Read existing state** from `.agent-orchestration/`
2. **Identify current position**:
   - Find stories with `status: "in_progress"` or `status: "in_review"`
   - Check last_updated timestamps
3. **Resume from last checkpoint**:
   - Continue with in-progress story
   - Or move to next story if previous was completed
4. **Report resume status** to user

---

## USAGE

Simply invoke this command:
```
/implement-stories
```

The workflow will guide you through the entire process, invoking the appropriate
agents at each step and tracking progress in state files.

You can pause at any time (press Escape) and resume later. The state files
ensure no progress is lost.

