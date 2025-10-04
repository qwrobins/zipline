# Specialized Agents

This directory contains specialized Claude Code sub-agents for different phases of software development.

## Directory Structure

```
agents/
├── definitions/             # Agent definition files (load these in your IDE)
│   ├── javascript-developer.md
│   ├── planning-analyst.md
│   ├── product-manager.md
│   ├── scrum-master.md
│   └── software-architect.md
├── guides/                  # User guides and tutorials
│   ├── DEVELOPMENT_AGENTS.md
│   ├── JAVASCRIPT_DEVELOPER_GUIDE.md
│   ├── JAVASCRIPT_DEVELOPER_UPDATE.md
│   ├── PARALLEL_DEVELOPMENT.md
│   └── QUICK_START.md
├── conventions/             # Standards and conventions
│   └── DOCS_DIRECTORY_CONVENTION.md
├── CHANGELOG.md             # Change history
└── README.md                # This file
```

## Quick Links

- **[definitions/](./definitions/)** - Agent definition files (start here to use agents)
- **[guides/](./guides/)** - User guides and documentation
- **[conventions/](./conventions/)** - Standards and best practices
- **[CHANGELOG.md](./CHANGELOG.md)** - Version history and updates

## Agent Categories

### Planning Agents
Planning agents create documentation (PRDs, architecture documents, user stories) that guide the development process. They work in the `docs/` directory and produce markdown files.

**Available Planning Agents**:
- [product-manager](./definitions/product-manager.md)
- [software-architect](./definitions/software-architect.md)
- [planning-analyst](./definitions/planning-analyst.md)
- [scrum-master](./definitions/scrum-master.md)

**See**: Planning agents section below for details.

### Development Agents
Development agents write and maintain actual code. They implement features from user stories, fix bugs, refactor code, and ensure quality through testing.

**Available Development Agents**:
- [javascript-developer](./definitions/javascript-developer.md)

**See**: [guides/DEVELOPMENT_AGENTS.md](./guides/DEVELOPMENT_AGENTS.md) for comprehensive documentation.

## Planning Agent Overview

### 1. product-manager
**Purpose**: Transforms product briefs into comprehensive Product Requirements Documents (PRDs)

**Input**: Product brief, feature request, or high-level product concept
**Output**: Complete PRD with functional requirements, non-functional requirements, epics, and user stories

**When to Use**:
- Starting a new project with a product brief
- Documenting requirements for a new feature
- Formalizing vague product ideas into concrete requirements

**Key Features**:
- Numbered functional requirements (FR1, FR2, etc.)
- Numbered non-functional requirements (NFR1, NFR2, etc.)
- Epic breakdown with user stories
- Embedded examples and templates in agent definition

### 2. software-architect
**Purpose**: Creates comprehensive fullstack architecture documents from PRDs

**Input**: PRD or product requirements
**Output**: Complete architecture document covering system design, tech stack, data models, APIs, deployment, testing, and coding standards

**When to Use**:
- Designing system architecture for a new project
- Evaluating technology choices
- Documenting technical decisions and patterns

**Key Features**:
- Tech stack table with rationales
- Data models with TypeScript interfaces
- API specifications with examples
- Mermaid diagrams for architecture visualization
- Complete project structure definitions

### 3. planning-analyst
**Purpose**: Breaks down large planning documents into manageable, organized chunks

**Input**: Large PRD or architecture document
**Output**: Segmented directory structure with index and focused topic files

**When to Use**:
- Making large documents more navigable
- Organizing documentation for team accessibility
- Creating focused reference materials by topic

**Key Features**:
- Logical segmentation by topic/feature
- Master index with navigation links
- 100% content preservation (no summarization)
- Consistent file naming conventions

### 4. scrum-master
**Purpose**: Converts planning documents into actionable epics and user stories

**Input**: PRD and architecture documents
**Output**: Detailed user stories with acceptance criteria, tasks, and technical context

**When to Use**:
- Creating sprint backlogs from requirements
- Breaking down features into implementable stories
- Preparing work for development teams

**Key Features**:
- Proper Agile format ("As a...I want...so that...")
- Numbered acceptance criteria with task references
- Comprehensive Dev Notes with architecture citations
- Complete story template embedded in agent definition

## Documentation Directory Structure

All planning documents are saved to the `docs/` directory in the project root:

```
docs/
├── prd.md                    # Product Requirements Document (monolithic)
├── prd/                      # Segmented PRD (optional)
│   ├── index.md
│   ├── goals-and-background-context.md
│   ├── requirements.md
│   └── ...
├── architecture.md           # Architecture Document (monolithic)
├── architecture/             # Segmented architecture (optional)
│   ├── index.md
│   ├── high-level-architecture.md
│   ├── tech-stack.md
│   └── ...
└── stories/                  # User stories
    ├── README.md
    ├── 1.1.project-initialization.md
    ├── 1.2.shadcn-ui-setup.md
    └── ...
```

