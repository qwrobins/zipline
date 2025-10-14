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
Implements ALL stories in `docs/stories/`

### **Range Syntax** (1.1-1.5)
Implements stories 1.1, 1.2, 1.3, 1.4, 1.5 (inclusive range)

### **Specific Stories** (1.1 1.3 1.5)
Implements only the specified stories

### **Epic Scope** (epic:auth)
Implements all stories tagged with epic "auth"

### **Pattern Matching** (1.*)
Implements all stories matching the pattern

**See `.claude/agents/agent-guides/orchestration-patterns.md` for detailed argument parsing logic.**

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

**See `.claude/agents/agent-guides/git-workflow.md` for complete workflow details.**

## 🔧 QUICK REFERENCE: Post-Review Handoff

**After code reviews are approved, BEFORE merge operations:**

1. **Check if stories are ready for merge:**
   ```bash
   ./.claude/agents/lib/worktree-readiness-checker.sh check <story-ids>
   ```

2. **If NOT ready (uncommitted changes found):**
   - Hand stories back to their original developer agents
   - Agents commit all changes in their worktrees
   - Re-run readiness check

3. **If ready (all clean):**
   - Proceed with sequential merge operations

**See `docs/post-review-handoff-fix.md` for complete details.**

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

**See `.claude/agents/agent-guides/git-workflow.md` for git worktree details.**
**See `.claude/agents/agent-guides/orchestration-patterns.md` for complete orchestration patterns.**

## Workflow

### Step 1: Parse Arguments and Determine Scope

**Parse `$ARGUMENTS` to determine which stories to implement:**
- No arguments → All stories
- Range syntax → Parse range
- Specific stories → Parse list
- Epic scope → Find stories in epic
- Pattern matching → Match pattern

**See `.claude/agents/agent-guides/orchestration-patterns.md` for argument parsing details.**

### Step 2: Load Planning State

**🚨 CRITICAL: This phase loads pre-existing planning artifacts created by `/automate-planning`**

#### 2.1: Verify Orchestration Infrastructure

1. **Check if `.agent-orchestration/` directory exists**
   - If NOT exists:
     ```
     ❌ ERROR: Orchestration infrastructure not found!

     The .agent-orchestration/ directory does not exist.
     This directory should have been created by the /automate-planning command.

     Please run /automate-planning first to:
     1. Create user stories
     2. Build dependency graph
     3. Match stories to agents
     4. Generate implementation roadmap

     Then run /implement-stories to execute the implementation.
     ```
     **STOP** - Do not proceed without orchestration infrastructure

#### 2.2: Load Dependency Graph

2. **Read `.agent-orchestration/dependency-graph.json`**
   - Extract:
     - All story nodes
     - Dependency edges
     - Implementation order
     - Parallel waves
     - Parallel opportunities
   - If file missing or invalid:
     ```
     ❌ ERROR: Dependency graph not found or invalid!

     Expected: .agent-orchestration/dependency-graph.json

     Please run /automate-planning to generate the dependency graph.
     ```
     **STOP** - Do not proceed without dependency graph

#### 2.3: Load Task State Files

3. **Scan `.agent-orchestration/tasks/` directory**
   - Read all `*-task.json` files
   - Build map of story ID → task state
   - If directory missing or empty:
     ```
     ❌ ERROR: Task state files not found!

     Expected: .agent-orchestration/tasks/*.json

     Please run /automate-planning to generate task state files.
     ```
     **STOP** - Do not proceed without task state files

#### 2.4: Load Roadmap

4. **Read `.agent-orchestration/roadmap.md`**
   - Display roadmap to user for reference
   - If file missing, warn but continue (not critical)

#### 2.5: Apply Scope Filter

5. **Filter based on scope from Step 1:**
   - If scope is "all": use all stories from loaded state
   - If scope is range: filter loaded stories to range
   - If scope is epic: filter loaded stories to epic
   - If scope is pattern: filter loaded stories to pattern
   - If scope is list: filter loaded stories to specific IDs

6. **Filter dependency graph and waves:**
   - Remove out-of-scope stories from dependency graph
   - Recalculate parallel waves for in-scope stories only
   - Update implementation order for filtered set

#### 2.6: Check Out-of-Scope Dependencies

