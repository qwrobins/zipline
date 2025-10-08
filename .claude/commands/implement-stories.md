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

1. **ALWAYS use git worktrees** for agent isolation to prevent conflicts
2. **ALWAYS use sequential_thinking** for complex planning and dependency resolution
3. **ALWAYS use context7** when uncertain about algorithms or best practices
4. **ALWAYS update state files** in `.agent-orchestration/` to track progress
5. **NEVER skip dependency checks** - stories must wait for dependencies to be approved
6. **ALWAYS verify test results** before marking stories as complete
7. **ALWAYS check for out-of-scope dependencies** and warn the user
8. **ALWAYS cleanup worktrees** after story completion or failure
9. **PRIORITIZE PARALLEL EXECUTION** - maximize parallelism by running independent stories simultaneously

## 🚀 CRITICAL REQUIREMENT - Maximize Parallel Execution 🚀

**DEFAULT TO PARALLEL EXECUTION:**

The orchestrator MUST prioritize parallel story implementation as the default approach. Sequential execution should ONLY be used when stories have explicit dependencies.

**Parallel Execution Strategy:**

1. **Analyze Dependencies First:**
   - Build a dependency graph of all stories
   - Identify stories with NO dependencies (can start immediately)
   - Identify stories that only depend on completed stories (can start immediately)
   - Group independent stories into "waves" that can run in parallel

2. **Launch Multiple Agents Simultaneously:**
   - For each wave of independent stories, launch ALL agents at once
   - Example: If Stories 2.1, 2.2, 2.3, 2.4 all depend only on Story 1.x (and not on each other), launch 4 agents in parallel
   - Do NOT wait for one story to complete before starting the next if they're independent

3. **Only Wait for Dependencies:**
   - Story B should ONLY wait for Story A if Story B explicitly lists Story A as a dependency
   - If Story 2.1 and Story 2.2 both depend on Story 1.3 but NOT on each other, they can run in parallel after 1.3 completes

4. **Maximum Parallelism Examples:**

   **CORRECT ✅ (Parallel):**
   ```
   Wave 1: Launch Story 1.1 (no dependencies)
   Wave 2: Launch Stories 1.2, 1.3, 1.4 simultaneously (all depend only on 1.1)
   Wave 3: Launch Stories 2.1, 2.2, 2.3, 2.4 simultaneously (all depend only on 1.x, not on each other)
   ```

   **INCORRECT ❌ (Sequential when parallel is possible):**
   ```
   Story 1.1 → wait for completion
   Story 1.2 → wait for completion  ← WRONG! Could run with 1.3, 1.4
   Story 1.3 → wait for completion  ← WRONG! Could run with 1.2, 1.4
   Story 1.4 → wait for completion  ← WRONG! Could run with 1.2, 1.3
   ```

5. **Benefits of Parallel Execution:**
   - Dramatically faster implementation (4 stories in parallel = 4x faster)
   - Better resource utilization
   - Faster feedback cycles
   - Reduced overall project timeline

**When to Use Sequential Execution:**
- ONLY when Story B explicitly depends on Story A
- Example: Story 3.2 (Add Comment) depends on Story 3.1 (View Comments) → must be sequential

## ⚠️ CRITICAL REQUIREMENT - Git Worktree Isolation ⚠️

**MANDATORY WORKTREE USAGE:**

When multiple agents work simultaneously, they MUST use isolated git worktrees to prevent conflicts.

**Orchestrator Responsibilities:**

1. **Before assigning a story to an agent:**
   - Create a worktree using: `./.claude/agents/lib/git-worktree-manager.sh create "{story-id}" "{agent-name}"`
   - Save the worktree path in the task state file
   - Provide the worktree path to the agent

2. **During story implementation:**
   - Track active worktrees in `.agent-orchestration/worktree-registry.json`
   - Monitor for abandoned worktrees (older than 24 hours)
   - Ensure agents work exclusively in their worktrees

3. **After story completion:**
   - Verify the agent merged their worktree
   - Verify the agent cleaned up their worktree
   - If cleanup failed, manually cleanup: `./.claude/agents/lib/git-worktree-manager.sh cleanup "{worktree-path}"`

