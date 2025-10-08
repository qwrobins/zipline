# Enhanced Git Worktree Workflow with Design Integration

## ⚠️ MANDATORY: Multi-Agent Conflict Prevention + Design Quality ⚠️

**CRITICAL**: This enhanced workflow is **MANDATORY** for ALL development agents to prevent conflicts AND ensure professional-quality UI design.

**Failure to follow this workflow will result in:**
- Merge conflicts between agents
- Lost work and code overwrites
- **Poor visual design and user experience**
- **Unprofessional-looking applications**
- **Missing design consistency and polish**

## Overview

This enhanced workflow combines the technical benefits of git worktrees with **mandatory design quality gates** to ensure applications achieve professional visual standards comparable to tools like btop, modern TUIs, and polished applications.

**Key Benefits:**
- ✅ **Technical Isolation**: Each agent works in their own directory
- ✅ **No Conflicts**: Changes don't interfere until intentionally merged
- ✅ **Design Quality**: Mandatory visual design validation and review
- ✅ **Professional Polish**: Ensures applications meet visual standards
- ✅ **Consistent UX**: Enforces design system and style guidelines

## When to Use This Enhanced Workflow

**ALWAYS use this workflow when:**
- Implementing user stories from `docs/stories/`
- Making any code changes that affect UI/UX
- Working on visual components, themes, or styling
- Adding new features with user-facing elements
- Working as part of a multi-agent orchestration

## Enhanced Workflow Steps

### Phase 0: Design Planning (NEW - MANDATORY)

**Before ANY coding begins, you MUST complete design planning:**

#### Step 0.1: Create Visual Design Mockups

```bash
# Create design directory in your story
mkdir -p docs/stories/<story-id>/design/
```

**Requirements:**
1. **Create ASCII art mockups** of the intended UI
2. **Define color scheme** and visual hierarchy
3. **Specify visual behavior** (animations, transitions, feedback)
4. **Document accessibility requirements** (contrast ratios, screen reader support)

**Example mockup structure:**
```
docs/stories/1.1/design/
├── mockup.txt          # ASCII art layout
├── colors.md           # Color palette and usage
├── interactions.md     # User interaction design
└── accessibility.md    # Accessibility requirements
```

#### Step 0.2: Reference Analysis

**Compare against professional applications:**
1. **Analyze btop, htop, or similar tools** for visual inspiration
2. **Document specific visual elements** to emulate or improve upon
3. **Identify color schemes, layouts, and visual patterns** that work well
4. **Create comparison screenshots** or descriptions

#### Step 0.3: Design System Validation

**Ensure consistency with existing design system:**
1. **Review existing theme system** and color palettes
2. **Validate new designs** against established patterns
3. **Update design system** if new patterns are needed
4. **Document design decisions** and rationale

### Phase 1: Pre-Work Setup (ENHANCED)

#### Step 1.1: Verify Git Initialization

```bash
# Check if git is initialized
git rev-parse --git-dir
```

**If this fails:**
- ❌ **STOP immediately**
- 🚨 Report error to user: "Git repository not initialized. Please run 'git init' before proceeding."
- ⛔ **DO NOT proceed** with any file modifications

#### Step 1.2: Create Isolated Worktree

Use the git-worktree-manager script to create your isolated workspace:

```bash
# Create worktree for your story
./agents/lib/git-worktree-manager.sh create "<story-id>" "<your-agent-name>"

# Example:
./agents/lib/git-worktree-manager.sh create "1.1" "javascript-developer"
```

**The script will:**
- Generate a unique branch name: `agent-<agent-name>-<story-id>-<timestamp>`
- Create worktree directory: `.worktrees/agent-<agent-name>-<story-id>-<timestamp>/`
- Checkout a new branch in the worktree
- Register the worktree in the tracking registry
- Output the worktree path

**Save the worktree path** - you'll need it for cleanup later.

**Example output:**
```
[INFO] Creating worktree for story: 1.1, agent: javascript-developer
[INFO] Creating worktree at: .worktrees/agent-javascript-developer-1-1-20240107-120000
[SUCCESS] Worktree created successfully
.worktrees/agent-javascript-developer-1-1-20240107-120000
```