7. **For each in-scope story, check if dependencies are also in scope**
   - If dependencies are out of scope, warn the user:
     ```
     ⚠️  Warning: Story 1.3 depends on Story 1.1, which is not in scope.

     Options:
     1. Add Story 1.1 to scope (recommended)
     2. Continue anyway (Story 1.3 will be blocked)
     3. Cancel and adjust scope

     What would you like to do?
     ```

#### 2.7: Report Loaded State

8. **Report loaded state:**
   ```
   ✅ Planning State Loaded Successfully

   📊 Orchestration Infrastructure:
   - Dependency Graph: ✅ Loaded
   - Task State Files: ✅ Loaded ([count] stories)
   - Roadmap: ✅ Loaded
   - Parallel Waves: [count] waves identified
   - Max Parallel Agents: [count]

   📋 Scope:
   - Total Stories in Scope: [count]
   - Out-of-Scope Dependencies: [count] warnings
   ```

### Step 3: Git Initialization Check

**🚨 CRITICAL: Verify git is initialized BEFORE any story implementation begins 🚨**

#### 3.1: Check Git Status

1. **Verify git repository exists:**
   ```bash
   git rev-parse --git-dir 2>/dev/null
   ```
   - If succeeds → Git is initialized, proceed to Step 4
   - If fails → Git is NOT initialized, proceed to 3.2

#### 3.2: Initialize Git (If Missing)

2. **Initialize git repository (MANDATORY if missing):**
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

   # Set default branch to "main"
   git branch -M main

   # Verify initialization succeeded
   git rev-parse --git-dir 2>/dev/null
   ```

   **Error Handling:**
   - If `git init` fails → STOP and report: "Failed to initialize git repository. Please check git installation."
   - If initial commit fails → STOP and report: "Failed to create initial commit. Please check file permissions."
   - If verification fails → STOP and report: "Git initialization verification failed. Please initialize git manually."

   **After successful initialization:**
   - Report: "✅ Git repository initialized successfully. Proceeding with worktree workflow."
   - Continue to Step 4

#### 3.3: Enforce Worktree Workflow

3. **⚠️ CRITICAL: The git worktree workflow is MANDATORY for ALL story implementations.**
   - There are NO exceptions to using git worktrees
   - Even if git was just initialized, worktrees MUST be used
   - NEVER proceed with story implementation without worktrees
   - NEVER work directly in the main repository

   **If worktree creation fails:**
   - STOP and report the error to the user
   - Do NOT attempt to work without worktrees
   - Provide troubleshooting guidance

### Step 4: Execute Stories in Waves (Parallel Execution)

**🚀 CRITICAL: Execute stories in PARALLEL waves, not sequentially! 🚀**

**⚠️ CRITICAL: Each wave MUST complete code review before proceeding to the next wave ⚠️**

**Execution Strategy:**

1. **Process by Waves (NOT individual stories):**
   - Identify all stories in the current wave (stories with satisfied dependencies)
   - Launch ALL agents for the wave simultaneously
   - Wait for ALL stories in the wave to complete and pass code review
   - Only then proceed to the next wave

2. **NEVER process stories one-by-one if they can run in parallel**
   - This defeats the purpose of the parallel execution architecture
   - Always check if multiple stories can run simultaneously
   - Maximize parallelism to minimize total implementation time

**For each wave:**

#### 4.1: Identify Stories in Current Wave

1. **Determine which stories can run now:**
   - Stories with NO dependencies (Wave 0)
   - Stories whose dependencies are ALL completed and approved
   - Group these stories into the current wave

2. **Report wave composition:**
   ```
   🚀 Wave [N]: [count] stories ready for parallel execution
   - Story [id]: [title] (@[agent])
   - Story [id]: [title] (@[agent])
   - Story [id]: [title] (@[agent])
   ```

#### 4.2: Launch All Stories in Wave (Parallel)

**🚨 CRITICAL: You MUST create worktrees and invoke agents for ALL stories in the wave 🚨**

**For EACH story in current wave, execute these steps:**

**Step 1: Create git worktree (MANDATORY)**

Execute the worktree creation script:
```bash
./.claude/agents/lib/git-worktree-manager.sh create "<story-id>" "<agent-name>"
```

Example:
```bash
# For story 1.1 assigned to nextjs-developer
./.claude/agents/lib/git-worktree-manager.sh create "1.1" "nextjs-developer"

