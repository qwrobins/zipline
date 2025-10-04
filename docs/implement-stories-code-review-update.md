# Implement-Stories Command Update: Mandatory Code Review Enforcement

**Date**: 2025-10-03
**Command Updated**: `.claude/commands/implement-stories.md`

## Summary

The `implement-stories` slash command has been updated to enforce **mandatory code reviews after every single story implementation**. This is a critical quality control measure that ensures no story can proceed to the next without passing a comprehensive code review.

## Key Changes

### 1. **Critical Requirement Section Added**

A new prominent section was added immediately after the existing critical requirements:

**⚠️ CRITICAL REQUIREMENT - Code Review After Every Story ⚠️**

This section establishes:
- Code review is MANDATORY for every story
- No exceptions under any circumstances
- Clear workflow enforcement steps
- Verification checklist before proceeding

### 2. **Workflow Enforcement Rules**

The command now enforces this strict workflow:

```
Story N implemented → STOP
  ↓
Trigger code review for Story N → WAIT for completion
  ↓
Address code review feedback for Story N
  ↓
Document code review results in Story N
  ↓
ONLY THEN proceed to Story N+1
```

### 3. **Updated Execution Loop (Phase 7)**

The execution loop has been completely restructured with:

**Step 4: MANDATORY CODE REVIEW - DO NOT SKIP**
- Explicit STOP checkpoint
- Immediate code review invocation (no exceptions)
- Verification checkpoints at each stage
- Clear instructions for code reviewer agent

**Step 5: Process Review Results**
- WAIT requirement (cannot proceed without review)
- Verification checkpoints
- Task state updates

**Step 6: Handle Review Outcome**
- **If Approved**: Document review, update story, ONLY THEN proceed
- **If Changes Requested**: Re-invoke dev agent, REPEAT review process, DO NOT proceed

### 4. **Critical Enforcement Rules**

Added explicit rules at the end of Phase 7:

❌ **NEVER skip code review** for any story
❌ **NEVER proceed to next story** without approved code review
❌ **NEVER mark story as done** without code review documentation
✅ **ALWAYS wait** for code review completion
✅ **ALWAYS address** code review feedback before proceeding
✅ **ALWAYS document** code review results in story file

### 5. **Enhanced Error Handling**

Added new error conditions:

- **Code Review Skipped**: IMMEDIATELY STOP workflow, require confirmation
- **Code Review Not Documented**: STOP workflow, require documentation
- **Proceeding Without Approval**: STOP workflow, require fixes and re-review
- **Review Never Completes**: Enhanced with "DO NOT proceed" warning

### 6. **Updated Roadmap Template**

The roadmap template now includes:

```markdown
## Code Review Enforcement
- ✅ Every story implementation triggers immediate code review
- ✅ No story can be marked "done" without approved code review
- ✅ Next story cannot start until current story's code review is approved
- ✅ Code review results must be documented in story's Dev Agent Record
```

### 7. **Enhanced Completion Reporting (Phase 8)**

The final report now includes:

**Code Review Compliance Section:**
- Total code reviews performed
- First-pass approvals
- Required revisions
- Average review cycles per story
- Code review coverage: 100% (MANDATORY)

**Verification Steps:**
- Confirm ALL stories have approved reviews
- Verify ALL review documentation exists
- Check ALL review files are saved
- STOP if any story lacks code review

### 8. **Prominent Warning at Document Start**

Added a critical warning section at the very beginning:

```markdown
## 🚨 CRITICAL: Mandatory Code Review Enforcement 🚨

EVERY story implementation MUST be followed by an immediate code review.

The workflow is:
1. Implement Story N
2. STOP → Trigger code review for Story N
3. WAIT → Wait for code review completion
4. FIX → Address any issues found
5. DOCUMENT → Add review results to story
6. ONLY THEN → Proceed to Story N+1

This is NON-NEGOTIABLE. No exceptions. No shortcuts.
```

## Code Review Trigger Format

The command now specifies the exact format for triggering code reviews:

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

## Verification Checkpoints

Multiple verification checkpoints were added throughout the workflow:

**After Code Review Invocation:**
- [ ] Code review agent invoked
- [ ] Waiting for code review completion
- [ ] DO NOT proceed to next story until review is complete

**After Review Processing:**
- [ ] Review file exists and was read
- [ ] Review status extracted
- [ ] Task state updated with review information

**After Approval:**
- [ ] Story marked as done
- [ ] Code review documented in story file
- [ ] Progress tracking updated
- [ ] Ready to proceed to next story

**During Revision Cycle:**
- [ ] Dev agent re-invoked with feedback
- [ ] Waiting for fixes to be completed
- [ ] Will trigger another code review after fixes
- [ ] NOT proceeding to next story until approved

## Benefits

1. **Consistent Quality**: Every story undergoes the same rigorous review process
2. **Early Issue Detection**: Problems are caught immediately, not accumulated
3. **Technical Debt Prevention**: Issues are addressed before moving forward
4. **Clear Accountability**: Review documentation provides audit trail
5. **Enforced Best Practices**: No shortcuts or skipped steps possible
6. **Better Code Quality**: Continuous review improves overall codebase quality

## Impact on Workflow

- **Slightly Slower**: Each story now requires review completion before proceeding
- **Much Higher Quality**: Issues caught and fixed immediately
- **Better Documentation**: Every story has review documentation
- **Reduced Rework**: Problems don't compound across multiple stories
- **Clearer Progress**: Review status clearly tracked in state files

## Files Modified

- `.claude/commands/implement-stories.md` - Complete update with mandatory code review enforcement

## Related Documentation

- Code review process: See `code-reviewer` agent definition
- Story format: See `docs/stories/` directory
- Orchestration system: See `docs/orchestration-system.md`

## Next Steps

When using `/implement-stories`, the command will now:

1. Automatically enforce code review after each story
2. Stop and wait for review completion
3. Require addressing all review feedback
4. Document review results before proceeding
5. Track code review metrics in final report

**No manual intervention needed** - the enforcement is built into the workflow.

