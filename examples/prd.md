# Mini Social Feed Product Requirements Document (PRD)

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2025-09-30 | 1.0 | Initial PRD draft from product brief | John (PM) |

---

## Goals and Background Context

### Goals

- Build a non-trivial web app to test AI development workflows (requirements → user stories → implementation → tests)
- Create a realistic social feed application (Twitter/Reddit-style) using only JSONPlaceholder API
- Demonstrate complete CRUD operations with optimistic UI patterns without requiring backend infrastructure
- Provide an accessible, zero-setup application requiring no authentication or user accounts
- Validate the BMAD workflow system with a real-world project scenario

### Background Context

The Mini Social Feed project addresses the need for a realistic testing ground for AI-assisted development workflows. Traditional demo applications often oversimplify real-world complexity or require extensive backend setup that distracts from workflow experimentation. By leveraging JSONPlaceholder's public API and implementing mock CRUD with optimistic UI patterns, this project creates a non-trivial application that mimics production patterns (state management, form handling, error boundaries, loading states) while remaining completely self-contained and accessible. The app enables anyone to instantly experience a fully functional social platform without authentication barriers, making it ideal for demonstrating development methodologies and AI agent coordination.

---

## Requirements

### Functional Requirements

**FR1:** The system shall display a paginated list of posts fetched from JSONPlaceholder `/posts` endpoint

**FR2:** The system shall allow users to click on a post to view its full details including title, body, and author information

**FR3:** The system shall display author name and avatar (generated from initials) on each post card

**FR4:** The system shall provide a search interface to filter posts by title or body content

**FR5:** The system shall allow filtering posts by author/user

**FR6:** The system shall display a directory of all users fetched from JSONPlaceholder `/users` endpoint

**FR7:** The system shall display individual user profiles showing contact information, company details, and address

**FR8:** The system shall display all posts authored by a specific user on their profile page

**FR9:** The system shall display all todos associated with a specific user on their profile page

**FR10:** The system shall display a static map placeholder for user addresses (no real map integration)

**FR11:** The system shall display all comments under a post detail view

**FR12:** The system shall allow users to add new comments with optimistic UI updates (mock POST to JSONPlaceholder)

**FR13:** The system shall allow users to edit existing comments with optimistic UI updates (mock PUT to JSONPlaceholder)

**FR14:** The system shall allow users to delete comments with optimistic UI updates and undo capability (mock DELETE to JSONPlaceholder)

**FR15:** The system shall display comment count badges on post cards

**FR16:** The system shall display todos for individual users with completion status

**FR17:** The system shall allow users to toggle todo completion state with optimistic UI updates (mock PATCH to JSONPlaceholder)

**FR18:** The system shall allow users to create new todos with optimistic UI updates (mock POST to JSONPlaceholder)

**FR19:** The system shall provide filtering for todos by completion status (completed/open)

**FR20:** The system shall allow reassignment of todos to different users with optimistic UI updates

**FR21:** The system shall provide a global todos list view accessible via `/todos` route

**FR22:** The system shall use URL parameters for pagination, search queries, and filters (e.g., `?page=2&q=foo&userId=3`)

### Non-Functional Requirements

**NFR1:** The system shall require no authentication, login, signup, or OAuth - all routes must be publicly accessible

**NFR2:** The system shall not implement any backend database or data persistence layer

**NFR3:** The system shall not require any API keys, credentials, or secrets for operation

**NFR4:** The system shall handle all write operations (POST/PUT/PATCH/DELETE) as mock requests with optimistic UI updates only

**NFR5:** The system shall meet WCAG AA accessibility standards leveraging Radix primitives and shadcn/ui defaults

**NFR6:** The system shall display loading skeletons during data fetching operations

**NFR7:** The system shall implement error boundaries with retry capabilities for graceful failure handling

**NFR8:** The system shall display empty states when no data is available

**NFR9:** The system shall use React Query (TanStack Query) for data fetching, caching, and state management

**NFR10:** The system shall implement optimistic updates with automatic rollback on failure

**NFR11:** The system shall display toast notifications (using sonner) for user actions and system feedback

**NFR12:** The system shall implement proper TypeScript typing throughout the codebase with strict mode enabled

**NFR13:** The system shall use Zod schemas for form validation

**NFR14:** The system shall be built using Next.js 15 App Router architecture