This keeps all planning and design documentation organized in a central location separate from source code.

## Development Agent Overview

### 1. javascript-developer
**Purpose**: Implements features and fixes bugs in JavaScript/TypeScript projects using Node.js, React, or Next.js

**Technology Stack**: JavaScript (ES6+), TypeScript, Node.js, React, Next.js, testing frameworks

**When to Use**:
- Implementing React components with TypeScript
- Creating Next.js pages, layouts, or API routes
- Building Node.js backend services
- Fixing bugs in JavaScript/TypeScript codebases
- Refactoring code for better performance
- Setting up testing infrastructure

**Key Features**:
- Modern JavaScript/TypeScript patterns
- React hooks and component best practices
- Next.js App Router and Pages Router expertise
- Type-safe development with TypeScript strict mode
- Performance optimization techniques
- Accessibility (WCAG) compliance
- Comprehensive testing strategies

**Documentation**: See [DEVELOPMENT_AGENTS.md](./DEVELOPMENT_AGENTS.md) for detailed usage guide.

### Future Development Agents
- **python-developer**: Python, Django, Flask, FastAPI development
- **devops-engineer**: Docker, Kubernetes, CI/CD, cloud platforms
- **database-specialist**: SQL, PostgreSQL, MongoDB, schema design
- **mobile-developer**: React Native, Swift, Kotlin development

## Typical Workflow

The agents are designed to work in sequence across planning and development phases:

```
Product Brief
     ↓
[product-manager] → docs/prd.md (monolithic)
     ↓
[planning-analyst] → docs/prd/ (segmented, optional)
     ↓
[software-architect] → docs/architecture.md (monolithic)
     ↓
[planning-analyst] → docs/architecture/ (segmented, optional)
     ↓
[scrum-master] → docs/stories/ (individual story files)
     ↓
[orchestrator] → Assigns stories to development agents
     ↓
[javascript-developer] → Implements features in code
     ↓
[QA/Testing] → Validates implementation
     ↓
Ready for Deployment
```

### Detailed Workflow Steps

1. **Start with Product Brief**
   - Create or obtain a product brief (see `examples/product-brief.md`)
   - Document high-level goals, scope, and constraints

2. **Generate PRD**
   ```
   Use: product-manager agent
   Input: Product brief
   Output: docs/prd.md (comprehensive PRD with requirements and epics)
   ```

3. **Segment PRD (Optional but Recommended)**
   ```
   Use: planning-analyst agent
   Input: docs/prd.md (monolithic PRD)
   Output: docs/prd/ directory with index and segmented files
   ```

4. **Design Architecture**
   ```
   Use: software-architect agent
   Input: docs/prd.md or docs/prd/ (PRD in either format)
   Output: docs/architecture.md (complete architecture document)
   ```

5. **Segment Architecture (Optional but Recommended)**
   ```
   Use: planning-analyst agent
   Input: docs/architecture.md (monolithic architecture)
   Output: docs/architecture/ directory with index and segmented files
   ```

6. **Create User Stories**
   ```
   Use: scrum-master agent
   Input: docs/prd/ + docs/architecture/ (or monolithic versions)
   Output: docs/stories/ directory with individual story files
   ```

7. **Implement Features**
   ```
   Use: javascript-developer agent (or other development agents)
   Input: User story from docs/stories/
   Output: Working code implementation with tests
   ```

## Using Agents

### Quick Start

1. **Load an agent** using the `/agents` command in your IDE:
   ```
   /agents product-manager
   ```

2. **Provide input** (e.g., paste your product brief or describe the task)

3. **Review output** and iterate as needed

For detailed usage instructions, see [guides/QUICK_START.md](./guides/QUICK_START.md).

### Invoking an Agent

In Claude Code, use the `/agents` command:

```
/agents product-manager
```

Then provide your input (e.g., paste your product brief).

### Agent Capabilities

**Planning agents** have access to:
- **sequential_thinking**: For complex multi-step reasoning and planning
- **context7**: For researching best practices, frameworks, and methodologies
- **codebase-retrieval**: For understanding existing code and patterns
- **view**: For examining reference examples

**Development agents** have access to:
- **codebase-retrieval**: Understanding existing code patterns
- **view**: Examining specific files and directories
- **str-replace-editor**: Editing existing files (primary tool)
- **save-file**: Creating new files
- **launch-process**: Running tests, builds, and other commands
- **context7**: Researching framework documentation
- **sequential_thinking**: Breaking down complex implementations

### Example Invocations

**Creating a PRD**:
```
/agents product-manager

I have a product brief for a task management app. Here's the brief:
[paste product brief content]
```

**Creating Architecture**:
```
/agents software-architect

I have a PRD ready. Please create the architecture document.
[paste PRD or provide path to PRD file]
```

