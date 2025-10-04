# Epic 1: Foundation & Posts Feed

**Goal**: Establish the complete project foundation including Next.js 15 setup, TypeScript configuration, Tailwind CSS, shadcn/ui components, React Query, and deliver the first user-facing feature: a fully functional posts feed with search, filtering, pagination, and post detail views. This epic delivers immediate value by allowing users to browse and read posts while setting up all infrastructure for subsequent epics.

## Story 1.1: Project Initialization & Core Setup

As a **developer**,
I want **a properly initialized Next.js 15 project with TypeScript, Tailwind, ESLint, and Prettier configured**,
so that **the team has a solid foundation with proper tooling and code quality standards from day one**.

**Acceptance Criteria:**

1. Next.js 15 application created using App Router with TypeScript and strict mode enabled
2. Tailwind CSS v3+ installed and configured with proper PostCSS setup
3. ESLint configured with Next.js and TypeScript recommended rules
4. Prettier configured with consistent formatting rules and integration with ESLint
5. Package.json includes all core dependencies: react-query, react-hook-form, zod, sonner
6. Git repository initialized with .gitignore properly configured for Next.js projects
7. Basic folder structure created: `/app`, `/components`, `/lib`, `/types`
8. Development server runs successfully with default Next.js welcome page
9. TypeScript compilation succeeds with no errors

## Story 1.2: shadcn/ui Setup & Design System Foundation

As a **developer**,
I want **shadcn/ui initialized with core components and a consistent design system**,
so that **all UI development uses accessible, styled components with a unified look and feel**.

**Acceptance Criteria:**

1. shadcn/ui CLI installed and configuration file (components.json) created
2. Core components installed: Button, Card, Input, Avatar, Badge, Skeleton, Separator
3. Additional components installed: NavigationMenu, Tabs, Select, Textarea, Tooltip, Dialog, DropdownMenu
4. Tailwind theme extended with custom design tokens (colors, spacing, typography)
5. Global CSS includes shadcn/ui base styles and custom utility classes
6. Component documentation or Storybook-like page created showing all installed components
7. Dark mode setup completed using next-themes (if time permits) or placeholder for future implementation

## Story 1.3: API Client & React Query Setup

As a **developer**,
I want **a configured API client with React Query for data fetching and caching**,
so that **all data operations have consistent error handling, loading states, and cache management**.

**Acceptance Criteria:**

1. React Query provider configured in root layout with sensible defaults (staleTime, cacheTime, retry logic)
2. API client utility created with base URL for JSONPlaceholder (https://jsonplaceholder.typicode.com)
3. TypeScript types defined for all JSONPlaceholder entities (Post, User, Comment, Todo)
4. Zod schemas created for runtime validation of API responses
5. Custom hooks created: `usePosts`, `usePost`, `useUsers`, `useUser`
6. Error handling utility for API failures with user-friendly messages
7. React Query DevTools installed and accessible in development mode
8. Sonner toast provider configured in root layout for global notifications

## Story 1.4: Global Navigation & Layout

As a **user**,
I want **a consistent navigation bar and page layout across the application**,
so that **I can easily navigate between Posts, Users, and Todos sections**.

**Acceptance Criteria:**

1. Root layout component includes global navigation menu with links to: Posts (`/`), Users (`/users`), Todos (`/todos`)
2. Navigation menu uses shadcn/ui NavigationMenu component with responsive behavior
3. Active route highlighted in navigation menu
4. Mobile-responsive navigation (hamburger menu or similar pattern for small screens)
5. Layout includes proper semantic HTML (header, nav, main, footer)
6. Footer displays app name and version or simple credit
7. Page transitions are smooth without layout shift
8. Navigation menu includes visual branding (app title/logo placeholder)

## Story 1.5: Posts Feed - List View with Pagination

As a **user**,
I want **to see a paginated list of posts from all users**,
so that **I can browse content without being overwhelmed by loading all posts at once**.

**Acceptance Criteria:**

1. Posts feed page (`/` or `/posts`) displays posts in Card components (10 posts per page)
2. Each post card shows: title (truncated if needed), body excerpt (first 100 chars), author avatar and name
3. Loading skeletons displayed while posts are being fetched
4. Empty state message shown if no posts exist
5. Error boundary catches and displays user-friendly error message with retry button
6. Pagination controls displayed at bottom of list (Previous/Next buttons with current page indicator)
7. URL reflects current page via query parameter (`?page=2`)
8. Browser back/forward buttons work correctly with pagination
9. Page parameter persists across navigation and refreshes
10. Post author information fetched efficiently (single users request or joined data)

## Story 1.6: Posts Feed - Search and Filter

As a **user**,
I want **to search posts by keywords and filter by specific authors**,
so that **I can quickly find relevant content**.

**Acceptance Criteria:**

1. Search input field above posts list allows text entry
2. Search filters posts by title or body content (client-side or API parameter if supported)
3. Search query reflected in URL parameter (`?q=searchterm`)
4. User dropdown/select allows filtering by specific author
5. Author filter reflected in URL parameter (`?userId=3`)
6. Search and filter can be combined (e.g., `?q=foo&userId=2`)
7. Clear/reset button removes active filters and returns to full list
8. Filter state persists across page refreshes via URL parameters
9. Debounced search input (300ms delay) to avoid excessive re-renders
10. Loading indicator or skeleton shown during filter application

## Story 1.7: Post Detail View with Comments

As a **user**,
I want **to click on a post to see its full content and all comments**,
so that **I can read the complete discussion**.

**Acceptance Criteria:**

1. Post detail page created at `/posts/[id]` route
2. Full post displayed with title, complete body text, and author information (avatar, name, email)
3. Author name is a clickable link to user profile (`/users/[userId]`)
4. Comments section below post displays all comments for that post
5. Each comment shows: commenter name, email, and comment body
6. Comment count badge displayed on post (e.g., "12 comments")
7. Loading skeleton shown while post and comments are being fetched
8. Error handling for missing post (404 state) or failed comment fetch
9. Back button or breadcrumb navigation to return to posts feed
10. Page metadata (title, description) set appropriately for SEO

---