**NFR15:** The system shall use Tailwind CSS for styling and shadcn/ui components for UI primitives

**NFR16:** The system shall optimize images using next/image for static assets

**NFR17:** The system shall implement proper focus management and keyboard navigation

**NFR18:** The system shall be responsive and usable across desktop and mobile viewports

**NFR19:** The system shall use React Hook Form for form state management

**NFR20:** The system shall include unit tests using Jest + React Testing Library

**NFR21:** The system shall include end-to-end tests using Playwright

---

## User Interface Design Goals

### Overall UX Vision

The Mini Social Feed aims to deliver a familiar, intuitive social media experience that feels polished and production-ready despite its mock backend. The interface should emphasize clarity, responsiveness, and immediate feedback through optimistic UI patterns. Users should feel the application is "real" with smooth interactions, loading states, and visual feedback that mirrors modern social platforms like Twitter or Reddit.

### Key Interaction Paradigms

- **Optimistic UI First**: All write operations (comments, todos) update immediately with visual confirmation via toast notifications
- **Progressive Disclosure**: Post lists show summaries; clicking reveals full details with comments
- **Inline Actions**: Quick actions (todo toggle, comment delete) available directly in context without modal dialogs
- **Search-as-you-type**: Real-time filtering of posts and todos as users enter search terms
- **Persistent Navigation**: Global navigation menu provides consistent access to Posts, Users, and Todos sections

### Core Screens and Views

- **Posts Feed** (`/`) - Paginated post list with search/filter controls and author avatars
- **Post Detail** (`/posts/[id]`) - Full post content with nested comments section and comment management
- **User Directory** (`/users`) - Grid or list of all users with avatars and basic info
- **User Profile** (`/users/[id]`) - User details, address map placeholder, posts tab, and todos tab
- **Global Todos** (`/todos`) - Filterable todo list across all users with status toggles

### Accessibility: WCAG AA

Leveraging shadcn/ui (Radix primitives), the application will meet WCAG AA standards including:
- Proper ARIA labels and roles
- Keyboard navigation support
- Focus visible indicators
- Sufficient color contrast ratios
- Screen reader compatibility
- Skip navigation links

### Branding

Minimal, clean design following modern SaaS aesthetics:
- Neutral color palette with accent colors for actions
- System font stack for readability
- Generous whitespace and clear visual hierarchy
- Subtle shadows and borders for depth
- Avatar generation using user initials with color-coded backgrounds

### Target Device and Platforms: Web Responsive

Responsive web application optimized for:
- Desktop browsers (1024px+)
- Tablet devices (768px-1023px)
- Mobile devices (320px-767px)
- Touch and mouse/keyboard interactions

---

## Technical Assumptions

### Repository Structure: Monorepo

Single repository structure appropriate for this self-contained application with no separate services.

### Service Architecture

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

### Testing Requirements

**Full Testing Pyramid**:
- **Unit Tests**: Jest + React Testing Library for components, hooks, and utilities
- **Integration Tests**: React Testing Library for multi-component interactions and form flows
- **E2E Tests**: Playwright for critical user journeys (post viewing, comment creation, todo management)
- **Manual Testing**: Development server with hot reload for rapid iteration

Test coverage expectations:
- Utility functions: 90%+ coverage
- React components: 70%+ coverage
- Critical paths (CRUD operations): 100% E2E coverage

### Additional Technical Assumptions and Requests

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

## Epic List

**Epic 1: Foundation & Posts Feed** - Establish project infrastructure, setup Next.js app with all dependencies, implement routing, and deliver a fully functional posts feed with search, filtering, and pagination.

**Epic 2: User Profiles & Directory** - Create user directory and individual user profile pages displaying user information, posts, todos, and address visualization.

**Epic 3: Comments & Engagement** - Implement complete comment functionality on posts including viewing, creating, editing, and deleting with optimistic UI patterns.

**Epic 4: Todo Management** - Build comprehensive todo system with creation, completion toggling, filtering, reassignment, and global todos view.

---

## Epic 1: Foundation & Posts Feed

**Goal**: Establish the complete project foundation including Next.js 15 setup, TypeScript configuration, Tailwind CSS, shadcn/ui components, React Query, and deliver the first user-facing feature: a fully functional posts feed with search, filtering, pagination, and post detail views. This epic delivers immediate value by allowing users to browse and read posts while setting up all infrastructure for subsequent epics.

