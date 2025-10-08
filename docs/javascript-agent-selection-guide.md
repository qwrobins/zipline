# JavaScript Agent Selection Guide

Quick reference for choosing the right JavaScript agent for your project.

## Decision Tree

```
Are you working with JavaScript/TypeScript?
│
├─ YES → Continue below
│
└─ NO → Use language-specific agent (golang-developer, python-developer, rust-developer)

What is your primary focus?
│
├─ Advanced TypeScript type system → Use: typescript-developer
│   ├─ Type-level programming
│   ├─ Generic constraints
│   ├─ Full-stack type safety (tRPC)
│   ├─ Migration JS → TS
│   └─ Type definition authoring
│
├─ NestJS backend framework → Use: nestjs-developer
│   ├─ Dependency injection
│   ├─ REST/GraphQL APIs
│   ├─ Microservices
│   ├─ Authentication/Authorization
│   └─ Enterprise architecture
│
├─ React (with Vite) → Use: react-developer
│   ├─ Building React components
│   ├─ Using React hooks
│   ├─ State management (Context, Zustand, Redux)
│   ├─ Performance optimization
│   └─ React Testing Library
│
├─ Next.js → Use: nextjs-developer
│   ├─ App Router architecture
│   ├─ Server Components
│   ├─ Server Actions
│   ├─ SEO optimization
│   ├─ Full-stack features
│   └─ Deployment
│
└─ Vanilla JavaScript/Node.js → Use: vanilla-javascript-developer
    ├─ DOM manipulation
    ├─ Web APIs
    ├─ Node.js server
    ├─ No framework
    └─ Build tools (Webpack, Rollup, esbuild)
```

## Agent Comparison

| Feature | React | Next.js | Vanilla JS | TypeScript | NestJS |
|---------|-------|---------|------------|------------|--------|
| **Framework** | React 18+ | Next.js 14+ | None | N/A (language) | NestJS 10+ |
| **Build Tool** | Vite | Next.js | Webpack/Rollup | tsc | NestJS CLI |
| **Rendering** | Client-side | SSR/SSG/ISR | Browser/Node.js | N/A | Server-side |
| **Focus** | Frontend | Full-stack | Frontend/Backend | Type system | Backend |
| **State Mgmt** | Context/Zustand | Server + Client | Custom | N/A | DI container |
| **Routing** | React Router | App Router | Custom | N/A | Decorators |
| **SEO** | Limited | Excellent | Manual | N/A | N/A |
| **Testing** | RTL | Playwright/Jest | Playwright/Jest | Jest | Jest/Supertest |
| **Use Case** | SPAs | Full-stack apps | Libraries/APIs | Type safety | Enterprise APIs |

## When to Use Each Agent

### Use `react-developer` When:

✅ **Building React Applications:**
- Single-page applications (SPAs)
- Interactive dashboards
- Admin panels
- Component libraries
- React Native web apps

✅ **Working With:**
- React hooks (useState, useEffect, custom hooks)
- Component patterns (compound components, render props)
- State management (Context, Zustand, Redux Toolkit)
- React Router for client-side routing
- Vite for build tooling

✅ **Focusing On:**
- Component reusability and composition
- Performance optimization (memoization, code splitting)
- React-specific testing (React Testing Library)
- Client-side rendering and interactivity

❌ **Don't Use For:**
- Next.js projects (use nextjs-developer)
- Vanilla JavaScript without React (use vanilla-javascript-developer)
- Server-side rendering requirements (use nextjs-developer)

### Use `nextjs-developer` When:

✅ **Building Next.js Applications:**
- Marketing websites
- E-commerce platforms
- Blogs and content sites
- Full-stack applications
- SEO-critical applications

✅ **Working With:**
- Next.js 14+ App Router
- Server Components and Client Components
- Server Actions for mutations
- API routes and middleware
- Database integration (Prisma, Drizzle)

✅ **Focusing On:**
- SEO optimization (metadata, sitemap, structured data)
- Performance (Core Web Vitals, edge caching)
- Server-side rendering (SSR, SSG, ISR)
- Full-stack features (API, database, auth)
- Production deployment (Vercel, Docker, self-hosting)

❌ **Don't Use For:**
- React-only projects without Next.js (use react-developer)
- Vanilla JavaScript projects (use vanilla-javascript-developer)
- Client-side only applications (use react-developer)

### Use `vanilla-javascript-developer` When:

✅ **Building Vanilla JavaScript:**
- JavaScript libraries (no framework dependencies)
- Browser extensions
- Bookmarklets
- Static websites with vanilla JS
- Node.js CLI tools
- Node.js APIs/servers

