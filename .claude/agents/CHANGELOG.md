# Agent Definitions Changelog

## Version 1.6.1 - 2025-09-30

### Critical Fix: scrum-master One File Per Story (Not One File Per Epic)

**Problem**: The scrum-master agent was creating one large file per epic containing ALL stories from that epic (e.g., `epic-1-foundation-posts-feed.md` with all 10 stories combined), instead of creating a separate individual file for each user story.

**Example of Incorrect Behavior**:
```
docs/stories/
├── README.md
├── epic-1-foundation-posts-feed.md  ← Contains all 10 stories ❌
├── epic-2-user-profiles.md          ← Contains all 5 stories ❌
└── epic-3-comments.md               ← Contains all 5 stories ❌

Total: 4 files (should be 26 files)
```

**Expected Correct Behavior**:
```
docs/stories/
├── README.md
├── 1.1.project-initialization.md     ← One file for Story 1.1 ✅
├── 1.2.shadcn-ui-setup.md           ← One file for Story 1.2 ✅
├── 1.3.api-client-setup.md          ← One file for Story 1.3 ✅
... (one file for each of the 10 stories in Epic 1)
├── 2.1.user-directory.md            ← One file for Story 2.1 ✅
... (one file for each of the 5 stories in Epic 2)
└── ... (25 total story files + README.md = 26 files)
```

**Root Cause**: The agent's instructions were not explicit enough that "one file per story" means literally one file for each individual story, not one file per epic.

**Reference**: The `examples/stories/` directory demonstrates the correct structure with 22 individual story files (e.g., `1.1.project-initialization.md`, `1.2.shadcn-ui-setup.md`, etc.), each containing exactly ONE user story.

#### Changes to scrum-master.md

**1. Added Explicit "One File Per Story" Instructions in Step 3**:
```markdown
**CRITICAL**: Each user story gets its OWN SEPARATE individual markdown file. Do NOT combine multiple stories into one file.

**You MUST**:
1. Review the PRD's Epic List section to identify all epics
2. For each epic, review all user stories listed in that epic
3. Create a **SEPARATE individual file** for **EVERY SINGLE user story** in the PRD
4. **ONE FILE = ONE STORY** (not one file per epic, not multiple stories per file)
5. Do NOT skip stories or create only a few examples
6. Do NOT combine multiple stories into one file
7. Do NOT create one file per epic containing all stories from that epic
8. Ensure the total number of story files matches the total number of stories in the PRD
```

**2. Added Visual Examples of Incorrect vs. Correct**:

**INCORRECT** ❌:
```
docs/stories/
├── README.md
├── epic-1-foundation-posts-feed.md  ← Contains all 10 stories ❌ WRONG!
├── epic-2-user-profiles.md          ← Contains all 5 stories ❌ WRONG!
└── epic-3-comments.md               ← Contains all 5 stories ❌ WRONG!
```

**CORRECT** ✅:
```
docs/stories/
├── README.md
├── 1.1.project-initialization.md     ← One file for Story 1.1 ✅
├── 1.2.shadcn-ui-setup.md           ← One file for Story 1.2 ✅
├── 1.3.api-client-setup.md          ← One file for Story 1.3 ✅
... (one file for each of the 10 stories in Epic 1)
├── 2.1.user-directory.md            ← One file for Story 2.1 ✅
├── 2.2.user-profile-basic.md        ← One file for Story 2.2 ✅
... (one file for each of the 5 stories in Epic 2)
└── ... (25 total story files)
```

**3. Updated Critical File Location Instructions**:
```markdown
**YOU MUST**:
...
4. **CRITICAL**: Create ONE SEPARATE FILE for EACH individual user story
...
7. **DO NOT** combine multiple stories into one file
8. **DO NOT** create one file per epic containing all stories from that epic
...
11. **ONE FILE = ONE STORY** (each file contains exactly one user story)
```

**4. Enhanced save-file Tool Usage Examples**:
```markdown
**CRITICAL**: You must call `save-file` once for EACH individual user story. If the PRD has 25 stories, you must make 25 separate `save-file` calls (plus one for README.md).

**Example for a PRD with 25 stories across 4 epics**:
```
save-file:
  path: docs/stories/README.md
  file_content: [README content]