### Story 1.1: Project Initialization & Core Setup

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

### Story 1.2: shadcn/ui Setup & Design System Foundation

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

### Story 1.3: API Client & React Query Setup

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

### Story 1.4: Global Navigation & Layout

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

### Story 1.5: Posts Feed - List View with Pagination

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

### Story 1.6: Posts Feed - Search and Filter

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

### Story 1.7: Post Detail View with Comments

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

## Epic 2: User Profiles & Directory

**Goal**: Create a comprehensive user directory and detailed profile pages that display user information, their posts, todos, and a visual representation of their address. This epic enables users to explore content by author and understand user context, delivering value through improved content discovery and user relationship visualization.

### Story 2.1: User Directory Page

As a **user**,
I want **to see a list of all users in the system**,
so that **I can discover authors and navigate to their profiles**.

**Acceptance Criteria:**

1. User directory page created at `/users` route
2. All users displayed in a responsive grid (3-4 columns on desktop, 1-2 on mobile)
3. Each user card shows: avatar (generated from initials), name, username, email, and company name
4. User cards are clickable and navigate to individual profile page (`/users/[id]`)
5. Loading skeletons displayed while users are being fetched
6. Empty state displayed if no users found (unlikely with JSONPlaceholder)
7. Error boundary handles API failures with retry option
8. User avatars have consistent color-coding based on user ID or name hash

### Story 2.2: User Profile - Basic Information

As a **user**,
I want **to view detailed information about a specific user**,
so that **I can learn more about an author**.

**Acceptance Criteria:**

1. User profile page created at `/users/[id]` route
2. Profile header displays: large avatar, name, username, email
3. Contact information section shows: phone, website (as clickable link)
4. Company information section shows: company name, catch phrase, business type (bs)
5. Address section shows: street, suite, city, zipcode
6. Static map placeholder image displayed for address (can be a simple colored box with "Map" text)
7. Loading skeleton shown while user data is being fetched
8. Error handling for missing user (404 state)
9. Breadcrumb navigation back to users directory

### Story 2.3: User Profile - Posts Tab

As a **user**,
I want **to see all posts written by a specific user on their profile**,
so that **I can explore an author's content in one place**.

**Acceptance Criteria:**

1. Tabbed interface on user profile with "Posts" as first tab (using shadcn/ui Tabs)
2. Posts tab displays all posts by that user in a list format
3. Each post item shows: title, body excerpt, and link to full post detail
4. Post count displayed in tab label (e.g., "Posts (10)")
5. Empty state message if user has no posts
6. Loading skeleton shown while posts are being fetched
7. Posts are clickable and navigate to post detail page
8. API efficiently fetches only posts for this user (`/users/{id}/posts` or filtered)

### Story 2.4: User Profile - Todos Tab

As a **user**,
I want **to see all todos for a specific user on their profile**,
so that **I can understand what tasks they're working on**.

**Acceptance Criteria:**

1. "Todos" tab added to user profile tabbed interface
2. Todos tab displays all todos for that user in a list format
3. Each todo shows: title, completion checkbox (checked/unchecked based on `completed` status)
4. Todo count displayed in tab label with completion summary (e.g., "Todos (8/20)")
5. Completed todos visually distinguished (strikethrough text, muted color)
6. Empty state message if user has no todos
7. Loading skeleton shown while todos are being fetched
8. API efficiently fetches only todos for this user (`/users/{id}/todos` or filtered)
9. Todos are displayed but not yet interactive (toggle functionality in Epic 4)

### Story 2.5: Address Visualization Enhancement

As a **user**,
I want **a visual representation of a user's location**,
so that **I have a sense of their geographic context**.

**Acceptance Criteria:**

1. Static map placeholder replaced with a more polished visual (can use a service like placeholder.com with map styling)
2. Address coordinates (lat/lng) displayed below address text
3. Map placeholder sized appropriately (e.g., 400x200px) and responsive
4. Optional: Use a static map service (Mapbox Static API, Google Static Maps) with no API key required, or an SVG placeholder
5. Fallback handling if map service unavailable
6. Map visual clearly indicates this is non-interactive (no zoom, pan controls)

---

## Epic 3: Comments & Engagement

