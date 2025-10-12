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

### 2.1: Detect AI Requirements and Extract Configuration

**Step 2.1a: Scan for AI-related keywords and concepts:**

**Conversational AI patterns**:
- "chatbot", "AI assistant", "virtual assistant", "conversational interface"

**Content Generation patterns**:
- "content generation", "text generation", "writing assistant", "summarization"

**Code Analysis patterns**:
- "code analysis", "code review", "code generation", "AI-powered IDE"

**Natural Language Processing patterns**:
- "NLP", "natural language", "sentiment analysis", "text classification"

**AI-Powered Features patterns**:
- "AI-powered", "machine learning", "intelligent", "smart recommendations"

**Model Integration patterns**:
- "LLM", "language model", "GPT", "Claude", "AI model"

**Step 2.1b: Extract existing AI configuration from product brief:**

**Framework Detection patterns**:
- "Claude Agent SDK", "Anthropic Claude", "claude-agent-sdk"
- "Mastra", "Mastra AI", "multi-provider AI", "provider fallback"
- "OpenAI", "GPT-4", "gpt-4o", "ChatGPT"
- "Google Gemini", "Gemini Pro", "Google AI"

**Model Detection patterns**:
- "claude-3-5-sonnet", "claude-3-5-haiku", "claude-3-opus"
- "gpt-4o", "gpt-4o-mini", "gpt-4-turbo", "gpt-3.5-turbo"
- "gemini-pro", "gemini-pro-vision", "gemini-ultra"

**Configuration Detection patterns**:
- Temperature settings: "temperature 0.7", "temp=0.5"
- Provider preferences: "primary provider", "fallback to", "backup provider"
- Cost considerations: "cost optimization", "budget constraints", "cheaper models"
- Multi-agent: "different models for different tasks", "specialized agents"

**Examples of Complete Configuration in Product Brief:**

```
Example 1 (Claude Agent SDK):
"The application will use Claude Agent SDK with claude-3-5-sonnet-20241022
as the primary model at temperature 0.7. We need custom MCP tools for file
system access and code analysis."

Example 2 (Mastra Framework):
"We want to use Mastra AI Framework with OpenAI gpt-4o as primary provider
and Anthropic claude-3-5-haiku as fallback for cost optimization. The system
needs multi-agent workflows with different models for research vs writing tasks."

Example 3 (Partial Configuration):
"The app needs AI capabilities using OpenAI models for content generation."
→ Framework not specified, model not specific, temperature not mentioned
→ Prompt user for: Framework choice, specific model, temperature, fallback strategy
```

### 2.2: Determine Configuration Approach

**If AI requirements are detected**, determine the configuration approach:

**Option A: Configuration Already Specified in Product Brief**
- If framework, models, and configuration are already specified in the product brief
- Extract and validate the configuration
- Skip user prompts and proceed to Step 2.5 (Store AI Configuration)

**Option B: Partial Configuration in Product Brief**
- If some AI configuration is specified but incomplete
- Extract what's available
- Only prompt user for missing information

**Option C: No Configuration in Product Brief**
- If AI features are mentioned but no specific configuration provided
- Present full framework selection workflow to user

### 2.3: Present Framework Options (If Configuration Needed)

**If configuration is needed from user**, present this prompt:

```
🤖 AI Integration Detected

Your project needs AI capabilities. I'll help you choose the right framework:

**Option 1: Claude Agent SDK** (Recommended for most projects)
✅ **Pros:** Simple setup, excellent AI quality, great for teams new to AI
💰 **Cost:** Moderate (Anthropic Claude models)
📋 **Best for:** Most business applications, content generation, analysis tasks

**Option 2: Mastra AI Framework** (For advanced needs)
✅ **Pros:** Multiple AI providers, cost optimization, high availability
💰 **Cost:** Variable (can optimize across providers)
📋 **Best for:** Large-scale apps, cost-sensitive projects, complex AI workflows

**Quick Decision:**
- Choose **Option 1** if you want simplicity and excellent AI quality
- Choose **Option 2** if you need cost optimization or provider flexibility
- **Not sure?** Type "recommend" for a personalized suggestion

Enter your choice (1, 2, or "recommend"):
```

Wait for user response before proceeding.

### 2.4A: Claude Agent SDK Configuration (If Option 1 Selected)

