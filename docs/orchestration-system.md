# Story Orchestration System

A comprehensive workflow automation system for coordinating the implementation of user stories using Claude Code's slash commands and development agents.

## 📋 Overview

The Story Orchestration System automates the process of:
- Analyzing user stories and their dependencies
- Determining the correct implementation order
- Coordinating development agents
- Managing code review workflows
- Tracking progress across sessions

## 🎯 Key Features

- **Dependency Resolution**: Automatically determines the correct order to implement stories based on dependencies
- **Agent Matching**: Intelligently selects the appropriate development agent for each story based on technology stack
- **Code Review Integration**: Automatically triggers code reviews and handles feedback loops
- **Progress Tracking**: Maintains state across sessions so work can be paused and resumed
- **Parallel Opportunities**: Identifies stories that can be implemented simultaneously
- **Error Handling**: Detects circular dependencies, missing dependencies, and other issues

## 🚀 Quick Start

### 1. Initialize the System

```bash
# Implement all stories
/implement-stories

# Or scope to specific stories
/implement-stories 1.1-1.5

# Or work on an epic
/implement-stories epic:auth

# Or use a pattern
/implement-stories 1.*
```

This command will:
- Scan stories in `docs/stories/` (filtered by scope if provided)
- Build a dependency graph
- Create a roadmap
- Start implementing stories in the correct order

### 2. Check Progress

```bash
/story-status
```

Shows a comprehensive report of:
- Completed stories
- In-progress stories
- Blocked stories
- Next available stories

### 3. Continue Work

```bash
/next-story
```

Starts the next story that's ready for implementation.

### 4. Trigger Code Review

```bash
/review-story 1.1
```

Triggers a code review for a specific story.

## 📁 Directory Structure

The orchestration system creates and maintains the following structure:

```
.agent-orchestration/
├── roadmap.md                    # Human-readable implementation plan
├── progress.json                 # Overall progress metrics
├── dependency-graph.json         # Story dependency relationships
└── tasks/
    ├── 1.1-task.json            # Task state for story 1.1
    ├── 1.2-task.json            # Task state for story 1.2
    └── ...

docs/
├── stories/                      # User story files (input)
│   ├── 1.1-user-authentication.md
│   ├── 1.2-user-profile.md
│   └── ...
└── code_reviews/                 # Code review reports (output)
    ├── 1.1-code-review.md
    ├── 1.2-code-review.md
    └── ...
```

## 📊 State File Formats

### progress.json

```json
{
  "initialized_at": "2025-10-02T10:00:00Z",
  "last_updated": "2025-10-02T14:30:00Z",
  "total_stories": 8,
  "completed": 3,
  "in_progress": 2,
  "blocked": 2,
  "not_started": 1
}
```

### Task State File (tasks/{story-id}-task.json)

```json
{
  "story_id": "1.1",
  "story_file": "docs/stories/1.1-user-authentication.md",
  "status": "done",
  "assigned_agent": "javascript-developer",
  "dependencies": [],
  "tech_stack": ["React", "TypeScript", "Next.js"],
  "started_at": "2025-10-02T10:30:00Z",
  "completed_at": "2025-10-02T12:45:00Z",
  "review_status": "Approved",
  "review_file": "docs/code_reviews/1.1-code-review.md",
  "iteration_count": 1,
  "last_updated": "2025-10-02T12:45:00Z"
}
```

### dependency-graph.json

```json
{
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
  ]
}
```

## 🔄 Workflow Phases

### Phase 1: Discovery & Analysis
- Scans `docs/stories/` directory
- Extracts story metadata (ID, status, dependencies, tech stack)
- Creates task state files

### Phase 2: Dependency Resolution
- Builds dependency graph
- Validates no circular dependencies
- Performs topological sort
- Identifies parallel opportunities

### Phase 3: Agent Matching
- Analyzes technology stack for each story
- Matches to appropriate development agent
- Falls back to default agent if needed

### Phase 4: Implementation
- Starts stories in dependency order
- Invokes development agents
- Monitors for completion
- Updates state files

### Phase 5: Code Review
- Triggers code review when story is ready
- Processes review results
- Handles feedback loops (rework if needed)
- Marks story as done when approved

### Phase 6: Completion
- Generates final report
- Archives roadmap
- Updates all metrics

## 🎮 Available Commands

### `/implement-stories`
**Purpose**: Full automated workflow from start to finish

**When to use**:
- Starting a new project
- Implementing multiple stories
- Want automated coordination

**What it does**:
- Analyzes all stories
- Creates roadmap
- Implements stories in order
- Handles reviews automatically
- Tracks progress

### `/next-story`
**Purpose**: Start the next available story

**When to use**:
- Continuing work after a break
- Want manual control over pacing
- One story at a time approach

**What it does**:
- Finds next story with dependencies met
- Starts implementation
- Updates state

### `/review-story [story-id]`
**Purpose**: Trigger code review for a specific story

**When to use**:
- Story development is complete
- Need to re-review after fixes
- Manual review workflow

**What it does**:
- Validates story is ready
- Invokes code-reviewer agent
- Processes review results
- Updates story status

### `/story-status`
**Purpose**: Show comprehensive progress report