#### Step 1.3: Switch to Worktree Directory

**CRITICAL**: Change your working directory to the worktree:

```bash
cd .worktrees/agent-<agent-name>-<story-id>-<timestamp>
```

**Verify you're in the worktree:**
```bash
# Should show your worktree branch name
git branch --show-current

# Should show the worktree path
pwd
```

**⚠️ ALL SUBSEQUENT OPERATIONS MUST HAPPEN IN THIS DIRECTORY ⚠️**

#### Step 1.4: Set Up Design Testing Environment (NEW)

**Prepare visual validation tools:**
```bash
# Copy design mockups to worktree
cp -r docs/stories/<story-id>/design/ .worktrees/<worktree-name>/design/

# Set up terminal testing
export TERM=xterm-256color  # Ensure color support
export COLORTERM=truecolor  # Enable true color if available
```

### Phase 2: During Work (ENHANCED)

#### Step 2.1: Design-Driven Development

**Follow design-first approach:**
1. **Implement visual mockups first** before adding functionality
2. **Use design system colors and patterns** consistently
3. **Test visual appearance frequently** during development
4. **Compare with reference applications** regularly

#### Step 2.2: Progressive Visual Validation

**At each development milestone:**
```bash
# Test visual appearance
./your-app --theme=dark
./your-app --theme=light
./your-app --theme=high-contrast

# Compare with mockups
diff -u design/mockup.txt current-output.txt

# Test in different terminal sizes
resize -s 24 80 && ./your-app    # Minimum size
resize -s 40 120 && ./your-app   # Medium size
resize -s 60 160 && ./your-app   # Large size
```

#### Step 2.3: Design Quality Checkpoints

**Before each commit, verify:**
- [ ] **Visual hierarchy** is clear and logical
- [ ] **Color usage** follows design system
- [ ] **Spacing and alignment** are consistent
- [ ] **Typography** is readable and well-structured
- [ ] **Interactive elements** provide clear feedback
- [ ] **Accessibility** requirements are met

#### Step 2.4: Regular Design Review

**Self-review questions:**
1. Does this look as professional as btop or similar tools?
2. Is the visual hierarchy clear and intuitive?
3. Are colors used effectively to convey information?
4. Is the layout clean and well-organized?
5. Would a user find this visually appealing and easy to use?

#### Step 2.5: Work in Isolation

**While in the worktree directory:**

1. **Make all file modifications** using your normal tools:
   - `str-replace-editor` for editing files
   - `save-file` for creating new files
   - `launch-process` for running commands

2. **Commit changes regularly:**
   ```bash
   git add .
   git commit -m "Implement feature X for story 1.1"
   ```

3. **Run tests in the worktree:**
   ```bash
   npm test
   # or
   pnpm test
   # or
   pytest
   ```

4. **Update story status** in the worktree:
   - Edit `docs/stories/<story-id>.md`
   - Update status to "Ready for Review"
   - Add your Dev Agent Record

#### Step 2.6: Ensure All Changes Are Committed

**Before proceeding to merge, verify:**

```bash
# Should show "nothing to commit, working tree clean"
git status
```

**If there are uncommitted changes:**
```bash
git add .
git commit -m "Final changes for story <story-id>"
```

### Phase 3: Post-Work Integration (ENHANCED)

#### Step 3.1: Design Quality Gate (NEW - MANDATORY)

**Before merging, complete design validation using industry-standard tools:**

```bash
# Web Applications (React, Vue, Angular, etc.)
npm run test:design  # Runs Playwright + Lighthouse + axe-core

# Desktop Applications (Electron, Tauri, etc.)
npm run test:desktop  # Runs Spectron/platform-specific tests

# CLI Applications (Go, Rust, etc.)
# Create project-specific validation script for terminal testing
# Test color support, responsive layout, themes, accessibility
```

**Tool-Specific Validation Requirements:**
- **Web Apps**: Playwright visual tests, Lighthouse audit (≥90), axe-core accessibility
- **Desktop Apps**: Platform testing frameworks, DPI scaling, window management
- **CLI Apps**: Terminal compatibility, color degradation, ASCII fallbacks