save-file:
  path: docs/stories/1.1.project-initialization.md
  file_content: [Complete story 1.1 content - ONE story only]

save-file:
  path: docs/stories/1.2.shadcn-ui-setup.md
  file_content: [Complete story 1.2 content - ONE story only]

... (continue for ALL 25 stories)

Total: 26 save-file calls (25 stories + 1 README.md)
```

**DO NOT** put multiple stories in one file_content. Each save-file call creates ONE file for ONE story.
```

**5. Updated Common Pitfalls**:
- Added #1: "Combining Multiple Stories in One File" - DO NOT create `epic-1-foundation.md` with all 10 stories
- Added #2: "Creating One File Per Epic" - DO NOT create one file per epic - create one file per STORY

**6. Enhanced Validation Checklist**:

**Completeness Section**:
- [ ] **Each story has its OWN SEPARATE file** (not multiple stories combined in one file)
- [ ] **No files contain multiple stories** (each file = exactly one story)

**File Structure Section**:
- [ ] **NO files like `epic-1-foundation.md` containing multiple stories**
- [ ] **Each file contains exactly ONE user story** (not multiple stories)
- [ ] File count = (number of stories in PRD) + 1 (for README.md)

#### Expected Behavior After Fix

**For a PRD with 25 stories across 4 epics**:

**Before** (incorrect):
```
docs/stories/
├── README.md
├── epic-1-foundation-posts-feed.md  ← All 10 stories combined ❌
├── epic-2-user-profiles.md          ← All 5 stories combined ❌
├── epic-3-comments.md               ← All 5 stories combined ❌
└── epic-4-todos.md                  ← All 5 stories combined ❌

Total: 5 files (should be 26)
```

**After** (correct):
```
docs/stories/
├── README.md
├── 1.1.project-initialization.md
├── 1.2.shadcn-ui-setup.md
├── 1.3.api-client-setup.md
├── 1.4.navigation-setup.md
├── 1.5.posts-feed-list.md
├── 1.6.posts-feed-search.md
├── 1.7.posts-feed-pagination.md
├── 1.8.post-detail-view.md
├── 1.9.post-detail-navigation.md
├── 1.10.post-detail-error-handling.md
├── 2.1.user-directory.md
├── 2.2.user-profile-basic.md
├── 2.3.user-profile-posts.md
├── 2.4.user-profile-todos.md
├── 2.5.user-profile-address-map.md
├── 3.1.view-comments.md
├── 3.2.add-comment.md
├── 3.3.edit-comment.md
├── 3.4.delete-comment.md
├── 3.5.comment-optimistic-ui.md
├── 4.1.todo-toggle-completion.md
├── 4.2.todo-create.md
├── 4.3.todo-filter.md
├── 4.4.todo-global-view.md
└── 4.5.todo-reassignment.md

Total: 26 files (25 individual story files + README.md)
```

#### Key Principle

**ONE FILE = ONE STORY**

Each user story defined in the PRD must have its own dedicated markdown file. Do not combine multiple stories into one file, and do not create one file per epic.

#### Testing Recommendations

To verify the fix:
1. Run scrum-master agent on a PRD with 4 epics and 25 stories
2. **Verify file count**: Should create exactly 26 files (25 stories + README.md)
3. **Verify each file contains ONE story**: Open each file and confirm it has only one story
4. **Verify NO combined files**: Ensure no files like `epic-1-foundation.md` exist
5. **Verify flat structure**: All files in `docs/stories/`, no subdirectories
6. **Verify file names**: Follow `[epic].[story].[title].md` format

---

## Version 1.6 - 2025-09-30

### Critical Fix: scrum-master Flat Directory Structure and Complete Story Generation

**Problem 1 - Incorrect Directory Structure**: The scrum-master agent was creating subdirectories for each epic (e.g., `docs/stories/epic-1/`, `docs/stories/epic-2/`) instead of placing all stories in a flat `docs/stories/` directory.

**Problem 2 - Incomplete Story Generation**: The agent was only creating 2-3 example stories instead of generating individual story files for ALL stories defined in the PRD.

