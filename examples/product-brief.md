# Mini Social Feed — Product Brief (Next.js + TypeScript + Tailwind + shadcn/ui)

> **Goal:** A realistic “Twitter/Reddit-style” app powered only by JSONPlaceholder.  
> **No database. No authentication. 100% public and anonymous.**  
> All write operations are mocked with optimistic UI.

---

## 1) Purpose

Build a non-trivial web app to test AI development workflows: requirements → user stories → implementation → tests.  
The app consumes only **JSONPlaceholder** (`posts`, `users`, `comments`, `todos`) and performs **mock CRUD** (POST/PUT/PATCH/DELETE) with optimistic UI.  
No persistence, no auth, no secrets.

---

## 2) Public & Anonymous

- ✅ No authentication required (no login, no signup, no OAuth).  
- ✅ All routes are public.  
- ✅ JSONPlaceholder endpoints are public and require no API keys.  
- ✅ Mock writes (comments, todos) are handled with **optimistic UI** only.  
- ✅ No user tracking, sessions, or cookies beyond browser defaults.  
- ✅ Visitors remain anonymous — no profile, no account system.  

This ensures the app is **accessible to anyone instantly**, with zero setup or identity management.

---

## 3) Scope & Constraints

- **In scope:** posts feed, user directory & profiles, comments, todos, search/filter/sort, optimistic updates, file export.
- **Out of scope:** authentication, payments, real maps, real persistence, 3rd-party analytics.
- **Constraints:** No DB, no external credentials. All data fetched from JSONPlaceholder.

---

## 4) Tech Stack

- **Framework:** Next.js 15 (App Router)
- **Language:** TypeScript
- **Styling:** Tailwind CSS
- **UI:** **shadcn/ui** (Radix primitives)
- **Data fetching/cache:** React Query (TanStack Query)
- **HTTP:** Fetch (built-in) or Axios (optional)
- **Forms:** React Hook Form + Zod
- **Notifications:** `sonner` toasts (works great with shadcn)
- **Testing:** Jest + React Testing Library, Playwright (E2E)
- **Lint/Format:** ESLint + Prettier

---

## 5) High-Level Architecture

### Routes
- `/` → Posts feed (list, search, filter, pagination)
- `/posts/[id]` → Post detail + comments
- `/users` → User directory
- `/users/[id]` → Profile (info, posts, todos)
- `/todos` → Global todos list (optional shortcut)

### Data Endpoints (JSONPlaceholder)
- `GET /posts`, `GET /posts/:id`, `GET /posts/:id/comments`
- `GET /users`, `GET /users/:id`
- `GET /todos`
- Mock writes: `POST /comments`, `PUT /comments/:id`, `DELETE /comments/:id`, `PATCH /todos/:id`, `POST /todos`

### State & Data Flow
- **React Query** handles caching, loading/error states, retries, and invalidation.
- **Optimistic updates** for mock writes (comments/todos).
- **URL params** for pagination/query (e.g., `?page=2&q=foo&userId=3`).

---

## 6) UI System (shadcn/ui)

- **Global:** `NavigationMenu`, `Button`, `Input`, `Textarea`, `Select`, `Tabs`, `Badge`, `Tooltip`, `Dialog`/`Sheet`, `DropdownMenu`, `Avatar`, `Card`, `Separator`, `Skeleton`, `Toast` (sonner)
- **Lists:** `Card` for items, `Skeleton` placeholders, `Pagination` (custom with `Button`s)
- **Forms:** `Form`, `FormField`, `FormItem`, `FormLabel`, `FormMessage`, `Checkbox`, `Select`, `Input`, `Textarea`
- **Feedback:** `Alert`, `Toaster` (sonner), `Tooltip`, `Skeleton`, `Toast`
- **Navigation:** `NavigationMenu`, `Tabs`, `DropdownMenu`
- **Misc:** `Avatar` for user initials, `Badge` for counts/status, custom `Pagination` built from `Button`

---

## 7) Epics & User Stories (4 × 5)

### **Epic 1 — Posts Feed**
1. View a paginated list of posts.
2. Click a post to view details.
3. See author name and avatar on each post.
4. Search posts by title/body.
5. Filter posts by author.

---

### **Epic 2 — User Profiles**
1. View a list of all users.
2. Open a user profile with contact info.
3. View posts by that user.
4. View todos for that user.
5. Display user’s address on a static map placeholder.

---

### **Epic 3 — Comments**
1. View comments under a post.
2. Add a comment (mock POST, optimistic insert).
3. Edit a comment (mock PUT).
4. Delete a comment (mock DELETE with undo).
5. Show comment count badges on posts.

---

### **Epic 4 — Todos**
1. View todos for a user.
2. Toggle a todo completed state (mock PATCH).
3. Create a todo (mock POST).
4. Filter todos by completed/open.
5. Reassign a todo to a different user.

---

## 8) Non-Functional Requirements

- **Accessibility:** Radix + shadcn defaults; ensure labels, roles, focus rings, skip links.
- **Performance:** Use Suspense + streaming where helpful; paginate; memoize heavy lists; `next/image` for static assets.
- **Resilience:** Graceful error boundaries with retry; skeletons; empty states.
- **DX:** Strict TypeScript; Zod schemas for forms; clear module boundaries.

---

## 9) Success Criteria

- ✅ All 20 user stories demonstrably pass with UI + mocked write flows.  
- ✅ Entire app usable without authentication.  
- ✅ No backend or database needed.  
- ✅ Polished UX: skeletons, empty states, toast notifications.  
- ✅ Ready for workflow experimentation (epics → stories → tasks).  

---

## 10) Stretch Goals

- Export/import view data as JSON.
- Offline mode (cache GET responses with service worker).
- Light/dark theme toggle (next-themes + shadcn tokens).
- Batch actions on todos.
- Virtualized lists for performance.

---
