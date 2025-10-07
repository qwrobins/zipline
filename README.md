# Zipline: AI-Powered Development Workflow System

A comprehensive ecosystem for AI-driven software development, featuring specialized agents, automated orchestration, and production-ready workflows. This repository demonstrates how to build complex applications using AI agents that handle everything from requirements gathering to code implementation.

## 🎯 Project Overview

Zipline is a complete AI development workflow system that transforms product ideas into production-ready applications through a coordinated team of specialized AI agents. The system includes:

- **Specialized AI Agents** for planning, architecture, development, and code review
- **Git Worktree Multi-Agent Development** for conflict-free parallel work (NEW!)
- **Automated Story Orchestration** for managing complex development workflows
- **Production-Ready Agent Collection** (ACCA) with 100+ specialized agents
- **Slash Commands** for rapid workflow automation
- **Example Implementation** of a Mini Social Feed application

## 🏗️ Architecture

### Core Components

```
zipline/
├── agents/                    # Specialized AI agent definitions
│   ├── definitions/          # Agent specifications and prompts
│   ├── guides/              # Usage guides and tutorials
│   └── conventions/         # Development standards
├── acca/                     # Augment Claude Code Agents collection
│   └── categories/          # 100+ production-ready agents
├── .claude/commands/         # Slash commands for automation
├── docs/                     # Comprehensive documentation
├── examples/                 # Sample PRDs, architecture, and stories
└── .agent-orchestration/     # Runtime state management
```

### Agent Workflow

```
Product Brief → [product-manager] → PRD
     ↓
[software-architect] → Architecture Document  
     ↓
[scrum-master] → User Stories
     ↓
[orchestrator] → Automated Implementation
     ↓
[javascript-developer] → Code Implementation
     ↓
[code-reviewer] → Quality Assurance
     ↓
Production Ready Application
```

## 🚀 Quick Start

### Prerequisites

- Claude Code IDE with agent support
- Node.js 18+ (for example projects)
- pnpm package manager (recommended)
- Git 2.5+ (for worktree support)
- jq (for JSON processing)

### Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd zipline
   ```

2. **Explore available agents**
   ```bash
   # View all agent definitions
   ls agents/definitions/
   
   # Browse ACCA collection
   ls acca/categories/
   ```

3. **Use slash commands for rapid development**
   ```bash
   # Create a PRD from a product brief
   /create-prd docs/product-brief.md
   
   # Implement user stories automatically
   /implement-stories
   
   # Check progress
   /story-status
   ```

4. **Invoke agents directly**
   ```
   /agents software-architect
   Please create the architecture document based on the PRD at docs/prd.md
   ```

## 🤖 Available Agents

### Planning Agents
- **product-manager**: Transform product briefs into comprehensive PRDs
- **software-architect**: Create technical architecture documents
- **scrum-master**: Generate user stories from requirements
- **planning-analyst**: Segment large documents for better organization

### Development Agents
- **javascript-developer**: Implement JavaScript/TypeScript features
- **python-developer**: Build Python applications and APIs
- **rust-developer**: Create high-performance Rust applications
- **code-reviewer**: Perform comprehensive code reviews
- **conflict-resolver**: AI-assisted merge conflict resolution (NEW!)

### Design Agents
- **v0-frontend-design**: Generate designs using v0.dev integration

### Orchestration
- **orchestrator**: Coordinate multi-agent workflows
- **agent-organizer**: Optimize team assembly and task distribution

## ⚡ Slash Commands

### Planning & Requirements
- `/create-prd [product-brief-path]` - Transform product brief into comprehensive PRD
- `/create-design-spec [prd-or-brief-path]` - Create frontend design specification

### Story Orchestration
- `/implement-stories [scope]` - Full automated implementation workflow
- `/next-story` - Start the next available story
- `/review-story [story-id]` - Trigger code review for specific story
- `/story-status` - Show comprehensive progress report

### Git Worktree Management
- `/cleanup-worktrees list` - List all active worktrees
- `/cleanup-worktrees auto` - Cleanup abandoned worktrees (older than 24h)
- `/cleanup-worktrees <path>` - Cleanup specific worktree
- `/cleanup-worktrees force` - Force cleanup all worktrees (use with caution)

## 📚 Documentation

### Core Documentation
- [Agent System Overview](agents/README.md) - Complete guide to the agent ecosystem
- [Orchestration System](docs/orchestration-system.md) - Automated workflow coordination
- [Slash Commands Guide](.claude/commands/README.md) - Command usage and examples
- [Quick Start Guide](agents/guides/QUICK_START.md) - Get up and running quickly

### Git Worktree Multi-Agent Development
- [Git Worktree Quick Start](docs/git-worktree-quick-start.md) - 5-minute setup guide
- [Git Worktree Multi-Agent Guide](docs/git-worktree-multi-agent-guide.md) - Complete workflow guide
- [Git Worktree Workflow Directive](agents/directives/git-worktree-workflow.md) - Mandatory agent workflow
- [Git Worktree Manager](agents/lib/README.md) - Core utility documentation

### Conflict Prevention and Resolution (NEW!)
- [Conflict Resolution Design](docs/conflict-prevention-and-resolution-design.md) - System architecture
- [Conflict Resolution Summary](docs/conflict-resolution-implementation-summary.md) - Implementation guide
- [Conflict-Resolver Agent](agents/definitions/conflict-resolver.md) - AI-assisted conflict resolution

### Example Project
The repository includes a complete example implementation of a Mini Social Feed application:
- [Product Requirements](examples/prd.md) - Comprehensive PRD
- [Architecture Document](examples/architecture.md) - Technical specifications  
- [User Stories](examples/stories/) - Implementation-ready stories
- [Development Workflow](examples/architecture/development-workflow.md) - Setup and commands

## 🎨 ACCA Collection

The **Augment Claude Code Agents** (ACCA) collection provides 100+ production-ready agents across 9 categories:

- **Core Development** - Essential coding agents
- **Specialized Languages** - Language-specific experts  
- **Testing & QA** - Quality assurance specialists
- **DevOps & Infrastructure** - Deployment and operations
- **Data & Analytics** - Data processing and analysis
- **Security** - Security-focused agents
- **Developer Experience** - Tooling and productivity
- **Design & UX** - User experience specialists
- **Meta-Orchestration** - Advanced coordination agents

Browse the full collection in the [acca/](acca/) directory.

## 🛠️ Technology Stack

The example implementation demonstrates modern web development practices:

- **Frontend**: Next.js 15, TypeScript, Tailwind CSS, shadcn/ui
- **State Management**: TanStack Query (React Query)
- **Forms**: React Hook Form with Zod validation
- **Testing**: Jest, React Testing Library, Playwright
- **Code Quality**: ESLint, Prettier, TypeScript strict mode
- **Package Manager**: pnpm
- **Deployment**: Vercel (optimized for Next.js)

## 🔄 Development Workflow

### Automated Approach (Recommended)
```bash
# Start full workflow
/implement-stories

# Monitor progress  
/story-status

# Resume if interrupted
/implement-stories
```

### Manual Control
```bash
# Initialize analysis
/implement-stories  # Press Escape after analysis

# Work on stories individually
/next-story
/review-story 1.1

# Continue step by step
/next-story
```

## 📁 Project Structure

```
zipline/
├── agents/                    # AI agent ecosystem
│   ├── definitions/          # Agent specifications
│   ├── guides/              # Usage documentation
│   └── conventions/         # Development standards
├── acca/                     # Production agent collection
│   └── categories/          # Organized by domain
├── .claude/commands/         # Workflow automation
├── docs/                     # System documentation
├── examples/                 # Sample implementation
│   ├── prd.md               # Product requirements
│   ├── architecture.md      # Technical design
│   └── stories/             # User stories
└── .agent-orchestration/     # Runtime state
    ├── progress.json        # Overall metrics
    ├── dependency-graph.json # Story relationships
    └── tasks/               # Individual story state
```

## 🤝 Contributing

We welcome contributions to expand the agent ecosystem:

1. **Add new agents** - Create agent definitions in `agents/definitions/`
2. **Improve documentation** - Enhance guides and examples
3. **Submit ACCA agents** - Contribute to the production collection
4. **Report issues** - Help us improve the system

See individual directories for specific contribution guidelines.

## 📄 License

This project is open source. See individual components for specific licensing terms.

## 🔗 Related Projects

- [VoltAgent](https://github.com/voltagent/voltagent) - Open-source AI agent framework
- [Claude Code](https://claude.ai/code) - AI-powered development environment

---

**Built with ❤️ by the AI development community**

Transform your development workflow with AI agents. Start building smarter, ship faster.