**Root Cause**: The agent's output format instructions were not explicit enough about:
1. Using a flat directory structure (no epic subdirectories)
2. Generating ALL stories from the PRD (not just examples)

**Solution**: Updated scrum-master agent with explicit, mandatory instructions.

#### Changes to scrum-master.md

**1. Added Critical File Location Instructions**:
```markdown
**YOU MUST**:
1. Create the `docs/` directory if it doesn't exist
2. Create the `docs/stories/` subdirectory if it doesn't exist
3. **CRITICAL**: Save ALL story files directly to `docs/stories/` in a FLAT structure
4. **DO NOT** create subdirectories like `docs/stories/epic-1/` or `docs/stories/epic-2/`
5. **DO NOT** organize stories into epic-based subdirectories
6. Use the file naming convention: `[epic].[story].[kebab-case-title].md`
7. The epic number is part of the FILENAME, not a directory structure
```

**2. Added Visual Examples**:

**CORRECT** ✅:
```
docs/stories/
├── README.md
├── 1.1.project-initialization.md
├── 1.2.shadcn-ui-setup.md
├── 1.3.api-client-setup.md
├── 2.1.user-directory.md
├── 2.2.user-profile-basic.md
└── ... (ALL stories in one flat directory)
```

**INCORRECT** ❌:
```
docs/stories/
├── epic-1/                    # ❌ DO NOT CREATE
│   ├── 1.1.project-initialization.md
│   └── 1.2.shadcn-ui-setup.md
└── epic-2/                    # ❌ DO NOT CREATE
    ├── 2.1.user-directory.md
    └── 2.2.user-profile-basic.md
```

**3. Added Completeness Requirements in Step 3**:
```markdown
**CRITICAL**: Generate user stories for **ALL** epics and **ALL** stories defined in the PRD.

**You MUST**:
1. Review the PRD's Epic List section to identify all epics
2. For each epic, review all user stories listed in that epic
3. Create a separate story file for EVERY user story in the PRD
4. Do NOT skip stories or create only a few examples
5. Ensure the total number of story files matches the total number of stories in the PRD

**Example**: If the PRD has:
- Epic 1 with 10 stories
- Epic 2 with 5 stories
- Epic 3 with 5 stories
- Epic 4 with 5 stories

You MUST create 25 individual story files (plus README.md = 26 files total).
```

**4. Updated Common Pitfalls**:
- Added #1: "Creating Epic Subdirectories" - DO NOT create subdirectories
- Added #2: "Incomplete Story Generation" - DO NOT create only examples

**5. Enhanced Validation Checklist**:

Added **Completeness** section:
- [ ] ALL epics from the PRD have stories created
- [ ] ALL user stories from each epic in the PRD have individual story files
- [ ] Total number of story files matches total number of stories in PRD
- [ ] No stories were skipped or omitted

Added **File Structure** section:
- [ ] ALL story files are in `docs/stories/` directory (FLAT structure)
- [ ] NO subdirectories like `docs/stories/epic-1/` were created
- [ ] File naming follows convention: `[epic].[story].[kebab-case-title].md`
- [ ] Epic number is part of filename, not directory structure

#### Expected Behavior After Fix

**For a PRD with 25 stories across 4 epics**:

**Before** (incorrect):
```
docs/stories/
├── epic-1/
│   ├── story-1.1-project-initialization.md
│   └── story-1.2-shadcn-ui-setup.md
└── epic-2/
    └── story-2.1-user-directory.md

Total: 3 files (incomplete, wrong structure)
```

**After** (correct):
```
docs/stories/
├── README.md
├── 1.1.project-initialization.md
├── 1.2.shadcn-ui-setup.md
├── 1.3.api-client-setup.md
├── 1.4.navigation-setup.md
├── 1.5.posts-feed-list.md
... (continues for all 25 stories)
└── 4.5.todo-reassignment.md

Total: 26 files (25 stories + README.md, flat structure)
```

#### Benefits