4. **Error handling:**
   - If merge fails due to conflicts, STOP and report to user
   - Do NOT cleanup worktrees with merge conflicts
   - Provide clear instructions for manual conflict resolution

**See `.claude/agents/directives/git-worktree-workflow.md` for complete workflow details.**

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

### Phase 4: Dependency Resolution & Parallel Execution Planning

**🚀 CRITICAL: This phase determines parallel execution opportunities - maximize parallelism!**

1. **Use sequential_thinking** to build dependency graph:
   - Create adjacency list of story dependencies (only in-scope stories)
   - Validate no circular dependencies exist
   - If circular dependencies found, report error and stop

2. **Identify Parallel Execution Waves:**
   - **Wave 0**: Stories with NO dependencies (can start immediately)
   - **Wave 1**: Stories that depend only on Wave 0 stories
   - **Wave 2**: Stories that depend only on Wave 0 or Wave 1 stories
   - Continue until all stories are assigned to waves
   - **CRITICAL**: All stories in the same wave can run in PARALLEL

3. **Perform topological sort** to determine implementation order:
   - Use context7 if uncertain about topological sort algorithm
   - Generate ordered list of stories
   - **Prioritize grouping independent stories into waves**

4. **Calculate Parallel Opportunities:**
   - For each wave, count how many stories can run simultaneously
   - Estimate time savings from parallel execution
   - Example: Wave 2 has 4 stories = 4 agents can work simultaneously

5. **Save dependency graph** to `.agent-orchestration/dependency-graph.json`:
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
     "parallel_waves": [
       {"wave": 0, "stories": ["1.1", "1.5"], "can_run_parallel": true},
       {"wave": 1, "stories": ["1.2", "1.3"], "can_run_parallel": true},
       {"wave": 2, "stories": ["1.4"], "can_run_parallel": false}
     ],
     "parallel_opportunities": [
       ["1.1", "1.5"],
       ["1.2", "1.3"]
     ],
     "max_parallel_agents": 2,
     "estimated_time_savings": "50% faster with parallel execution",
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
1. Scan `.claude/agents/` directory for available agent definition files (*.md)
2. Read each agent's YAML frontmatter to understand capabilities
3. Match story requirements to agent capabilities
4. Update task state file with `assigned_agent` field

**Available Agents:**
- `.claude/agents/code-reviewer.md`
- `.claude/agents/conflict-resolver.md`
- `.claude/agents/nestjs-developer.md`
- `.claude/agents/nextjs-developer.md`
- `.claude/agents/planning-analyst.md`
- `.claude/agents/product-manager.md`
- `.claude/agents/python-developer.md`
- `.claude/agents/react-developer.md`
- `.claude/agents/rust-developer.md`
- `.claude/agents/scrum-master.md`
- `.claude/agents/typescript-developer.md`
- `.claude/agents/vanilla-javascript-developer.md`

### Phase 6: Create Implementation Roadmap

Generate `.agent-orchestration/roadmap.md` with:

```markdown
# Story Implementation Roadmap

**Generated**: <timestamp>
**Scope**: <scope description>
**Total Stories**: X (in scope)
**Parallel Execution**: Y stories can run simultaneously
**Estimated Time Savings**: Z% faster with parallel execution

## Scope

<Description of what stories are included>

Examples:
- "All stories in docs/stories/"
- "Stories 1.1 through 1.5"
- "Stories in epic: auth"
- "Stories matching pattern: 1.*"

## 🚀 Parallel Execution Strategy

**CRITICAL: The orchestrator will launch multiple agents simultaneously for independent stories.**

### Wave 1 (No Dependencies) - **2 agents in parallel**
- [ ] Story 1.1: User Authentication (@agent-javascript-developer)
- [ ] Story 1.5: Error Logging (@agent-javascript-developer)

**Action**: Launch BOTH agents simultaneously. Do NOT wait for 1.1 to complete before starting 1.5.

### Wave 2 (Depends on Wave 1) - **2 agents in parallel**
- [ ] Story 1.2: User Profile (@agent-javascript-developer) - Depends on: 1.1
- [ ] Story 1.3: Password Reset (@agent-javascript-developer) - Depends on: 1.1

**Action**: After Wave 1 completes, launch BOTH agents simultaneously. Do NOT wait for 1.2 to complete before starting 1.3.

### Wave 3 (Depends on Wave 2) - **1 agent (sequential)**
- [ ] Story 1.4: Admin Dashboard (@agent-javascript-developer) - Depends on: 1.2, 1.3

**Action**: Wait for BOTH 1.2 and 1.3 to complete, then launch 1.4.

## Dependency Graph

```
Wave 1 (Parallel):     1.1 ──┐
                       1.5    │
                              ↓