# For story 1.2 assigned to python-developer
./.claude/agents/lib/git-worktree-manager.sh create "1.2" "python-developer"
```

This script will:
- Create a new branch: `story/<story-id>`
- Create worktree directory: `.worktrees/agent-<agent-name>-<story-id>-<timestamp>/`
- Return the worktree path
- Initialize the worktree with main branch code

**Step 2: Save worktree path**

Capture the worktree path returned by the script and save it to the task state file:
```json
{
  "storyId": "1.1",
  "status": "In Progress",
  "agent": "nextjs-developer",
  "worktree": ".worktrees/agent-nextjs-developer-1.1-20250112143022/",
  "dependencies": ["0.1"],
  "startTime": "2025-01-12T14:30:22Z"
}
```

**Step 3: Invoke agent in worktree**

Switch to the worktree directory and invoke the agent:
```bash
cd <worktree-path>

# Invoke the agent with the story file
# Example: @nextjs-developer, please implement story 1.1
# Story file: docs/stories/1.1-user-authentication.md
```

The agent will:
- Read the story file and acceptance criteria
- Implement the required functionality
- Write and run tests (ALL tests must pass)
- Update story file with Dev Agent Record
- Change story status to "Ready for Review"

**Step 4: Track progress**

Update state file in `.agent-orchestration/tasks/<story-id>-task.json`:
- Set status to "In Progress"
- Record start time
- Record worktree path
- Record agent name

**🚨 CRITICAL: Launch ALL stories in the wave BEFORE waiting for any to complete 🚨**

**🚨 CRITICAL: Always use absolute paths for worktree operations 🚨**

**Parallel Execution Pattern:**
```bash
# Get repository root for absolute paths
REPO_ROOT=$(git rev-parse --show-toplevel)

# Wave 1 has stories 1.1, 1.2, 1.3 (all independent)

# Launch story 1.1 (don't wait)
# create_worktree returns ABSOLUTE path
WORKTREE_1_1=$($REPO_ROOT/.claude/agents/lib/git-worktree-manager.sh create "1.1" "nextjs-developer")
cd "$WORKTREE_1_1"
# Invoke @nextjs-developer for story 1.1
# Store WORKTREE_1_1 path in task state file

# Launch story 1.2 (don't wait)
cd "$REPO_ROOT"
WORKTREE_1_2=$($REPO_ROOT/.claude/agents/lib/git-worktree-manager.sh create "1.2" "python-developer")
cd "$WORKTREE_1_2"
# Invoke @python-developer for story 1.2
# Store WORKTREE_1_2 path in task state file

# Launch story 1.3 (don't wait)
cd "$REPO_ROOT"
WORKTREE_1_3=$($REPO_ROOT/.claude/agents/lib/git-worktree-manager.sh create "1.3" "nextjs-developer")
cd "$WORKTREE_1_3"
# Invoke @nextjs-developer for story 1.3
# Store WORKTREE_1_3 path in task state file