1. **Correct Structure**: Flat directory matches examples and orchestrator expectations
2. **Complete Coverage**: All stories from PRD are converted to individual files
3. **Easy Navigation**: All stories in one directory, sorted by epic.story number
4. **Orchestrator Compatible**: Flat structure is easier for orchestrator to scan
5. **Consistent Naming**: Epic number in filename makes organization clear

#### Testing Recommendations

To verify the fix:
1. Run scrum-master agent on a PRD with multiple epics (e.g., 4 epics, 25 stories)
2. Verify ALL 25 story files are created (not just 2-3 examples)
3. Verify all files are in `docs/stories/` (flat structure)
4. Verify NO subdirectories like `docs/stories/epic-1/` were created
5. Verify file names follow `[epic].[story].[title].md` format
6. Count files: should be (number of stories + 1 README.md)

---

## Version 1.5 - 2025-09-30

### Major Improvement: Use md-tree CLI Tool for Document Segmentation

**Problem**: The planning-analyst agent was manually parsing documents and creating files one by one using the `save-file` tool, which was slow, error-prone, and could hit token limits for large documents.

**Solution**: Updated planning-analyst to use the `md-tree explode` command from the `@kayvan/markdown-tree-parser` package, which automatically splits markdown documents based on heading levels.

#### Benefits of md-tree

1. **Faster**: Splits documents in seconds instead of minutes
2. **More Reliable**: Automated parsing eliminates manual errors
3. **Automatic Index**: Creates `index.md` with links automatically
4. **Content Preservation**: Guarantees 100% content preservation
5. **Consistent Naming**: Uses kebab-case file naming automatically
6. **No Token Limits**: Runs as a CLI command, not constrained by LLM output tokens

#### How md-tree Works

**Command**:
```bash
md-tree explode <input-file> <output-directory>
```

**What it does**:
1. Reads the input markdown file
2. Identifies all level 2 headings (`## Section Name`)
3. Extracts each section into a separate file (e.g., `section-name.md`)
4. Creates an `index.md` with a table of contents linking to all files
5. Preserves all formatting, code blocks, diagrams, and content

**Example**:
```bash
md-tree explode docs/prd.md docs/prd
```

This creates:
```
docs/prd/
├── index.md
├── goals-and-background-context.md
├── requirements.md
├── user-interface-design-goals.md
├── technical-assumptions.md
├── epic-1-foundation-posts-feed.md
└── ...
```

#### Changes to planning-analyst.md

**Updated Workflow**:
- **Step 1**: Analyze document structure (verify it uses level 2 headings)
- **Step 2**: Use `md-tree explode` command via `launch-process` tool
- **Step 3**: Verify and enhance the output if needed

**Removed**:
- Manual document parsing logic
- Multiple `save-file` tool calls
- Complex segmentation algorithms

**Added**:
- Instructions to use `launch-process` tool with `md-tree explode`
- Command syntax and examples
- Verification steps after md-tree completes
- Common issues and solutions section
- Troubleshooting for md-tree command not found

**Updated Tool Usage**:
- **Primary tool**: `launch-process` (to run md-tree command)
- **Secondary tools**: `view` (to verify output), `str-replace-editor` (for post-processing if needed)
- **Removed**: Heavy reliance on `save-file` for creating multiple files

#### Installation Requirement

The `@kayvan/markdown-tree-parser` package must be installed globally:
```bash
npm install -g @kayvan/markdown-tree-parser
```

This provides the `md-tree` CLI command.

#### Workflow Comparison

**Before (Manual)**:
1. Agent reads entire document
2. Agent parses sections manually
3. Agent creates files one by one with `save-file`
4. Agent creates index.md manually
5. Time: 2-5 minutes for large documents
6. Risk: Token limits, parsing errors, missing content

**After (md-tree)**:
1. Agent runs `md-tree explode docs/prd.md docs/prd`
2. md-tree automatically splits document
3. md-tree creates index.md with links
4. Agent verifies output
5. Time: 5-10 seconds
6. Risk: Minimal (automated tool)

#### Testing Recommendations

To verify the improvement:
1. Create a large PRD or architecture document (1000+ lines)
2. Run planning-analyst agent
3. Verify it uses `md-tree explode` command
4. Check that segmentation completes in seconds
5. Verify all files were created correctly
6. Verify index.md has proper links