**Segmenting Documents**:
```
/agents planning-analyst

Please break down this large PRD into organized sections.
[paste PRD or provide path to PRD file]
```

**Creating User Stories**:
```
/agents scrum-master

Create user stories from the PRD and architecture docs.
PRD location: docs/prd/ (or docs/prd.md)
Architecture location: docs/architecture/ (or docs/architecture.md)
Output location: docs/stories/
```

**Implementing Features**:
```
/agents javascript-developer

Please implement user story 1.2 from docs/stories/1.2.shadcn-ui-setup.md
```

**Fixing Bugs**:
```
/agents javascript-developer

Fix the infinite re-render issue in the UserProfile component. The useEffect hook is triggering too many times.
```

For more examples and detailed guides, see [guides/](./guides/).

## Agent Self-Containment

All planning agents are **fully self-contained** and portable:

### Embedded Templates
Each agent includes complete templates and examples directly in its system prompt:
- **product-manager**: Full PRD template with example requirements and epics
- **software-architect**: Complete architecture template with tech stack tables, data models, and diagrams
- **planning-analyst**: Index file templates and segmentation examples
- **scrum-master**: Complete user story template with all sections

### No External Dependencies
Agents do not rely on external reference files or example directories. All necessary:
- Document structures
- Format specifications
- Code examples
- Best practices

...are embedded directly in each agent's definition file.

### Portability
You can copy these agent files to any project and they will work immediately without requiring:
- Example directories
- Reference documentation
- External templates
- Configuration files

## Quality Standards

All planning agents follow these quality principles:

### Completeness
- All required sections are present
- No ambiguous or vague content
- Comprehensive coverage of the topic

### Clarity
- Clear, unambiguous language
- Well-organized structure
- Proper use of examples and diagrams

### Traceability
- Requirements map to goals
- Architecture maps to requirements
- Stories map to requirements and architecture

### Implementability
- Sufficient detail for implementation
- Clear technical specifications
- Concrete examples and patterns

## Agent Configuration

Each agent is defined in a markdown file with:
- **YAML frontmatter**: name, description, model
- **System prompt**: Detailed instructions and guidelines
- **Examples**: When to invoke the agent
- **Reference materials**: Links to example files

## Customization

To customize an agent:
1. Edit the agent's `.md` file
2. Modify the system prompt section
3. Update examples if needed
4. Test with sample inputs

## Troubleshooting

### Agent Not Found
- Ensure you're using the correct agent name
- Check that the agent file exists in `agents/` directory

### Poor Quality Output
- Review the embedded templates in the agent definition
- Ensure input is sufficiently detailed
- Check that you're providing the right type of input
- Use sequential_thinking for complex planning tasks

### Missing Context
- All necessary context is embedded in agent definitions
- Review the agent's system prompt for templates and examples
- Use context7 to research domain-specific best practices

## Best Practices

1. **Start with Good Input**: Quality output requires quality input
2. **Use Sequential Workflow**: Follow the recommended agent sequence
3. **Review Agent Templates**: Study the embedded templates in each agent's system prompt
4. **Leverage Tools**: Use sequential_thinking for complex planning and context7 for research
5. **Iterate if Needed**: Don't hesitate to refine and regenerate
6. **Preserve Context**: Keep PRD and architecture docs together for story creation
7. **Customize as Needed**: Edit agent definitions to match your team's specific needs

## Future Agents

### Planning Agents (Planned)
- **data-architect**: Specialized database and data model design
- **security-architect**: Security-focused architecture review
- **ux-designer**: User experience and interface design
- **technical-writer**: Documentation and API reference generation

### Development Agents (Planned)
- **python-developer**: Python, Django, Flask, FastAPI development
- **devops-engineer**: Docker, Kubernetes, CI/CD, cloud platforms
- **database-specialist**: SQL, PostgreSQL, MongoDB, schema design
- **mobile-developer**: React Native, Swift, Kotlin development

## Related Documentation

- **[DEVELOPMENT_AGENTS.md](./DEVELOPMENT_AGENTS.md)**: Comprehensive guide to development agents
- **[PARALLEL_DEVELOPMENT.md](./PARALLEL_DEVELOPMENT.md)**: Guide to parallel development orchestration
- **[DOCS_DIRECTORY_CONVENTION.md](./DOCS_DIRECTORY_CONVENTION.md)**: Documentation organization standards

## Support

For issues or questions:
1. Review this README
2. For development agents, see [DEVELOPMENT_AGENTS.md](./DEVELOPMENT_AGENTS.md)
3. Review the agent's system prompt for detailed guidelines and embedded templates
4. Check the embedded examples within each agent definition
5. Consult Claude Code documentation for `/agents` command usage
6. Use context7 to research specific methodologies or best practices

---

**Version**: 2.0
**Last Updated**: 2025-10-01
**Maintained By**: AI Agent Development Team

