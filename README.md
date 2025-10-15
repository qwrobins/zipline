# Zipline - AI Agent Orchestration Framework

> **A powerful multi-agent orchestration system for Claude Code that enables parallel development workflows, automated story implementation, and intelligent agent coordination.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> ⚠️ **WORK IN PROGRESS**: This documentation is currently being updated. The Installation and Quick Start sections contain placeholder information and may not be accurate. Please check back soon for updated instructions.

---

## 🚀 What is Zipline?

Zipline is an advanced agent orchestration framework designed for developers who want to leverage AI agents for complex software development workflows. It provides:

- **Multi-Agent Coordination**: Orchestrate multiple specialized AI agents working in parallel
- **Git Worktree Integration**: Isolated development environments for concurrent story implementation
- **Automated Story Implementation**: From PRD to tested code with minimal human intervention
- **Extensible Agent System**: Create and customize agents for your specific development needs
- **Intelligent Conflict Resolution**: Automatic detection and resolution of cross-agent conflicts

---

## 📦 What's Included

### 1. **Agent Orchestration System**
Coordinate multiple AI agents working on different stories simultaneously using git worktrees for isolation.

**Key Features:**
- Parallel story execution across multiple agents
- Dependency-aware task scheduling
- Automated code review and quality gates
- Progress tracking and state management

**Documentation:** [`docs/orchestration-system.md`](docs/orchestration-system.md)

### 2. **Agent Definitions**
Pre-configured agent definitions for common development tasks, stored in `.claude/agents/`.

**Included Agents:**
- Development agents (React, Next.js, Python, Go, TypeScript, etc.)
- Coordination agents (Scrum Master, Product Manager, Architect)
- Quality agents (Code Reviewer, QA Expert, Security Engineer)
- Specialized agents (Frontend Design, DevOps, etc.)

**Location:** [`.claude/agents/`](.claude/agents/)

### 3. **Development Workflow Tools**
Scripts and utilities to streamline your development process.

**Available Tools:**
- Design validation and visual testing
- Web testing setup automation
- Terminal testing utilities
- Pre-commit quality checks

**Location:** [`scripts/`](scripts/)

---

## 🎯 Quick Start

> **📘 New to Zipline?** Check out our **[Quick Start Guide](docs/QUICKSTART-GUIDE.md)** for complete step-by-step setup instructions!

