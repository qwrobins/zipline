# Orchestration Patterns Guide

This guide provides comprehensive patterns for orchestrating multi-agent workflows, story implementation, and parallel execution strategies.

## Core Orchestration Principles

### 1. Maximize Parallel Execution

**Default to parallel execution** - Sequential execution should ONLY be used when stories have explicit dependencies.

**Benefits:**
- Faster overall completion time
- Better resource utilization
- Reduced waiting time for developers
- Improved throughput

### 2. Dependency Management

**Always check dependencies before execution:**
- Build dependency graph of all stories
- Identify stories with NO dependencies (can start immediately)
- Track dependency completion status
- Wait for dependencies before starting dependent stories

### 3. State Management

**Track orchestration state in `.agent-orchestration/`:**
- Story status (Not Started, In Progress, Ready for Review, Approved)
- Agent assignments
- Dependency relationships
- Execution history

### 4. Error Handling

**Graceful failure handling:**
- Isolate failures to individual stories
- Continue executing independent stories
- Cleanup resources on failure
- Report failures clearly to user

## Parallel Execution Strategy

### Phase 1: Dependency Analysis

**Build dependency graph:**
```
1. Read all story files from docs/stories/
2. Extract dependencies from each story
3. Create adjacency list of dependencies
4. Identify stories with zero dependencies
```

**Categorize stories:**
- **Wave 0**: Stories with NO dependencies (can start immediately)
- **Wave 1**: Stories depending only on Wave 0
- **Wave 2**: Stories depending on Wave 0 or Wave 1
- **Wave N**: Continue until all stories categorized

### Phase 2: Wave Execution

**Execute stories in waves:**
```
For each wave:
  1. Start ALL stories in the wave in parallel
  2. Wait for ALL stories in the wave to complete
  3. Verify all stories passed tests
  4. Proceed to next wave
```

**Parallel execution within wave:**
- Each story gets its own git worktree
- Each story is assigned to appropriate agent
- Stories execute simultaneously
- No interference between stories

### Phase 3: Completion Verification

**After each wave:**
- Verify all tests passed
- Check all acceptance criteria met
- Confirm no merge conflicts
- Update story status to "Ready for Review"

## Story Implementation Workflow

### Step 1: Story Discovery

**Scan for stories:**
```
1. List all .md files in docs/stories/
2. Filter out README.md and non-story files
3. Parse story IDs from filenames
4. Sort by story ID (epic.story format)
```

**Story ID formats:**
- `0.0.project-initialization.md` (Foundation)
- `0.1.design-system-foundation-setup.md` (Foundation)
- `1.1.user-authentication.md` (Feature)
- `2.3.dashboard-widgets.md` (Feature)

### Step 2: Dependency Resolution

**Extract dependencies from story:**
```markdown
**Dependencies**: 0.1, 1.1, 1.2
```

**Dependency types:**
- **Foundation dependencies**: 0.0, 0.1 (always required)
- **Feature dependencies**: Explicit dependencies listed in story
- **Implicit dependencies**: Same epic, lower story number

**Validation:**
- Check all dependencies exist
- Verify no circular dependencies
- Warn about out-of-scope dependencies

### Step 3: Agent Assignment

**Select appropriate agent based on story content:**

**Technology detection:**
- Python files → python-developer
- Go files → golang-developer
- TypeScript/React files → react-developer or nextjs-developer
- Design specs → frontend-design
- Architecture docs → No implementation (documentation only)

**Agent selection logic:**
```
1. Read story acceptance criteria
2. Identify primary technology stack
3. Check for specialized requirements
4. Assign to most appropriate agent
5. Fallback to general developer if unclear
```

### Step 4: Worktree Creation

**Create isolated worktree for each story:**
```bash
./.claude/agents/lib/git-worktree-manager.sh create "<story-id>" "<agent-name>"
```

**Benefits:**
- Complete isolation between stories
- No merge conflicts during development
- Parallel execution without interference
- Easy cleanup on completion or failure

### Step 5: Story Execution

**Execute story in worktree:**
```
1. Switch to worktree directory
2. Invoke assigned agent with story file
3. Agent implements acceptance criteria
4. Agent runs tests and verifies
5. Agent updates story status
6. Return to repo root
```

**Monitoring:**
- Track execution progress
- Capture agent output
- Monitor test results
- Detect failures early

### Step 6: Code Review (MANDATORY)

