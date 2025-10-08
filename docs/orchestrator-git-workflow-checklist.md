# Orchestrator Git Workflow Checklist

## 🚨 CRITICAL: This checklist is MANDATORY for ALL story implementations

## Phase 7: Before ANY Story Implementation

### Step 1: Check Git Status (REQUIRED)
```bash
git rev-parse --git-dir 2>/dev/null
```

**If command succeeds:**
- ✅ Git is initialized
- ✅ Proceed to Step 3 (Enforce Worktree Workflow)

**If command fails:**
- ❌ Git is NOT initialized
- ⚠️ Proceed to Step 2 (Initialize Git)

---

### Step 2: Initialize Git (AUTOMATIC - NO USER INTERVENTION)

**Run these commands automatically:**

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

# Verify initialization succeeded
git rev-parse --git-dir 2>/dev/null
```

**Error Handling:**

| Error | Action |
|-------|--------|
| `git init` fails | STOP and report: "Failed to initialize git repository. Please check git installation." |
| Initial commit fails | STOP and report: "Failed to create initial commit. Please check file permissions." |
| Verification fails | STOP and report: "Git initialization verification failed. Please initialize git manually." |

**After successful initialization:**
- ✅ Report to user: "✅ Git repository initialized successfully. Proceeding with worktree workflow."
- ✅ Proceed to Step 3

---

### Step 3: Enforce Worktree Workflow (MANDATORY - NO EXCEPTIONS)

**⚠️ CRITICAL RULES:**

- ✅ Git worktree workflow is MANDATORY for ALL story implementations
- ✅ There are NO exceptions to using git worktrees
- ✅ Even if git was just initialized, worktrees MUST be used
- ❌ NEVER proceed with story implementation without worktrees
- ❌ NEVER work directly in the main repository
- ❌ NEVER ask user if they want to use worktrees

**If worktree creation fails:**
- ❌ STOP and report the error to the user
- ❌ Do NOT attempt to work without worktrees
- ✅ Provide troubleshooting guidance

---

## Before Each Wave: Pre-Wave Verification

### Verify Git Initialization (MANDATORY CHECK)

**Before launching ANY agents, run this verification:**

```bash
# Verify git is initialized
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "ERROR: Git is not initialized. This should have been caught in Phase 7 initialization."
  echo "Please ensure git is initialized before proceeding."
  exit 1
fi
```

**If verification fails:**
- ❌ STOP immediately
- ❌ Report: "CRITICAL ERROR: Git not initialized. Cannot proceed with worktree workflow."
- ❌ Do NOT attempt to launch any agents
- ✅ Return to Phase 7 git initialization step

**If verification succeeds:**
- ✅ Proceed to create worktrees for wave

---

## For Each Story: Worktree Creation

### Create Worktree with Verification (MANDATORY)

```bash
# Create worktree
WORKTREE_PATH=$(./.claude/agents/lib/git-worktree-manager.sh create "{story_id}" "{assigned_agent}")

# Verify worktree creation succeeded
if [ -z "$WORKTREE_PATH" ] || [ ! -d "$WORKTREE_PATH" ]; then
  echo "ERROR: Failed to create worktree for story {story_id}"
  echo "Worktree workflow is MANDATORY. Cannot proceed without it."
  exit 1
fi
```

**If worktree creation succeeds:**
- ✅ Save worktree path in task state
- ✅ Proceed to launch agent

**If worktree creation fails:**
- ❌ STOP immediately
- ❌ Report error to user
- ❌ Do NOT launch agent
- ❌ Do NOT attempt to work without worktree

---

## Agent Invocation: MANDATORY Worktree Instructions

### Message Template for Agents

```
@agent-{assigned_agent}, please implement story {story_id}.

Story file: {story_file}

🚨 CRITICAL: Git worktree workflow is MANDATORY - NO EXCEPTIONS 🚨

Git has been initialized and your isolated worktree has been created at: {worktree_path}

⚠️ YOU MUST work in the worktree - NEVER work directly in the main repository.
⚠️ The worktree workflow is REQUIRED for conflict prevention.
⚠️ There are NO exceptions to this requirement.

Follow these steps EXACTLY:
1. Design Planning
2. Reference Analysis
3. **Switch to worktree** (MANDATORY): cd {worktree_path}
4. **Verify you're in worktree**: pwd (should show .worktrees/agent-...)
5. Design-First Implementation
6. Progressive Validation
7. Commit all changes
8. Return to repo root: cd ../../
9. Design Quality Gate
10. **Merge worktree**: ./.claude/agents/lib/git-worktree-manager.sh merge "{worktree_path}"
11. **Cleanup worktree**: ./.claude/agents/lib/git-worktree-manager.sh cleanup "{worktree_path}"

