# Conflict Prevention and Resolution System Design

## Overview

This document describes the design of an intelligent conflict prevention and resolution system that combines proactive conflict avoidance with AI-assisted conflict resolution.

## Goals

1. **Prevent conflicts before they occur** through intelligent story analysis and merge ordering
2. **Detect conflicts early** before they reach the merge stage
3. **Resolve conflicts intelligently** using AI analysis when they do occur
4. **Minimize manual intervention** while maintaining safety and quality

## Architecture

### Components

```
┌─────────────────────────────────────────────────────────────┐
│                    Orchestrator                              │
│  - Analyzes story dependencies                               │
│  - Determines merge order                                    │
│  - Coordinates conflict resolution                           │
└─────────────────┬───────────────────────────────────────────┘
                  │
        ┌─────────┴─────────┐
        │                   │
        ▼                   ▼
┌───────────────┐   ┌──────────────────┐
│ File Tracker  │   │ Conflict Resolver│
│ - Track files │   │ - Analyze conflicts│
│ - Detect      │   │ - Propose solutions│
│   overlaps    │   │ - Apply resolutions│
└───────────────┘   └──────────────────┘
```

## Phase 1: Conflict Prevention

### 1.1 Story Dependency Analysis

**Goal:** Understand which stories depend on each other

**Implementation:**
- Parse story files for dependency markers
- Build dependency graph
- Determine optimal merge order

**Story Metadata Format:**
```yaml
---
id: "1.1"
title: "User Authentication"
dependencies: []
modifies:
  - "src/auth/"
  - "src/middleware/auth.ts"
  - "tests/auth/"
---
```

**Dependency Graph:**
```
Story 1.1 (Auth) → Story 1.3 (Protected Routes)
Story 1.2 (API Client) → Story 1.4 (Data Fetching)
```

**Merge Order:**
```
1. Story 1.1 (no dependencies)
2. Story 1.2 (no dependencies)
3. Story 1.3 (depends on 1.1)
4. Story 1.4 (depends on 1.2)
```

### 1.2 File Ownership Tracking

**Goal:** Track which files are being modified by which agents

**Registry Format:**
```json
{
  "file_ownership": {
    "src/auth/login.ts": {
      "story_id": "1.1",
      "agent": "javascript-developer",
      "status": "in_progress",
      "worktree": ".worktrees/agent-javascript-developer-1-1-20240107-120000"
    },
    "src/api/client.ts": {
      "story_id": "1.2",
      "agent": "javascript-developer",
      "status": "in_progress",
      "worktree": ".worktrees/agent-javascript-developer-1-2-20240107-130000"
    }
  },
  "potential_conflicts": [
    {
      "file": "src/config/app.ts",
      "stories": ["1.1", "1.2"],
      "severity": "high",
      "detected_at": "2024-01-07T12:30:00Z"
    }
  ]
}
```

**Tracking Process:**
1. Before agent starts work, register files they plan to modify
2. Check for overlaps with other active stories
3. If overlap detected, flag as potential conflict
4. Orchestrator decides: sequence stories or allow parallel with warning

### 1.3 Smart Merge Ordering

**Goal:** Merge stories in an order that minimizes conflicts

**Strategy:**
1. **Dependency-First:** Merge dependencies before dependents
2. **Low-Risk First:** Merge stories with fewer file changes first
3. **Isolated First:** Merge stories with no overlapping files first
4. **Sequential for Conflicts:** If files overlap, merge sequentially

**Example:**
```
Available to merge: [1.1, 1.2, 1.3]

Analysis:
- 1.1: 5 files, no overlaps, no dependencies → Priority 1
- 1.2: 3 files, no overlaps, no dependencies → Priority 2
- 1.3: 8 files, overlaps with 1.1, depends on 1.1 → Priority 3

Merge Order: 1.1 → 1.2 → 1.3
```

## Phase 2: Early Conflict Detection

### 2.1 Pre-Merge Analysis

**Goal:** Detect conflicts before attempting merge

