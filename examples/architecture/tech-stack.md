# Tech Stack

## Technology Stack Table

| Category | Technology | Version | Purpose | Rationale |
|----------|-----------|---------|---------|-----------|
| Frontend Language | TypeScript | 5.3+ | Type-safe development | Catches errors at compile time; required for strict mode (NFR12) |
| Frontend Framework | Next.js | 15.x | React meta-framework with App Router | PRD requirement (NFR14); provides RSC, routing, and image optimization |
| Runtime | Node.js | 18+ LTS | JavaScript runtime | Required for Next.js 15; stable LTS support |
| UI Component Library | shadcn/ui | Latest | Accessible Radix-based components | PRD requirement (NFR15); meets WCAG AA standards (NFR5) |
| UI Primitives | Radix UI | Latest | Headless accessible components | Foundation for shadcn/ui; keyboard navigation (NFR17) |
| State Management | TanStack Query (React Query) | 5.x | Server state and cache management | PRD requirement (NFR9); optimistic updates (NFR10) |
| Forms | React Hook Form | 7.x | Form state management | PRD requirement (NFR19); performant re-renders |
| Validation | Zod | 3.x | Runtime type validation | PRD requirement (NFR13); validates API responses and forms |
| Styling | Tailwind CSS | 3.x | Utility-first CSS framework | PRD requirement (NFR15); rapid UI development |
| Notifications | Sonner | Latest | Toast notification system | PRD requirement (NFR11); accessible announcements |
| HTTP Client | Native Fetch API | Browser native | HTTP requests | PRD specifies no Axios; modern browser support |
| Frontend Testing | Jest + React Testing Library | Latest | Unit and integration tests | PRD requirement (NFR20); React-focused testing |
| E2E Testing | Playwright | Latest | End-to-end browser testing | PRD requirement (NFR21); multi-browser support |
| Image Optimization | next/image | Built-in (Next.js) | Automatic image optimization | PRD requirement (NFR16); WebP conversion and lazy loading |
| Package Manager | pnpm | 8.x | Fast package management | PRD preference; efficient disk usage and faster installs |
| Code Quality | ESLint | 8.x | Linting and code standards | PRD requirement; Next.js recommended rules |
| Code Formatting | Prettier | 3.x | Code formatting | PRD requirement; consistent style across team |
| Git Hooks | Husky + lint-staged | Latest | Pre-commit quality checks | PRD requirement; prevents bad commits |
| CI/CD | GitHub Actions | N/A | Automated testing and deployment | PRD requirement; free for public repos |
| Deployment Platform | Vercel | N/A | Hosting and CDN | PRD recommendation; optimal Next.js hosting |
| Monitoring | Vercel Analytics | N/A | Web Vitals and performance | Lightweight monitoring; no external APM needed |
| Error Logging | Console + React Error Boundaries | Browser native | Error tracking | PRD specifies console logging sufficient (NFR) |

---
