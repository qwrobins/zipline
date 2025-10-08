---
description: Automate the complete planning process from initial requirements through to epic and story creation
---

You are orchestrating the complete planning workflow from initial requirements through to epic and story creation. This command automates the entire planning process by calling the appropriate agents in sequence.

# Instructions

## Step 1: Gather Initial Requirements

### 1.1: Get Product Brief Input

**If a product brief path was provided as an argument**:
- Read the product brief file using the `view` tool
- Validate the file exists and contains requirements

**If no product brief path was provided**:
- Ask the user to provide either:
  - A file path to an existing product brief document, OR
  - A text description of the project/feature requirements
- Wait for user response before proceeding

### 1.2: Get Planning Preferences

Ask the user whether they need:
- **Architecture document** (yes/no)
- **Frontend design specification document** (yes/no)

**Example prompt**:
```
I have your product brief. To complete the planning process, I need to know:

1. Do you need an architecture document? (yes/no)
2. Do you need a frontend design specification document? (yes/no)

Please respond with your preferences.
```

Wait for user response before proceeding to Step 2.

## Step 2: Execute Planning Workflow (Sequential)

Once you have the product brief and user preferences, execute the following steps in sequence:

### 2.1: Generate PRD

**Use the same functionality as the `/create-prd` slash command**:

1. **Analyze Requirements** using `sequential_thinking` tool:
   - Product vision and goals
   - Target users and their needs
   - Key features and functionality
   - Technical constraints and assumptions
   - Success metrics and acceptance criteria

2. **Research Best Practices** using `context7` tools:
   ```
   resolve-library-id: "product requirements document best practices"
   get-library-docs: [Use the library ID from resolve-library-id]
   
   resolve-library-id: "[product domain] requirements"
   get-library-docs: [Use the library ID from resolve-library-id]
   
   resolve-library-id: "[technology stack] best practices"
   get-library-docs: [Use the library ID from resolve-library-id]
   ```

3. **Create PRD** using `save-file` tool:
   - Save to `docs/prd.md`
   - Include all 14 essential PRD sections
   - Base content on analysis and research

4. **Report PRD completion**:
   ```
   ✅ PRD Created: docs/prd.md
   - [X] epics created
   - [X] user stories created
   - Key features: [list]
   ```

### 2.2: Generate Architecture Document (Conditional)

**If user requested architecture document**:

Invoke the `software-architect` agent approach:

1. **Analyze PRD Requirements** using `sequential_thinking` tool:
   - Review functional and non-functional requirements
   - Identify technical constraints and assumptions
   - Determine scalability and performance needs
   - Understand integration requirements

2. **Research Technologies** using `context7` tools:
   ```
   resolve-library-id: "[framework name]"
   get-library-docs: [Use the library ID from resolve-library-id]
   
   resolve-library-id: "architecture patterns"
   get-library-docs: [Use the library ID from resolve-library-id]
   ```

3. **Create Architecture Document** using `save-file` tool:
   - Save to `docs/architecture.md`
   - Follow Phase 1 approach (1000-1500 lines maximum)
   - Include all 12 essential architecture sections

4. **Report Architecture completion**:
   ```
   ✅ Architecture Document Created: docs/architecture.md
   - Technology stack: [list]
   - Key patterns: [list]
   - Phase 2 expansions available on request
   ```

### 2.3: Generate Frontend Design Spec (Conditional)

**If user requested frontend design specification**:

Invoke the `frontend-design` agent approach:

1. **Analyze Design Requirements** using `sequential_thinking` tool:
   - Product vision and user experience goals
   - Target users and their design needs
   - Key features requiring UI/UX design
   - Brand personality and design principles

2. **Research Design Best Practices** using `context7` tools:
   ```
   resolve-library-id: "design system best practices"
   get-library-docs: [Use the library ID from resolve-library-id]
   
   resolve-library-id: "WCAG accessibility guidelines"
   get-library-docs: [Use the library ID from resolve-library-id]
   ```

