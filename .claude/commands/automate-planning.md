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

Ask the user which documents they would like to generate:

```
Would you like to generate an architecture document or front end spec?

1. Generate an Architecture Document
2. Generate front end specification
3. Both
4. Neither

Enter your choice (1-4):
```

Wait for user response before proceeding to Step 2.

## Step 2: AI Framework Selection (Conditional)

**ONLY execute this step if AI features are detected in the product brief.**

### 2.1: Detect AI Requirements

**Scan for AI-related keywords:**
- See `.claude/agents/agent-guides/ai-framework-selection.md` for complete detection patterns
- Conversational AI, Content Generation, Code Analysis, NLP, AI-Powered Features, Model Integration

**Extract existing configuration from product brief:**
- Framework preferences (Claude Agent SDK, Mastra AI)
- Model specifications (claude-3-5-sonnet, gpt-4o, gemini-pro)
- Configuration settings (temperature, providers, fallbacks)

### 2.2: Determine Configuration Approach

**If complete AI configuration found in product brief:**
- Extract and validate configuration
- Skip interactive prompts
- Proceed to Step 2.5 (Validate and Store)

**If partial or no AI configuration found:**
- Proceed to Step 2.3 (Interactive Configuration)

### 2.3: Interactive AI Framework Configuration

**Only prompt for information not already specified in the product brief.**

#### Framework Selection

**If framework not specified, ask:**

```
🤖 AI Framework Selection

Choose your AI integration approach:

1. **Claude Agent SDK** (Simpler, single-provider)
   - Best for: Straightforward AI needs, new to AI development
   - Provider: Anthropic Claude only

2. **Mastra AI Framework** (Flexible, multi-provider)
   - Best for: High availability, cost optimization, multi-agent workflows
   - Providers: OpenAI, Anthropic, Google (with fallbacks)

Enter your choice (1-2, or 'help' for recommendations):
```

**If user requests help:**
- See `.claude/agents/agent-guides/ai-framework-selection.md` for recommendation criteria
- Provide tailored recommendation based on project needs

#### Provider and Model Selection

**For Claude Agent SDK:**
- Default to claude-3-5-sonnet-20241022
- Ask for temperature (default 0.7)
- Ask about custom tools (default No)

**For Mastra AI Framework:**
- Prompt for primary provider (OpenAI, Anthropic, Google)
- Show provider-specific model options (see guide for details)
- Ask about fallback provider (recommended for production)
- Ask about multi-agent workflows (optional)
- Ask about priority (cost, performance, reliability)

**All provider/model details:** See `.claude/agents/agent-guides/ai-framework-selection.md`

### 2.4: Validate and Store AI Configuration

**Validate configuration:**
- Framework choice is valid
- Model names are current and available
- Provider/model compatibility
- Configuration completeness

**Store configuration for use in subsequent planning steps.**

**Required AI Configuration Documentation:**

```markdown
## AI Integration

**Framework**: [Claude Agent SDK | Mastra AI Framework]
**Primary Model**: [model-name]
**Temperature**: [0.0-1.0]
**Fallback Provider**: [provider-name | None]
**Multi-Agent**: [Yes | No]
**Custom Tools**: [Yes | No]
```

## Step 3: Generate Architecture Document (Conditional)

**Execute if user selected option 1 or 3 in Step 1.2**

### 3.1: Invoke Architecture Agent

**Call the architecture agent:**
- Provide product brief content
- Include AI configuration (if applicable)
- Request architecture document generation

**Expected output:**
- `docs/architecture/architecture.md`
- System architecture overview
- Technology stack decisions
- Component architecture
- Data flow diagrams
- Deployment architecture
- AI integration architecture (if applicable)

### 3.2: Verify Architecture Document

**Validate output:**
- File exists at correct location
- Contains all required sections
- AI configuration properly documented (if applicable)
- No placeholder content

## Step 4: Generate Frontend Design Specification (Conditional)

**Execute if user selected option 2 or 3 in Step 1.2**

### 4.1: Invoke Frontend Design Agent

**Call the frontend-design agent:**
- Provide product brief content
- Request design specification generation

**Expected output:**
- `docs/design/frontend-design-spec.md`
- Design system (colors, typography, spacing)
- Component specifications
- User flows
- Accessibility requirements
- Responsive design guidelines

### 4.2: Verify Design Specification

**Validate output:**
- File exists at correct location
- Contains all required sections
- Design system fully defined
- Component specs complete

## Step 5: Generate Product Requirements Document

### 5.1: Invoke PRD Agent

**Call the PRD creation agent:**
- Provide product brief content
- Include architecture document (if generated)
- Include design specification (if generated)
- Include AI configuration (if applicable)

**Expected output:**
- `docs/requirements/prd.md`
- Product overview
- User personas
- Feature requirements
- Technical requirements
- Success metrics
- Timeline and milestones

### 5.2: Verify PRD