Wave 2 (Parallel):     1.2 ──┤
                       1.3 ──┘
                              ↓
Wave 3 (Sequential):   1.4
```

## Parallel Execution Benefits

- **Without Parallelism**: 5 stories × 4 hours = 20 hours total
- **With Parallelism**: Wave 1 (4h) + Wave 2 (4h) + Wave 3 (4h) = 12 hours total
- **Time Savings**: 40% faster (8 hours saved)

## Out of Scope

<If any stories were excluded, list them here>

## Notes
- **🚀 DEFAULT: Stories in the same wave WILL be implemented in parallel automatically**
- **⚠️ CRITICAL: Each story MUST pass code review before proceeding to the next wave**
- Code reviews are MANDATORY and CANNOT be skipped under any circumstances
- Out-of-scope dependencies will block stories from starting
- Parallel execution uses git worktrees to prevent conflicts

## Code Review Enforcement
- ✅ Every story implementation triggers immediate code review
- ✅ No story can be marked "done" without approved code review
- ✅ Next story cannot start until current story's code review is approved
- ✅ Code review results must be documented in story's Dev Agent Record
```

### Phase 7: Parallel Execution Loop

**🚨 CRITICAL: Git Initialization Check (REQUIRED FIRST STEP) 🚨**

**BEFORE ANY story implementation begins, verify git is initialized:**

1. **Check Git Status:**
   ```bash
   git rev-parse --git-dir 2>/dev/null
   ```
   - If this command succeeds → Git is initialized, proceed to step 2
   - If this command fails → Git is NOT initialized, proceed to git initialization

2. **Initialize Git if Missing (MANDATORY):**

   **If git is not initialized, you MUST initialize it before proceeding:**

   ```bash
   # Initialize git repository
   git init

   # Create .gitignore if it doesn't exist
   if [ ! -f .gitignore ]; then
     cat > .gitignore << 'EOF'
   node_modules/
   .env
   .env.local
   dist/
   build/
   .DS_Store
   *.log
   .agent-orchestration/
   .worktrees/
   EOF
   fi

   # Create initial commit
   git add .
   git commit -m "Initial commit"

   # Set default branch to "main" (modern best practice)
   git branch -M main

   # Verify initialization succeeded
   git rev-parse --git-dir 2>/dev/null
   ```

   **Error Handling:**
   - If `git init` fails → STOP and report: "Failed to initialize git repository. Please check git installation."
   - If initial commit fails → STOP and report: "Failed to create initial commit. Please check file permissions."
   - If verification fails → STOP and report: "Git initialization verification failed. Please initialize git manually."

   **After successful initialization:**
   - Report to user: "✅ Git repository initialized successfully. Proceeding with worktree workflow."
   - Continue to step 3

3. **Enforce Worktree Workflow (MANDATORY - NO EXCEPTIONS):**

   **⚠️ CRITICAL: The git worktree workflow is MANDATORY for ALL story implementations.**

   - There are NO exceptions to using git worktrees
   - Even if git was just initialized, worktrees MUST be used
   - NEVER proceed with story implementation without worktrees
   - NEVER work directly in the main repository

   **If worktree creation fails:**
   - STOP and report the error to the user
   - Do NOT attempt to work without worktrees
   - Provide troubleshooting guidance

**🚀 CRITICAL: Execute stories in PARALLEL waves, not sequentially! 🚀**

**⚠️ CRITICAL: Each wave MUST complete code review before proceeding to the next wave ⚠️**

**Execution Strategy:**

1. **Process by Waves (NOT individual stories):**
   - Identify all stories in the current wave (stories with satisfied dependencies)
   - Launch ALL agents for the wave simultaneously
   - Wait for ALL stories in the wave to complete and pass code review
   - Only then proceed to the next wave