**Design Review Checklist:**
- [ ] Visual design matches approved mockups
- [ ] Color scheme is consistent and effective
- [ ] Layout is clean and professional
- [ ] Typography is readable and well-structured
- [ ] Interactive elements are intuitive
- [ ] Accessibility requirements are met
- [ ] Cross-terminal compatibility verified
- [ ] Performance impact of visual elements is acceptable

#### Step 3.2: Design Documentation Update

**Update design system documentation:**
```bash
# Document new patterns or components
echo "New component: CPU meter with gradient colors" >> docs/design-system.md

# Update color palette if needed
./scripts/update-color-palette.sh

# Generate design system documentation
./scripts/generate-design-docs.sh
```

#### Step 3.3: Return to Repository Root

```bash
# Go back to the repository root
cd ../../
```

**Verify you're in the repo root:**
```bash
# Should show "main" or your base branch
git branch --show-current
```

#### Step 3.4: Merge Worktree Changes

Use the git-worktree-manager script to merge your changes:

```bash
./agents/lib/git-worktree-manager.sh merge "<worktree-path>"

# Example:
./agents/lib/git-worktree-manager.sh merge ".worktrees/agent-javascript-developer-1-1-20240107-120000"
```

**The script will:**
- Verify all changes are committed
- Switch to the main branch
- Merge your worktree branch with `--no-ff` (creates merge commit)
- Report success or failure

**If merge succeeds:**
- ✅ Your changes are now in the main branch
- ✅ Proceed to cleanup

**If merge fails (conflicts):**
- ❌ **STOP and report to user**
- 🚨 Error message: "Merge conflicts detected. Manual resolution required."
- 📋 Provide conflict details
- ⏸️ **DO NOT cleanup** - user needs to resolve conflicts first

#### Step 3.5: Cleanup Worktree

**After successful merge, cleanup the worktree:**

```bash
./agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"

# Example:
./agents/lib/git-worktree-manager.sh cleanup ".worktrees/agent-javascript-developer-1-1-20240107-120000"
```

**The script will:**
- Remove the worktree directory
- Delete the worktree branch
- Unregister from the tracking registry

**Verify cleanup:**
```bash
# Should not show your worktree anymore
git worktree list
```

## Error Handling

### Error: Git Not Initialized

**Symptom:** `git rev-parse --git-dir` fails

**Solution:**
1. ❌ **STOP immediately**
2. 🚨 Report to user: "Git repository not initialized"
3. 📋 Suggest: "Please run 'git init' in the project root"
4. ⛔ **DO NOT proceed** with any work

### Error: Worktree Creation Fails

**Symptom:** `git-worktree-manager.sh create` fails

**Possible causes:**
- Disk space full
- Permission issues
- Git repository corrupted

**Solution:**
1. ❌ **STOP immediately**
2. 🚨 Report error to user with full error message
3. 📋 Suggest checking disk space and permissions
4. ⛔ **DO NOT proceed** with any work

### Error: Merge Conflicts

**Symptom:** `git-worktree-manager.sh merge` reports conflicts

**Solution:**
1. ⏸️ **PAUSE work**
2. 🚨 Report to user: "Merge conflicts detected in the following files:"
3. 📋 List conflicting files
4. 💡 Suggest: "Please resolve conflicts manually, then run cleanup"
5. ⚠️ **DO NOT cleanup worktree** - user needs to resolve conflicts

### Error: Uncommitted Changes During Merge

**Symptom:** Merge fails due to uncommitted changes

**Solution:**
1. Return to worktree directory
2. Commit all changes:
   ```bash
   git add .
   git commit -m "Final changes"
   ```
3. Return to repo root and retry merge

## Best Practices

### DO:
- ✅ Always create a worktree before making changes
- ✅ Work exclusively in the worktree directory
- ✅ Commit changes regularly
- ✅ Run tests in the worktree before merging
- ✅ Cleanup worktrees after successful merge
- ✅ Report errors clearly to the user

### DON'T:
- ❌ Make changes in the main working directory
- ❌ Skip worktree creation "just this once"
- ❌ Leave uncommitted changes when merging
- ❌ Cleanup worktrees with merge conflicts
- ❌ Reuse worktree directories across stories
- ❌ Manually create worktrees (use the script)

## Troubleshooting