**Validate output:**
- File exists at correct location
- Contains all required sections
- References architecture and design docs (if applicable)
- AI requirements documented (if applicable)

## Step 6: Generate Epics and Stories

### 6.1: Invoke Scrum Master Agent

**Call the scrum-master agent:**
- Provide PRD content
- Provide architecture document (if generated)
- Provide design specification (if generated)
- Request epic and story generation

**Expected output:**
- `docs/stories/README.md` (Epic overview)
- `docs/stories/0.0.project-initialization.md` (if no codebase)
- `docs/stories/0.1.design-system-foundation-setup.md` (always)
- `docs/stories/[epic].[story].[title].md` (Feature stories)

### 6.2: Verify Stories

**Validate output:**
- README.md exists with epic overview
- Foundation stories generated correctly
- All feature stories have:
  - Clear acceptance criteria
  - Proper dependencies
  - Appropriate sizing
  - Design tokens (for UI stories)

## Step 7: Analyze Story Dependencies

**Build dependency graph and identify parallel execution opportunities**:

### 7.1: Scan Story Dependencies

1. **Scan all story files** in `docs/stories/`:
   - Read each story file
   - Extract story ID from filename
   - Extract dependencies from story content:
     - Look for "Dependencies:" section or field
     - Look for "**Dependencies**:" in story body
     - Parse dependency story IDs

2. **Use sequential_thinking** to build dependency graph:
   - Create adjacency list of story dependencies
   - Validate no circular dependencies exist
   - If circular dependencies found, report error and stop

### 7.2: Identify Parallel Execution Waves

1. **Identify Parallel Execution Waves**:
   - **Wave 0**: Stories with NO dependencies (can start immediately)
   - **Wave 1**: Stories that depend only on Wave 0 stories
   - **Wave 2**: Stories that depend only on Wave 0 or Wave 1 stories
   - Continue until all stories are assigned to waves
   - **CRITICAL**: All stories in the same wave can run in PARALLEL

2. **Perform topological sort** to determine implementation order:
   - Use context7 if uncertain about topological sort algorithm
   - Generate ordered list of stories
   - Prioritize grouping independent stories into waves

3. **Calculate Parallel Opportunities**:
   - For each wave, count how many stories can run simultaneously
   - Estimate time savings from parallel execution
   - Identify maximum parallel agents needed

### 7.3: Save Dependency Graph

**Save dependency graph** using `save-file` tool to `.agent-orchestration/dependency-graph.json`:

```json
{
  "scope": "all stories",
  "nodes": ["0.0", "0.1", "1.1", "1.2", ...],
  "edges": [
    {"from": "0.0", "to": "0.1"},
    {"from": "0.1", "to": "1.1"},
    ...
  ],
  "implementation_order": ["0.0", "0.1", "1.1", "1.2", ...],
  "parallel_waves": [
    {"wave": 0, "stories": ["0.0"], "can_run_parallel": false},
    {"wave": 1, "stories": ["0.1"], "can_run_parallel": false},
    {"wave": 2, "stories": ["1.1", "1.2", "1.3"], "can_run_parallel": true},
    ...
  ],
  "parallel_opportunities": [
    ["1.1", "1.2", "1.3"],
    ["2.1", "2.2"],
    ...
  ],
  "max_parallel_agents": 3,
  "estimated_time_savings": "40% faster with parallel execution"
}
```

### 7.4: Report Dependency Analysis

```
✅ Dependency Analysis Complete:
- Total stories: [X]
- Dependency edges: [Y]
- Parallel waves: [Z]
- Max parallel agents: [N]
- Estimated time savings: [P]% with parallel execution
- No circular dependencies detected ✓
```

## Step 8: Match Stories to Agents

**Determine appropriate development agent for each story**:

### 8.1: Scan Available Agents

1. **Scan available agents**:
   - List all files in `.claude/agents/` directory
   - Filter for agent definition files (*.md)
   - Read each agent's YAML frontmatter to understand capabilities

### 8.2: Match Stories to Agents

2. **For each story**, determine the appropriate development agent:
   - Read story file
   - Extract technology stack indicators:
     - JavaScript/TypeScript/React/Next.js/Node.js
     - Python/Django/Flask/FastAPI
     - Rust/Cargo
     - Database mentions (PostgreSQL, MongoDB, etc.)
   - Match to agent based on technology detection rules:
     - **JavaScript/TypeScript/React/Next.js** → `nextjs-developer` or `react-developer`
     - **Python/Django/Flask** → `python-developer`
     - **Rust** → `rust-developer`
     - **Backend/API** → Check for framework-specific agent first
     - **Default** → `typescript-developer`

### 8.3: Create Task State Files

3. **Create task state file** for each story using `save-file` tool:
   Save to: `.agent-orchestration/tasks/{story-id}-task.json`

   ```json
   {
     "story_id": "1.1",
     "story_file": "docs/stories/1.1.user-authentication.md",
     "agent": "nextjs-developer",
     "status": "pending",
     "dependencies": ["0.1"],
     "wave": 2,
     "can_run_parallel_with": ["1.2", "1.3"],
     "assigned_at": null,
     "started_at": null,
     "completed_at": null,
     "worktree_path": null,
     "branch_name": null
   }
   ```

