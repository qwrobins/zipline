# Development Agents

This document describes the specialized development agents designed for implementing features, fixing bugs, and writing code in specific technology stacks. These agents complement the planning agents by taking the output of the planning phase (PRDs, architecture documents, and user stories) and turning them into working code.

## Overview

Development agents are specialized AI assistants with deep expertise in specific programming languages, frameworks, and ecosystems. Unlike the planning agents that create documentation, development agents write, refactor, and debug actual code.

### Key Differences from Planning Agents

| Aspect | Planning Agents | Development Agents |
|--------|----------------|-------------------|
| **Purpose** | Create documentation (PRDs, architecture, stories) | Write and maintain code |
| **Output** | Markdown files in `docs/` directory | Source code files in project directories |
| **Expertise** | Product management, architecture, Agile | Programming languages, frameworks, tools |
| **When to Use** | Before implementation begins | During implementation phase |
| **Tools Used** | sequential_thinking, context7, save-file | codebase-retrieval, view, str-replace-editor |

## Available Development Agents

### 1. javascript-developer

**Purpose**: Implement features and fix bugs in JavaScript/TypeScript projects, especially those using Node.js, React, or Next.js.

**Technology Stack**:
- **Languages**: JavaScript (ES6+), TypeScript
- **Runtimes**: Node.js, Bun, Deno
- **Frontend**: React, Next.js (App Router & Pages Router)
- **State Management**: React Context, Zustand, Redux Toolkit, React Query
- **Styling**: Tailwind CSS, CSS Modules, styled-components
- **Testing**: Jest, Vitest, React Testing Library, Playwright
- **Tooling**: npm/yarn/pnpm, ESLint, Prettier, TypeScript compiler

**When to Use**:
- Implementing React components with TypeScript
- Creating Next.js pages, layouts, or API routes
- Building Node.js backend services or APIs
- Fixing bugs in JavaScript/TypeScript codebases
- Refactoring code for better performance or maintainability
- Setting up testing infrastructure
- Implementing state management solutions
- Optimizing React application performance

**Example Invocations**:
```
/agents javascript-developer

I need to create a reusable Button component in React with TypeScript that supports different variants (primary, secondary, outline) and sizes (sm, md, lg). It should be accessible and follow our design system.
```

```
/agents javascript-developer

Fix the infinite re-render issue in the UserProfile component. The useEffect hook is triggering too many times.
```

```
/agents javascript-developer

Implement a Next.js API route at /api/users that handles GET and POST requests with proper error handling and TypeScript types.
```

**Key Capabilities**:
- Modern JavaScript/TypeScript patterns (async/await, destructuring, optional chaining)
- React hooks and component patterns (useState, useEffect, custom hooks)
- Next.js features (Server Components, Client Components, API routes, data fetching)
- Type-safe development with TypeScript strict mode
- Performance optimization (memoization, code splitting, lazy loading)
- Accessibility best practices (WCAG compliance, semantic HTML, ARIA)
- Testing strategies (unit tests, component tests, integration tests)
- Error handling and validation (try-catch, error boundaries, Zod schemas)

## Future Development Agents

The development agent pattern is designed to be extensible. Planned additions include:

### 2. python-developer (Planned)
**Focus**: Python, Django, Flask, FastAPI, data science libraries
**Use Cases**: Backend APIs, data processing, ML model integration, scripting

### 3. devops-engineer (Planned)
**Focus**: Docker, Kubernetes, CI/CD, cloud platforms (AWS, GCP, Azure)
**Use Cases**: Infrastructure setup, deployment pipelines, monitoring, scaling

### 4. database-specialist (Planned)
**Focus**: SQL, PostgreSQL, MongoDB, Redis, database design
**Use Cases**: Schema design, query optimization, migrations, data modeling

### 5. mobile-developer (Planned)
**Focus**: React Native, Swift, Kotlin, mobile-specific patterns
**Use Cases**: Mobile app development, native integrations, mobile UI/UX

## Workflow Integration

Development agents fit into the overall development workflow after the planning phase:

```
Product Brief
     ↓
[product-manager] → docs/prd.md
     ↓
[software-architect] → docs/architecture.md
     ↓
[scrum-master] → docs/stories/*.md
     ↓
[orchestrator] → Assigns stories to development agents
     ↓
[javascript-developer] → Implements features in code
     ↓
[QA/Testing] → Validates implementation
     ↓
Ready for Deployment
```

### Typical Development Workflow

1. **Planning Phase Complete**: PRD, architecture, and user stories are ready
2. **Story Assignment**: Orchestrator assigns an "Approved" story to a development agent
3. **Implementation**: Development agent reads the story and implements the feature
4. **Testing**: Agent writes tests and suggests running them
5. **Review**: Code is reviewed (can be manual or by another agent)
6. **Story Update**: Story status is updated to "Ready for Review" or "Done"

## Using Development Agents

### Invoking a Development Agent

In Claude Code, use the `/agents` command:

```
/agents javascript-developer
```

Then provide your implementation request, which can include:
- A user story from `docs/stories/`
- A specific bug to fix
- A feature to implement
- Code to refactor
- A technical question