3. **Create Design Specification** using `save-file` tool:
   - Save modular files to `docs/design/` directory:
     - `docs/design/README.md` (overview and navigation)
     - `docs/design/design-system.md` (tokens and foundations)
     - `docs/design/components.md` (component specifications)
     - `docs/design/implementation.md` (technical guidelines)

4. **Report Design Spec completion**:
   ```
   ✅ Frontend Design Specification Created: docs/design/
   - [X] components specified
   - Design principles: [list]
   - Accessibility: WCAG 2.1 AA compliant
   ```

### 2.4: Shard Documents

**Use the `planning-analyst` agent functionality**:

For each large document created (PRD, Architecture), if it's over 500 lines:

1. **Analyze Document Structure** using `sequential_thinking` tool:
   - Identify document type and structure
   - Verify level 2 headings for major sections
   - Plan output directory structure

2. **Use md-tree to explode documents**:
   ```bash
   # For PRD (if large)
   md-tree explode docs/prd.md docs/prd
   
   # For Architecture (if large)
   md-tree explode docs/architecture.md docs/architecture
   ```

3. **Verify sharding results**:
   - Check all sections were extracted correctly
   - Verify index.md files have proper links
   - Ensure no content was lost

4. **Report sharding completion**:
   ```
   ✅ Documents Sharded:
   - docs/prd/ directory created with [X] sections
   - docs/architecture/ directory created with [X] sections
   - Navigation indexes created
   ```

### 2.5: Create Epics and Stories

**Use the `scrum-master` agent functionality**:

1. **Analyze Planning Documents** using `sequential_thinking` tool:
   - Read PRD (sharded or monolithic)
   - Read Architecture document (if exists)
   - Read Design specification (if exists)
   - Identify all epics and stories from PRD

2. **Research Agile Best Practices** using `context7` tools:
   ```
   resolve-library-id: "agile user stories best practices"
   get-library-docs: [Use the library ID from resolve-library-id]
   
   resolve-library-id: "acceptance criteria patterns"
   get-library-docs: [Use the library ID from resolve-library-id]
   ```

3. **Create User Stories** using `save-file` tool:
   - Create `docs/stories/README.md` with overview
   - Create individual story files: `docs/stories/[epic].[story].[title].md`
   - **CRITICAL**: One file per story (not per epic)
   - Include all required sections per story template

4. **Report Stories completion**:
   ```
   ✅ User Stories Created: docs/stories/
   - [X] epics created
   - [X] individual story files created
   - Dependencies mapped
   - Ready for implementation
   ```

## Step 3: Final Summary

Provide a comprehensive summary of all generated documents:

```
🎉 Planning Process Complete!

📋 Generated Documents:
✅ PRD: docs/prd.md ([X] lines)
[✅/❌] Architecture: docs/architecture.md ([X] lines)
[✅/❌] Design Spec: docs/design/ ([X] files)
[✅/❌] Sharded PRD: docs/prd/ ([X] sections)
[✅/❌] Sharded Architecture: docs/architecture/ ([X] sections)
✅ User Stories: docs/stories/ ([X] stories across [X] epics)

🚀 Next Steps:
1. Review generated documents for accuracy
2. Run /implement-stories to begin development
3. Use /story-status to track progress

📁 All planning documents are organized in the docs/ directory
```

## Error Handling

**Missing product brief**:
```
Error: No product brief provided.

Please provide either:
1. A file path to an existing product brief document, OR
2. A text description of your project/feature requirements

Example: /automate-planning docs/product-brief.md
```

**File not found**:
```
Error: Product brief file not found at [path].

Please check the file path and try again, or provide the requirements as text.
```

**Agent failures**:
- If any step fails, report the specific error
- Provide guidance on manual completion
- Suggest running individual commands (e.g., /create-prd)

## Usage Examples

```bash
# With product brief file
/automate-planning docs/product-brief.md

# Without arguments (will prompt for input)
/automate-planning
```

This command is useful when:
- Starting a new project from scratch
- Want complete planning automation
- Need consistent document structure
- Working with multiple planning documents
- Want to ensure all planning steps are completed

# Critical Requirements