2. **Wave-Based Execution Example:**
   ```
   Wave 1: Launch agents for Stories 1.1 and 1.5 simultaneously
   → Wait for BOTH to complete and pass code review

   Wave 2: Launch agents for Stories 1.2 and 1.3 simultaneously
   → Wait for BOTH to complete and pass code review

   Wave 3: Launch agent for Story 1.4
   → Wait for completion and code review
   ```

**For each wave of stories:**

1. **Identify Ready Stories**:
   - Find all stories where ALL dependencies have `status: "done"` and `review_status: "Approved"`
   - Group these stories into the current wave
   - **Launch ALL agents for this wave simultaneously**

2. **Check Dependencies for Each Story in Wave**:
   - Read task state files for all dependencies
   - Verify ALL dependencies have `status: "done"` and `review_status: "Approved"`
   - If dependencies not met, story is not ready for this wave

3. **Verify Git Initialization Before Wave Execution (MANDATORY CHECK)**:

   **Before launching ANY agents, verify git is initialized:**

   ```bash
   # Verify git is initialized
   if ! git rev-parse --git-dir >/dev/null 2>&1; then
     echo "ERROR: Git is not initialized. This should have been caught in Phase 7 initialization."
     echo "Please ensure git is initialized before proceeding."
     exit 1
   fi
   ```

   **If verification fails:**
   - STOP immediately
   - Report: "CRITICAL ERROR: Git not initialized. Cannot proceed with worktree workflow."
   - Do NOT attempt to launch any agents
   - Return to Phase 7 git initialization step

4. **Start Wave Implementation (Launch ALL agents simultaneously)**:

   **For EACH story in the current wave, launch its agent in parallel:**

   - Update task state: `status: "in_progress"`, `started_at: <timestamp>`
   - Update progress.json counters
   - **Create Git Worktree** for the agent (MANDATORY):
     ```bash
     WORKTREE_PATH=$(./.claude/agents/lib/git-worktree-manager.sh create "{story_id}" "{assigned_agent}")

     # Verify worktree creation succeeded
     if [ -z "$WORKTREE_PATH" ] || [ ! -d "$WORKTREE_PATH" ]; then
       echo "ERROR: Failed to create worktree for story {story_id}"
       echo "Worktree workflow is MANDATORY. Cannot proceed without it."
       exit 1
     fi
     ```
   - Save the worktree path in task state: `worktree_path: "$WORKTREE_PATH"`
   - **Register Files for Tracking** (optional, for conflict prevention):
     ```bash
     # Auto-register files after agent makes changes
     ./.claude/agents/lib/file-tracker.sh auto-register "{story_id}" "{assigned_agent}" "$WORKTREE_PATH"
     ```
   - Invoke appropriate dev agent:

   **CRITICAL: Do NOT wait for one agent to complete before launching the next agent in the same wave. Launch ALL agents for the wave at once.**
     ```
     @agent-{assigned_agent}, please implement story {story_id}.

     Story file: {story_file}

     🚨 CRITICAL: Git worktree workflow is MANDATORY - NO EXCEPTIONS 🚨

     Git has been initialized and your isolated worktree has been created at: {worktree_path}

     ⚠️ YOU MUST work in the worktree - NEVER work directly in the main repository.
     ⚠️ The worktree workflow is REQUIRED for conflict prevention.
     ⚠️ There are NO exceptions to this requirement.

     🚨 CRITICAL: DO NOT MERGE OR CLEANUP - Code review happens FIRST 🚨

     ⚠️ You will implement the story and commit changes to your worktree
     ⚠️ The orchestrator will trigger code review BEFORE merging
     ⚠️ You will be re-invoked after code review to merge (if approved) or fix issues
     ⚠️ DO NOT merge or cleanup the worktree in this phase

     Follow these steps EXACTLY:
     1. **Design Planning**: Create visual mockups in docs/stories/{story_id}/design/
     2. **Reference Analysis**: Compare with professional applications (btop, etc.)
     3. **Switch to worktree** (MANDATORY): cd {worktree_path}
     4. **Verify you're in worktree**: pwd (should show .worktrees/agent-...)
     5. **Design-First Implementation**: Implement visuals before functionality
     6. **Progressive Validation**: Test visual appearance at each milestone
     7. **Commit all changes** with design quality checkpoints
     8. **Return to repo root**: cd ../../
     9. **Design Quality Gate**: Verify professional appearance and accessibility
     10. **Update story status to "Ready for Review"**
     11. **Add Dev Agent Record** documenting implementation and design decisions
     12. **STOP HERE** - Do NOT merge or cleanup worktree

     ⚠️ LEAVE THE WORKTREE INTACT - The orchestrator will handle merge after code review

     See .claude/agents/directives/git-worktree-workflow.md for complete enhanced workflow.

     **If you encounter ANY issues with the worktree workflow:**
     - STOP immediately
     - Report the error to the orchestrator
     - Do NOT attempt to work without the worktree

     **Design Quality Requirements:**
     - Visual design must match professional standards for the application type
     - Web apps: Responsive design, browser compatibility, Core Web Vitals compliance
     - Desktop apps: DPI scaling, native platform feel, smooth performance
     - CLI apps: Terminal compatibility, color degradation, ASCII fallbacks
     - All apps: WCAG 2.1 Level AA accessibility compliance
     - Consistent design system usage across all components

     **Project Dependencies (Story 1.1 ONLY):**
     - If this is Story 1.1 (Project Initialization), install ALL core project dependencies
     - Include: package managers, frameworks, testing libraries, linting tools, etc.
     - Commit package.json and lock files to enable efficient dependency installation in later stories
     - Document all installed dependencies in the Dev Agent Record

     **Project Dependencies (Stories 1.2+):**
     - Check if dependencies already exist in package.json/lock file before installing
     - If dependencies exist, run install command (npm install, pip install -r, etc.)
     - Only add new dependencies if they are NOT already in the lock file
     - This saves tokens and ensures consistent dependency versions

     When complete, update the story status to "Ready for Review" and add
     a Dev Agent Record section documenting your implementation AND design decisions.

     Then STOP and return control to the orchestrator for code review.
     ```