**After EVERY story implementation:**
```
1. STOP - Trigger code review
2. WAIT - Wait for review completion
3. FIX - Address any issues found
4. DOCUMENT - Add review results to story
5. ONLY THEN - Proceed to next story
```

**This is NON-NEGOTIABLE.**

### Step 7: Merge and Cleanup

**After successful review:**
```bash
# Merge changes
./.claude/agents/lib/git-worktree-manager.sh merge "<worktree-path>"

# Cleanup worktree
./.claude/agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
```

## State File Management

### Story State File Format

**Location:** `.agent-orchestration/story-<story-id>.json`

```json
{
  "storyId": "1.1",
  "status": "In Progress",
  "agent": "python-developer",
  "worktree": ".worktrees/agent-python-developer-1.1-20250112-143022",
  "dependencies": ["0.1"],
  "startTime": "2025-01-12T14:30:22Z",
  "lastUpdate": "2025-01-12T14:35:10Z"
}
```

### Orchestration State File

**Location:** `.agent-orchestration/orchestration-state.json`

```json
{
  "totalStories": 15,
  "completed": 3,
  "inProgress": 5,
  "pending": 7,
  "failed": 0,
  "currentWave": 2,
  "startTime": "2025-01-12T14:00:00Z"
}
```

## Error Handling Patterns

### Story Failure

**When a story fails:**
```
1. Mark story as "Failed" in state file
2. Cleanup story worktree
3. Log failure details
4. Continue with other independent stories
5. Report failure to user at end
```

### Dependency Failure

**When a dependency fails:**
```
1. Mark dependent stories as "Blocked"
2. Skip dependent stories in current execution
3. Report blocked stories to user
4. Suggest manual intervention
```

### Agent Failure

**When an agent crashes:**
```
1. Capture error output
2. Cleanup worktree
3. Mark story as "Failed"
4. Continue with other stories
5. Report agent failure details
```

## Scope Management

### Argument Parsing

**No arguments:**
- Implement ALL stories in docs/stories/

**Range syntax (1.1-1.5):**
- Parse start and end story IDs
- Include all stories in range (inclusive)
- Validate range is valid

**Specific stories (1.1 1.3 1.5):**
- Parse list of story IDs
- Validate all stories exist
- Execute only specified stories

**Epic scope (epic:auth):**
- Detect epic from story metadata
- Find all stories in epic
- Execute all stories in epic

**Pattern matching (1.*):**
- Use glob pattern matching
- Find all matching stories
- Execute all matches

### Out-of-Scope Dependencies

**Detection:**
```
1. Parse dependencies from story
2. Check if dependency is in scope
3. If not in scope, warn user
4. Ask user to confirm or expand scope
```

**Warning message:**
```
⚠️ Out-of-Scope Dependency Detected

Story 2.3 depends on story 1.5, which is not in the current scope.

Options:
1. Expand scope to include 1.5
2. Skip story 2.3 for now
3. Cancel orchestration

Enter your choice (1-3):
```

## Progress Reporting

### Real-Time Updates

**Show progress during execution:**
```
📊 Story Implementation Progress

Wave 1 (3 stories):
  ✅ 0.1 - Design System Foundation (Completed)
  ✅ 1.1 - User Authentication (Completed)
  ⏳ 1.2 - User Profile (In Progress - 45%)

Wave 2 (5 stories):
  ⏸️  2.1 - Dashboard Layout (Waiting for Wave 1)
  ⏸️  2.2 - Widget System (Waiting for Wave 1)
  ...
```

### Completion Summary

**After all stories complete:**
```
✅ Story Implementation Complete

Total Stories: 15
✅ Completed: 13
❌ Failed: 2
⏭️  Skipped: 0

Failed Stories:
  - 3.2: API Integration (Test failures)
  - 4.1: Advanced Search (Dependency failed)

Next Steps:
  1. Review failed stories
  2. Fix issues and re-run
  3. Proceed with code review
```

## Best Practices

### 1. Always Use Git Worktrees
- Prevents conflicts between parallel stories
- Enables true parallel execution
- Easy cleanup and rollback

### 2. Verify Dependencies
- Never skip dependency checks
- Build complete dependency graph
- Detect circular dependencies early

### 3. Monitor Progress
- Update state files regularly
- Provide real-time feedback
- Log all actions for debugging

### 4. Handle Failures Gracefully
- Isolate failures to individual stories
- Continue with independent stories
- Provide clear error messages

### 5. Cleanup Resources
- Always cleanup worktrees after completion
- Remove state files for completed stories
- Keep orchestration directory clean

