---
name: javascript-developer
description: |
  ⚠️ **DEPRECATED - Use Specialized Agents Instead** ⚠️

  This agent has been refactored into specialized agents for better focus and maintainability:

  - **`react-developer`**: For React applications (hooks, components, state management, performance)
  - **`nextjs-developer`**: For Next.js applications (App Router, Server Components, SEO, full-stack)
  - **`vanilla-javascript-developer`**: For vanilla JavaScript/Node.js (DOM APIs, Web APIs, Node.js runtime)

  **Please use the appropriate specialized agent for your needs.**

  This file is kept for backward compatibility but will be removed in a future version.
  See `docs/javascript-agent-refactoring-complete.md` for migration details.
model: sonnet
---

# ⚠️ DEPRECATED AGENT - DO NOT USE ⚠️

This agent has been **deprecated** and split into specialized agents for better maintainability and focus.

## Use These Specialized Agents Instead:

### For React Development
**Use: `react-developer`**
- React 18+ features (hooks, concurrent features, Suspense)
- Component patterns (compound components, render props, custom hooks)
- Performance optimization (memoization, virtual scrolling, code splitting)
- State management (Redux Toolkit, Zustand, Jotai, Recoil)
- React Testing Library and E2E testing
- Migration strategies and best practices

### For Next.js Development
**Use: `nextjs-developer`**
- Next.js 14+ App Router architecture
- Server Components and Server Actions
- SEO optimization (Metadata API, sitemap, structured data)
- Performance optimization (Core Web Vitals, edge caching)
- Full-stack features (API routes, middleware, database integration)
- Deployment and production best practices

### For Vanilla JavaScript/Node.js
**Use: `vanilla-javascript-developer`**
- Modern JavaScript (ES6+ through ES2024)
- DOM manipulation and Web APIs
- Browser APIs (Fetch, Storage, Intersection Observer)
- Node.js runtime and core modules
- Build tools (Webpack, Rollup, esbuild)
- Vanilla JavaScript patterns without frameworks

### For Advanced TypeScript
**Use: `typescript-developer`**
- TypeScript 5.0+ advanced type system
- Type-level programming (conditional types, mapped types, template literals)
- Generic constraints and type inference
- Full-stack type safety (tRPC, GraphQL codegen, Zod validation)
- Migration strategies (JavaScript to TypeScript)
- Type definition authoring (@types packages)
- Build optimization (tsconfig, project references)

### For NestJS Backend
**Use: `nestjs-developer`**
- NestJS 10+ enterprise backend applications
- Dependency injection and decorators
- REST/GraphQL API development
- Microservices architecture
- Database integration (TypeORM, Prisma, Mongoose)
- Authentication and authorization (Passport, JWT, guards)
- Testing (Jest, Supertest, E2E testing)

## Migration Guide

### If You Were Using This Agent For:

**React Projects:**
```
Before: javascript-developer
After:  react-developer
```

**Next.js Projects:**
```
Before: javascript-developer
After:  nextjs-developer
```

**Vanilla JavaScript/Node.js Projects:**
```
Before: javascript-developer
After:  vanilla-javascript-developer
```

**Advanced TypeScript:**
```
Before: javascript-developer
After:  typescript-developer
```

**NestJS Backend:**
```
Before: javascript-developer
After:  nestjs-developer
```

## Why This Change?

1. **Better Focus**: Each specialized agent focuses on specific expertise
2. **Reduced Complexity**: Agents are 65-81% smaller and easier to maintain
3. **Improved Quality**: Merged best practices from ACCA counterparts
4. **Self-Contained**: All agents work independently in separate repositories
5. **Common Patterns**: Shared JavaScript knowledge in `agents/directives/javascript-development.md`

## Documentation

For complete details on the refactoring:
- See: `docs/javascript-agent-refactoring-complete.md`
- Common JavaScript patterns: `agents/directives/javascript-development.md`

---

**This agent is no longer maintained. All content has been moved to specialized agents listed above.**