4. **Monitor Wave for Completion**:
   - Wait for ALL agents in the wave to complete their work
   - For each story in the wave:
     - Verify story status changed to "Ready for Review"
     - Verify Dev Agent Record section was added
     - Verify worktree is still intact (NOT merged or cleaned up)
     - Update task state: `status: "ready_for_review"`
   - **Do NOT proceed to code review until ALL stories in the wave are complete**

   **Verification Checkpoint:**
   - [ ] All stories in wave have status "Ready for Review"
   - [ ] All Dev Agent Records are present
   - [ ] All worktrees are intact (not merged yet)
   - [ ] Ready to proceed to code review phase

5. **⚠️ MANDATORY CODE REVIEW - DO NOT SKIP ⚠️**:

   **🚨 CRITICAL: Code review happens BEFORE merge - worktrees are still intact 🚨**

   **For each story in the wave:**

   - Update task state: `status: "in_review"`
   - **IMMEDIATELY** invoke code reviewer (no exceptions):
     ```
     @agent-code-reviewer, please review the implementation for story {story_id}.

     Story file: {story_file}
     Worktree path: {worktree_path}
     Files modified: [list all modified files from Dev Agent Record]

     🚨 IMPORTANT: The changes are in the worktree and have NOT been merged yet.
     Review the code in the worktree before it gets merged to main.

     Please perform a comprehensive code review following your agent definition,
     focusing on:
     - Code quality and best practices
     - Test coverage and correctness
     - Security vulnerabilities
     - Performance considerations
     - Adherence to acceptance criteria
     - Design quality and accessibility

     Save the review to docs/code_reviews/{story_id}-code-review.md

     Include in your review:
     - Overall assessment (Approved / Changes Requested / Rejected)
     - Critical issues (must fix before merge)
     - High-priority issues (should fix before merge)
     - Medium/low-priority issues (can fix later)
     - Positive observations
     ```

   **Verification Checkpoint:**
   - [ ] Code review agent invoked for each story in wave
   - [ ] Waiting for ALL code reviews to complete
   - [ ] Worktrees are still intact (not merged)
   - [ ] DO NOT proceed until ALL reviews are complete