# NOW wait for all three to complete
```

**All stories in wave execute simultaneously in separate worktrees.**

**Path Management:**
- git-worktree-manager.sh returns ABSOLUTE paths
- Store absolute paths in task state files
- Use absolute paths for all subsequent operations (merge, cleanup, review)
- Never use relative paths like `.worktrees/...`

#### 4.3: Wait for Wave Completion

**Monitor all stories in wave:**

1. **Wait for ALL agents in wave to complete:**
   - Monitor each agent's progress
   - Collect test results as they complete
   - Track completion status in state files

2. **Check for failures:**
   - If any story fails:
     - Mark story as "Failed" in state file
     - Cleanup failed story worktree
     - Continue monitoring other stories
     - Report failure at end
   - If all stories succeed:
     - Mark stories as "Ready for Review"
     - Proceed to code review phase

3. **Report wave completion:**
   ```
   ✅ Wave [N] Implementation Complete
   - [count] stories completed successfully
   - [count] stories failed
   - Ready for code review
   ```

#### 4.4: Code Review (MANDATORY - Wave-Based)

**🚨 CRITICAL: Review ALL stories in wave before proceeding to next wave 🚨**

**For EACH completed story in wave:**

1. **Trigger code review:**
   ```bash
   /review-story <story-id>
   ```

2. **Wait for review completion:**
   - Review checks code quality
   - Review verifies tests pass
   - Review checks acceptance criteria met
   - Review validates no regressions

3. **If issues found:**

   **🚨 CRITICAL: Main agent MUST NOT fix issues directly 🚨**

   **Required workflow for fixes:**

   a. **Identify the original developer agent:**
      - Read task state file: `.agent-orchestration/tasks/<story-id>-task.json`
      - Extract `agent` field (e.g., "nextjs-developer", "python-developer")
      - Extract `worktree_path` field (existing worktree location)

   b. **Hand story back to ORIGINAL developer agent:**
      ```bash
      # Switch to the existing worktree
      cd <worktree_path>

      # Invoke the SAME developer agent that did original implementation
      # Pass code review feedback to the agent
      # Agent name from task state file (e.g., @nextjs-developer)
      ```

   c. **Developer agent fixes issues in EXISTING worktree:**
      - Developer agent reads code review feedback
      - Fixes issues in the worktree (NOT main branch)
      - Re-runs tests to verify fixes
      - Updates story file in worktree (NOT main branch)
      - Marks story as "Ready for Re-Review"

   d. **Re-invoke code-reviewer agent (NOT self-review):**
      ```bash
      /review-story <story-id>
      ```
      - Code-reviewer agent reviews the fixes
      - If still has issues: repeat steps a-d
      - If approved: proceed to step 4

   **🚨 NEVER allow:**
   - Main agent fixing code directly
   - Creating new worktree for fixes (use existing worktree)
   - Self-review (agent reviewing its own fixes)
   - Updating story files on main branch

4. **Document review results (after approval):**
   - Add review results to story file (in worktree)
   - Update story status to "Approved" in state file
   - Record review completion time

5. **Track wave review progress:**
   ```
   📋 Wave [N] Code Review Progress:
   - Story [id]: ✅ Approved
   - Story [id]: ✅ Approved
   - Story [id]: 🔄 In Review
   - Story [id]: ❌ Issues Found (fixing...)
   ```

#### 4.4.1: Parallel Fix Execution (If Multiple Stories Have Issues)

**If multiple stories in wave have review issues:**

1. **Identify all stories needing fixes:**
   - Collect all story IDs with review issues
   - Read task state files for each story
   - Extract agent name and worktree path for each

2. **Hand ALL stories back to their developer agents IN PARALLEL:**
   ```bash
   # For each story with issues, invoke its developer agent simultaneously
   # Story 1.1 → @nextjs-developer in worktree-1
   # Story 1.2 → @python-developer in worktree-2
   # Story 1.3 → @nextjs-developer in worktree-3
   # All agents work in parallel in separate worktrees
   ```

3. **Wait for ALL developer agents to complete fixes:**
   - Monitor all agents in parallel
   - Track completion status for each
   - Collect test results from each

4. **Re-review ALL fixed stories IN PARALLEL:**
   ```bash
   # Invoke code-reviewer for all fixed stories simultaneously
   /review-story 1.1
   /review-story 1.2
   /review-story 1.3
   ```

5. **If any still have issues:**
   - Repeat parallel fix process for remaining issues
   - Continue until ALL stories approved

**🚨 CRITICAL: Maintain parallel execution even during fix cycles 🚨**

**🚨 CRITICAL: Do NOT proceed to next wave until ALL stories in current wave are reviewed and approved 🚨**

**Wave Review Completion:**
- ALL stories must be approved
- NO stories can have pending issues
- ALL fixes must be tested and verified
- Only then proceed to post-review handoff

#### 4.4.2: Post-Review Handoff (CRITICAL FIX)

**🚨 CRITICAL: After ALL stories in wave are approved, hand control back to developer agents to finalize changes 🚨**

**This step is MANDATORY before any merge operations to prevent merge conflicts due to uncommitted changes.**

**For EACH approved story in wave (in parallel):**

1. **Identify the developer agent and worktree:**
   - Read task state file: `.agent-orchestration/tasks/<story-id>-task.json`
   - Extract `assigned_agent` field (e.g., "nextjs-developer", "python-developer")
   - Extract `worktree_path` field (existing worktree location)

2. **Hand story back to ORIGINAL developer agent for finalization:**
   ```bash
   # Switch to the existing worktree
   cd <worktree_path>

   # Invoke the SAME developer agent that did original implementation
   # Pass finalization instructions to the agent
   # Agent name from task state file (e.g., @nextjs-developer)
   ```

3. **Developer agent finalizes changes in EXISTING worktree:**
   - Developer agent reviews their working directory status
   - Commits ALL uncommitted changes (if any)
   - Ensures clean working directory: `git status` shows "working tree clean"
   - Updates story file with final implementation notes
   - Marks story as "Ready for Merge" in story file

4. **Verify clean working directory:**
   ```bash
   # Use the readiness checker to verify all worktrees in wave
   ./.claude/agents/lib/worktree-readiness-checker.sh check <story-id1> <story-id2> <story-id3>
   ```
   - **If any uncommitted changes found:** STOP and report error
   - **If all clean:** Proceed to merge operations

5. **Track finalization progress:**
   ```
   📋 Wave [N] Post-Review Finalization:
   - Story [id]: ✅ Finalized (clean working directory)
   - Story [id]: ✅ Finalized (clean working directory)
   - Story [id]: 🔄 Finalizing changes...
   - Story [id]: ❌ Has uncommitted changes (fixing...)
   ```

**🚨 CRITICAL Requirements:**
- ALL developer agents work in parallel in their existing worktrees
- NO new worktrees created (use existing worktrees from implementation)
- ALL working directories MUST be clean before proceeding to merge
- Main agent MUST NOT attempt merge until ALL stories finalized

**Error Handling:**
- If any story has uncommitted changes after finalization attempt:
  - STOP the entire wave merge process
  - Report which stories have uncommitted changes
  - Provide clear instructions for manual resolution
  - Do NOT proceed to merge operations

**Only after ALL stories in wave are finalized with clean working directories:**
- Proceed to Sequential Merge and Cleanup (Step 4.5)

#### 4.5: Sequential Merge and Cleanup (Wave-Based)

**🚨 CRITICAL: Merge stories SEQUENTIALLY within each wave to prevent conflicts 🚨**

**After ALL stories in wave are approved AND finalized (Step 4.4.2 completed):**

**Sequential Merge Process:**

1. **Verify all stories are ready for merge:**
   ```bash
   # Check that all worktrees have clean working directories
   ./.claude/agents/lib/worktree-readiness-checker.sh check <story-id1> <story-id2> <story-id3>
   ```
   - **If check fails:** STOP and complete post-review handoff (Step 4.4.2)
   - **If check passes:** Proceed with merge operations

2. **Get repository root:**
   ```bash
   REPO_ROOT=$(git rev-parse --show-toplevel)
   ```

3. **Sort stories by ID** (1.1, 1.2, 1.3, etc.)
   - Ensures consistent merge order
   - Prevents race conditions
   - Example: `1.1` → `1.2` → `1.3`

4. **For EACH approved story in wave (in order):**

   a. **Merge changes:**
      ```bash
      $REPO_ROOT/.claude/agents/lib/git-worktree-manager.sh merge "<absolute-worktree-path>"
      ```
      - Merges story branch into main
      - **If conflicts occur:**
        - STOP immediately
        - Report conflict to user
        - Provide conflict resolution instructions:
          ```
          CONFLICT in story [story-id]

          To resolve:
          1. cd <worktree-path>
          2. git fetch origin main:main
          3. git rebase main
          4. Resolve conflicts manually
          5. git add <resolved-files>
          6. git rebase --continue
          7. Return to main agent to retry merge
          ```
        - Do NOT proceed to next story
        - Do NOT cleanup worktree (preserve for conflict resolution)

   b. **Verify merge succeeded:**
      ```bash
      cd $REPO_ROOT
      git log -1 --oneline
      ```
      - **MUST show merge commit**
      - **MUST be on main branch**

   c. **Update main branch in remaining worktrees (CRITICAL):**
      ```bash
      # For each remaining story in wave that hasn't been merged yet
      for remaining_worktree in <remaining-worktrees>; do
          git -C "$remaining_worktree" fetch origin main:main 2>/dev/null || true
          git -C "$remaining_worktree" merge main --no-edit 2>/dev/null || {
              echo "Note: Worktree $remaining_worktree may need manual rebase"
          }
      done
      ```
      - **This prevents conflicts in subsequent merges**
      - **Each story gets latest main before its merge**
      - **Failures are logged but don't stop the process**

   d. **Cleanup worktree:**
      ```bash
      $REPO_ROOT/.claude/agents/lib/git-worktree-manager.sh cleanup "<absolute-worktree-path>"
      ```
      - Removes worktree directory
      - Deletes story branch
      - Frees up disk space

   e. **Update state:**
      - Mark story as "Completed" in state file
      - Record completion time
      - Update orchestration progress
      - Update dependency graph (mark as satisfied for dependent stories)

4. **Report wave merge completion:**
   ```
   ✅ Wave [N] Merged Successfully
   - [count] stories merged into main (sequential)
   - [count] worktrees cleaned up
   - Ready to proceed to Wave [N+1]
   ```

**Why Sequential Merging:**
- Prevents merge conflicts in shared files (package.json, package-lock.json, etc.)
- Each story merges against latest main
- Conflicts are detected and resolved one at a time
- Simpler conflict resolution (one story at a time)
- Remaining worktrees updated with latest main before their merge

**Merge Order Example:**
```
Wave 1: Stories 1.1, 1.2, 1.3