**Only prompt for information not already specified in the product brief.**

**Model Selection (if not specified):**

```
📋 Claude Model Selection

Choose your Claude model (we recommend option 1 for most projects):

1. **Claude Sonnet** (RECOMMENDED) ⭐
   - Best overall performance for most tasks
   - Excellent at reasoning, coding, and analysis
   - Cost: ~$3 per 1M tokens

2. **Claude Haiku** (Budget-friendly)
   - Fast and cost-effective
   - Good for simple tasks and high-volume usage
   - Cost: ~$0.25 per 1M tokens

**For reference:** 1M tokens ≈ 750,000 words of text

Enter your choice (1-2, or press Enter for recommended):
```

**Additional Configuration (only ask if not specified in product brief):**

**Temperature Setting (if not specified):**
```
🎛️ AI Response Style (Optional)

How creative should the AI responses be?

1. **Focused** (Recommended) - Consistent, predictable responses
2. **Balanced** - Mix of consistency and creativity
3. **Creative** - More varied and creative responses

This is optional - press Enter to use the recommended setting.
Enter your choice (1-3, or press Enter for default):
```

**Custom Tools (if not specified):**
```
🔧 Custom Capabilities (Optional)

Do you need the AI to access external tools like:
- File systems or databases
- APIs or web services
- Custom business logic

Most projects don't need this initially.

Add custom tools? (y/N - press Enter for No):
```

### 2.4B: Mastra AI Framework Configuration (If Option 2 Selected)

**Only prompt for information not already specified in the product brief.**

**Provider Selection (if not specified):**

```
📋 Primary AI Provider Selection

Choose your main AI provider:

1. **OpenAI** (Most popular)
   - Strengths: Coding, general tasks, multimodal (text + images)
   - Cost: Moderate, good performance/price ratio

2. **Anthropic (Claude)** (Best reasoning)
   - Strengths: Complex reasoning, analysis, safety-focused
   - Cost: Moderate to high, excellent quality

3. **Google (Gemini)** (Most affordable)
   - Strengths: Fast responses, cost-effective, good for simple tasks
   - Cost: Low, great for high-volume usage

**Recommendation:** Choose OpenAI (1) for most business applications

Enter your choice (1-3, or press Enter for recommended):
```

**After primary provider selection, show provider-specific models:**

**If OpenAI selected:**
```
📋 OpenAI Model Selection

Choose your OpenAI model (we recommend option 1 for most projects):

1. **GPT-4o** (RECOMMENDED) ⭐
   - Best overall performance, handles text and images
   - Excellent for complex reasoning and coding
   - Cost: ~$2.50 per 1M tokens

2. **GPT-4o Mini** (Budget-friendly)
   - Fast and cost-effective
   - Good for most business tasks
   - Cost: ~$0.15 per 1M tokens

**For reference:** 1M tokens ≈ 750,000 words of text

Enter your choice (1-2, or press Enter for recommended):
```

**If Anthropic selected:**
```
📋 Anthropic Model Selection

Choose your Claude model (we recommend option 1 for most projects):

1. **Claude Sonnet** (RECOMMENDED) ⭐
   - Best overall performance for most tasks
   - Excellent at reasoning, coding, and analysis
   - Cost: ~$3 per 1M tokens

2. **Claude Haiku** (Budget-friendly)
   - Fast and cost-effective
   - Good for simple tasks and high-volume usage
   - Cost: ~$0.25 per 1M tokens

**For reference:** 1M tokens ≈ 750,000 words of text

Enter your choice (1-2, or press Enter for recommended):
```

**If Google selected:**
```
📋 Google Model Selection

Choose your Gemini model (we recommend option 1 for most projects):

1. **Gemini Pro** (RECOMMENDED) ⭐
   - Best overall performance for most tasks
   - Good balance of capability and cost
   - Cost: ~$0.50 per 1M tokens

2. **Gemini Pro Vision** (Multimodal)
   - Handles text and images
   - Good for visual analysis tasks
   - Cost: ~$0.50 per 1M tokens

**For reference:** 1M tokens ≈ 750,000 words of text

Enter your choice (1-2, or press Enter for recommended):
```

**Additional Configuration (only ask if not specified in product brief):**

