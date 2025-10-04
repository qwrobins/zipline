# Agent Ecosystem Visualization

This document provides visual representations of the agent ecosystems in both directories.

---

## Current State: Two Separate Ecosystems

```mermaid
graph TB
    subgraph "agents/ - Workflow-Integrated Ecosystem (5 agents)"
        PB[Product Brief]
        PM[product-manager]
        PRD[PRD Document]
        SA[software-architect]
        ARCH[Architecture Doc]
        PA[planning-analyst]
        SEG[Segmented Docs]
        SM[scrum-master]
        STORIES[User Stories]
        JD[javascript-developer]
        CODE[Implementation]
        
        PB --> PM
        PM --> PRD
        PRD --> SA
        SA --> ARCH
        ARCH --> PA
        PA --> SEG
        PRD --> SM
        ARCH --> SM
        SM --> STORIES
        STORIES --> JD
        JD --> CODE
    end
    
    subgraph "acca/ - Modular Ecosystem (126 agents)"
        TASK[Any Task]
        
        subgraph "Language Specialists (23)"
            JS[javascript-pro]
            PY[python-pro]
            GO[golang-pro]
            RS[rust-engineer]
            REACT[react-specialist]
        end
        
        subgraph "Infrastructure (12)"
            DEVOPS[devops-engineer]
            K8S[kubernetes-specialist]
            CLOUD[cloud-architect]
        end
        
        subgraph "Quality (12)"
            CR[code-reviewer]
            QA[qa-expert]
            PERF[performance-engineer]
        end
        
        subgraph "Business (10)"
            PM2[product-manager]
            SM2[scrum-master]
        end
        
        subgraph "Meta (8)"
            MAC[multi-agent-coordinator]
        end
        
        TASK -.-> JS
        TASK -.-> PY
        TASK -.-> GO
        TASK -.-> RS
        TASK -.-> REACT
        TASK -.-> DEVOPS
        TASK -.-> K8S
        TASK -.-> CLOUD
        TASK -.-> CR
        TASK -.-> QA
        TASK -.-> PERF
        TASK -.-> PM2
        TASK -.-> SM2
        TASK -.-> MAC
    end
    
    style PM fill:#4CAF50
    style SA fill:#4CAF50
    style PA fill:#4CAF50
    style SM fill:#4CAF50
    style JD fill:#4CAF50
    
    style JS fill:#2196F3
    style PY fill:#2196F3
    style REACT fill:#2196F3
    style DEVOPS fill:#FF9800
    style CR fill:#9C27B0
    style PM2 fill:#F44336
    style MAC fill:#607D8B
```

---

## Recommended Future State: Unified Ecosystem

```mermaid
graph TB
    subgraph "Unified Agent Ecosystem"
        subgraph "00-workflow/ - Planning & Development Pipeline"
            PB[Product Brief]
            PM[product-manager<br/>Enhanced with strategy]
            PRD[PRD]
            SA[software-architect]
            ARCH[Architecture]
            PA[planning-analyst]
            SEG[Segmented Docs]
            SM[scrum-master<br/>Enhanced with ceremonies]
            STORIES[User Stories]
            JD[javascript-developer<br/>Enhanced with ES2023+]
            CODE[Implementation]
            
            PB --> PM
            PM --> PRD
            PRD --> SA
            SA --> ARCH
            ARCH --> PA
            PA --> SEG
            PRD --> SM
            ARCH --> SM
            SM --> STORIES
            STORIES --> JD
            JD --> CODE
        end
        
        subgraph "01-development/ - Language Specialists"
            REACT[react-specialist]
            NEXT[nextjs-developer]
            PY[python-pro]
            TS[typescript-pro]
            FE[frontend-developer]
            BE[backend-developer]
        end
        
        subgraph "02-quality/ - Quality & Testing"
            CR[code-reviewer]
            QA[qa-expert]
            PERF[performance-engineer]
            SEC[security-auditor]
        end
        
        subgraph "03-infrastructure/ - DevOps & Cloud"
            DEVOPS[devops-engineer]
            K8S[kubernetes-specialist]
            CLOUD[cloud-architect]
        end
        
        subgraph "04-orchestration/ - Meta-Coordination"
            MAC[multi-agent-coordinator]
        end
        
        STORIES -.-> REACT
        STORIES -.-> NEXT
        STORIES -.-> PY
        STORIES -.-> FE
        STORIES -.-> BE
        
        CODE --> CR
        CODE --> QA
        CODE --> PERF
        CODE --> SEC
        
        CODE -.-> DEVOPS
        CODE -.-> K8S
        CODE -.-> CLOUD
        
        MAC -.-> JD
        MAC -.-> REACT
        MAC -.-> PY
        MAC -.-> DEVOPS
    end
    
    style PM fill:#4CAF50
    style SA fill:#4CAF50
    style PA fill:#4CAF50
    style SM fill:#4CAF50
    style JD fill:#4CAF50
    
    style REACT fill:#2196F3
    style NEXT fill:#2196F3
    style PY fill:#2196F3
    style TS fill:#2196F3
    style FE fill:#2196F3
    style BE fill:#2196F3
    
    style CR fill:#9C27B0
    style QA fill:#9C27B0
    style PERF fill:#9C27B0
    style SEC fill:#9C27B0
    
    style DEVOPS fill:#FF9800
    style K8S fill:#FF9800
    style CLOUD fill:#FF9800
    
    style MAC fill:#607D8B
```

