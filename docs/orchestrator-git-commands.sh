#!/bin/bash
# Orchestrator Git Workflow Commands
# This script shows the exact commands the orchestrator should run
# DO NOT execute this script directly - these are reference commands for the orchestrator

set -e  # Exit on error

# =============================================================================
# PHASE 7: Git Initialization Check (REQUIRED FIRST STEP)
# =============================================================================

echo "=== Phase 7: Git Initialization Check ==="

# -----------------------------------------------------------------------------
# Step 1: Check Git Status
# -----------------------------------------------------------------------------

echo "Step 1: Checking if git is initialized..."

if git rev-parse --git-dir >/dev/null 2>&1; then
    echo "✅ Git is initialized"
    echo "✅ Proceeding to worktree workflow"
    GIT_INITIALIZED=true
else
    echo "❌ Git is NOT initialized"
    echo "⚠️ Proceeding to automatic git initialization"
    GIT_INITIALIZED=false
fi

# -----------------------------------------------------------------------------
# Step 2: Initialize Git if Missing (AUTOMATIC)
# -----------------------------------------------------------------------------

if [ "$GIT_INITIALIZED" = false ]; then
    echo ""
    echo "Step 2: Initializing git repository..."
    
    # Initialize git repository
    if ! git init; then
        echo "❌ ERROR: Failed to initialize git repository. Please check git installation."
        echo ""
        echo "Troubleshooting:"
        echo "1. Verify git is installed: git --version"
        echo "2. Install git if missing"
        echo "3. Retry story implementation"
        exit 1
    fi
    echo "✅ Git repository initialized"
    
    # Create .gitignore if it doesn't exist
    if [ ! -f .gitignore ]; then
        echo "Creating .gitignore file..."
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
        echo "✅ .gitignore created"
    else
        echo "✅ .gitignore already exists"
    fi
    
    # Create initial commit
    echo "Creating initial commit..."
    if ! git add .; then
        echo "❌ ERROR: Failed to stage files for initial commit."
        echo ""
        echo "Troubleshooting:"
        echo "1. Check file permissions in project directory"
        echo "2. Ensure you have write access"
        exit 1
    fi
    
    if ! git commit -m "Initial commit"; then
        echo "❌ ERROR: Failed to create initial commit. Please check file permissions."
        echo ""
        echo "Troubleshooting:"
        echo "1. Check file permissions in project directory"
        echo "2. Ensure you have write access"
        echo "3. Check for .git directory conflicts"
        exit 1
    fi
    echo "✅ Initial commit created"
    
    # Verify initialization succeeded
    echo "Verifying git initialization..."
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "❌ ERROR: Git initialization verification failed. Please initialize git manually."
        echo ""
        echo "Troubleshooting:"
        echo "1. Run: git init"
        echo "2. Run: git add ."
        echo "3. Run: git commit -m \"Initial commit\""
        echo "4. Retry story implementation"
        exit 1
    fi
    echo "✅ Git initialization verified"
    
    # Report success
    echo ""
    echo "✅ Git repository initialized successfully. Proceeding with worktree workflow."
    echo ""
fi

# -----------------------------------------------------------------------------
# Step 3: Enforce Worktree Workflow (MANDATORY - NO EXCEPTIONS)
# -----------------------------------------------------------------------------

echo "Step 3: Enforcing worktree workflow..."
echo ""
echo "⚠️ CRITICAL: The git worktree workflow is MANDATORY for ALL story implementations."
echo "⚠️ There are NO exceptions to using git worktrees"
echo "⚠️ Even if git was just initialized, worktrees MUST be used"
echo "⚠️ NEVER proceed with story implementation without worktrees"
echo "⚠️ NEVER work directly in the main repository"
echo ""

# =============================================================================
# BEFORE EACH WAVE: Pre-Wave Verification
# =============================================================================

echo "=== Pre-Wave Verification ==="

# Verify git is initialized before launching ANY agents
echo "Verifying git is initialized before launching agents..."

if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "❌ CRITICAL ERROR: Git is not initialized. This should have been caught in Phase 7 initialization."
    echo "❌ Please ensure git is initialized before proceeding."
    echo "❌ Cannot proceed with worktree workflow."
    echo ""
    echo "Action: Return to Phase 7 git initialization step"
    exit 1
fi

echo "✅ Git is initialized"
echo "✅ Proceeding to create worktrees for wave"
echo ""

# =============================================================================
# FOR EACH STORY: Worktree Creation
# =============================================================================

echo "=== Worktree Creation for Story ==="

# Example story variables (replace with actual values)
STORY_ID="1.1"
ASSIGNED_AGENT="dev1"

