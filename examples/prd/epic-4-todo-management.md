# Epic 4: Todo Management

**Goal**: Build a comprehensive todo management system allowing users to view, create, toggle completion, filter, and reassign todos. This epic demonstrates complex state management with optimistic updates across multiple views (user profiles and global todos), delivering a complete task management feature that showcases form handling, filtering, and multi-entity updates.

## Story 4.1: Todo Toggle Completion (Optimistic UI)

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

## Story 4.2: Create New Todo (Optimistic UI)

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

## Story 4.3: Filter Todos by Status

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

## Story 4.4: Reassign Todo to Different User

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

## Story 4.5: Global Todos View

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