---

## Version 1.4 - 2025-09-30

### Critical Fix: Two-Phase Architecture Generation to Avoid Token Limits

**Problem**: The software-architect agent was hitting Claude's 32,000 output token limit when generating comprehensive architecture documents, causing failures after writing only 61 lines.

**Root Cause**: The agent was attempting to generate a massive, comprehensive architecture document (17 sections with extensive detail) in a single output, which easily exceeded the 32K token limit.

**Solution**: Implemented a two-phase approach that generates architecture documents in manageable chunks.

#### Phase 1: Core Architecture Document (Always Generated First)

**Target**: 1000-1500 lines maximum (well within token limits)

**Includes 12 essential sections**:
1. Introduction (50-100 lines)
2. High Level Architecture (100-150 lines)
3. Tech Stack (100-150 lines)
4. Data Models - core entities only (150-200 lines)
5. API Specification - core endpoints only (150-200 lines)
6. Component Architecture (100-150 lines)
7. Project Structure (100-150 lines)
8. Development Workflow (100-150 lines)
9. Testing Strategy (50-100 lines)
10. Security Considerations (50-100 lines)
11. Performance Optimization (50-100 lines)
12. Deployment Architecture (50-100 lines)

**Content Guidelines**:
- Be concise - focus on essential information
- Use tables to summarize information
- Provide 2-3 examples per section (not exhaustive)
- Add notes: "See Phase 2 expansion for detailed specifications"
- Keep Mermaid diagrams simple
- Avoid excessive detail

**After Phase 1**: Agent informs user that core architecture is complete and offers Phase 2 expansions.

#### Phase 2: Detailed Expansions (Only If User Requests)

**Approach**: Generate detailed content for specific sections only when requested

**Expandable Sections**:
- Detailed data models for all entities
- Complete API specifications for all endpoints
- Detailed component specifications
- Core workflow diagrams (sequence diagrams)
- Comprehensive testing strategy
- Detailed coding standards
- Error handling patterns
- Monitoring and observability setup

**File Locations**:
- Phase 1: `docs/architecture.md` (core document)
- Phase 2: `docs/architecture/detailed-*.md` (individual expansion files)

**Example Phase 2 workflow**:
```
User: "Can you expand the API Specification section?"
Agent: Creates docs/architecture/detailed-api-spec.md with complete API docs

User: "Can you create detailed component specifications?"
Agent: Creates docs/architecture/detailed-components.md with all component specs
```

#### Changes to software-architect.md

**Updated Step 3: Design Architecture**:
- Added "Two-Phase Approach" with clear instructions
- Defined Phase 1 sections with target line counts
- Added content guidelines to keep Phase 1 concise
- Explained Phase 2 expansion approach
- Added examples of Phase 2 workflow

**Updated Quality Standards**:
- Added Phase 1 quality standards emphasizing conciseness
- Added critical requirement: "Keep Phase 1 document to 1000-1500 lines maximum"
- Added Phase 2 quality standards for expansions

**Updated Output Format**:
- Added "CRITICAL: Use the Two-Phase Approach to avoid token limits"
- Emphasized keeping document to 1000-1500 lines maximum
- Added file locations for Phase 2 expansions
- Added example save-file usage for both phases

**Updated Validation Checklist**:
- Added Phase 1 validation with critical check: "Document length is 1000-1500 lines maximum"
- Added Phase 2 validation for expansions
- Updated goal to emphasize staying within token limits

**Updated Common Pitfalls**:
- Added "Token Limit Exceeded" as #1 pitfall
- Added "Excessive Detail in Phase 1" pitfall
- Added "Too Many Examples" pitfall

#### Benefits

1. **Prevents Token Limit Errors**: Phase 1 stays well within 32K token limit
2. **Faster Initial Generation**: Core architecture generated quickly
3. **User Control**: User decides which sections need detailed expansion
4. **Flexible Detail Level**: Can expand only the sections that need more detail
5. **Better Organization**: Detailed expansions in separate files for easier navigation

#### Testing Recommendations

