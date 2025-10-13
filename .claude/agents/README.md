# Agent Definitions

This directory contains the actual agent definition files. These are the core agent specifications that can be loaded and used in your development workflow.

## Quick Reference

| Agent | Category | Primary Use Case | Load Command |
|-------|----------|------------------|--------------|
| [product-manager.md](./product-manager.md) | Planning | Create PRDs from product briefs | `/agents product-manager` |
| [software-architect.md](./software-architect.md) | Planning | Design system architecture | `/agents software-architect` |
| [planning-analyst.md](./planning-analyst.md) | Planning | Break down large documents | `/agents planning-analyst` |
| [scrum-master.md](./scrum-master.md) | Planning | Create user stories | `/agents scrum-master` |
| [kubernetes-operator-developer.md](./kubernetes-operator-developer.md) | Development | Build K8s operators/controllers | `/agents kubernetes-operator-developer` |
| [golang-developer.md](./golang-developer.md) | Development | Go microservices & APIs | `/agents golang-developer` |
| [python-developer.md](./python-developer.md) | Development | Python web apps & automation | `/agents python-developer` |
| [rust-developer.md](./rust-developer.md) | Development | Rust systems programming | `/agents rust-developer` |
| [typescript-developer.md](./typescript-developer.md) | Development | TypeScript applications | `/agents typescript-developer` |
| [react-developer.md](./react-developer.md) | Development | React applications | `/agents react-developer` |
| [nextjs-developer.md](./nextjs-developer.md) | Development | Next.js applications | `/agents nextjs-developer` |
| [nestjs-developer.md](./nestjs-developer.md) | Development | NestJS backend services | `/agents nestjs-developer` |
| [vanilla-javascript-developer.md](./vanilla-javascript-developer.md) | Development | Vanilla JS applications | `/agents vanilla-javascript-developer` |
| [javascript-developer.md](./javascript-developer.md) | Development | General JavaScript/Node.js | `/agents javascript-developer` |
| [frontend-design.md](./frontend-design.md) | Design | Modern UI/UX design | `/agents frontend-design` |
| [v0-frontend-design.md](./v0-frontend-design.md) | Design | v0.dev integration | `/agents v0-frontend-design` |
| [code-reviewer.md](./code-reviewer.md) | Quality | Code review & feedback | `/agents code-reviewer` |
| [conflict-resolver.md](./conflict-resolver.md) | Quality | Resolve merge conflicts | `/agents conflict-resolver` |

## Available Agents

### Planning Agents

Planning agents transform product ideas into implementation-ready documentation. They work in the `docs/` directory and produce markdown files.

#### [product-manager.md](./product-manager.md)
**Purpose**: Transforms product briefs into comprehensive Product Requirements Documents (PRDs)

**Input**: Product brief, feature request, or high-level product concept  
**Output**: Complete PRD with functional requirements, non-functional requirements, epics, and user stories  
**Output Location**: `docs/prd.md`

**When to Use**:
- Starting a new project with a product brief
- Documenting requirements for a new feature
- Formalizing vague product ideas into concrete requirements

#### [software-architect.md](./software-architect.md)
**Purpose**: Creates comprehensive fullstack architecture documents from PRDs

**Input**: PRD or product requirements  
**Output**: Complete architecture document covering system design, tech stack, data models, APIs, deployment, testing, and coding standards  
**Output Location**: `docs/architecture.md`

**When to Use**:
- Designing system architecture for a new project
- Evaluating technology choices
- Documenting technical decisions and patterns

#### [planning-analyst.md](./planning-analyst.md)
**Purpose**: Breaks down large documents into organized, navigable directory structures

**Input**: Monolithic PRD or architecture document  
**Output**: Segmented directory with index and individual section files  
**Output Location**: `docs/prd/` or `docs/architecture/`

**When to Use**:
- After creating a large PRD or architecture document
- When documents exceed 500 lines
- To improve navigation and maintainability

#### [scrum-master.md](./scrum-master.md)
**Purpose**: Creates detailed user stories from PRD and architecture documents

**Input**: PRD and architecture documents  
**Output**: Individual user story files with acceptance criteria, tasks, and technical details  
**Output Location**: `docs/stories/`

**When to Use**:
- After PRD and architecture are complete
- To break down epics into implementable stories
- To create development-ready work items

### Development Agents

Development agents write and maintain actual code. They implement features from user stories, fix bugs, refactor code, and ensure quality through testing.

#### [kubernetes-operator-developer.md](./kubernetes-operator-developer.md)
**Purpose**: Builds production-grade Kubernetes operators and custom controllers

**Input**: Operator requirements, CRD specifications, reconciliation logic needs
**Output**: Custom controllers, CRDs, webhooks, RBAC, tests

**When to Use**:
- Building Kubernetes operators with Kubebuilder, Operator SDK, or controller-runtime
- Creating custom resource definitions (CRDs) and controllers
- Implementing admission webhooks (validating/mutating)
- Managing stateful applications on Kubernetes
- Developing operators in Go, Python (Kopf), or Rust (kube-rs)

**Key Capabilities**:
- Kubebuilder, Operator SDK, controller-runtime expertise
- CRD design with versioning and conversion webhooks
- Reconciliation loop patterns and finalizers
- envtest integration testing and E2E testing
- Production-ready RBAC, metrics, and observability

#### [javascript-developer.md](./javascript-developer.md)
**Purpose**: Implements features, fixes bugs, and writes tests for JavaScript/TypeScript projects

**Input**: User stories, bug reports, or feature requests
**Output**: Source code, tests, and documentation updates

**When to Use**:
- Implementing user stories from `docs/stories/`
- Fixing bugs in JavaScript/TypeScript code
- Adding tests to existing code
- Refactoring JavaScript/TypeScript components

**Key Capabilities**:
- React, Next.js, Node.js, TypeScript expertise
- React Query, Zod, shadcn/ui integration
- Comprehensive testing with Vitest/Jest
- Performance optimization and best practices

## Usage

### Loading an Agent

To use an agent in your workflow:

```bash
# In Claude Code or compatible IDE
/agents <agent-name>

# Examples:
/agents product-manager
/agents software-architect
/agents javascript-developer
```

### Agent Workflow

**Planning Phase**:
1. `product-manager` → Creates PRD from product brief
2. `software-architect` → Creates architecture from PRD
3. `planning-analyst` → Segments large documents (optional)
4. `scrum-master` → Creates user stories from PRD + architecture

**Development Phase**:
5. `javascript-developer` → Implements user stories

## Agent File Format

All agent definition files follow this structure:

```yaml
---
name: agent-name
description: Brief description of when to use this agent
model: sonnet
---

# Agent Name

[System prompt and instructions...]
```

## Related Documentation

- [../guides/](../guides/) - User guides and how-to documentation
- [../conventions/](../conventions/) - Standards and conventions
- [../README.md](../README.md) - Main agents overview
- [../../docs/](../../docs/) - Project documentation

## Adding New Agents

When creating a new agent definition:

1. Create a new `.md` file in this directory
2. Follow the standard agent file format (YAML frontmatter + system prompt)
3. Update this README with the new agent's information
4. Add usage examples to the guides directory
5. Test the agent thoroughly before committing

See [../guides/](../guides/) for detailed agent development guides.