### Prerequisites
- [Claude Code](https://claude.ai/code) installed
- Git 2.25+ (for worktree support)

### Setup Overview

1. **Create your project directory:**
```bash
mkdir my-project
cd my-project
```

2. **Create directory structure:**
```bash
mkdir .cluade
mkdir .cluade/agents
```

3. **Copy core agent resources from Zipline:**
```bash
# Copy agent guides, directives, and libraries
cp -r /path-to-zipline/.claude/agents/agent-guides /path-to-your-project/.cluade/agents/
cp -r /path-to-zipline/.claude/agents/directives /path-to-your-project/.cluade/agents/
cp -r /path-to-zipline/.claude/agents/lib /path-to-your-project/.cluade/agents/
```

4. **Copy planning agents:**
```bash
# Copy product-manager, software-architect, planning-analyst, scrum-master, etc.
cp /path-to-zipline/.claude/agents/product-manager.md /path-to-your-project/.cluade/agents/
cp /path-to-zipline/.claude/agents/scrum-master.md /path-to-your-project/.cluade/agents/
# ... (see Quick Start Guide for complete list)
```

5. **Copy development agents you need:**
```bash
# Example: Next.js developer
cp /path-to-zipline/.claude/agents/nextjs-developer.md /path-to-your-project/.cluade/agents/
```

6. **Copy configuration files:**
```bash
cp /path-to-zipline/.claude/mcp.json /path-to-your-project/
cp /path-to-zipline/.claude/settings.local.json /path-to-your-project/.cluade/
cp -r /path-to-zipline/.claude/commands /path-to-your-project/
```

> **Note:** Add your GitHub PAT to the `.mcp.json` file and configure Context7 and Sequential Thinking servers.

**📖 For complete setup instructions, see the [Quick Start Guide](docs/QUICKSTART-GUIDE.md).**

---

### Usage

Once setup is complete, you can start building:

#### 1. Automated Planning
```bash
# Run automated planning with a product brief
/automate-planning

# Or with a direct prompt
/automate-planning docs/product-brief.md <your prompt>
```

#### 2. Implementation
```bash
# After planning is complete, implement the stories
/implement-stories
```

---

## 📚 Documentation

### Getting Started
- **[Quick Start Guide](docs/QUICKSTART-GUIDE.md)** - ⭐ Step-by-step setup and first steps
- **[Orchestration System Overview](docs/orchestration-system.md)** - Understanding the multi-agent workflow
- **[Git Worktree Quick Start](docs/git-worktree-quick-start.md)** - Setting up isolated development environments
- **[Orchestrator Quick Reference](docs/orchestrator-quick-reference.md)** - Command reference and usage

### Guides
- **[Git Worktree Multi-Agent Guide](docs/git-worktree-multi-agent-guide.md)** - Advanced parallel development patterns
- **[Orchestrator Workflow Quick Reference](docs/orchestrator-workflow-quick-reference.md)** - Step-by-step workflow guide
- **[JavaScript Agent Selection Guide](docs/javascript-agent-selection-guide.md)** - Choosing the right JS/TS agent
- **[Git Workflow Checklist](docs/orchestrator-git-workflow-checklist.md)** - Best practices for git operations

### Reference
- **[Design System](docs/design-system.md)** - Design principles and component guidelines
- **[Dev Server Quick Reference](docs/dev-server-quick-reference.md)** - Development server management

---

## 🎨 Example Workflow

Here's a typical workflow using Zipline:

```bash
# 1. Create a product brief
cat > product-brief.md << EOF
# My Awesome App
Build a social feed application with posts, comments, and user profiles...
EOF

# 2. Generate user stories (using scrum-master agent)
# Stories are automatically created with acceptance criteria

# 3. Plan implementation (using orchestrator)
# Dependencies are analyzed, parallel execution waves determined

# 4. Implement stories in parallel
# Multiple agents work simultaneously in isolated worktrees
# - react-developer implements frontend stories
# - backend-developer implements API stories
# - qa-expert writes tests

# 5. Automated code review
# code-reviewer agent validates each implementation

# 6. Merge completed stories
# Conflict detection and resolution handled automatically
```

---

## 🏗️ Architecture

### Agent Types

**Development Agents:**
- `react-developer` - React/TypeScript frontend development
- `nextjs-developer` - Next.js full-stack applications
- `python-developer` - Python backend services
- `golang-developer` - Go microservices
- And 20+ more language specialists

**Coordination Agents:**
- `scrum-master` - Story creation and sprint planning
- `product-manager` - PRD creation and feature planning
- `software-architect` - System design and architecture
- `code-reviewer` - Code quality and review

**Specialized Agents:**
- `frontend-design` - UI/UX design and prototyping
- `qa-expert` - Test automation and quality assurance
- `devops-engineer` - CI/CD and infrastructure
- `security-engineer` - Security audits and hardening

### Orchestration Flow

```
PRD → Stories → Dependencies → Parallel Execution → Review → Merge
  ↓       ↓          ↓              ↓                ↓        ↓
 PM    Scrum    Orchestrator    Dev Agents      Reviewer  Conflict
Agent  Master                                    Agent    Resolver
```

---

## 🛠️ Advanced Features

### Git Worktree Integration
Zipline uses git worktrees to enable true parallel development:
- Each story gets its own isolated worktree
- No branch switching or stashing required
- Automatic conflict detection across worktrees
- Clean merge strategies

**Learn more:** [Git Worktree Multi-Agent Guide](docs/git-worktree-multi-agent-guide.md)

### Intelligent Conflict Resolution
Automatic detection and resolution of:
- File-level conflicts (same file modified by multiple agents)
- Dependency conflicts (shared code changes)
- Configuration conflicts (package.json, etc.)

### State Management
Persistent state tracking for:
- Story progress and completion
- Agent assignments and workload
- Dependency graphs and execution waves
- Review status and feedback

**Location:** `.agent-orchestration/`

---

## 📖 Examples

### Example 1: Social Feed Application
See [`examples/product-brief.md`](examples/product-brief.md) for a complete example of:
- Product requirements document
- User story breakdown
- Implementation plan
- Testing strategy

### Example 2: Multi-Agent Parallel Development
```bash
# Implement 5 stories in parallel with 3 agents
# - Stories 1-2: react-developer (frontend)
# - Stories 3-4: python-developer (backend)
# - Story 5: qa-expert (testing)

# All work happens simultaneously in isolated worktrees
# Automatic conflict detection and resolution
# Coordinated merge when all stories complete
```

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Adding New Agents
1. Create agent definition in `.claude/agents/`
2. Follow the agent template structure
3. Test with real-world scenarios
4. Submit PR with documentation

### Improving Documentation
1. Identify gaps or unclear sections
2. Add examples and use cases
3. Update quick reference guides
4. Submit PR

### Reporting Issues
- Use GitHub Issues for bug reports
- Include reproduction steps
- Provide agent logs and context
- Tag with appropriate labels

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details

---

## 🔗 Resources

- **[VoltAgent Framework](https://github.com/voltagent/voltagent)** - Underlying agent framework
- **[Claude Code Documentation](https://docs.anthropic.com/claude-code)** - Official Claude Code docs
- **[Community Discord](https://s.voltagent.dev/discord)** - Join the community

---

## 🙏 Acknowledgments

Special thanks to:
- Anthropic for Claude Code
- The [VoltAgent](https://github.com/VoltAgent/awesome-claude-code-subagents) team for the agent framework that was referenced during the creation of this project

---

<p align="center">
  <strong>Ready to supercharge your development workflow?</strong><br>
  <a href="docs/orchestration-system.md">Get Started →</a>
</p>