6. **Process Review Results**:

   **For each story in the wave:**

   - **WAIT** for review completion (do not proceed without it)
   - Read review file from `docs/code_reviews/{story_id}-code-review.md`
   - Extract review status (Approved / Changes Requested / Rejected)
   - Update task state with `review_status` and `review_file` path

   **Verification Checkpoint:**
   - [ ] All review files exist and were read
   - [ ] All review statuses extracted
   - [ ] All task states updated with review information
   - [ ] Ready to handle review outcomes

7. **Handle Review Outcomes and Merge (NEW PHASE)**:

   **🚨 CRITICAL: Developer agents are re-invoked to handle review results and merge 🚨**

   **For each story in the wave, based on review outcome:**

   **If Review APPROVED:**

   - Update task state: `status: "merging"`
   - **Re-invoke developer agent to merge**:
     ```
     @agent-{assigned_agent}, congratulations! The code review for story {story_id} has been APPROVED.

     Story file: {story_file}
     Review file: {review_file}
     Worktree path: {worktree_path}

     ✅ Your implementation passed code review!

     Now you must merge your changes to the main branch:

     1. **Review the code review feedback** (even if approved, there may be notes)
     2. **Return to repo root**: cd {project_root}
     3. **Detect potential conflicts**:
        ```bash
        CONFLICT_RESULT=$(./.claude/agents/lib/conflict-detector.sh detect "{worktree_path}")
        ```
     4. **If conflicts detected**:
        - Report conflicts to orchestrator
        - Wait for conflict resolution guidance
     5. **If no conflicts OR conflicts resolved**:
        - **Merge worktree**: ./.claude/agents/lib/git-worktree-manager.sh merge "{worktree_path}"
        - **Unregister files**: ./.claude/agents/lib/file-tracker.sh unregister "{story_id}"
        - **Cleanup worktree**: ./.claude/agents/lib/git-worktree-manager.sh cleanup "{worktree_path}"
     6. **Update story status to "Done"**
     7. **Document merge in Dev Agent Record**:
        - Add code review status (Approved)
        - Link to review file
        - Note merge timestamp
        - Note any follow-up items from review

     When complete, report back to orchestrator that merge is complete.
     ```

   - **Wait for developer agent to complete merge**
   - **Verify merge completed successfully**:
     - [ ] Worktree merged to main
     - [ ] Worktree cleaned up
     - [ ] Story status updated to "Done"
     - [ ] Dev Agent Record updated with review results

   - Update task state: `status: "done"`, `completed_at: <timestamp>`
   - Update progress.json counters
   - Update roadmap.md to check off the story

   **Verification Checkpoint:**
   - [ ] Developer agent re-invoked for merge
   - [ ] Merge completed successfully
   - [ ] Worktree cleaned up
   - [ ] Story marked as done
   - [ ] Progress tracking updated
   - [ ] Ready to proceed to next wave

   **If Review CHANGES REQUESTED:**

   - Update task state: `status: "in_progress"`, `iteration_count: +1`
   - **DO NOT merge - worktree stays intact**
   - **Re-invoke developer agent to fix issues**:
     ```
     @agent-{assigned_agent}, the code review for story {story_id} found issues
     that need to be addressed before merging.

     Story file: {story_file}
     Review file: {review_file}
     Worktree path: {worktree_path}

     ⚠️ Your implementation requires changes before it can be merged.

     Critical issues to address:
     [List critical and high-priority issues from review]

     Please:
     1. **Read the complete code review**: {review_file}
     2. **Switch to your worktree**: cd {worktree_path}
     3. **Address ALL critical and high-priority issues**
     4. **Commit your fixes** with clear commit messages
     5. **Return to repo root**: cd ../../
     6. **Update story status back to "Ready for Review"**
     7. **Update Dev Agent Record** with fixes made

     ⚠️ DO NOT merge or cleanup the worktree - keep it intact for re-review

     IMPORTANT: You must address these issues before this story can be merged
     and before we can proceed to the next wave.
     ```

   - **Wait for developer agent to complete fixes**
   - Return to step 4 (Monitor for Completion)
   - **REPEAT code review process** (step 5) after fixes are complete
   - **REPEAT this merge phase** (step 7) after re-review

   **Verification Checkpoint:**
   - [ ] Developer agent re-invoked with feedback
   - [ ] Waiting for fixes to be completed
   - [ ] Worktree still intact (not merged)
   - [ ] Will trigger another code review after fixes
   - [ ] NOT proceeding to next wave until approved and merged

   **If Review REJECTED:**

   - Update task state: `status: "blocked"`, `blocked_reason: "Code review rejected"`
   - **STOP and escalate to user**:
     ```
     ⚠️ CRITICAL: Code review for story {story_id} was REJECTED

     Review file: {review_file}
     Reason: [Extract rejection reason from review]

     This story cannot proceed without significant changes or re-scoping.

     Options:
     1. Re-scope the story and restart implementation
     2. Abandon this story and update roadmap
     3. Escalate for manual review and decision

     Please review the code review and decide how to proceed.
     ```

   - **Wait for user decision**
   - **Do NOT proceed to next wave until resolved**

   **Verification Checkpoint:**
   - [ ] User notified of rejection
   - [ ] Waiting for user decision
   - [ ] Story blocked until resolved
   - [ ] NOT proceeding to next wave