**Fallback Provider (if not specified):**
```
🛡️ Backup Provider (Recommended for production)

If your primary AI provider has issues, should we automatically switch to a backup?

This prevents downtime but adds complexity.

Configure backup provider? (Y/n - press Enter for Yes):
```

**Multi-Agent Workflows (if not specified):**
```
🤖 Multi-Agent Setup (Optional)

Do you need different AI models for different tasks? For example:
- Research agent using one model
- Writing agent using another model
- Analysis agent using a third model

Most projects start simple with one model.

Set up multi-agent workflows? (y/N - press Enter for No):
```

**Priority Setting (if not specified):**
```
🎯 Project Priority (Optional)

What's most important for your project?

1. **Cost optimization** - Minimize AI expenses
2. **Performance** - Best possible AI quality
3. **Reliability** - Maximum uptime and availability

This helps optimize your configuration.

Enter your priority (1-3, or press Enter to skip):
```

### 2.4: Provide Recommendations (If User Is Unsure)

If the user responds with "I'm not sure" or "What do you recommend?", provide a recommendation based on these criteria:

**Recommend Claude Agent SDK when:**
- Project is relatively simple with straightforward AI needs
- Team is new to AI development and wants simpler setup
- Project specifically requires Anthropic/Claude features
- Single-provider approach is acceptable
- Budget allows for Claude pricing

**Recommend Mastra AI Framework when:**
- Project requires high availability and needs provider fallbacks
- Cost optimization is a priority (can switch to cheaper providers for simple tasks)
- Project needs multi-agent workflows with different models
- Team wants flexibility to switch providers in the future
- Project has complex AI orchestration requirements

**Example recommendation response:**
```
💡 Recommendation: [Framework Name]

Based on your project, I recommend **[Framework Name]** because:

✅ **Perfect fit:** [Primary reason based on project needs]
💰 **Cost-effective:** [Cost consideration]
⚡ **Easy to implement:** [Implementation benefit]

This choice will work well for your project and you can always adjust later as your needs evolve.

Proceed with this recommendation? (Y/n - press Enter for Yes):
```

### 2.5: Validate and Store AI Configuration

**Step 2.5a: Validate Configuration**

Validate the AI configuration (whether extracted from product brief or collected from user):

