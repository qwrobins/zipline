# Agent Comparison Quick Reference

**TL;DR**: Keep all `agents/` for workflow integration. Add 8-12 high-priority `acca/` agents for specialized expertise.

---

## At a Glance

| Aspect | `agents/` (5 agents) | `acca/` (126 agents) |
|--------|---------------------|---------------------|
| **Philosophy** | Workflow-integrated, deep | Modular, broad coverage |
| **Best For** | Planning → Development workflow | Specialized tasks, any domain |
| **Depth** | 400-950 lines/agent | 280-320 lines/agent |
| **Integration** | Tightly coupled | Independent |
| **Protocols** | Mandatory (sequential_thinking, context7) | Optional |
| **Coverage** | JavaScript/TypeScript + Planning | All languages, all domains |

---

## Quick Decision Guide

### Use `agents/` When You Need:
- ✅ Product brief → PRD → Architecture → Stories → Code workflow
- ✅ Implementation-ready documentation with numbered requirements
- ✅ Orchestrator-ready user stories for parallel development
- ✅ JavaScript/TypeScript development with mandatory quality gates
- ✅ Document segmentation with md-tree automation

### Use `acca/` When You Need:
- ✅ Python, Go, Rust, Java, or other language development
- ✅ DevOps, Kubernetes, Terraform, cloud infrastructure
- ✅ Code review, security audits, performance testing
- ✅ Product strategy, roadmapping, analytics (not just PRDs)
- ✅ Team facilitation, sprint ceremonies, Agile coaching
- ✅ Quick reference with concise, checklist-driven guidance

---

## Head-to-Head Winners

| Category | Winner | Reason |
|----------|--------|--------|
| **JavaScript Development** | `agents/javascript-developer` | Workflow integration + mandatory protocols |
| **React Expertise** | `acca/react-specialist` | Deeper React 18+ patterns |
| **PRD Creation** | `agents/product-manager` | Implementation-ready with templates |
| **Product Strategy** | `acca/product-manager` | Roadmapping, analytics, business focus |
| **User Story Creation** | `agents/scrum-master` | Orchestrator-ready, complete workflow |
| **Team Facilitation** | `acca/scrum-master` | Sprint ceremonies, coaching |
| **Architecture Design** | `agents/software-architect` | No equivalent in acca/ |
| **Document Segmentation** | `agents/planning-analyst` | No equivalent in acca/ |
| **Code Review** | `acca/code-reviewer` | No equivalent in agents/ |
| **Python Development** | `acca/python-pro` | No equivalent in agents/ |
| **DevOps** | `acca/devops-engineer` | No equivalent in agents/ |

---

## Top 12 Agents to Adopt from `acca/`

### Tier 1: Critical Gaps (Add Immediately)
1. **react-specialist** - React 18+ deep expertise
2. **python-pro** - Python development (missing from agents/)
3. **devops-engineer** - DevOps & CI/CD (missing from agents/)
4. **code-reviewer** - Comprehensive code review
5. **nextjs-developer** - Next.js 14+ specialist

### Tier 2: High Value (Add Soon)
6. **multi-agent-coordinator** - Orchestrate complex workflows
7. **frontend-developer** - Multi-framework frontend
8. **backend-developer** - Server-side development
9. **typescript-pro** - TypeScript-specific expertise
10. **qa-expert** - Test automation specialist

### Tier 3: Nice to Have (Add as Needed)
11. **performance-engineer** - Performance optimization
12. **security-auditor** - Security vulnerability assessment

---

## Recommended Organization

```
agents/
├── 00-workflow/              # Keep from agents/ (workflow-integrated)
│   ├── product-manager.md
│   ├── software-architect.md
│   ├── planning-analyst.md
│   ├── scrum-master.md
│   └── javascript-developer.md
│
├── 01-development/           # Add from acca/ (specialized dev)
│   ├── react-specialist.md
│   ├── nextjs-developer.md
│   ├── python-pro.md
│   ├── typescript-pro.md
│   ├── frontend-developer.md
│   └── backend-developer.md
│
├── 02-quality/               # Add from acca/ (quality & testing)
│   ├── code-reviewer.md
│   ├── qa-expert.md
│   ├── performance-engineer.md
│   └── security-auditor.md
│
├── 03-infrastructure/        # Add from acca/ (DevOps & cloud)
│   └── devops-engineer.md
│
└── 04-orchestration/         # Add from acca/ (meta-orchestration)
    └── multi-agent-coordinator.md
```

