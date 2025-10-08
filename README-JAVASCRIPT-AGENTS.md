# JavaScript/TypeScript Agent Suite

> **Complete ecosystem coverage with 5 specialized agents + 1 common directive**

## 🎯 Quick Selection Guide

```
┌─────────────────────────────────────────────────────────────┐
│  What are you building?                                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🎨 React SPA / Dashboard                                   │
│     → Use: react-developer                                  │
│     → Focus: Hooks, components, state management            │
│                                                             │
│  🚀 Next.js Full-Stack App                                  │
│     → Use: nextjs-developer                                 │
│     → Focus: App Router, SEO, Server Components             │
│                                                             │
│  📦 JavaScript Library / Browser Extension                  │
│     → Use: vanilla-javascript-developer                     │
│     → Focus: DOM APIs, Web APIs, no frameworks              │
│                                                             │
│  🔷 Advanced TypeScript / Type-Safe Full-Stack              │
│     → Use: typescript-developer                             │
│     → Focus: Type system, generics, tRPC, Zod               │
│                                                             │
│  🏢 NestJS Backend API / Microservices                      │
│     → Use: nestjs-developer                                 │
│     → Focus: DI, decorators, REST/GraphQL, auth             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 📊 Agent Overview

| Agent | Size | Focus | Key Strengths |
|-------|------|-------|---------------|
| **react-developer** | 738 lines | React 18+ | Hooks, concurrent features, performance |
| **nextjs-developer** | 400 lines | Next.js 14+ | App Router, SEO, Server Components |
| **vanilla-javascript-developer** | 300 lines | Vanilla JS/Node.js | DOM APIs, Web APIs, no frameworks |
| **typescript-developer** | 500 lines | TypeScript 5.0+ | Type system, generics, full-stack types |
| **nestjs-developer** | 550 lines | NestJS 10+ | DI, microservices, enterprise APIs |
| **javascript-development** | 300 lines | Common patterns | Testing, quality, security (directive) |

## 🚀 Features

### ✅ Self-Contained Architecture
- All configurations embedded inline
- No external script dependencies
- Works in separate repositories
- Complete code examples

### ✅ Specialized Expertise
- Each agent focuses on specific domain
- No overlap between agents
- Clear boundaries and responsibilities
- Framework-specific knowledge

### ✅ Quality Standards
- Comprehensive checklists
- Specific metrics (>85-95% coverage)
- Type safety requirements
- Performance targets

### ✅ Production-Ready
- Complete implementations
- Testing patterns
- Security best practices
- Deployment strategies

## 📚 Agent Details

### React Developer
**File:** `agents/definitions/react-developer.md`

**Expertise:**
- React 18+ concurrent features (useTransition, useDeferredValue, Suspense)
- Advanced patterns (compound components, render props, custom hooks)
- Performance (memoization, virtual scrolling, code splitting)
- State management (Redux Toolkit, Zustand, Jotai, Recoil)
- Testing (React Testing Library, E2E)

**Use For:**
- Single-page applications
- Interactive dashboards
- Admin panels
- Component libraries

---

### Next.js Developer
**File:** `agents/definitions/nextjs-developer.md`

**Expertise:**
- App Router architecture (layouts, parallel routes, intercepting routes)
- Server Components and Client Components
- Server Actions with validation
- SEO (Metadata API, sitemap, structured data)
- Performance (Core Web Vitals, edge caching)
- Full-stack (API routes, database, auth)

**Use For:**
- Marketing websites
- E-commerce platforms
- Blogs and content sites
- SEO-critical applications

---

### Vanilla JavaScript Developer
**File:** `agents/definitions/vanilla-javascript-developer.md`

**Expertise:**
- Modern JavaScript (ES6+ through ES2024)
- DOM manipulation and Web APIs
- Browser APIs (Fetch, Storage, Intersection Observer)
- Node.js runtime and core modules
- Build tools (Webpack, Rollup, esbuild)

**Use For:**
- JavaScript libraries
- Browser extensions
- Node.js CLI tools
- Static websites

---

### TypeScript Developer
**File:** `agents/definitions/typescript-developer.md`

**Expertise:**
- Type-level programming (conditional types, mapped types, template literals)
- Generic constraints and type inference
- Discriminated unions and branded types
- Full-stack type safety (tRPC, GraphQL codegen, Zod)
- Migration strategies (JS → TS)
- Build optimization (tsconfig, project references)

**Use For:**
- Migrating JavaScript to TypeScript
- Type-safe full-stack applications
- Creating type-safe libraries
- Complex type systems

---

### NestJS Developer
**File:** `agents/definitions/nestjs-developer.md`

**Expertise:**
- Dependency injection and decorators
- REST/GraphQL API development
- Microservices (TCP, Redis, NATS, RabbitMQ, Kafka)
- Database integration (TypeORM, Prisma, Mongoose)
- Authentication/authorization (Passport, JWT, guards)
- Testing (Jest, Supertest, E2E)

**Use For:**
- Enterprise REST APIs
- GraphQL servers
- Microservices architecture
- Real-time applications

---

### JavaScript Development (Directive)
**File:** `agents/directives/javascript-development.md`

**Shared Knowledge:**
- Complete testing setup (Playwright, Lighthouse, axe-core)
- Code quality (ESLint, Prettier, TypeScript)
- Performance optimization
- Security best practices
- Git worktree workflow

**Referenced By:** All JavaScript/TypeScript agents

## 🎓 Usage Examples

### Example 1: React Dashboard
```bash
Agent: react-developer
Task: Build an interactive admin dashboard with charts and tables
Patterns: Custom hooks, state management, performance optimization
```

### Example 2: Next.js E-commerce
```bash
Agent: nextjs-developer
Task: Build an e-commerce site with product pages and checkout
Patterns: Server Components, SEO, API routes, database integration
```

### Example 3: TypeScript Library
```bash
Agent: typescript-developer + vanilla-javascript-developer
Task: Create a type-safe date formatting library
Patterns: Advanced types, branded types, no framework dependencies
```

### Example 4: NestJS Microservices
```bash
Agent: nestjs-developer + typescript-developer
Task: Build a microservices backend with message queues
Patterns: Dependency injection, message patterns, type safety
```

## 📖 Documentation

### Quick Start
- **Selection Guide:** `docs/javascript-agent-selection-guide.md`
- **Complete Overview:** `docs/javascript-ecosystem-agents-complete.md`

### Detailed Documentation
- **Refactoring Summary:** `docs/javascript-agent-refactoring-final.md`
- **TypeScript/NestJS Addition:** `docs/typescript-nestjs-agents-added.md`

### Migration
- **From Deprecated Agent:** See `agents/definitions/javascript-developer.md`

## 🔄 Migration from Deprecated Agent

The original `javascript-developer.md` has been deprecated and split into specialized agents:

| Old | New |
|-----|-----|
| javascript-developer (React) | → react-developer |
| javascript-developer (Next.js) | → nextjs-developer |
| javascript-developer (Vanilla JS) | → vanilla-javascript-developer |
| javascript-developer (TypeScript) | → typescript-developer |
| javascript-developer (NestJS) | → nestjs-developer |

## 📈 Statistics

### Size Reduction
- **Original:** 2,141 lines (monolithic)
- **New Suite:** 2,788 lines total (5 agents + 1 directive)
- **Average per Agent:** 557 lines (77% reduction)

### Coverage
- **Frontend:** React, Next.js ✅
- **Backend:** NestJS, vanilla Node.js ✅
- **Type System:** TypeScript ✅
- **Language:** JavaScript/ECMAScript ✅

### Quality
- **Code Examples:** 50+ complete implementations
- **Checklists:** 5 comprehensive quality checklists
- **Self-Contained:** 100% (no external dependencies)
- **Test Coverage:** >85-90% required

## 🎯 Benefits

### 1. Improved Focus
- Each agent specializes in specific expertise
- No confusion about which patterns to use
- Clear boundaries between frameworks

### 2. Reduced Complexity
- 65-86% size reduction per agent
- Easier to read and understand
- Faster for AI agents to process

### 3. Better Maintainability
- Common patterns in shared directive
- Framework-specific knowledge separated
- Easy to update and extend

### 4. Enhanced Quality
- Merged best practices from ACCA
- Comprehensive checklists
- Production-ready configurations

### 5. Self-Contained
- All configurations embedded inline
- No external dependencies
- Works in separate repositories

## 🚦 Getting Started

1. **Identify your project type** (React, Next.js, vanilla JS, TypeScript, NestJS)
2. **Choose the appropriate agent** from the selection guide
3. **Reference the common directive** for testing and quality standards
4. **Follow the embedded examples** for implementation patterns
5. **Use the checklists** to validate quality

## 📝 License

Part of the Zipline AI Agent Orchestration System.

---

**Last Updated:** 2025-10-08  
**Version:** 2.0 (Complete Suite with TypeScript and NestJS)
