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

**See `agents/agent-guides/orchestration-patterns.md` for detailed argument parsing logic.**

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

**See `agents/agent-guides/git-workflow.md` for git worktree details.**
**See `agents/agent-guides/orchestration-patterns.md` for complete orchestration patterns.**

## Workflow

### Step 1: Parse Arguments and Determine Scope

**Parse `$ARGUMENTS` to determine which stories to implement:**
- No arguments → All stories
- Range syntax → Parse range
- Specific stories → Parse list
- Epic scope → Find stories in epic
- Pattern matching → Match pattern

**See `agents/agent-guides/orchestration-patterns.md` for argument parsing details.**

### Step 2: Discover and Analyze Stories

**Scan `docs/stories/` directory:**
- List all .md files
- Filter out README.md and non-story files
- Parse story IDs from filenames
- Filter stories based on scope from Step 1

**For each story in scope:**
- Read story file
- Extract dependencies
- Identify technology stack
- Determine appropriate agent

**See `agents/agent-guides/orchestration-patterns.md` for story discovery patterns.**

### Step 3: Build Dependency Graph

**Create dependency graph:**
- Map all dependencies between stories
- Identify stories with zero dependencies (Wave 0)
- Categorize stories into waves based on dependencies
- Detect circular dependencies (error if found)

**Check for out-of-scope dependencies:**
- If story depends on story outside scope, warn user
- Offer to expand scope or skip story
- Wait for user decision

**See `agents/agent-guides/orchestration-patterns.md` for dependency resolution details.**

### Step 4: Execute Stories in Waves (Parallel Execution)

**For each wave:**

#### 4.1: Start All Stories in Wave (Parallel)

**For each story in current wave:**

1. **Create git worktree:**
   ```bash
   ./agents/lib/git-worktree-manager.sh create "<story-id>" "<agent-name>"
   ```

2. **Invoke agent in worktree:**
   - Switch to worktree directory
   - Call appropriate agent with story file
   - Agent implements acceptance criteria
   - Agent runs tests and verifies
   - Agent updates story status to "Ready for Review"

3. **Track progress:**
   - Update state file in `.agent-orchestration/`
   - Monitor agent output
   - Capture test results

**All stories in wave execute simultaneously.**

#### 4.2: Wait for Wave Completion

**Monitor all stories in wave:**
- Wait for all agents to complete
- Collect test results
- Check for failures

**If any story fails:**
- Mark story as "Failed"
- Cleanup failed story worktree
- Continue with other stories
- Report failure at end

#### 4.3: Code Review (MANDATORY)

**For EACH completed story in wave:**

1. **Trigger code review:**
   ```bash
   /review-story <story-id>
   ```

2. **Wait for review completion**

3. **If issues found:**
   - Agent fixes issues
   - Re-run tests
   - Update story

4. **Document review results:**
   - Add review results to story file
   - Update story status to "Approved"

**CRITICAL: Do NOT proceed to next wave until ALL stories in current wave are reviewed and approved.**

#### 4.4: Merge and Cleanup

**For each approved story:**

1. **Merge changes:**
   ```bash
   ./agents/lib/git-worktree-manager.sh merge "<worktree-path>"
   ```

2. **Cleanup worktree:**
   ```bash
   ./agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
   ```

3. **Update state:**
   - Mark story as "Approved" in state file
   - Update orchestration progress

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

**See `agents/agent-guides/orchestration-patterns.md` for complete state management patterns.**

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

**See `agents/agent-guides/orchestration-patterns.md` for error handling patterns.**

## Best Practices

1. **Maximize parallel execution** - Default to parallel, only sequential when dependencies require
2. **Always use git worktrees** - Prevents conflicts, enables true parallelism
3. **Verify dependencies** - Never skip dependency checks
4. **Monitor progress** - Update state files, provide real-time feedback
5. **Handle failures gracefully** - Isolate failures, continue with independent stories
6. **Mandatory code review** - Review EVERY story before proceeding
7. **Cleanup resources** - Always cleanup worktrees after completion

**See `agents/agent-guides/orchestration-patterns.md` for complete best practices and patterns.**