**Goal**: Implement full comment functionality allowing users to view, create, edit, and delete comments on posts using optimistic UI patterns. This epic delivers core engagement features that make the application feel interactive and dynamic, demonstrating complete CRUD operations with immediate user feedback despite mock backend operations.

### Story 3.1: View Comments on Post Detail

As a **user**,
I want **to see all comments on a post in a clear, organized format**,
so that **I can read the discussion and understand different perspectives**.

**Acceptance Criteria:**

1. Comments section rendered below post content on post detail page
2. Each comment displays: commenter name, email, timestamp (mock or post ID-based), and full comment body
3. Comments ordered chronologically (oldest first or newest first with toggle option)
4. Comment count badge shows accurate number (e.g., "23 Comments")
5. Empty state message displayed if no comments exist ("No comments yet. Be the first!")
6. Loading skeletons shown while comments are being fetched
7. Comments visually separated from post content (using Separator component or spacing)
8. Comments responsive on mobile devices with proper text wrapping

### Story 3.2: Add New Comment (Optimistic UI)

As a **user**,
I want **to add my own comment to a post**,
so that **I can participate in the discussion**.

**Acceptance Criteria:**

1. Comment form displayed below existing comments with Name, Email, and Comment body fields
2. Form validation using Zod schema (name and email required, valid email format, body min length)
3. Submit button triggers optimistic insert: new comment immediately appears in list
4. Success toast notification displayed ("Comment added!")
5. Form clears after successful submission
6. Mock POST request sent to `/posts/{postId}/comments` with form data
7. Comment count badge increments immediately
8. New comment assigned temporary ID and added to top or bottom of list
9. Loading/submitting state shown on submit button during request
10. Error handling: if mock POST fails, rollback optimistic update and show error toast

### Story 3.3: Edit Comment (Optimistic UI)

As a **user**,
I want **to edit my comment after posting it**,
so that **I can fix mistakes or update my thoughts**.

**Acceptance Criteria:**

1. Edit button (icon or text) displayed on each comment (in dropdown menu or inline)
2. Clicking edit opens inline edit form or dialog with current comment text
3. Edit form includes same validation as create form (Zod schema)
4. Submitting edit triggers optimistic update: comment text updates immediately in list
5. Success toast notification displayed ("Comment updated!")
6. Mock PUT request sent to `/comments/{id}` with updated data
7. Cancel button reverts to original comment text without saving
8. Error handling: if mock PUT fails, rollback optimistic update and show error toast
9. Loading/submitting state shown during request

### Story 3.4: Delete Comment (Optimistic UI with Undo)

As a **user**,
I want **to delete my comment**,
so that **I can remove content I no longer want visible**.

**Acceptance Criteria:**

1. Delete button (icon or text) displayed on each comment (in dropdown menu or inline)
2. Clicking delete triggers immediate optimistic removal: comment disappears from list
3. Toast notification displayed with undo option ("Comment deleted. Undo?")
4. Comment count badge decrements immediately
5. Mock DELETE request sent to `/comments/{id}`
6. Undo button in toast restores comment to list and cancels DELETE request
7. Toast auto-dismisses after 5 seconds if no undo action taken
8. Error handling: if mock DELETE fails and user didn't undo, restore comment and show error toast
9. Confirmation dialog optional (consider for better UX, but optimistic + undo may be sufficient)

### Story 3.5: Comment Count Badges on Feed

As a **user**,
I want **to see comment counts on post cards in the feed**,
so that **I can identify popular or active discussions**.

**Acceptance Criteria:**

1. Comment count badge displayed on each post card in feed (e.g., "💬 12" or icon with number)
2. Badge uses shadcn/ui Badge component with appropriate styling
3. Comment counts fetched efficiently (consider `/posts` with comments count or separate query)
4. Badge is clickable and navigates to post detail page, scrolling to comments section
5. Zero comments shown as "0" or hidden badge (design decision)
6. Badge updates optimistically when user adds/deletes comment from post detail page
7. Loading state: show badge with "..." or skeleton if count not yet loaded

---

## Epic 4: Todo Management

**Goal**: Build a comprehensive todo management system allowing users to view, create, toggle completion, filter, and reassign todos. This epic demonstrates complex state management with optimistic updates across multiple views (user profiles and global todos), delivering a complete task management feature that showcases form handling, filtering, and multi-entity updates.

### Story 4.1: Todo Toggle Completion (Optimistic UI)