### Best Practices

1. **Provide Context**: Reference the relevant user story, architecture section, or existing code
2. **Be Specific**: Clearly describe what needs to be implemented or fixed
3. **Include Requirements**: Mention any specific requirements (accessibility, performance, etc.)
4. **Reference Existing Patterns**: Point to similar implementations in the codebase
5. **Request Tests**: Ask the agent to include tests or suggest testing approaches

### Example Workflow with User Stories

**Step 1: Read the User Story**
```
/agents javascript-developer

Please implement user story 1.2 from docs/stories/1.2.shadcn-ui-setup.md
```

**Step 2: Agent Implements**
The agent will:
- Read the user story and acceptance criteria
- Review the architecture document for technical details
- Examine existing code patterns
- Implement the feature following best practices
- Write or suggest tests

**Step 3: Verify Implementation**
```
Run the suggested tests to verify the implementation works correctly.
```

**Step 4: Update Story Status**
Update the story file to mark it as "Ready for Review" or "Done"

## Agent Capabilities

All development agents have access to:

### Code Understanding Tools
- **codebase-retrieval**: Understand existing code patterns and architecture
- **view**: Examine specific files and directories
- **git-commit-retrieval**: Learn from past changes and patterns

### Code Modification Tools
- **str-replace-editor**: Edit existing files (primary tool for code changes)
- **save-file**: Create new files
- **remove-files**: Delete files when necessary

### Research Tools
- **context7**: Research framework documentation and best practices
- **web-search**: Find solutions to specific problems
- **web-fetch**: Read documentation from the web

### Execution Tools
- **launch-process**: Run commands (tests, builds, linters)
- **read-process**: Check command output
- **diagnostics**: Get IDE errors and warnings

### Planning Tools
- **sequential_thinking**: Break down complex implementations
- **add_tasks**: Create implementation subtasks if needed

## Quality Standards

All development agents follow these quality standards:

### Code Quality
- Follow existing code style and conventions
- Use meaningful names for variables, functions, and components
- Keep functions small and focused (single responsibility principle)
- Add comments for complex logic
- Remove unused code and imports

### Type Safety (for typed languages)
- Use strict type checking
- Avoid `any` types or equivalents
- Define clear interfaces and types
- Use generics for reusable code

### Testing
- Write unit tests for business logic
- Write component/integration tests for UI
- Test error scenarios and edge cases
- Suggest running tests after implementation

### Performance
- Avoid premature optimization
- Use appropriate data structures and algorithms
- Implement lazy loading and code splitting where beneficial
- Memoize expensive computations

### Accessibility
- Use semantic HTML
- Add proper ARIA labels
- Ensure keyboard navigation
- Follow WCAG guidelines

### Security
- Validate and sanitize user input
- Use parameterized queries for databases
- Implement proper authentication and authorization
- Follow security best practices for the framework

## Creating New Development Agents

To create a new specialized development agent, follow this pattern:

### 1. Create Agent File

Create a new markdown file in `agents/` directory:
```
agents/[technology]-developer.md
```

### 2. Define Agent Metadata

Use YAML frontmatter with three required fields:
```yaml
---
name: technology-developer
description: Use this agent when... [include examples]
model: sonnet
---
```

### 3. Write System Prompt

The system prompt should include:
- **Core Expertise**: Languages, frameworks, tools the agent knows
- **Core Responsibilities**: What the agent does (implement, fix, refactor, etc.)
- **Development Workflow**: Step-by-step process the agent follows
- **Best Practices**: Code examples and patterns for the technology
- **Common Patterns**: Solutions to frequent problems
- **Quality Standards**: Code quality, testing, performance criteria
- **Tool Usage Guidelines**: How to use available tools effectively

### 4. Include Code Examples

Embed comprehensive code examples directly in the system prompt:
- Modern syntax and patterns
- Common use cases
- Error handling
- Testing approaches
- Performance optimization

### 5. Test the Agent

Test with various scenarios:
- Simple feature implementation
- Bug fixing
- Code refactoring
- Complex multi-file changes
- Edge cases and error handling

## Troubleshooting

### Agent Not Following Existing Patterns
- Ensure the agent uses `codebase-retrieval` to understand existing code
- Provide explicit references to similar implementations
- Update the agent's system prompt with project-specific patterns

### Agent Making Too Many Changes
- Be more specific in your request
- Reference the exact file or component to modify
- Ask the agent to explain the plan before implementing

### Agent Not Using TypeScript Properly
- Remind the agent to check `tsconfig.json` settings
- Reference existing type definitions in the codebase
- Ask for strict type checking

### Tests Not Passing
- Ask the agent to run the tests and read the output
- Provide the test failure messages to the agent
- Request the agent to fix the issues iteratively

## Support

For issues or questions:
1. Review this documentation
2. Check the specific agent's system prompt for detailed guidelines
3. Review example invocations in the agent's description
4. Consult the planning agents documentation for upstream context
5. Use context7 to research specific technologies or patterns

---

**Version**: 1.0  
**Last Updated**: 2025-10-01  
**Maintained By**: AI Agent Development Team