✅ **Working With:**
- DOM APIs (querySelector, createElement, addEventListener)
- Web APIs (Fetch, Storage, Intersection Observer)
- Node.js core modules (fs, http, stream, path)
- ES Modules (import/export)
- Build tools (Webpack, Rollup, esbuild)

✅ **Focusing On:**
- No framework dependencies
- Minimal bundle size
- Browser compatibility
- Progressive enhancement
- Custom event systems
- Efficient DOM manipulation

❌ **Don't Use For:**
- React projects (use react-developer)
- Next.js projects (use nextjs-developer)
- Framework-specific patterns
- Advanced TypeScript patterns (use typescript-developer)

### Use `typescript-developer` When:

✅ **Working With Advanced TypeScript:**
- Type-level programming and type system design
- Generic constraints and conditional types
- Discriminated unions and branded types
- Full-stack type safety (tRPC, GraphQL codegen)
- Migration from JavaScript to TypeScript
- Type definition authoring (@types packages)
- Complex type transformations

✅ **Focusing On:**
- Advanced type patterns (mapped types, template literals)
- Type-safe APIs and validation (Zod, Yup)
- Monorepo type sharing
- Build optimization (tsconfig, project references)
- Type-driven development
- Runtime type checking
- Type documentation

✅ **Use Cases:**
- Migrating large JavaScript codebases to TypeScript
- Building type-safe full-stack applications
- Creating type-safe libraries and SDKs
- Implementing complex type systems
- Optimizing TypeScript build performance
- Authoring type definitions

❌ **Don't Use For:**
- Basic TypeScript usage (use framework-specific agents)
- React TypeScript patterns (use react-developer)
- Next.js TypeScript patterns (use nextjs-developer)
- NestJS TypeScript patterns (use nestjs-developer)

### Use `nestjs-developer` When:

✅ **Building NestJS Applications:**
- Enterprise-grade REST APIs
- GraphQL APIs with resolvers
- Microservices architecture
- WebSocket servers
- Full-stack backend applications
- Scalable Node.js services

✅ **Working With:**
- Dependency injection and IoC container
- Decorators and metadata
- Guards, interceptors, pipes, filters
- TypeORM, Prisma, or Mongoose
- Passport authentication strategies
- Message queues (RabbitMQ, Kafka, Redis)

✅ **Focusing On:**
- Module-based architecture
- Type-safe API development
- Authentication and authorization
- Database integration and ORM
- Testing (unit, integration, E2E)
- Production deployment
- Microservices patterns

✅ **Use Cases:**
- Building enterprise backend APIs
- Microservices architecture
- GraphQL servers
- Real-time applications (WebSockets)
- Authentication systems
- Database-driven applications

❌ **Don't Use For:**
- Frontend applications (use react-developer or nextjs-developer)
- Vanilla Node.js without framework (use vanilla-javascript-developer)
- Express/Fastify applications (use vanilla-javascript-developer)
- Simple REST APIs without DI (use vanilla-javascript-developer)

## Common Scenarios

### Scenario 1: Building a Dashboard
**Question:** "I need to build an admin dashboard with charts and tables."

**Answer:** Use `react-developer`
- React is ideal for interactive dashboards
- Component libraries (Recharts, AG Grid) work well with React
- State management for complex data flows
- Client-side rendering is sufficient

### Scenario 2: Building a Blog
**Question:** "I need to build a blog with good SEO."

**Answer:** Use `nextjs-developer`
- Next.js provides excellent SEO capabilities
- Static generation for blog posts
- Metadata API for SEO tags
- Sitemap and structured data generation

### Scenario 3: Building a JavaScript Library
**Question:** "I need to create a reusable JavaScript library for date formatting."

**Answer:** Use `vanilla-javascript-developer`
- No framework dependencies
- Works in any JavaScript environment
- Minimal bundle size
- ES Modules for modern usage

### Scenario 4: Building an E-commerce Site
**Question:** "I need to build an e-commerce platform with product pages and checkout."

**Answer:** Use `nextjs-developer`
- SEO critical for product discovery
- Server-side rendering for product pages
- API routes for checkout logic
- Database integration for products/orders

### Scenario 5: Building a Chrome Extension
**Question:** "I need to build a Chrome extension with a popup and content script."

**Answer:** Use `vanilla-javascript-developer`
- Chrome extensions use vanilla JavaScript
- No build step required (or minimal with esbuild)
- Direct DOM manipulation
- Web APIs for extension functionality