As a **user**,
I want **to mark todos as complete or incomplete with a single click**,
so that **I can track progress on tasks**.

**Acceptance Criteria:**

1. Checkbox displayed next to each todo item on user profile Todos tab
2. Clicking checkbox toggles completion state immediately (optimistic update)
3. Completed todos visually distinguished: strikethrough text, muted color, checked checkbox
4. Mock PATCH request sent to `/todos/{id}` with updated `completed` status
5. Success toast notification optional (may be too noisy for toggle action)
6. Error handling: if mock PATCH fails, rollback toggle and show error toast
7. Todo count summary updates immediately (e.g., "8/20 completed")
8. Toggle animation smooth (checkbox transition, text styling change)

### Story 4.2: Create New Todo (Optimistic UI)

As a **user**,
I want **to create new todos for users**,
so that **I can add tasks to any user's list**.

**Acceptance Criteria:**

1. "Add Todo" button or form displayed on user profile Todos tab
2. Form includes: Todo title (required), User select dropdown (pre-filled with current profile user, but changeable)
3. Form validation using Zod schema (title required, min 3 characters)
4. Submitting form triggers optimistic insert: new todo immediately appears in list as incomplete
5. Success toast notification displayed ("Todo created!")
6. Form clears after successful submission
7. Mock POST request sent to `/todos` with form data
8. New todo assigned temporary ID and added to top of todos list
9. Todo count increments immediately
10. Error handling: if mock POST fails, remove optimistic todo and show error toast

### Story 4.3: Filter Todos by Status

As a **user**,
I want **to filter todos by completion status**,
so that **I can focus on open tasks or review completed work**.

**Acceptance Criteria:**

1. Filter controls displayed above todos list (radio buttons or select dropdown)
2. Filter options: All, Open (incomplete), Completed
3. Selecting filter immediately updates displayed todos list
4. Filter state reflected in URL query parameter (`?status=completed`)
5. Filter persists across page refreshes and browser navigation
6. Empty state message displayed if no todos match filter (e.g., "No open todos!")
7. Todo count summary respects current filter (e.g., "Showing 8 of 20 todos")
8. Filter applies to both user profile Todos tab and global todos view

### Story 4.4: Reassign Todo to Different User

As a **user**,
I want **to reassign a todo to a different user**,
so that **I can move tasks to the appropriate person**.

**Acceptance Criteria:**

1. Edit/reassign button displayed on each todo item (dropdown menu or inline action)
2. Clicking reassign opens dropdown or dialog with user select dropdown
3. User dropdown populated with all users from `/users` endpoint
4. Selecting new user triggers optimistic update: todo disappears from current user's list (if viewing profile)
5. Success toast notification displayed ("Todo reassigned to [Username]!")
6. Mock PATCH request sent to `/todos/{id}` with updated `userId`
7. Error handling: if mock PATCH fails, restore todo to original user and show error toast
8. Todo counts update appropriately on both users' profiles
9. If viewing global todos, reassigned todo updates user label immediately

### Story 4.5: Global Todos View

As a **user**,
I want **to see all todos from all users in one consolidated view**,
so that **I can get an overview of all tasks in the system**.

**Acceptance Criteria:**

1. Global todos page created at `/todos` route
2. All todos displayed in a list with user identification (avatar, name next to each todo)
3. Each todo item shows: checkbox, title, completion status, assigned user (clickable link to profile)
4. Filter controls available (All, Open, Completed) same as user profile view
5. Search input allows filtering by todo title text
6. Pagination implemented if todo count exceeds 20 items per page
7. Loading skeletons shown while todos are being fetched
8. Empty state displayed if no todos exist
9. All interactive features functional: toggle completion, reassign, create new todo
10. User links in todo items navigate to respective user profiles

---

## Checklist Results Report

### PRD VALIDATION REPORT - Mini Social Feed

#### Executive Summary

**Overall PRD Completeness:** 85%
**MVP Scope Appropriateness:** Just Right
**Readiness for Architecture Phase:** Ready
**Most Critical Gaps:**
- Limited business goals/success metrics (workflow testing focus vs. traditional product metrics)
- Minimal user research context (demo/testing app vs. real product)
- Some non-functional requirements need quantification (performance targets, browser versions)

