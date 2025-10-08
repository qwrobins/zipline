# Scrum Master Agent - Flat Directory Structure Fix

## Issue

The scrum master agent was creating subdirectories for epics and placing stories in those subdirectories, instead of creating all stories in a flat `docs/stories/` directory structure.

**Incorrect Behavior:**
```
docs/
└── stories/
    ├── epic-1/                            ❌ WRONG
    │   ├── 1.1.project-initialization.md
    │   └── 1.2.shadcn-ui-setup.md
    └── epic-2/                            ❌ WRONG
        ├── 2.1.user-directory.md
        └── 2.2.user-profile-basic.md
```

**Correct Behavior:**
```
docs/
└── stories/
    ├── README.md
    ├── 1.1.project-initialization.md     ✅ CORRECT
    ├── 1.2.shadcn-ui-setup.md           ✅ CORRECT
    ├── 2.1.user-directory.md            ✅ CORRECT
    └── 2.2.user-profile-basic.md        ✅ CORRECT
```

## Root Cause

While the scrum master agent definition (`agents/definitions/scrum-master.md`) already contained clear instructions about using a flat directory structure, the instructions may not have been prominent enough or explicit enough to prevent the agent from creating subdirectories.

## Solution

Enhanced the scrum master agent definition with:

### 1. Prominent Warning at Workflow Start

Added a highly visible warning at the beginning of the workflow section:

```markdown
🚨 CRITICAL FILE STRUCTURE REQUIREMENT 🚨

BEFORE YOU START - READ THIS:

All user story files MUST be saved to `docs/stories/` in a FLAT structure:
- ✅ CORRECT: `docs/stories/1.1.project-initialization.md`
- ✅ CORRECT: `docs/stories/2.1.user-directory.md`
- ❌ WRONG: `docs/stories/epic-1/1.1.project-initialization.md`
- ❌ WRONG: `docs/stories/epic-2/2.1.user-directory.md`

NO SUBDIRECTORIES UNDER `docs/stories/` - EVER!

The epic number is part of the FILENAME, not a directory structure.
```

### 2. Strengthened Critical File Location Instructions

Updated the "Critical File Location Instructions" section with:

- Changed header to: **⚠️ ABSOLUTE REQUIREMENT - NO EXCEPTIONS ⚠️**
- Added "ABSOLUTELY FORBIDDEN" language for prohibited actions
- Added explicit examples of correct vs. wrong paths when calling save-file tool
- Added requirement #13: **ALL FILES GO DIRECTLY IN `docs/stories/`** - NO SUBDIRECTORIES EVER

### 3. Enhanced save-file Tool Usage Examples

Added explicit path format requirements:

```markdown
⚠️ PATH REQUIREMENT - FLAT STRUCTURE ONLY ⚠️

EVERY save-file call MUST use this exact path format:
- `path: docs/stories/[epic].[story].[title].md`
- NO subdirectories allowed
- NO epic folders allowed
- ALL files go directly in docs/stories/
```

Added "WRONG PATHS - NEVER USE THESE" section with explicit examples of incorrect paths.

## Changes Made

### File Modified
- `agents/definitions/scrum-master.md`

### Specific Changes

1. **Line 35-55**: Added prominent warning at workflow start
2. **Line 465-489**: Strengthened critical file location instructions
3. **Line 541-607**: Enhanced save-file tool usage with explicit path requirements

## Verification

To verify the fix is working:

1. **Invoke the scrum master agent** to create user stories from a PRD
2. **Check the file paths** in the save-file tool calls
3. **Verify all paths** follow the format: `docs/stories/[epic].[story].[title].md`
4. **Confirm no subdirectories** are created under `docs/stories/`

## Expected Behavior After Fix

When the scrum master agent creates user stories:

1. ✅ All story files are saved directly to `docs/stories/`
2. ✅ No subdirectories like `epic-1/`, `epic-2/`, etc. are created
3. ✅ Epic number is part of the filename (e.g., `1.1`, `2.1`, `3.1`)
4. ✅ File naming follows: `[epic].[story].[kebab-case-title].md`
5. ✅ Directory structure is completely flat

## Example Correct Output

For a PRD with 4 epics and 25 total stories:

```
docs/
└── stories/
    ├── README.md
    ├── 1.1.project-initialization.md
    ├── 1.2.shadcn-ui-setup.md
    ├── 1.3.api-client-setup.md
    ├── 1.4.navigation-setup.md
    ├── 1.5.posts-feed-basic.md
    ├── 1.6.posts-feed-search.md
    ├── 1.7.posts-feed-filter.md
    ├── 1.8.posts-feed-pagination.md
    ├── 1.9.post-detail-view.md
    ├── 1.10.responsive-design.md
    ├── 2.1.user-directory.md
    ├── 2.2.user-profile-basic.md
    ├── 2.3.user-profile-posts.md
    ├── 2.4.user-profile-todos.md
    ├── 2.5.user-profile-address.md
    ├── 3.1.view-comments.md
    ├── 3.2.add-comment.md
    ├── 3.3.edit-comment.md
    ├── 3.4.delete-comment.md
    ├── 3.5.comment-validation.md
    ├── 4.1.todo-toggle-completion.md
    ├── 4.2.todo-filter.md
    ├── 4.3.todo-search.md
    ├── 4.4.todo-statistics.md
    └── 4.5.todo-bulk-actions.md
```

Total: 26 files (25 stories + 1 README.md), all in flat structure.

## Benefits of Flat Structure

1. **Easier Navigation**: All stories in one directory, easy to browse
2. **Simpler Orchestration**: Orchestrator can easily list all stories with `ls docs/stories/*.md`
3. **No Path Confusion**: No need to remember which epic a story belongs to
4. **Consistent Naming**: Epic number is always in the filename
5. **Better Tooling**: Easier to write scripts that process all stories
6. **Clearer Dependencies**: Story dependencies are explicit in the filename (e.g., 2.1 depends on 1.x)

## Additional Notes

The scrum master agent definition already had extensive documentation about the flat structure requirement. The enhancements made in this fix:

- Make the requirement more **prominent** (visible at workflow start)
- Use stronger **language** ("ABSOLUTELY FORBIDDEN", "NO EXCEPTIONS")
- Provide more **explicit examples** of correct vs. wrong paths
- Add **visual markers** (🚨, ✅, ❌) to draw attention

These changes should prevent the agent from creating subdirectories while maintaining all other functionality.