## Step 9: Generate Implementation Roadmap

**Create human-readable implementation plan**:

### 9.1: Generate Roadmap Content

**Create roadmap.md** using `save-file` tool to `.agent-orchestration/roadmap.md`:

```markdown
# Story Implementation Roadmap

**Generated**: <timestamp>
**Scope**: All stories
**Total Stories**: X
**Parallel Execution**: Y stories can run simultaneously
**Estimated Time Savings**: Z% faster with parallel execution

## 🚀 Parallel Execution Strategy

**CRITICAL: The orchestrator will launch multiple agents simultaneously for independent stories.**

### Wave 0 (Foundation) - **1 agent (sequential)**
- [ ] Story 0.0: Project Initialization (@nextjs-developer)

**Action**: Launch agent. Wait for completion and code review before Wave 1.

### Wave 1 (Design System) - **1 agent (sequential)**
- [ ] Story 0.1: Design System Foundation Setup (@nextjs-developer) - Depends on: 0.0

**Action**: After Wave 0 completes, launch agent. Wait for completion and code review before Wave 2.

### Wave 2 (Core Features) - **3 agents in parallel**
- [ ] Story 1.1: User Authentication (@nextjs-developer) - Depends on: 0.1
- [ ] Story 1.2: User Profile (@nextjs-developer) - Depends on: 0.1
- [ ] Story 1.3: Dashboard (@nextjs-developer) - Depends on: 0.1

**Action**: After Wave 1 completes, launch ALL 3 agents simultaneously. Wait for ALL to complete and pass code review before Wave 3.

[Continue for all waves...]

## Dependency Graph

```
Wave 0:     0.0
             ↓
Wave 1:     0.1
             ↓
Wave 2:  1.1  1.2  1.3  (parallel)
          ↓    ↓    ↓
Wave 3:     2.1  2.2     (parallel)
```

## Implementation Order

1. Story 0.0 (Wave 0)
2. Story 0.1 (Wave 1)
3. Stories 1.1, 1.2, 1.3 (Wave 2 - parallel)
4. Stories 2.1, 2.2 (Wave 3 - parallel)
[...]

## Agent Assignments

- **nextjs-developer**: Stories 0.0, 0.1, 1.1, 1.2, 1.3, ...
- **python-developer**: Stories 2.1, 2.2, ...
- **rust-developer**: Stories 3.1, ...

## Parallel Execution Commands

### Wave 2 (Example)
```bash
# Launch all Wave 2 stories in parallel
/implement-stories --stories 1.1,1.2,1.3 --parallel
```

### Wave 3 (Example)
```bash
# Launch all Wave 3 stories in parallel
/implement-stories --stories 2.1,2.2 --parallel
```
```

## Step 10: Summary and Next Steps

### 10.1: Display Planning Summary

**Show user what was generated:**

```
✅ Planning Complete

Documents Generated:
  ✅ Architecture Document: docs/architecture/architecture.md
  ✅ Design Specification: docs/design/frontend-design-spec.md
  ✅ Product Requirements: docs/requirements/prd.md
  ✅ Epic Overview: docs/stories/README.md
  ✅ Stories: [count] stories in docs/stories/

Orchestration Files:
  ✅ Dependency Graph: .agent-orchestration/dependency-graph.json
  ✅ Implementation Roadmap: .agent-orchestration/roadmap.md
  ✅ Task State Files: .agent-orchestration/tasks/*.json

AI Configuration:
  Framework: [framework-name]
  Primary Model: [model-name]
  Temperature: [value]

Parallel Execution:
  Max Parallel Agents: [N]
  Parallel Waves: [Z]
  Estimated Time Savings: [P]%

Next Steps:
  1. Review generated documents
  2. Review implementation roadmap
  3. Run /implement-stories to begin parallel development
```

### 10.2: Suggest Next Actions

**Recommend next steps:**
- Review all generated documents
- Review dependency graph and roadmap
- Make any necessary adjustments
- Run `/story-status` to see story overview
- Run `/implement-stories` to begin parallel implementation
- Run `/next-story` to implement stories one at a time (sequential mode)

## Error Handling

### Missing Product Brief
- Prompt user for product brief
- Validate input before proceeding
- Provide clear error messages

### Agent Failures
- Capture error output
- Report which step failed
- Suggest manual intervention
- Provide recovery options

### Validation Failures
- Report missing or incomplete sections
- Suggest corrections
- Allow user to retry or proceed

## Best Practices

1. **Always validate inputs** before calling agents
2. **Check outputs** after each agent completes
3. **Provide clear progress updates** to user
4. **Handle errors gracefully** with recovery options
5. **Store AI configuration** for use across all planning documents
6. **Reference guide files** for detailed information instead of embedding verbose content