**When to use**:
- Check overall progress
- Identify blockers
- Plan next actions
- Resume after interruption

**What it does**:
- Reads all state files
- Generates detailed report
- Shows metrics and recommendations
- Identifies next actions

## 🔧 Technology Detection

The system automatically detects technology stack from story content:

| Keywords | Assigned Agent |
|----------|---------------|
| JavaScript, TypeScript, React, Next.js, Node.js | `@agent-javascript-developer` |
| Python, Django, Flask, FastAPI | `@agent-python-developer` |
| Rust, Cargo | `@agent-rust-developer` |
| Backend, API, Database | Framework-specific or backend agent |

## 📝 Story File Requirements

For the orchestration system to work properly, story files should include:

### Required Fields:
- **Story ID**: In filename (e.g., `1.1-user-authentication.md`)
- **Status**: Field indicating current state
- **Acceptance Criteria**: Clear, testable requirements

### Optional but Recommended:
- **Epic**: Tag stories that belong to the same epic/feature
- **Dependencies**: List of story IDs this story depends on
- **Technology Stack**: Mentioned in description or requirements
- **File Paths**: Specific files or directories to work with

### Epic Organization

Stories can be organized into epics using any of these methods:

#### **Method 1: Epic Field in Story**
```markdown
# Story 1.1: User Login

**Epic**: Authentication
**Status**: Not Started
```

#### **Method 2: YAML Frontmatter**
```markdown
---
epic: authentication
---

# Story 1.1: User Login
```

#### **Method 3: Directory Structure**
```
docs/stories/
├── epic-auth/
│   ├── 1.1-login.md
│   ├── 1.2-logout.md
│   └── 1.3-password-reset.md
└── epic-profile/
    ├── 2.1-view-profile.md
    └── 2.2-edit-profile.md
```

#### **Method 4: Story ID Prefix**
```
docs/stories/
├── auth-1.1-login.md
├── auth-1.2-logout.md
├── profile-2.1-view-profile.md
└── profile-2.2-edit-profile.md
```

Then use: `/implement-stories epic:auth`

### Example Story File:

```markdown
# Story 1.2: User Profile Management

**Epic**: User Management
**Status**: Not Started
**Dependencies**: 1.1 (User Authentication)

## Description
Implement user profile management functionality allowing users to view and edit their profile information.

## Technology Stack
- React
- TypeScript
- Next.js
- PostgreSQL

## Acceptance Criteria
1. Users can view their profile information
2. Users can edit their name, email, and bio
3. Changes are validated before saving
4. Profile updates are persisted to database
5. All tests pass

## Files to Modify
- `src/components/UserProfile.tsx`
- `src/api/profile.ts`
- `src/pages/profile.tsx`
```

## 🔄 Resume Capability

The orchestration system can be paused and resumed at any time:

1. **Press Escape** to interrupt the workflow
2. **State is automatically saved** in `.agent-orchestration/`
3. **Run `/implement-stories` or `/next-story`** to resume
4. **System picks up where it left off**

## ⚠️ Error Handling

The system handles common errors:

- **Circular Dependencies**: Detected and reported with suggestions
- **Missing Dependencies**: Identified with list of missing stories
- **Agent Not Found**: Suggests fallback agents
- **Story File Not Found**: Skips and continues with warning
- **Stuck Reviews**: Prompts user to check status

## 🎯 Best Practices

1. **Write Clear Dependencies**: Explicitly list dependencies in story files
2. **Use Consistent Story IDs**: Follow numbering scheme (e.g., 1.1, 1.2, 2.1)
3. **Check Status Regularly**: Run `/story-status` to monitor progress
4. **Review Roadmap**: Check `.agent-orchestration/roadmap.md` before starting
5. **Handle Review Feedback Promptly**: Address code review issues quickly
6. **Commit State Files**: Consider committing `.agent-orchestration/` to track progress

## 🚧 Future Enhancements

Planned features for future versions:

- **QA Integration**: Add QA testing phase between code review and completion
- **Parallel Execution**: Support for running multiple agents simultaneously
- **Custom Workflows**: Configurable workflow phases
- **Metrics Dashboard**: Visual progress tracking
- **Notification System**: Alerts when stories complete or need attention

## 📚 Additional Resources

- **Agent Definitions**: See `agents/definitions/` for available agents
- **Code Review Guidelines**: See `agents/definitions/code-reviewer.md`
- **Development Workflow**: See `agents/definitions/javascript-developer.md`

## 🆘 Troubleshooting

### "Orchestration system not initialized"
**Solution**: Run `/implement-stories` to initialize

### "Story stuck in 'in_progress'"
**Solution**: Check if dev agent completed work, manually update state if needed

### "Circular dependency detected"
**Solution**: Review dependency graph, break the cycle by removing one dependency

### "No stories ready to start"
**Solution**: Check `/story-status` to see what's blocking progress

### "Review never completes"
**Solution**: Check if code-reviewer agent finished, verify review file was created

## 📞 Support

For issues or questions:
1. Check this documentation
2. Review state files in `.agent-orchestration/`
3. Run `/story-status` for current state
4. Check agent definitions for workflow details