**Framework Validation:**
- Ensure framework choice is valid (Claude Agent SDK or Mastra AI Framework)
- Verify model names are current and available
- Check provider/model compatibility (e.g., don't use GPT models with Claude Agent SDK)

**Configuration Completeness:**
- Framework: Must be specified
- Primary model: Must be specified
- Temperature: Default to 0.7 if not specified
- Fallback provider: Optional but recommended for production
- Multi-agent setup: Optional, document if specified

**Step 2.5b: Store Configuration**

Store the validated AI framework configuration for use in subsequent planning steps. This will be included in architecture documents and PRDs.

**Required AI Configuration Documentation:**

```markdown
## AI Integration [Architecture/Requirements]

### Framework Selection
- **Framework**: [Claude Agent SDK / Mastra AI Framework]
- **Rationale**: [Brief explanation based on project needs]

### Model Configuration
- **Primary Provider**: [OpenAI / Anthropic / Google]
- **Primary Model**: [specific model name]
- **Temperature**: [0.0-1.0]
- **Fallback Provider** (if applicable): [provider name]
- **Fallback Model** (if applicable): [model name]

### Multi-Agent Configuration (if applicable)
[Document different agent roles and their assigned models]

### Cost Considerations
- **Estimated Monthly Cost**: [based on expected usage]
- **Cost Optimization Strategy**: [e.g., use cheaper models for simple tasks]

### Security Requirements
- API key management strategy
- Input validation and sanitization requirements
- Output filtering requirements
- Rate limiting configuration

### Testing Strategy
- Unit testing approach for AI tools
- Integration testing with mocked responses
- E2E testing budget and approach
- Evaluation metrics for AI quality

### References
- **Main Framework Guide**: `agents/directives/[claude-agent-sdk.md / mastra-ai-framework.md]`
- **Security Guidelines**: `agents/directives/[claude-agent-security.md / mastra-ai-security.md]`
- **Testing Patterns**: `agents/directives/[claude-agent-testing.md / mastra-ai-testing.md]`
```

**If no AI requirements detected**, skip this entire step and proceed directly to Step 3.

## Step 3: Execute Planning Workflow (Sequential)

Once you have the product brief, user preferences, and AI configuration (if applicable), execute the following steps in sequence:

### 2.1: Generate PRD

**Use the same functionality as the `/create-prd` slash command**:

1. **Analyze Requirements** using `sequential_thinking` tool:
   - Product vision and goals
   - Target users and their needs
   - Key features and functionality
   - Technical constraints and assumptions
   - Success metrics and acceptance criteria
   - **AI integration requirements** (if AI framework was selected)

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
   - Include all 15 essential PRD sections (including Implementation Phasing)
   - **Include AI Integration Requirements section** (if AI framework was selected)
   - Base content on analysis and research
   - **🚨 CRITICAL: Follow feature phasing rules from `.claude/agents/directives/prd-feature-phasing.md`**

4. **Validate Feature Phasing** (CRITICAL):
   - ✅ All user-facing features in Pre-Launch phase
   - ✅ Theme switching (light/dark mode) is Pre-Launch
   - ✅ Accessibility features are Pre-Launch
   - ✅ Responsive design is Pre-Launch
   - ✅ Only deployment/operations infrastructure is Post-Launch
   - ✅ No functionality gaps requiring rework

5. **Report PRD completion**:
   ```
   ✅ PRD Created: docs/prd.md
   - [X] epics created
   - [X] user stories created
   - Key features: [list]
   - ✅ Feature phasing validated (all user-facing features Pre-Launch)
   ```

### 2.2: Generate Architecture Document (Conditional)

**If user requested architecture document**:

Invoke the `software-architect` agent approach:

1. **Analyze PRD Requirements** using `sequential_thinking` tool:
   - Review functional and non-functional requirements
   - Identify technical constraints and assumptions
   - Determine scalability and performance needs
   - Understand integration requirements
   - **Review AI integration requirements** (if AI framework was selected)

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
   - **Include AI Integration Architecture section** (if AI framework was selected)

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

1. **Detect Project State** (CRITICAL - FIRST STEP):
   - Check for package.json, node_modules, next.config.ts, app/ directory
   - Determine if Story 0.0 (Project Initialization) is needed
   - Document decision in stories README.md

2. **Analyze Planning Documents** using `sequential_thinking` tool:
   - Read PRD (sharded or monolithic)
   - Read Architecture document (if exists)
   - Read Design specification (if exists)
   - Identify all epics and stories from PRD

3. **Research Agile Best Practices** using `context7` tools:
   ```
   resolve-library-id: "agile user stories best practices"
   get-library-docs: [Use the library ID from resolve-library-id]

   resolve-library-id: "acceptance criteria patterns"
   get-library-docs: [Use the library ID from resolve-library-id]
   ```

4. **Create Foundation Stories** using `save-file` tool:
   - **Story 0.0** (if needed): Project Initialization
   - **Story 0.1** (always): Design System Foundation Setup
     - Extract ALL CSS variables from design-system.md
     - Include exact HSL values in acceptance criteria
   - **Story 0.2+** (as needed): Other infrastructure

5. **Create Feature Stories** using `save-file` tool:
   - Create `docs/stories/README.md` with overview and project state detection
   - Create individual story files: `docs/stories/[epic].[story].[title].md`
   - **CRITICAL**: One file per story (not per epic)
   - Include all required sections per story template
   - Add foundation story dependencies to ALL feature stories
   - Use specific design tokens in acceptance criteria (not generic descriptions)

6. **Report Stories completion**:
   ```
   ✅ User Stories Created: docs/stories/
   - Story 0.0: [GENERATED/SKIPPED] - Project Initialization
   - Story 0.1: GENERATED - Design System Foundation Setup
   - [X] epics created
   - [X] individual story files created
   - Dependencies mapped (all feature stories depend on foundation stories)
   - Design tokens extracted into acceptance criteria
   - Ready for implementation
   ```

### 2.6: Initialize Orchestration Infrastructure

**Create the orchestration directory structure and state files**:

1. **Create orchestration directory structure** if it doesn't exist:
   ```bash
   mkdir -p .agent-orchestration/tasks
   ```

2. **Count total stories** by scanning `docs/stories/` directory:
   - Count all `.md` files except `README.md`
   - Extract story IDs from filenames

3. **Initialize progress.json** using `save-file` tool:
   ```json
   {
     "initialized_at": "<current timestamp>",
     "last_updated": "<current timestamp>",
     "scope": "all stories",
     "total_stories": <count>,
     "completed": 0,
     "in_progress": 0,
     "blocked": 0,
     "not_started": <count>
   }
   ```
   Save to: `.agent-orchestration/progress.json`

4. **Initialize worktree registry** using `save-file` tool:
   ```json
   {
     "active_worktrees": [],
     "last_updated": "<current timestamp>"
   }
   ```
   Save to: `.agent-orchestration/worktree-registry.json`

5. **Report infrastructure initialization**:
   ```
   ✅ Orchestration Infrastructure Initialized:
   - Directory: .agent-orchestration/
   - Progress tracking: progress.json
   - Worktree registry: worktree-registry.json
   - Total stories: [X]
   ```

### 2.7: Analyze Story Dependencies

**Build dependency graph and identify parallel execution opportunities**:

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

3. **Identify Parallel Execution Waves**:
   - **Wave 0**: Stories with NO dependencies (can start immediately)
   - **Wave 1**: Stories that depend only on Wave 0 stories
   - **Wave 2**: Stories that depend only on Wave 0 or Wave 1 stories
   - Continue until all stories are assigned to waves
   - **CRITICAL**: All stories in the same wave can run in PARALLEL

4. **Perform topological sort** to determine implementation order:
   - Use context7 if uncertain about topological sort algorithm
   - Generate ordered list of stories
   - Prioritize grouping independent stories into waves

5. **Calculate Parallel Opportunities**:
   - For each wave, count how many stories can run simultaneously
   - Estimate time savings from parallel execution
   - Identify maximum parallel agents needed

6. **Save dependency graph** using `save-file` tool to `.agent-orchestration/dependency-graph.json`:
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

7. **Report dependency analysis**:
   ```
   ✅ Dependency Analysis Complete:
   - Total stories: [X]
   - Dependency edges: [Y]
   - Parallel waves: [Z]
   - Max parallel agents: [N]
   - Estimated time savings: [P]% with parallel execution
   - No circular dependencies detected ✓
   ```

### 2.8: Match Stories to Agents

**Determine appropriate development agent for each story**:

1. **Scan available agents**:
   - List all files in `.claude/agents/` directory
   - Filter for agent definition files (*.md)
   - Read each agent's YAML frontmatter to understand capabilities

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

3. **Create task state file** for each story using `save-file` tool:
   Save to: `.agent-orchestration/tasks/{story-id}-task.json`
   ```json
   {
     "story_id": "1.1",
     "story_file": "docs/stories/1.1-user-authentication.md",
     "epic": "auth",
     "status": "not_started",
     "assigned_agent": "nextjs-developer",
     "dependencies": ["0.1"],
     "tech_stack": ["Next.js", "TypeScript", "React"],
     "started_at": null,
     "completed_at": null,
     "review_status": null,
     "review_file": null,
     "iteration_count": 0,
     "last_updated": "<timestamp>",
     "in_scope": true,
     "worktree_path": null
   }
   ```

4. **Report agent matching**:
   ```
   ✅ Agent Matching Complete:
   - Total stories: [X]
   - nextjs-developer: [N] stories
   - python-developer: [M] stories
   - rust-developer: [K] stories
   - Task state files created: .agent-orchestration/tasks/
   ```

### 2.9: Generate Implementation Roadmap

**Create human-readable implementation plan**:

1. **Generate roadmap content** using the dependency graph and task state files

2. **Create roadmap.md** using `save-file` tool to `.agent-orchestration/roadmap.md`:
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
   - [ ] Story 0.0: Project Initialization (@agent-nextjs-developer)

   **Action**: Launch agent. Wait for completion and code review before Wave 1.

   ### Wave 1 (Design System) - **1 agent (sequential)**
   - [ ] Story 0.1: Design System Foundation Setup (@agent-nextjs-developer) - Depends on: 0.0

   **Action**: After Wave 0 completes, launch agent. Wait for completion and code review before Wave 2.

   ### Wave 2 (Core Features) - **3 agents in parallel**
   - [ ] Story 1.1: User Authentication (@agent-nextjs-developer) - Depends on: 0.1
   - [ ] Story 1.2: User Profile (@agent-nextjs-developer) - Depends on: 0.1
   - [ ] Story 1.3: Dashboard (@agent-nextjs-developer) - Depends on: 0.1

   **Action**: After Wave 1 completes, launch ALL 3 agents simultaneously. Wait for ALL to complete and pass code review before Wave 3.

   [Continue for all waves...]

   ## Dependency Graph

   ```
   Wave 0:     0.0
                ↓
   Wave 1:     0.1
                ↓
   Wave 2:     1.1 ── 1.2 ── 1.3 (parallel)
                ↓      ↓      ↓
   Wave 3:     2.1 ── 2.2 (parallel)
   ```

   ## Parallel Execution Benefits

   - **Without Parallelism**: X stories × 4 hours = Y hours total
   - **With Parallelism**: Wave times sum = Z hours total
   - **Time Savings**: P% faster (Q hours saved)

   ## Notes
   - **🚀 DEFAULT: Stories in the same wave WILL be implemented in parallel automatically**
   - **⚠️ CRITICAL: Each story MUST pass code review before proceeding to the next wave**
   - Code reviews are MANDATORY and CANNOT be skipped under any circumstances
   - Parallel execution uses git worktrees to prevent conflicts
   ```

3. **Report roadmap generation**:
   ```
   ✅ Implementation Roadmap Generated:
   - File: .agent-orchestration/roadmap.md
   - Parallel waves: [X]
   - Max concurrent agents: [Y]
   - Ready for /implement-stories command
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

📊 Orchestration Infrastructure:
✅ Dependency Graph: .agent-orchestration/dependency-graph.json
✅ Progress Tracking: .agent-orchestration/progress.json
✅ Task State Files: .agent-orchestration/tasks/ ([X] files)
✅ Implementation Roadmap: .agent-orchestration/roadmap.md
✅ Worktree Registry: .agent-orchestration/worktree-registry.json

🚀 Parallel Execution Analysis:
- Total stories: [X]
- Parallel waves: [Y]
- Max concurrent agents: [Z]
- Estimated time savings: [P]% with parallel execution

🚀 Next Steps:
1. Review generated documents for accuracy
2. Review implementation roadmap: .agent-orchestration/roadmap.md
3. Run /implement-stories to begin development (all stories)
4. Or run /implement-stories [scope] to implement specific stories
5. Use /story-status to track progress

📁 All planning documents are organized in the docs/ directory
📁 All orchestration state is in the .agent-orchestration/ directory
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
    ├── 0.0-project-initialization.md
    ├── 0.1-design-system-foundation.md
    ├── 1.1-[feature-name].md
    └── [additional story files]

.agent-orchestration/
├── README.md                       # Orchestration system documentation
├── progress.json                   # Overall progress tracking
├── dependency-graph.json           # Story dependencies and parallel waves
├── roadmap.md                      # Human-readable implementation plan
├── worktree-registry.json          # Active worktree tracking
└── tasks/                          # Individual task state files
    ├── 0.0-task.json
    ├── 0.1-task.json
    ├── 1.1-task.json
    └── [additional task files]
```

## Validation Checklist

Before completing, verify:

**Planning Documents:**
- [ ] Product brief was successfully read or provided
- [ ] User preferences were collected for architecture and design
- [ ] PRD was created with all required sections
- [ ] Architecture document created (if requested)
- [ ] Design specification created (if requested)
- [ ] Large documents were sharded appropriately
- [ ] User stories created with individual files per story
- [ ] All documents saved to correct locations

**Orchestration Infrastructure:**
- [ ] .agent-orchestration/ directory created
- [ ] progress.json initialized with correct story counts
- [ ] worktree-registry.json created
- [ ] dependency-graph.json created with all stories
- [ ] No circular dependencies detected
- [ ] Parallel waves identified correctly
- [ ] Task state files created for all stories
- [ ] All stories matched to appropriate agents
- [ ] roadmap.md generated with parallel execution strategy

**Quality Checks:**
- [ ] Progress updates provided throughout process
- [ ] Final summary includes all generated documents
- [ ] Final summary includes orchestration infrastructure
- [ ] Ready for /implement-stories command

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
