# Components

The application is organized into logical component groups that separate concerns and enable parallel development.

## API Service Layer

**Responsibility:** Abstraction layer over JSONPlaceholder API providing typed functions for all data operations.

**Key Interfaces:**
- `fetchPosts(params?: { userId?: number; page?: number })`: Fetch paginated posts
- `fetchPost(id: number)`: Fetch single post with error handling
- `fetchComments(postId: number)`: Fetch comments for a post
- `createComment(postId: number, data: CommentFormData)`: Mock create comment
- `updateComment(id: number, data: CommentFormData)`: Mock update comment
- `deleteComment(id: number)`: Mock delete comment
- `fetchUsers()`: Fetch all users
- `fetchUser(id: number)`: Fetch single user
- `fetchTodos(userId?: number)`: Fetch todos with optional user filter
- `createTodo(data: TodoFormData)`: Mock create todo
- `updateTodo(id: number, data: Partial<Todo>)`: Mock update todo

**Dependencies:** Native Fetch API, Zod schemas for validation

**Technology Stack:** TypeScript, Zod for runtime validation

## React Query Hooks

**Responsibility:** React Query hooks wrapping API service functions with caching, error handling, and optimistic updates.

**Key Interfaces:**
- `usePosts(filters)`: Query hook for posts with pagination
- `usePost(id)`: Query hook for single post
- `useComments(postId)`: Query hook for comments
- `useCreateComment()`: Mutation hook with optimistic update
- `useUpdateComment()`: Mutation hook with optimistic update
- `useDeleteComment()`: Mutation hook with optimistic update and undo
- `useUsers()`: Query hook for all users
- `useUser(id)`: Query hook for single user
- `useTodos(userId?, status?)`: Query hook for todos with filters
- `useCreateTodo()`: Mutation hook with optimistic update
- `useUpdateTodo()`: Mutation hook with optimistic update

**Dependencies:** API Service Layer, React Query client

**Technology Stack:** React Query v5, TypeScript

## UI Components

**Responsibility:** Presentational and interactive UI components built on shadcn/ui primitives.

**Key Interfaces:**
- `PostCard`: Display post summary with author info
- `PostDetail`: Full post view with comments section
- `CommentList`: Render list of comments with actions
- `CommentForm`: Form for creating/editing comments
- `UserCard`: User summary card for directory
- `UserProfile`: Detailed user profile with tabs
- `TodoItem`: Single todo with checkbox and actions
- `TodoList`: List of todos with filters
- `TodoForm`: Form for creating todos
- `Pagination`: Reusable pagination controls
- `SearchInput`: Debounced search input component
- `UserFilter`: Dropdown for filtering by user
- `Navigation`: Global navigation menu
- `ErrorBoundary`: Catch and display errors
- `LoadingSkeleton`: Loading state placeholders

**Dependencies:** shadcn/ui components, React Hook Form, Zod

**Technology Stack:** React 18, shadcn/ui, Tailwind CSS

## Layout Components

**Responsibility:** Page-level layout components and navigation structure.

**Key Interfaces:**
- `RootLayout`: Global layout with navigation and providers
- `PostsLayout`: Layout for posts feed and detail pages
- `UsersLayout`: Layout for user directory and profiles
- `TodosLayout`: Layout for todos page

**Dependencies:** Next.js App Router layouts, Navigation component

**Technology Stack:** Next.js 15 App Router, React Server Components

---