To verify the fix:
1. Run software-architect agent on a medium-sized PRD
2. Verify it generates `docs/architecture.md` successfully
3. Verify document is 1000-1500 lines (not 2000+)
4. Verify agent offers Phase 2 expansions
5. Request a Phase 2 expansion and verify it creates `docs/architecture/detailed-*.md`

---

## Version 1.3.1 - 2025-09-30

### Critical Fix: Enforce docs/ Directory Usage

**Problem**: Agents had documentation about the `docs/` directory convention but weren't explicitly instructed to create and use it. Testing revealed that product-manager saved to `prd.md` in the project root instead of `docs/prd.md`.

**Solution**: Added explicit, mandatory instructions to all planning agents.

#### Changes to All Planning Agents

**Added "Critical File Location Instructions" section** to each agent with:

1. **YOU MUST** create the `docs/` directory if it doesn't exist
2. **YOU MUST** save files to the correct `docs/` subdirectory (NOT to project root)
3. **YOU MUST** use the `save-file` tool with the correct path

**Added concrete examples** of save-file tool usage showing exact paths:
- `docs/prd.md`
- `docs/architecture.md`
- `docs/prd/index.md`, `docs/prd/requirements.md`
- `docs/architecture/index.md`, `docs/architecture/tech-stack.md`
- `docs/stories/README.md`, `docs/stories/1.1.project-initialization.md`

#### Files Updated

- ✅ **product-manager.md**: Added mandatory instructions to save to `docs/prd.md`
- ✅ **software-architect.md**: Added mandatory instructions to save to `docs/architecture.md`
- ✅ **planning-analyst.md**: Added mandatory instructions to save to `docs/prd/` or `docs/architecture/`
- ✅ **scrum-master.md**: Added mandatory instructions to save to `docs/stories/`

#### Why This Fix Was Needed

**Before**: Agents had informational text about the convention but no explicit instructions
```markdown
**Important**: All planning documents are saved to the `docs/` directory...
```

**After**: Agents have mandatory, actionable instructions
```markdown
**YOU MUST**:
1. Create the `docs/` directory if it doesn't exist
2. Save the PRD file to `docs/prd.md` (NOT to the project root)
3. Use the `save-file` tool with path: `docs/prd.md`
```

This ensures agents actually follow the convention instead of just documenting it.

---

## Version 1.3 - 2025-09-30

### Documentation Directory Convention

**Added to all planning agents**: Standardized output location for all planning documents.

#### Changes

**All planning documents now save to `docs/` directory**:
- **product-manager**: Outputs to `docs/prd.md`
- **software-architect**: Outputs to `docs/architecture.md`
- **planning-analyst**: Outputs to `docs/prd/` or `docs/architecture/`
- **scrum-master**: Outputs to `docs/stories/`

#### Directory Structure
```
docs/
├── prd.md                    # Product Requirements Document (monolithic)
├── prd/                      # Segmented PRD (optional)
│   ├── index.md
│   └── ...
├── architecture.md           # Architecture Document (monolithic)
├── architecture/             # Segmented architecture (optional)
│   ├── index.md
│   └── ...
└── stories/                  # User stories
    ├── README.md
    └── [story-files].md
```

#### Benefits

1. **Centralized Documentation**: All planning docs in one location
2. **Separation of Concerns**: Planning docs separate from source code
3. **Consistent Convention**: All agents follow the same pattern
4. **Easy Navigation**: Predictable location for all documentation
5. **Version Control**: Documentation changes tracked separately from code

#### Files Updated

- ✅ **product-manager.md**: Added `docs/prd.md` output location
- ✅ **software-architect.md**: Added `docs/architecture.md` output location
- ✅ **planning-analyst.md**: Added `docs/prd/` and `docs/architecture/` output locations
- ✅ **scrum-master.md**: Added `docs/stories/` output location
- ✅ **README.md**: Updated workflow diagrams and examples with `docs/` paths

---

## Version 1.2 - 2025-09-30

### Major Enhancement: Parallel Development Orchestration

**Added to scrum-master agent**: Critical features to enable parallel development by multiple agents working simultaneously.

