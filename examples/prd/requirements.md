# Requirements

## Functional Requirements

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

## Non-Functional Requirements

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