### Scenario 6: Building a Real-time Chat App
**Question:** "I need to build a real-time chat application."

**Answer:** Depends on requirements:
- **Client-only with external API:** Use `react-developer`
- **Full-stack with WebSockets:** Use `nextjs-developer`
- **Vanilla with Socket.io:** Use `vanilla-javascript-developer`

## Quick Reference

### React Developer
```bash
Agent: react-developer
Directive: agents/directives/javascript-development.md
Size: 738 lines
Focus: React 18+ applications with Vite
```

**Key Strengths:**
- React hooks and concurrent features
- Component patterns and composition
- Performance optimization
- State management (Context, Zustand, Redux)
- React Testing Library

### Next.js Developer
```bash
Agent: nextjs-developer
Directive: agents/directives/javascript-development.md
Size: 400 lines
Focus: Next.js 14+ App Router applications
```

**Key Strengths:**
- App Router and Server Components
- SEO optimization (metadata, sitemap, structured data)
- Performance (Core Web Vitals, edge caching)
- Full-stack features (API routes, database, auth)
- Deployment strategies

### Vanilla JavaScript Developer
```bash
Agent: vanilla-javascript-developer
Directive: agents/directives/javascript-development.md
Size: 300 lines
Focus: Vanilla JavaScript/Node.js without frameworks
```

**Key Strengths:**
- Modern JavaScript (ES6+ through ES2024)
- DOM APIs and Web APIs
- Node.js runtime and core modules
- Build tools (Webpack, Rollup, esbuild)
- No framework dependencies

### TypeScript Developer
```bash
Agent: typescript-developer
Directive: agents/directives/javascript-development.md
Size: 500 lines
Focus: TypeScript 5.0+ advanced type system
```

**Key Strengths:**
- Type-level programming (conditional types, mapped types)
- Generic constraints and type inference
- Full-stack type safety (tRPC, Zod)
- Migration strategies (JS → TS)
- Type definition authoring
- Build optimization (tsconfig, project references)

### NestJS Developer
```bash
Agent: nestjs-developer
Directive: agents/directives/javascript-development.md
Size: 550 lines
Focus: NestJS 10+ enterprise backend applications
```

**Key Strengths:**
- Dependency injection and decorators
- REST/GraphQL API development
- Microservices architecture
- Authentication and authorization
- Database integration (TypeORM, Prisma, Mongoose)
- Testing (unit, integration, E2E)

## Common Directive

All JavaScript agents reference:
```bash
agents/directives/javascript-development.md
```

**Shared Knowledge:**
- Testing setup (Playwright, Lighthouse, axe-core)
- Code quality (ESLint, Prettier, TypeScript)
- Performance optimization
- Security best practices
- Git worktree workflow

## Still Unsure?

### Ask Yourself:

1. **Am I focusing on advanced TypeScript type system?**
   - YES → `typescript-developer`
   - NO → Continue to question 2

2. **Am I building a NestJS backend?**
   - YES → `nestjs-developer`
   - NO → Continue to question 3

3. **Am I using React?**
   - YES → `react-developer` or `nextjs-developer`
   - NO → `vanilla-javascript-developer`

4. **Am I using Next.js?**
   - YES → `nextjs-developer`
   - NO → Continue to question 5

5. **Do I need SEO or server-side rendering?**
   - YES → `nextjs-developer`
   - NO → `react-developer` or `vanilla-javascript-developer`

6. **Do I want to avoid framework dependencies?**
   - YES → `vanilla-javascript-developer`
   - NO → `react-developer` or `nextjs-developer`

### Default Recommendations:

- **New web app with SEO:** `nextjs-developer`
- **New interactive dashboard:** `react-developer`
- **New JavaScript library:** `vanilla-javascript-developer`
- **New backend API:** `nestjs-developer`
- **Migrating JS to TS:** `typescript-developer`
- **Type-safe full-stack app:** `typescript-developer` + `nextjs-developer`
- **Existing React project:** `react-developer`
- **Existing Next.js project:** `nextjs-developer`
- **Existing NestJS project:** `nestjs-developer`
- **Existing vanilla JS project:** `vanilla-javascript-developer`

## Migration from Deprecated Agent

If you were using `javascript-developer`:

```bash
# Old (deprecated)
Agent: javascript-developer

# New (choose one)
React projects:     react-developer
Next.js projects:   nextjs-developer
Vanilla JS/Node.js: vanilla-javascript-developer
```

See `docs/javascript-agent-refactoring-final.md` for complete migration details.