**YOU MUST**:
- ✅ Execute steps in the exact sequence specified
- ✅ Wait for user input before proceeding to Step 2
- ✅ Use the same quality standards as individual commands
- ✅ Preserve all existing functionality from referenced commands
- ✅ Handle conditional steps based on user preferences
- ✅ Provide clear progress updates throughout the process

**DO NOT**:
- ❌ Skip any required steps
- ❌ Proceed without user confirmation on preferences
- ❌ Create documents in wrong locations
- ❌ Combine multiple stories into single files
- ❌ Skip research and analysis phases

## Implementation Notes

### Workflow Orchestration
This command acts as a workflow orchestrator, calling the same functionality used by existing agents and commands:

- **PRD Generation**: Uses `/create-prd` command logic
- **Architecture**: Uses `software-architect` agent methodology
- **Design Spec**: Uses `frontend-design` agent methodology
- **Document Sharding**: Uses `planning-analyst` agent functionality
- **Story Creation**: Uses `scrum-master` agent functionality

### Conditional Execution
- Architecture and design steps only execute if user requests them
- Document sharding only occurs for large documents (>500 lines)
- All generated documents are saved to appropriate `docs/` subdirectories

### Quality Assurance
Each step includes the same quality checks as the individual commands:
- Required use of `sequential_thinking` for analysis
- Required use of `context7` for research
- Proper file locations and naming conventions
- Complete content generation (no partial implementations)

### Progress Tracking
The command provides clear progress updates:
- Step completion confirmations
- Document creation notifications
- Error handling with specific guidance
- Final comprehensive summary

### Integration with Existing Workflow
Generated documents integrate seamlessly with existing development workflow:
- Stories are ready for `/implement-stories` command
- Architecture supports development agent implementations
- Design specs provide developer handoff documentation
- All documents follow established conventions

## Command Arguments

**Syntax**: `/automate-planning [product-brief-path]`

**Arguments**:
- `product-brief-path` (optional): Path to existing product brief file

**Examples**:
```bash
# With product brief file
/automate-planning docs/product-brief.md

# Without arguments (interactive mode)
/automate-planning
```

## Expected Output Structure

After successful completion, the workspace will contain:

```
docs/
├── prd.md                          # Product Requirements Document
├── prd/                            # Sharded PRD (if large)
│   ├── index.md
│   ├── goals-and-background-context.md
│   ├── requirements.md
│   ├── epic-1-[name].md
│   └── epic-2-[name].md
├── architecture.md                 # Architecture Document (if requested)
├── architecture/                   # Sharded Architecture (if large)
│   ├── index.md
│   ├── high-level-architecture.md
│   ├── tech-stack.md
│   └── api-specification.md
├── design/                         # Design Specification (if requested)
│   ├── README.md
│   ├── design-system.md
│   ├── components.md
│   └── implementation.md
└── stories/                        # User Stories
    ├── README.md
    ├── 1.1.project-initialization.md
    ├── 1.2.shadcn-ui-setup.md
    ├── 2.1.user-directory.md
    └── [additional story files]
```

## Validation Checklist

Before completing, verify:
- [ ] Product brief was successfully read or provided
- [ ] User preferences were collected for architecture and design
- [ ] PRD was created with all required sections
- [ ] Architecture document created (if requested)
- [ ] Design specification created (if requested)
- [ ] Large documents were sharded appropriately
- [ ] User stories created with individual files per story
- [ ] All documents saved to correct locations
- [ ] Progress updates provided throughout process
- [ ] Final summary includes all generated documents

## Troubleshooting

**Common Issues**:

1. **md-tree command not found**:
   ```bash
   npm install -g @kayvan/markdown-tree-parser
   ```

2. **Large document token limits**:
   - Documents are automatically sharded if over 500 lines
   - Use Phase 1 approach for architecture documents

3. **Missing dependencies**:
   - Ensure all required tools are available
   - Check file permissions for document creation

4. **Incomplete story generation**:
   - Verify PRD contains all epics and stories
   - Check that scrum-master creates individual files per story

**Recovery Options**:
- Run individual commands if automation fails
- Use existing agents directly for specific steps
- Check generated documents for completeness