**Process:**
```bash
# Before merging, analyze changes
git diff main...<worktree-branch> --name-only

# For each file, check if it was modified in main since worktree creation
git log main --since="<worktree-created-at>" --name-only

# If same file modified in both, flag as potential conflict
```

**Detection Script:**
```bash
#!/bin/bash
# detect-conflicts.sh

worktree_branch="$1"
base_branch="${2:-main}"

# Get files changed in worktree
worktree_files=$(git diff "$base_branch...$worktree_branch" --name-only)

# Get files changed in base since worktree creation
worktree_created=$(git log -1 --format=%ct "$worktree_branch")
base_files=$(git log "$base_branch" --since="@$worktree_created" --name-only --pretty=format: | sort -u)

# Find overlaps
conflicts=$(comm -12 <(echo "$worktree_files" | sort) <(echo "$base_files" | sort))

if [ -n "$conflicts" ]; then
    echo "Potential conflicts detected in:"
    echo "$conflicts"
    exit 1
fi
```

### 2.2 Conflict Severity Assessment

**Goal:** Classify conflicts by severity

**Severity Levels:**
- **Low:** Different sections of same file (no overlap)
- **Medium:** Same file, different functions/classes
- **High:** Same function/class modified
- **Critical:** Same lines modified

**Assessment:**
```bash
# For each conflicting file, analyze the actual changes
git diff main...<worktree-branch> <file> > worktree.diff
git diff <worktree-base>...main <file> > main.diff

# Use diff analysis to determine if changes overlap
# Low severity: Changes in different line ranges
# High severity: Changes in same line ranges
```

## Phase 3: AI-Assisted Conflict Resolution

### 3.1 Conflict-Resolver Agent

**Agent Definition:** `agents/definitions/conflict-resolver.md`

**Capabilities:**
1. **Analyze Conflicts:** Understand both versions of conflicting code
2. **Understand Context:** Read surrounding code and comments
3. **Propose Solutions:** Suggest intelligent merge strategies
4. **Explain Reasoning:** Provide rationale for proposed resolution
5. **Detect Semantic Conflicts:** Identify logic conflicts beyond text

**Input:**
```json
{
  "conflict": {
    "file": "src/auth/login.ts",
    "base_version": "...",
    "story_1_version": "...",
    "story_2_version": "...",
    "conflict_markers": "..."
  },
  "context": {
    "story_1": {
      "id": "1.1",
      "title": "User Authentication",
      "description": "..."
    },
    "story_2": {
      "id": "1.2",
      "title": "OAuth Integration",
      "description": "..."
    }
  }
}
```

**Output:**
```json
{
  "resolution": {
    "strategy": "merge_both",
    "resolved_content": "...",
    "reasoning": "Both changes are complementary. Story 1.1 adds basic auth, Story 1.2 adds OAuth. Combined implementation includes both methods.",
    "confidence": "high",
    "requires_review": false
  },
  "alternative_resolutions": [
    {
      "strategy": "keep_story_1",
      "reasoning": "If OAuth is not needed yet...",
      "confidence": "medium"
    }
  ]
}
```

### 3.2 Resolution Strategies

**1. Merge Both (Complementary Changes)**
```typescript
// Base version
function login(username, password) {
  return authenticate(username, password);
}

// Story 1.1: Add validation
function login(username, password) {
  if (!username || !password) throw new Error('Invalid credentials');
  return authenticate(username, password);
}

// Story 1.2: Add logging
function login(username, password) {
  logger.info('Login attempt', { username });
  return authenticate(username, password);
}

// Resolution: Merge both
function login(username, password) {
  if (!username || !password) throw new Error('Invalid credentials');
  logger.info('Login attempt', { username });
  return authenticate(username, password);
}
```

**2. Keep Newer (Supersedes)**
```typescript
// Story 1.1: Basic implementation
function fetchUser(id) {
  return fetch(`/api/users/${id}`);
}

// Story 1.2: Complete rewrite with error handling
async function fetchUser(id) {
  try {
    const response = await fetch(`/api/users/${id}`);
    if (!response.ok) throw new Error('User not found');
    return await response.json();
  } catch (error) {
    logger.error('Failed to fetch user', error);
    throw error;
  }
}

// Resolution: Keep Story 1.2 (complete rewrite supersedes basic version)
```