#### 1. Story Dependencies Section
**Added**: Explicit Dependencies section in user story template
- Lists all prerequisite stories that must be completed before work can begin
- Uses story numbering format (e.g., "Story 1.4", "Story 2.1")
- Specifies required completion status for each dependency ("Ready for Review" or "Done")
- Placed after Story section and before Acceptance Criteria
- For stories with no dependencies: "None - This story can be started immediately"

**Example**:
```markdown
## Dependencies
- Story 1.4 (API Client Setup) - Must be in "Ready for Review" status
- Story 1.2 (shadcn/ui Setup) - Must be in "Done" status
```

#### 2. Updated Story Status Field
**Changed**: Status field now uses exactly four values:
- **Draft**: Story drafted but not approved for work yet (initial state)
- **Approved**: Story approved and ready for a development agent to claim
- **Ready for Review**: Implementation complete, code committed, ready for QA testing
- **Done**: QA has signed off and story is fully completed

**Removed**: Old status values (In Progress, Review, etc.)

#### 3. Story Sizing for Parallel Development
**Added**: Comprehensive guidance on story sizing for parallel execution:

**Parallelizable Stories** (most feature work):
- Target: 2-4 hours of work per story (ideal for parallel execution)
- Break down large features into independent units
- Examples: Separate CRUD operations, different pages/routes, UI vs. business logic

**Non-Parallelizable Stories** (foundation/setup):
- Keep atomic even if 1-2 days of work
- Examples: Project initialization, database setup, authentication scaffolding
- These establish patterns that other work depends on

**Added**: Story sizing decision tree to help determine when to split vs. keep atomic

#### 4. Orchestrator Integration
**Added**: Section explaining orchestrator agent integration:
- Orchestrator monitors story status changes
- Checks dependencies before assigning work
- Assigns approved stories to available development agents
- Only assigns when all dependencies have reached required status
- Runs multiple development agents in parallel on independent stories

#### 5. Enhanced Dependency Management
**Added**: Detailed dependency management guidance:
- How to identify technical, feature, data, and UI dependencies
- How to specify required status for each dependency
- How to minimize dependencies for maximum parallelism
- Dependency chain visualization
- Examples of good vs. bad dependency structures

#### 6. Output Format Updates
**Added**: Stories directory structure with README.md:
- Directory structure showing story file organization
- README.md template for stories directory explaining:
  - Story status workflow
  - Orchestrator workflow
  - Dependency rules
  - Parallel development examples
  - Implementation order guidance

#### 7. Updated Validation Checklists
**Added**: Orchestrator compatibility checklist:
- Status field uses exactly one of four allowed values
- Dependencies use correct story numbering format
- Required status specified for each dependency
- No circular dependencies
- Stories sized for parallel execution
- Foundation stories clearly marked

**Updated**: Main validation checklist with dependency requirements:
- Dependencies section is present and complete
- Dependencies specify required status
- Stories with no dependencies explicitly state "None"
- Stories sized for parallel execution (2-4 hours ideal)

#### 8. Complete Story Example Update
**Updated**: The 170+ line complete story example to include:
- Status field with all four values defined
- Dependencies section with rationale
- Updated to "Draft" status (initial state)

### Benefits of Parallel Development Features

1. **Faster Development**: Multiple agents can work simultaneously on independent stories
2. **Clear Dependencies**: Orchestrator knows exactly when stories can be assigned
3. **Optimal Sizing**: Stories sized for quick completion and minimal blocking
4. **Predictable Workflow**: Four-state status system is simple and unambiguous
5. **Maximum Parallelism**: Guidance on breaking down work to minimize dependencies

---

## Version 1.1 - 2025-09-30

### Critical Fix: Removed External File Dependencies

**Problem**: All four agent definitions contained references to files in the `examples/` directory that wouldn't exist when agents are used in other projects, making them non-portable.

**Solution**: Made all agents fully self-contained by embedding templates, examples, and best practices directly into their system prompts.

### Changes by Agent

#### product-manager.md
**Removed**:
- References to `examples/product-brief.md`
- References to `examples/prd.md`
- References to `examples/prd/` directory
- "Reference Examples" section pointing to external files

