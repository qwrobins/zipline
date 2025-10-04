# Unified Project Structure

```
mini-social-feed/
├── .github/                    # CI/CD workflows
│   └── workflows/
│       ├── ci.yml             # Lint, type-check, test
│       └── deploy.yml         # Vercel deployment
├── app/                        # Next.js 15 App Router
│   ├── layout.tsx             # Root layout with providers
│   ├── page.tsx               # Posts feed (/)
│   ├── error.tsx              # Error boundary
│   ├── loading.tsx            # Global loading UI
│   ├── not-found.tsx          # 404 page
│   ├── posts/
│   │   └── [id]/
│   │       ├── page.tsx       # Post detail page
│   │       ├── loading.tsx
│   │       └── error.tsx
│   ├── users/
│   │   ├── page.tsx           # User directory
│   │   ├── loading.tsx
│   │   └── [id]/
│   │       ├── page.tsx       # User profile
│   │       └── loading.tsx
│   └── todos/
│       ├── page.tsx           # Global todos
│       └── loading.tsx
├── components/
│   ├── ui/                     # shadcn/ui components
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── input.tsx
│   │   ├── avatar.tsx
│   │   ├── badge.tsx
│   │   ├── skeleton.tsx
│   │   ├── tabs.tsx
│   │   ├── dialog.tsx
│   │   ├── navigation-menu.tsx
│   │   ├── select.tsx
│   │   ├── textarea.tsx
│   │   └── separator.tsx
│   ├── posts/                  # Post components
│   │   ├── post-card.tsx
│   │   ├── post-detail.tsx
│   │   ├── post-list.tsx
│   │   └── post-filters.tsx
│   ├── comments/               # Comment components
│   │   ├── comment-list.tsx
│   │   ├── comment-item.tsx
│   │   ├── comment-form.tsx
│   │   └── comment-actions.tsx
│   ├── users/                  # User components
│   │   ├── user-card.tsx
│   │   ├── user-profile.tsx
│   │   ├── user-directory.tsx
│   │   └── user-avatar.tsx
│   ├── todos/                  # Todo components
│   │   ├── todo-list.tsx
│   │   ├── todo-item.tsx
│   │   ├── todo-form.tsx
│   │   └── todo-filters.tsx
│   └── shared/                 # Shared components
│       ├── navigation.tsx
│       ├── pagination.tsx
│       ├── search-input.tsx
│       ├── error-boundary.tsx
│       └── loading-skeleton.tsx
├── lib/
│   ├── api/                    # API client and services
│   │   ├── client.ts          # Base API client
│   │   ├── schemas.ts         # Zod schemas
│   │   ├── posts.ts
│   │   ├── comments.ts
│   │   ├── users.ts
│   │   └── todos.ts
│   ├── hooks/                  # React Query hooks
│   │   ├── use-posts.ts
│   │   ├── use-comments.ts
│   │   ├── use-users.ts
│   │   └── use-todos.ts
│   └── utils/                  # Utility functions
│       ├── cn.ts              # Class name utility
│       ├── format.ts          # Formatters
│       └── validators.ts      # Form validators
├── types/
│   └── index.ts               # TypeScript type definitions
├── public/                     # Static assets
│   └── images/
├── tests/
│   ├── unit/                  # Jest unit tests
│   │   ├── components/
│   │   ├── hooks/
│   │   └── utils/
│   ├── integration/           # Integration tests
│   │   └── flows/
│   └── e2e/                   # Playwright E2E tests
│       ├── posts.spec.ts
│       ├── comments.spec.ts
│       ├── users.spec.ts
│       └── todos.spec.ts
├── .env.example               # Environment variable template
├── .env.local                 # Local environment (gitignored)
├── .eslintrc.json            # ESLint configuration
├── .prettierrc.json          # Prettier configuration
├── components.json            # shadcn/ui configuration
├── next.config.js            # Next.js configuration
├── package.json              # Dependencies and scripts
├── pnpm-lock.yaml           # Lock file
├── postcss.config.js        # PostCSS configuration
├── tailwind.config.ts       # Tailwind configuration
├── tsconfig.json            # TypeScript configuration
└── README.md                # Project documentation
```

---