**3. Refactor (Extract Common)**
```typescript
// Story 1.1: Add feature A
function processData(data) {
  validateData(data);
  return transformA(data);
}

// Story 1.2: Add feature B
function processData(data) {
  validateData(data);
  return transformB(data);
}

// Resolution: Refactor to support both
function processData(data, feature) {
  validateData(data);
  if (feature === 'A') return transformA(data);
  if (feature === 'B') return transformB(data);
  throw new Error('Unknown feature');
}
```

### 3.3 Orchestrator-Resolver Workflow

**Complete Workflow:**

```
1. Orchestrator detects conflict
   ↓
2. Orchestrator invokes conflict-resolver agent
   ↓
3. Conflict-resolver analyzes both versions
   ↓
4. Conflict-resolver proposes resolution(s)
   ↓
5. Orchestrator presents to user:
   - Conflict details
   - Proposed resolution
   - Reasoning
   - Confidence level
   ↓
6. User reviews and decides:
   - Accept proposed resolution
   - Choose alternative resolution
   - Manually resolve
   ↓
7. Orchestrator applies resolution
   ↓
8. Continue with merge and cleanup
```

**Orchestrator Logic:**
```bash
# In implement-stories.md

# After agent completes work
merge_result=$(./agents/lib/git-worktree-manager.sh merge "$WORKTREE_PATH")

if [ $? -ne 0 ]; then
    # Merge failed - likely conflicts
    
    # Extract conflict information
    conflicts=$(git diff --name-only --diff-filter=U)
    
    # Invoke conflict-resolver agent
    /agents conflict-resolver
    
    # Provide conflict context
    echo "Please analyze and resolve the following conflicts:"
    echo "Files: $conflicts"
    echo "Story 1: $CURRENT_STORY"
    echo "Story 2: (from main branch)"
    
    # Agent analyzes and proposes resolution
    # User reviews and approves
    # Apply resolution
    
    # Retry merge
    git merge --continue
fi
```

## Implementation Plan

### Phase 1: File Tracking (Week 1)
- [ ] Create file ownership registry
- [ ] Add file tracking to worktree creation
- [ ] Implement overlap detection
- [ ] Update orchestrator to check for overlaps

### Phase 2: Conflict Detection (Week 1-2)
- [ ] Implement pre-merge conflict detection
- [ ] Add severity assessment
- [ ] Create conflict detection script
- [ ] Integrate with merge workflow

### Phase 3: Conflict-Resolver Agent (Week 2-3)
- [ ] Create conflict-resolver agent definition
- [ ] Implement conflict analysis logic
- [ ] Add resolution strategy templates
- [ ] Test with various conflict scenarios

### Phase 4: Orchestrator Integration (Week 3-4)
- [ ] Update orchestrator to invoke conflict-resolver
- [ ] Implement user approval workflow
- [ ] Add resolution application logic
- [ ] Create comprehensive tests

## Success Metrics

**Conflict Prevention:**
- 80% reduction in merge conflicts
- 90% of stories merge without conflicts

**Conflict Resolution:**
- 70% of conflicts resolved automatically (with user approval)
- 95% user satisfaction with proposed resolutions
- Average resolution time < 5 minutes

**System Performance:**
- Conflict detection: < 5 seconds
- Resolution proposal: < 30 seconds
- Total overhead: < 1 minute per story

## Future Enhancements

1. **Machine Learning:** Learn from past resolutions to improve proposals
2. **Semantic Analysis:** Deeper code understanding for better resolutions
3. **Test-Driven Resolution:** Run tests to validate proposed resolutions
4. **Conflict Prediction:** Predict conflicts during story planning
5. **Auto-Apply Low-Risk:** Automatically apply high-confidence, low-risk resolutions