**Overall Assessment:** The PRD is well-structured and comprehensive for its purpose as a workflow testing application. While it lacks traditional product elements like market research and business KPIs (by design), it provides excellent technical clarity and complete functional requirements. Ready for architect with minor recommendations.

#### Category Analysis

| Category                         | Status  | Critical Issues                                                 |
| -------------------------------- | ------- | --------------------------------------------------------------- |
| 1. Problem Definition & Context  | PARTIAL | Limited business metrics; problem framed as workflow testing    |
| 2. MVP Scope Definition          | PASS    | None - excellent scope boundaries and rationale                 |
| 3. User Experience Requirements  | PASS    | None - comprehensive UI/UX goals with accessibility             |
| 4. Functional Requirements       | PASS    | None - all features well-defined and testable                   |
| 5. Non-Functional Requirements   | PARTIAL | Some NFRs need quantification (response times, browser support) |
| 6. Epic & Story Structure        | PASS    | None - excellent epic sequencing and story breakdown            |
| 7. Technical Guidance            | PASS    | None - comprehensive tech stack and constraints                 |
| 8. Cross-Functional Requirements | PARTIAL | Data models not explicitly defined; integration clear           |
| 9. Clarity & Communication       | PASS    | None - well-written and organized                               |

#### Top Issues by Priority

**BLOCKERS:** None - PRD is ready for architect to proceed.

**HIGH:**
1. Quantify Performance NFRs - Add specific response time targets (e.g., "Initial page load < 2s, API requests < 500ms")
2. Define Data Models - Document TypeScript interfaces for Post, User, Comment, Todo entities in PRD or reference where they'll be defined
3. Success Metrics - Add measurable success criteria beyond "all stories pass" (e.g., Lighthouse scores, test coverage %, build time)

**MEDIUM:**
4. Browser Support Specification - Currently says "modern evergreen browsers" but should specify exact versions
5. Error Logging Strategy - NFR mentions "console logging sufficient" but should specify log levels and error boundary patterns
6. User Personas - Even for demo app, defining 2-3 user personas would help

**LOW:**
7. Competitive Analysis - Not critical for workflow testing app
8. Future Enhancements Section - Stretch goals listed in brief but not carried into PRD Next Steps
9. Deployment Environment Details - Mentions Vercel but no environment variables, build configuration details

#### MVP Scope Assessment

**Features Appropriately Scoped:**
✅ All 4 epics deliver incremental value
✅ Story sizing appropriate for AI agent execution (2-4 hour chunks)
✅ No feature creep - stays focused on JSONPlaceholder CRUD
✅ Stretch goals appropriately deferred

#### Technical Readiness

**EXCELLENT** - Complete tech stack specified with no ambiguity for architect.

**Identified Technical Risks:**
1. React Query Optimistic Updates - Complex cache invalidation patterns need architectural patterns
2. Mock API Behavior - JSONPlaceholder returns 201 for POSTs but doesn't persist
3. State Synchronization - Keeping counts consistent across views requires careful design

#### Final Decision

✅ **READY FOR ARCHITECT**

The PRD provides comprehensive, well-structured requirements with excellent epic sequencing and story breakdown. Architect can proceed immediately.

---

## Next Steps

### UX Expert Prompt

*Note: This project has comprehensive UI/UX requirements already defined in the PRD. A dedicated UX phase is optional. If desired:*

**Prompt:** "Review the Mini Social Feed PRD (docs/prd.md) Section 3: User Interface Design Goals. Create high-fidelity mockups or interactive prototypes for the 5 core screens (Posts Feed, Post Detail, User Directory, User Profile, Global Todos) using shadcn/ui components. Focus on optimistic UI feedback patterns for CRUD operations and responsive layouts. Deliverables: Figma designs or shadcn/ui prototype pages."

### Architect Prompt

**Prompt:** "Review the Mini Social Feed PRD at docs/prd.md. Create a comprehensive technical architecture document covering: (1) Next.js 15 App Router structure with Server/Client Component boundaries, (2) React Query patterns for data fetching and optimistic updates with cache invalidation strategies, (3) Form handling architecture using React Hook Form + Zod, (4) Error boundary and error handling patterns, (5) Testing strategy for Jest/RTL unit tests and Playwright E2E tests, (6) TypeScript type definitions and Zod schemas for all JSONPlaceholder entities, (7) Component organization and folder structure. Output to docs/architecture.md."