---

## Key Differences

### `agents/` Unique Features
- ✅ Mandatory sequential_thinking before coding
- ✅ Mandatory context7 consultation when uncertain
- ✅ Iterative problem-solving protocol (2-3 retries)
- ✅ User story status management
- ✅ Embedded templates and examples
- ✅ Orchestrator-ready story structure
- ✅ Two-phase architecture generation (avoid token limits)
- ✅ md-tree automation for document segmentation

### `acca/` Unique Features
- ✅ 126 agents across 10 categories
- ✅ 23 language specialists (Python, Go, Rust, Java, etc.)
- ✅ 12 infrastructure specialists (DevOps, Kubernetes, Cloud)
- ✅ 12 quality & security specialists
- ✅ Explicit MCP tool listings
- ✅ Concise, checklist-driven format
- ✅ Production-ready (tested in real-world scenarios)
- ✅ Modular, independent usage

---

## Example Workflows

### Workflow 1: New Feature Development (Use `agents/`)
```
1. Product Brief → agents/product-manager → docs/prd.md
2. PRD → agents/software-architect → docs/architecture.md
3. Architecture → agents/planning-analyst → docs/architecture/ (segmented)
4. PRD + Architecture → agents/scrum-master → docs/stories/*.md
5. User Story → agents/javascript-developer → Implementation
```

### Workflow 2: Python Backend Feature (Use `acca/`)
```
1. Feature spec → acca/python-pro → Implementation
2. Code → acca/code-reviewer → Review feedback
3. Tests → acca/qa-expert → Test automation
```

### Workflow 3: React Component Optimization (Use `acca/`)
```
1. Component → acca/react-specialist → Optimization
2. Optimized code → acca/performance-engineer → Performance validation
3. Final code → acca/code-reviewer → Quality check
```

### Workflow 4: Product Strategy (Use `acca/`)
```
1. Market research → acca/product-manager → Roadmap
2. Roadmap → acca/scrum-master → Sprint planning
3. Sprint → acca/multi-agent-coordinator → Parallel development
```

---

## Migration Plan

### Week 1: Immediate Actions
- ✅ Keep all 5 agents/ (no changes)
- ✅ Add Tier 1 agents from acca/ (5 agents)
- ✅ Test integration

### Week 2: Organization
- ✅ Create category structure
- ✅ Move agents/ to 00-workflow/
- ✅ Add Tier 2 agents from acca/ (5 agents)
- ✅ Update documentation

### Week 3-4: Enhancement
- ✅ Merge capabilities (ES2023+, product strategy, ceremonies)
- ✅ Add Tier 3 agents from acca/ (2 agents)
- ✅ Create usage guides

### Month 2+: Expansion
- ✅ Add more acca/ agents as needed
- ✅ Build multi-agent orchestrator
- ✅ Continuous improvement

---

## Final Verdict

**Keep Both Approaches**

- **`agents/`** = Workflow-integrated, deep, opinionated, quality-focused
- **`acca/`** = Modular, broad, flexible, production-ready

**Best Strategy**: Organize them clearly, use each for their strengths, and let them complement each other.

**Total Recommended Agents**: 5 (from agents/) + 12 (from acca/) = **17 agents** to start

---

## Quick Reference: Which Agent for What?

| Task | Agent | Source |
|------|-------|--------|
| Create PRD from product brief | product-manager | agents/ |
| Design system architecture | software-architect | agents/ |
| Break down large docs | planning-analyst | agents/ |
| Create user stories | scrum-master | agents/ |
| Implement JS/TS features | javascript-developer | agents/ |
| Optimize React components | react-specialist | acca/ |
| Build Next.js app | nextjs-developer | acca/ |
| Develop Python backend | python-pro | acca/ |
| Review code quality | code-reviewer | acca/ |
| Set up CI/CD | devops-engineer | acca/ |
| Plan product roadmap | product-manager | acca/ |
| Facilitate sprint ceremonies | scrum-master | acca/ |
| Coordinate multiple agents | multi-agent-coordinator | acca/ |
| Write automated tests | qa-expert | acca/ |
| Optimize performance | performance-engineer | acca/ |
| Audit security | security-auditor | acca/ |

---

**Last Updated**: 2025-10-01  
**See Full Analysis**: [AGENT_COMPARISON_ANALYSIS.md](./AGENT_COMPARISON_ANALYSIS.md)