**CRITICAL ENFORCEMENT RULES:**
- ❌ **NEVER skip code review** for any story
- ❌ **NEVER merge before code review** is approved
- ❌ **NEVER proceed to next wave** without approved code reviews and successful merges
- ❌ **NEVER mark story as done** without code review documentation
- ✅ **ALWAYS wait** for code review completion before merge
- ✅ **ALWAYS re-invoke developer agent** to handle merge after approval
- ✅ **ALWAYS address** code review feedback before proceeding
- ✅ **ALWAYS document** code review results in story file
- ✅ **ALWAYS keep worktree intact** until after code review approval

### Phase 7a: Conflict Detection and Resolution (When Needed)

**This phase is triggered when a developer agent reports conflicts during merge attempt.**

**When developer agent reports conflicts:**

1. **Extract Conflict Information**:
   - Read conflict detection result from developer agent
   - Identify conflicting files
   - Determine severity level (low/medium/high/critical)

2. **For Low/Medium Severity Conflicts**:
   - Invoke conflict-resolver agent:
     ```
     @agent-conflict-resolver, please analyze and resolve the following conflicts:

     Story: {story_id}
     Worktree: {worktree_path}
     Conflicting files: {list_of_files}
     Severity: {severity_level}

     Please:
     1. Analyze both versions of the conflicting code
     2. Understand the intent of each change
     3. Propose an intelligent resolution
     4. Provide reasoning and confidence level
     5. Suggest alternative resolutions if applicable

     Context:
     - Story description: {story_description}
     - Files modified: {modified_files}
     - Recent changes in main: {recent_main_changes}
     ```

   - **Wait for conflict-resolver analysis**
   - **Automatically apply** proposed resolution (low/medium severity)
   - **Notify developer agent** to retry merge

3. **For High/Critical Severity Conflicts**:
   - Invoke conflict-resolver agent (same as above)
   - **Present proposed resolution to user**:
     ```
     ## High-Severity Conflict Resolution Proposal

     Story: {story_id}
     Severity: {severity_level}

     {conflict_resolver_analysis}

     Proposed Resolution:
     {proposed_resolution}

     Reasoning:
     {reasoning}

     Confidence Level: {confidence}

     Alternative Resolutions:
     {alternatives}

     Options:
     1. Accept proposed resolution (recommended)
     2. Choose alternative resolution
     3. Manually resolve conflicts
     4. Abort merge and re-implement story

     Please review and choose an option.
     ```

   - **Wait for user decision**
   - **Apply approved resolution**
   - **Notify developer agent** to retry merge

4. **After Conflict Resolution**:
   - Developer agent retries merge with resolved conflicts
   - If merge succeeds, proceed with cleanup
   - If merge still fails, escalate to user for manual resolution

**Verification Checkpoint:**
- [ ] Conflicts detected and analyzed
- [ ] Resolution proposed and applied
- [ ] Developer agent notified to retry
- [ ] Merge completed successfully after resolution

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