### List Active Worktrees

```bash
./agents/lib/git-worktree-manager.sh list
```

### Cleanup Abandoned Worktrees

If worktrees are left behind (older than 24 hours):

```bash
./agents/lib/git-worktree-manager.sh cleanup-abandoned
```

### Manual Cleanup (Emergency)

If the script fails, you can manually cleanup:

```bash
# Remove worktree
git worktree remove .worktrees/<worktree-name> --force

# Delete branch
git branch -D <branch-name>
```

## Design Quality Standards

### Visual Hierarchy Requirements
- **Clear section separation** with borders, spacing, or color
- **Consistent typography** with appropriate emphasis
- **Logical information grouping** and flow
- **Effective use of whitespace** for readability

### Color Usage Standards
- **Semantic color coding** (red=error, green=success, etc.)
- **Consistent color palette** across all components
- **Accessibility compliance** (WCAG 2.1 Level AA)
- **Graceful degradation** for limited color terminals

### Layout and Spacing
- **Consistent margins and padding** throughout the application
- **Proper alignment** of related elements
- **Responsive design** for different terminal sizes
- **Clean, uncluttered appearance** with breathing room

### Interactive Design
- **Clear visual feedback** for user actions
- **Intuitive navigation** and keyboard shortcuts
- **Consistent interaction patterns** across components
- **Helpful visual cues** for available actions

## Error Handling

### Design Quality Failures

**Symptom:** Visual design doesn't meet standards

**Solution:**
1. ⏸️ **PAUSE development**
2. 🎨 **Return to design phase**
3. 📋 **Revise mockups and specifications**
4. 🔄 **Restart implementation with better design**
5. ⚠️ **DO NOT merge** until design quality is achieved

### Accessibility Failures

**Symptom:** Contrast ratios or screen reader compatibility fails

**Solution:**
1. 🛑 **STOP immediately**
2. 🎨 **Revise color scheme** to meet WCAG standards
3. 📱 **Test with accessibility tools**
4. ✅ **Verify compliance** before proceeding

## Integration with Story Implementation

When implementing a story from `docs/stories/`:

1. **Read the story** in the main directory
2. **Create design mockups** (Phase 0)
3. **Create worktree** for the story
4. **Switch to worktree** directory
5. **Implement with design-first approach** in isolation
6. **Validate visual quality** at each checkpoint
7. **Update story status** in the worktree
8. **Commit all changes**
9. **Return to repo root**
10. **Complete design quality gate**
11. **Merge worktree** to main
12. **Cleanup worktree**
13. **Report completion** to user

## Best Practices

### DO:
- ✅ **Create detailed visual mockups** before coding
- ✅ **Compare with professional reference applications**
- ✅ **Test visual appearance frequently** during development
- ✅ **Follow design system** consistently
- ✅ **Validate accessibility** requirements
- ✅ **Document design decisions** and patterns

### DON'T:
- ❌ **Skip design planning** phase
- ❌ **Ignore visual quality** in favor of functionality
- ❌ **Use inconsistent colors** or styling
- ❌ **Merge without design validation**
- ❌ **Assume "functional" is sufficient**
- ❌ **Neglect accessibility** requirements

## Summary

**This enhanced workflow is MANDATORY for all development agents working on user-facing features.**

The key addition is **mandatory design quality gates** that ensure applications achieve professional visual standards, not just functional requirements.

**Quick Reference:**
```bash
# 0. Design planning (NEW)
mkdir -p docs/stories/<story-id>/design/
# Create mockups, define colors, document accessibility

# 1. Create worktree
./agents/lib/git-worktree-manager.sh create "<story-id>" "<agent-name>"

# 2. Switch to worktree
cd .worktrees/agent-<agent-name>-<story-id>-<timestamp>

# 3. Design-driven development
# Implement visuals first, test frequently, validate quality

# 4. Return to repo root
cd ../../

# 5. Design quality gate (NEW)
# Visual validation, accessibility testing, design review

# 6. Merge changes
./agents/lib/git-worktree-manager.sh merge "<worktree-path>"

# 7. Cleanup
./agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"
```

**Remember:** Users judge applications by their visual quality first. A poorly designed interface undermines all technical achievements.