echo "Creating worktree for story $STORY_ID (agent: $ASSIGNED_AGENT)..."

# Create worktree
WORKTREE_PATH=$(./.claude/agents/lib/git-worktree-manager.sh create "$STORY_ID" "$ASSIGNED_AGENT")

# Verify worktree creation succeeded
if [ -z "$WORKTREE_PATH" ] || [ ! -d "$WORKTREE_PATH" ]; then
    echo "❌ ERROR: Failed to create worktree for story $STORY_ID"
    echo "❌ Worktree workflow is MANDATORY. Cannot proceed without it."
    echo ""
    echo "Troubleshooting:"
    echo "1. Check git repository is initialized"
    echo "2. Verify .worktrees directory is writable"
    echo "3. Check for existing worktrees with same name"
    echo "4. Review git worktree manager logs"
    exit 1
fi

echo "✅ Worktree created at: $WORKTREE_PATH"
echo "✅ Agent $ASSIGNED_AGENT ready to implement story $STORY_ID"
echo ""

# Save worktree path in task state (pseudo-code)
# echo "worktree_path: $WORKTREE_PATH" >> .agent-orchestration/tasks/$STORY_ID/state.yaml

# =============================================================================
# AGENT INVOCATION: MANDATORY Worktree Instructions
# =============================================================================

echo "=== Agent Invocation ==="

# This is the message that should be sent to the agent
cat << EOF

@agent-$ASSIGNED_AGENT, please implement story $STORY_ID.

Story file: docs/stories/$STORY_ID.md

🚨 CRITICAL: Git worktree workflow is MANDATORY - NO EXCEPTIONS 🚨

Git has been initialized and your isolated worktree has been created at: $WORKTREE_PATH

⚠️ YOU MUST work in the worktree - NEVER work directly in the main repository.
⚠️ The worktree workflow is REQUIRED for conflict prevention.
⚠️ There are NO exceptions to this requirement.

Follow these steps EXACTLY:
1. **Design Planning**: Create visual mockups in docs/stories/$STORY_ID/design/
2. **Reference Analysis**: Compare with professional applications (btop, etc.)
3. **Switch to worktree** (MANDATORY): cd $WORKTREE_PATH
4. **Verify you're in worktree**: pwd (should show .worktrees/agent-...)
5. **Design-First Implementation**: Implement visuals before functionality
6. **Progressive Validation**: Test visual appearance at each milestone
7. **Commit all changes** with design quality checkpoints
8. **Return to repo root**: cd ../../
9. **Design Quality Gate**: Verify professional appearance and accessibility
10. **Merge worktree**: ./.claude/agents/lib/git-worktree-manager.sh merge "$WORKTREE_PATH"
11. **Cleanup worktree**: ./.claude/agents/lib/git-worktree-manager.sh cleanup "$WORKTREE_PATH"

See .claude/agents/directives/git-worktree-workflow.md for complete enhanced workflow.

**Design Quality Requirements:**
- Visual design must match professional standards for the application type
- Web apps: Responsive design, browser compatibility, Core Web Vitals compliance
- Desktop apps: DPI scaling, native platform feel, smooth performance
- CLI apps: Terminal compatibility, color degradation, ASCII fallbacks
- All apps: WCAG 2.1 Level AA accessibility compliance
- Consistent design system usage across all components

**If you encounter ANY issues with the worktree workflow:**
- STOP immediately
- Report the error to the orchestrator
- Do NOT attempt to work without the worktree

When complete, update the story status to "Ready for Review" and add
a Dev Agent Record section documenting your implementation AND design decisions.

EOF

echo ""
echo "✅ Agent invocation message prepared"
echo "✅ Ready to launch agent $ASSIGNED_AGENT for story $STORY_ID"
echo ""

# =============================================================================
# SUMMARY
# =============================================================================

echo "=== Summary ==="
echo ""
echo "Git Workflow Checklist:"
echo "✅ Git initialization checked"
echo "✅ Git initialized (if needed)"
echo "✅ Worktree workflow enforced (MANDATORY)"
echo "✅ Pre-wave verification completed"
echo "✅ Worktree created for story"
echo "✅ Agent invocation message prepared"
echo ""
echo "The orchestrator is ready to proceed with story implementation."
echo ""
echo "REMEMBER:"
echo "- Git worktree workflow is MANDATORY for ALL story implementations"
echo "- There are NO exceptions to using git worktrees"
echo "- NEVER proceed with story implementation without worktrees"
echo "- NEVER work directly in the main repository"
echo "- STOP if git initialization fails"
echo "- STOP if worktree creation fails"
echo ""