**If you encounter ANY issues with the worktree workflow:**
- STOP immediately
- Report the error to the orchestrator
- Do NOT attempt to work without the worktree
```

---

## Quick Decision Tree

```
START
  ↓
Is git initialized?
  ├─ YES → Proceed to worktree workflow
  └─ NO → Initialize git automatically
            ↓
          Did initialization succeed?
            ├─ YES → Report success → Proceed to worktree workflow
            └─ NO → STOP and report error
                      ↓
                    Do NOT proceed with story implementation

Worktree Workflow
  ↓
Create worktree for story
  ↓
Did worktree creation succeed?
  ├─ YES → Launch agent in worktree
  └─ NO → STOP and report error
            ↓
          Do NOT launch agent
          Do NOT work without worktree
```

---

## Common Mistakes to Avoid

### ❌ NEVER Do These:

1. ❌ Ask user if they want to use git worktrees
2. ❌ Skip git initialization and proceed anyway
3. ❌ Skip worktree workflow if git was just initialized
4. ❌ Allow agents to work directly in main repository
5. ❌ Proceed with story implementation if git init fails
6. ❌ Proceed with story implementation if worktree creation fails
7. ❌ Make worktree workflow optional or conditional

### ✅ ALWAYS Do These:

1. ✅ Check git status before ANY story implementation
2. ✅ Automatically initialize git if missing
3. ✅ Verify git initialization succeeded
4. ✅ Enforce MANDATORY worktree workflow (NO EXCEPTIONS)
5. ✅ Verify worktree creation succeeded
6. ✅ STOP if git initialization fails
7. ✅ STOP if worktree creation fails
8. ✅ Report clear error messages
9. ✅ Provide troubleshooting guidance

---

## Error Messages Reference

### Git Not Installed
```
ERROR: Failed to initialize git repository. Please check git installation.

Troubleshooting:
1. Verify git is installed: git --version
2. Install git if missing
3. Retry story implementation
```

### Git Init Failed
```
ERROR: Failed to create initial commit. Please check file permissions.

Troubleshooting:
1. Check file permissions in project directory
2. Ensure you have write access
3. Check for .git directory conflicts
4. Retry story implementation
```

### Git Verification Failed
```
ERROR: Git initialization verification failed. Please initialize git manually.

Troubleshooting:
1. Run: git init
2. Run: git add .
3. Run: git commit -m "Initial commit"
4. Retry story implementation
```

### Worktree Creation Failed
```
ERROR: Failed to create worktree for story {story_id}
Worktree workflow is MANDATORY. Cannot proceed without it.

Troubleshooting:
1. Check git repository is initialized
2. Verify .worktrees directory is writable
3. Check for existing worktrees with same name
4. Review git worktree manager logs
```

### Git Not Initialized (Pre-Wave Check)
```
CRITICAL ERROR: Git not initialized. Cannot proceed with worktree workflow.

This should have been caught in Phase 7 initialization.
Please ensure git is initialized before proceeding.

Action: Return to Phase 7 git initialization step
```

---

## Success Indicators

### ✅ Git Initialization Success
```
✅ Git repository initialized successfully. Proceeding with worktree workflow.
```

### ✅ Worktree Creation Success
```
✅ Worktree created at: .worktrees/agent-{agent_name}-{story_id}
✅ Agent {agent_name} ready to implement story {story_id}
```

### ✅ Pre-Wave Verification Success
```
✅ Git is initialized
✅ Proceeding to create worktrees for wave
```

---

## Summary

**The orchestrator MUST:**
1. ✅ Check git status before ANY story implementation
2. ✅ Automatically initialize git if missing (NO user intervention)
3. ✅ Verify git initialization succeeded
4. ✅ Enforce MANDATORY worktree workflow (NO EXCEPTIONS)
5. ✅ Verify worktree creation succeeded
6. ✅ STOP if any step fails
7. ✅ Report clear error messages
8. ✅ Never proceed without git and worktrees

**The orchestrator MUST NEVER:**
1. ❌ Ask user about git initialization
2. ❌ Skip git initialization
3. ❌ Skip worktree workflow
4. ❌ Allow agents to work without worktrees
5. ❌ Proceed if git init fails
6. ❌ Proceed if worktree creation fails
7. ❌ Make worktrees optional