**Added**:
- Complete PRD template with document header format
- Inline examples for each section:
  - Goals and Background Context example
  - Requirements example (FR and NFR format)
  - User Interface Design Goals example
  - Technical Assumptions example
  - Epic List example
  - Detailed Epic Descriptions example
- Full document structure template in markdown

#### software-architect.md
**Removed**:
- References to `examples/architecture.md`
- References to `examples/architecture/` directory
- "Reference Examples" section pointing to external files

**Added**:
- Complete architecture document template with metadata table
- Inline examples for each section:
  - Tech stack table format with example entries
  - Data model format with TypeScript interfaces
  - API specification format with endpoint examples
  - Workflow format with Mermaid diagram example
  - Project structure example with directory tree
  - Testing strategy example with pyramid breakdown
  - Coding standards example with file naming conventions
- Complete 200+ line example architecture document excerpt showing:
  - Tech stack table with rationales
  - Data models (Post, User, Address, Company interfaces)
  - Core workflows with Mermaid sequence diagram
  - Complete unified project structure
- Full document structure template

#### planning-analyst.md
**Removed**:
- References to `examples/prd/` directory
- References to `examples/architecture/` directory
- "Reference Examples" section pointing to external files
- Instructions to "study" external example files

**Added**:
- Complete index.md template format
- Full PRD index example with table of contents
- Full Architecture index example with table of contents
- Concrete segmentation examples showing:
  - Before: monolithic document structure with line counts
  - After: segmented directory structure with file breakdown
- Example for PRD segmentation (1600 lines → 8 files)
- Example for Architecture segmentation (2250 lines → 9 files)
- Detailed file naming and organization patterns

#### scrum-master.md
**Removed**:
- References to `examples/stories/` directory
- References to `examples/prd/epic-list.md`
- "Reference Examples" section pointing to external files
- Instructions to "study" external example files

**Added**:
- Complete user story template (200+ lines)
- Full epic list example with descriptions
- Expanded file naming examples (12 examples instead of 4)
- Extended acceptance criteria examples:
  - Setup story example (8 criteria)
  - Feature story example (7 criteria)
- Complete 170+ line story example showing:
  - Full story structure from Status to QA Results
  - Detailed acceptance criteria (9 items)
  - Comprehensive task breakdown with subtasks
  - Dev Notes with multiple sections
  - Tech stack requirements with code blocks
  - Project structure with directory tree
  - Coding standards with examples
  - Testing requirements
  - Change log table
  - Placeholder sections for Dev Agent and QA

#### README.md
**Removed**:
- "Reference Examples" section listing external files
- Instructions to study `examples/` directory
- References to example file paths

**Added**:
- "Agent Self-Containment" section explaining:
  - Embedded templates in each agent
  - No external dependencies
  - Portability guarantees
- "Key Features" subsections for each agent highlighting embedded content
- Updated troubleshooting to reference embedded templates
- Updated best practices to reference agent templates instead of examples
- Updated support section to reference embedded examples

### Benefits of Changes

1. **Portability**: Agents can now be copied to any project and work immediately
2. **Self-Documentation**: All necessary information is in the agent definition
3. **No Setup Required**: No need to maintain separate example directories
4. **Consistency**: Templates are version-controlled with the agent definitions
5. **Clarity**: Users see exactly what format is expected without hunting for examples

### Validation

All agents have been updated to:
- ✅ Include complete templates inline
- ✅ Provide concrete examples in system prompts
- ✅ Remove all references to `examples/` directory
- ✅ Maintain all original functionality
- ✅ Preserve quality standards and best practices
- ✅ Include sufficient detail for implementation

### Migration Notes

**For existing users**: If you were relying on the `examples/` directory:
- All templates and examples are now embedded in agent definitions
- Review each agent's system prompt to see the embedded templates
- The quality and detail level remains the same or better
- No functionality has been removed, only relocated

**For new users**: 
- No setup required beyond copying agent definition files
- All necessary context is self-contained
- Agents work immediately in any project

---

## Version 1.0 - 2025-09-30

Initial release of four planning agents:
- product-manager
- software-architect
- planning-analyst
- scrum-master

(Original version had external dependencies on `examples/` directory)