---

## Agent Interaction Patterns

### Pattern 1: Sequential Workflow (agents/)

```mermaid
sequenceDiagram
    participant User
    participant PM as product-manager
    participant SA as software-architect
    participant PA as planning-analyst
    participant SM as scrum-master
    participant JD as javascript-developer
    
    User->>PM: Product Brief
    PM->>PM: Use sequential_thinking
    PM->>PM: Research with context7
    PM->>User: PRD with FR/NFR
    
    User->>SA: PRD
    SA->>SA: Use sequential_thinking
    SA->>SA: Research frameworks
    SA->>User: Architecture Doc
    
    User->>PA: Architecture Doc
    PA->>PA: Run md-tree explode
    PA->>User: Segmented Docs
    
    User->>SM: PRD + Architecture
    SM->>SM: Use sequential_thinking
    SM->>SM: Research Agile practices
    SM->>User: User Stories (all)
    
    User->>JD: User Story
    JD->>JD: Use sequential_thinking
    JD->>JD: Research when uncertain
    JD->>JD: Implement with retries
    JD->>User: Implementation + Tests
    JD->>User: Update story status
```

### Pattern 2: Modular Task Execution (acca/)

```mermaid
sequenceDiagram
    participant User
    participant Agent as Any acca/ Agent
    participant Tools as MCP Tools
    
    User->>Agent: Task Request
    Agent->>Agent: Review checklist
    Agent->>Tools: Use domain tools
    Agent->>Agent: Execute task
    Agent->>User: Result
    
    Note over User,Tools: No workflow integration<br/>No mandatory protocols<br/>Independent execution
```

### Pattern 3: Orchestrated Parallel Execution (Recommended)

```mermaid
sequenceDiagram
    participant User
    participant MAC as multi-agent-coordinator
    participant JD as javascript-developer
    participant PY as python-pro
    participant REACT as react-specialist
    participant CR as code-reviewer
    
    User->>MAC: Multiple User Stories
    MAC->>MAC: Analyze dependencies
    MAC->>MAC: Assign to agents
    
    par Parallel Development
        MAC->>JD: Story 1 (no deps)
        MAC->>PY: Story 2 (no deps)
        MAC->>REACT: Story 3 (no deps)
    end
    
    JD->>MAC: Story 1 Complete
    PY->>MAC: Story 2 Complete
    REACT->>MAC: Story 3 Complete
    
    MAC->>CR: Review all code
    CR->>MAC: Review complete
    MAC->>User: All stories done
```

---

## Coverage Visualization

### agents/ Coverage (5 agents)

```
Planning & Development Workflow
├── Product Management ████████████ 100%
├── Architecture Design ████████████ 100%
├── Document Organization ████████████ 100%
├── Story Creation ████████████ 100%
└── JavaScript Development ████████████ 100%

Other Languages
├── Python ░░░░░░░░░░░░ 0%
├── Go ░░░░░░░░░░░░ 0%
├── Rust ░░░░░░░░░░░░ 0%
└── Java ░░░░░░░░░░░░ 0%

Infrastructure
├── DevOps ░░░░░░░░░░░░ 0%
├── Kubernetes ░░░░░░░░░░░░ 0%
└── Cloud ░░░░░░░░░░░░ 0%

Quality & Security
├── Code Review ░░░░░░░░░░░░ 0%
├── Testing ░░░░░░░░░░░░ 0%
└── Security ░░░░░░░░░░░░ 0%
```

### acca/ Coverage (126 agents)

```
Planning & Development Workflow
├── Product Management ████████░░░░ 70% (strategy, not PRDs)
├── Architecture Design ██████░░░░░░ 50% (cloud, microservices)
├── Document Organization ░░░░░░░░░░░░ 0%
├── Story Creation ░░░░░░░░░░░░ 0%
└── JavaScript Development ████████████ 100%

Other Languages
├── Python ████████████ 100%
├── Go ████████████ 100%
├── Rust ████████████ 100%
└── Java ████████████ 100%

Infrastructure
├── DevOps ████████████ 100%
├── Kubernetes ████████████ 100%
└── Cloud ████████████ 100%

Quality & Security
├── Code Review ████████████ 100%
├── Testing ████████████ 100%
└── Security ████████████ 100%
```