1. Merge 1.1 → main (main now has 1.1 changes)
2. Update 1.2 and 1.3 worktrees with latest main
3. Merge 1.2 → main (main now has 1.1 + 1.2 changes)
4. Update 1.3 worktree with latest main
5. Merge 1.3 → main (main now has 1.1 + 1.2 + 1.3 changes)
```

### Step 5: Progress to Next Wave

**After current wave is complete:**
- Verify all stories approved
- Check no merge conflicts
- Proceed to next wave
- Repeat Step 4 for next wave

**Continue until all waves complete.**

### Step 6: Final Summary

**After all stories complete:**

```
✅ Story Implementation Complete

Total Stories: [count]
✅ Completed: [count]
❌ Failed: [count]
⏭️  Skipped: [count]

Failed Stories:
  - [story-id]: [reason]

Next Steps:
  1. Review failed stories
  2. Fix issues and re-run
  3. All stories ready for deployment
```

## State Management

**Track orchestration state in `.agent-orchestration/`:**

**Story state file:** `.agent-orchestration/story-<story-id>.json`
```json
{
  "storyId": "1.1",
  "status": "In Progress",
  "agent": "python-developer",
  "worktree": ".worktrees/agent-python-developer-1.1-...",
  "dependencies": ["0.1"],
  "startTime": "2025-01-12T14:30:22Z"
}
```

**Orchestration state:** `.agent-orchestration/orchestration-state.json`
```json
{
  "totalStories": 15,
  "completed": 3,
  "inProgress": 5,
  "pending": 7,
  "currentWave": 2
}
```

**See `.claude/agents/agent-guides/orchestration-patterns.md` for complete state management patterns.**

## Error Handling

### Story Failure
- Mark story as "Failed"
- Cleanup worktree
- Continue with other stories
- Report at end

### Dependency Failure
- Mark dependent stories as "Blocked"
- Skip blocked stories
- Report to user

### Agent Failure
- Capture error output
- Cleanup worktree
- Mark story as "Failed"
- Continue with other stories

**See `.claude/agents/agent-guides/orchestration-patterns.md` for error handling patterns.**

## Best Practices

1. **Maximize parallel execution** - Default to parallel, only sequential when dependencies require
2. **Always use git worktrees** - Prevents conflicts, enables true parallelism
3. **Verify dependencies** - Never skip dependency checks
4. **Monitor progress** - Update state files, provide real-time feedback
5. **Handle failures gracefully** - Isolate failures, continue with independent stories
6. **Mandatory code review** - Review EVERY story before proceeding
7. **Cleanup resources** - Always cleanup worktrees after completion

**See `.claude/agents/agent-guides/orchestration-patterns.md` for complete best practices and patterns.**

