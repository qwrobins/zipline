# Technical Assumptions

## Repository Structure: Monorepo

Single repository structure appropriate for this self-contained application with no separate services.

## Service Architecture

**Monolith** - Single Next.js 15 application using App Router with the following structure:
- **Framework**: Next.js 15 (App Router, React Server Components where beneficial)
- **Language**: TypeScript (strict mode enabled)
- **Styling**: Tailwind CSS v3+
- **UI Components**: shadcn/ui (Radix UI primitives)
- **State Management**: React Query v5 (TanStack Query) for server state
- **Forms**: React Hook Form + Zod validation
- **Notifications**: Sonner toast library
- **HTTP Client**: Native fetch API (no Axios dependency needed)
- **Image Optimization**: next/image for static assets
- **Data Source**: JSONPlaceholder API (https://jsonplaceholder.typicode.com)

## Testing Requirements

**Full Testing Pyramid**:
- **Unit Tests**: Jest + React Testing Library for components, hooks, and utilities
- **Integration Tests**: React Testing Library for multi-component interactions and form flows
- **E2E Tests**: Playwright for critical user journeys (post viewing, comment creation, todo management)
- **Manual Testing**: Development server with hot reload for rapid iteration

Test coverage expectations:
- Utility functions: 90%+ coverage
- React components: 70%+ coverage
- Critical paths (CRUD operations): 100% E2E coverage

## Additional Technical Assumptions and Requests

- **Package Manager**: pnpm (faster installs, efficient disk usage) or npm if pnpm unavailable
- **Code Quality**: ESLint + Prettier with recommended Next.js and TypeScript rules
- **Git Hooks**: Husky + lint-staged for pre-commit linting and formatting
- **Node Version**: Node.js 18+ (LTS) required for Next.js 15
- **CI/CD**: GitHub Actions workflow for linting, type checking, and test execution
- **Environment**: Single `.env.local` file for local development (though no secrets needed)
- **Deployment Target**: Vercel (optimal Next.js hosting) or any Node.js hosting platform
- **Browser Support**: Modern evergreen browsers (last 2 versions of Chrome, Firefox, Safari, Edge)
- **Type Safety**: Zod schemas for API response validation in addition to TypeScript types
- **Error Tracking**: Console logging sufficient (no external error tracking for MVP)
- **Performance Monitoring**: React DevTools and Lighthouse audits (no external APM)

---