### Combined Coverage (Recommended)

```
Planning & Development Workflow
├── Product Management ████████████ 100% (agents/ + acca/ strategy)
├── Architecture Design ████████████ 100% (agents/ + acca/ cloud)
├── Document Organization ████████████ 100% (agents/)
├── Story Creation ████████████ 100% (agents/)
└── JavaScript Development ████████████ 100% (agents/ + acca/)

Other Languages
├── Python ████████████ 100% (acca/)
├── Go ████████████ 100% (acca/)
├── Rust ████████████ 100% (acca/)
└── Java ████████████ 100% (acca/)

Infrastructure
├── DevOps ████████████ 100% (acca/)
├── Kubernetes ████████████ 100% (acca/)
└── Cloud ████████████ 100% (acca/)

Quality & Security
├── Code Review ████████████ 100% (acca/)
├── Testing ████████████ 100% (acca/)
└── Security ████████████ 100% (acca/)
```

---

## Decision Tree: Which Agent to Use?

```mermaid
graph TD
    START[Need an Agent?]
    
    START --> Q1{Creating planning<br/>documents?}
    Q1 -->|Yes| Q2{What type?}
    Q1 -->|No| Q3{Writing code?}
    
    Q2 -->|PRD| PM[agents/product-manager]
    Q2 -->|Architecture| SA[agents/software-architect]
    Q2 -->|User Stories| SM[agents/scrum-master]
    Q2 -->|Segment Docs| PA[agents/planning-analyst]
    
    Q3 -->|Yes| Q4{What language?}
    Q3 -->|No| Q5{Infrastructure?}
    
    Q4 -->|JavaScript/TypeScript| Q6{Part of workflow?}
    Q4 -->|Python| PY[acca/python-pro]
    Q4 -->|Go| GO[acca/golang-pro]
    Q4 -->|Rust| RS[acca/rust-engineer]
    Q4 -->|Other| LANG[acca/language-specialists/]
    
    Q6 -->|Yes| JD[agents/javascript-developer]
    Q6 -->|No, React-specific| REACT[acca/react-specialist]
    Q6 -->|No, Next.js-specific| NEXT[acca/nextjs-developer]
    Q6 -->|No, general| JS[acca/javascript-pro]
    
    Q5 -->|Yes| Q7{What type?}
    Q5 -->|No| Q8{Quality/Testing?}
    
    Q7 -->|DevOps/CI/CD| DEVOPS[acca/devops-engineer]
    Q7 -->|Kubernetes| K8S[acca/kubernetes-specialist]
    Q7 -->|Cloud| CLOUD[acca/cloud-architect]
    Q7 -->|Terraform| TF[acca/terraform-engineer]
    
    Q8 -->|Yes| Q9{What type?}
    Q8 -->|No| Q10{Product/Business?}
    
    Q9 -->|Code Review| CR[acca/code-reviewer]
    Q9 -->|Testing| QA[acca/qa-expert]
    Q9 -->|Performance| PERF[acca/performance-engineer]
    Q9 -->|Security| SEC[acca/security-auditor]
    
    Q10 -->|Yes| Q11{What type?}
    Q10 -->|No| OTHER[Check acca/ categories]
    
    Q11 -->|Strategy/Roadmap| PM2[acca/product-manager]
    Q11 -->|Team Facilitation| SM2[acca/scrum-master]
    Q11 -->|Other| BIZ[acca/business-product/]
    
    style PM fill:#4CAF50
    style SA fill:#4CAF50
    style SM fill:#4CAF50
    style PA fill:#4CAF50
    style JD fill:#4CAF50
    
    style REACT fill:#2196F3
    style NEXT fill:#2196F3
    style PY fill:#2196F3
    style JS fill:#2196F3
    
    style DEVOPS fill:#FF9800
    style K8S fill:#FF9800
    style CLOUD fill:#FF9800
    
    style CR fill:#9C27B0
    style QA fill:#9C27B0
    style PERF fill:#9C27B0
    style SEC fill:#9C27B0
```

---

## Color Legend

- 🟢 **Green** - agents/ workflow-integrated agents
- 🔵 **Blue** - acca/ development specialists
- 🟠 **Orange** - acca/ infrastructure specialists
- 🟣 **Purple** - acca/ quality & security specialists
- ⚫ **Gray** - acca/ meta-orchestration

---

**See Also**:
- [Full Analysis](./AGENT_COMPARISON_ANALYSIS.md)
- [Quick Summary](./AGENT_COMPARISON_SUMMARY.md)
- [Comparison Matrix](./AGENT_COMPARISON_MATRIX.md)
