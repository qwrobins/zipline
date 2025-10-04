# Product Requirements Document
# Mini Social Feed Application

**Version:** 1.0
**Date:** October 1, 2025
**Author:** Product Management Team
**Status:** Draft for Review

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Problem Statement](#2-problem-statement)
3. [Goals and Objectives](#3-goals-and-objectives)
4. [User Personas](#4-user-personas)
5. [User Stories and Requirements](#5-user-stories-and-requirements)
6. [Technical Requirements](#6-technical-requirements)
7. [Non-Functional Requirements](#7-non-functional-requirements)
8. [Design Requirements](#8-design-requirements)
9. [Success Metrics](#9-success-metrics)
10. [Timeline and Milestones](#10-timeline-and-milestones)
11. [Risks and Mitigation](#11-risks-and-mitigation)
12. [Out of Scope](#12-out-of-scope)
13. [Appendix](#13-appendix)

---

## 1. Executive Summary

### 1.1 Product Overview

Mini Social Feed is a demonstration web application that simulates a Twitter/Reddit-style social platform. Built entirely with public APIs and requiring no authentication or backend infrastructure, it serves as a realistic testing ground for AI-assisted development workflows, from requirements gathering through implementation and testing.

### 1.2 Key Features

- **Posts Feed**: Browse, search, and filter social posts with pagination
- **User Profiles**: Explore user directories with detailed profile pages
- **Comments System**: View, add, edit, and delete comments with optimistic UI
- **Todo Management**: Create, update, and manage todos with filtering capabilities
- **Modern UI**: Polished interface using shadcn/ui components with Tailwind CSS
- **No Backend Required**: 100% client-side application using JSONPlaceholder API

### 1.3 Target Users

- Development teams testing AI coding workflows
- QA engineers validating test automation processes
- Product managers exploring requirement-to-implementation cycles
- Developers learning modern React patterns and optimistic UI

### 1.4 Business Value

This application provides a risk-free environment to:
- Test and validate AI-assisted development workflows
- Demonstrate modern frontend architecture patterns
- Train teams on React Query, optimistic updates, and component libraries
- Validate requirement specification and user story processes
- No infrastructure costs or security concerns

---

## 2. Problem Statement

### 2.1 Current Challenge

Development teams need realistic applications to test AI development workflows and modern frontend patterns, but:

- **Complexity**: Real applications require authentication, databases, and backend infrastructure
- **Cost**: Setting up test environments incurs hosting, database, and API costs
- **Security**: Test data and credentials create security concerns
- **Time**: Building complete systems takes significant time away from workflow testing
- **Maintenance**: Real backends require ongoing maintenance and updates

### 2.2 Proposed Solution

Mini Social Feed eliminates these barriers by:

- Using public JSONPlaceholder API (no setup required)
- Implementing mock write operations with optimistic UI (no persistence needed)
- Removing authentication entirely (no security surface area)
- Providing complete functionality without backend complexity
- Enabling immediate testing of development workflows

### 2.3 Success Definition

Success means development teams can immediately use this application to test workflows without spending time on infrastructure, authentication, or backend concerns.

---

## 3. Goals and Objectives

### 3.1 Primary Goals

1. **Workflow Testing**: Provide a realistic application for testing AI development workflows
2. **Zero Infrastructure**: Require no backend, database, or authentication setup
3. **Feature Completeness**: Implement all CRUD operations with realistic UX patterns
4. **Modern Patterns**: Demonstrate current best practices in React development
5. **Polish**: Deliver production-quality UI/UX despite being a demo

### 3.2 Measurable Objectives

| Objective | Target | Measurement Method |
|-----------|--------|-------------------|
| User Story Coverage | 100% (20/20 stories) | Manual verification checklist |
| Page Load Performance | < 2s initial load | Lighthouse audit |
| Accessibility Score | ≥ 90 | Lighthouse accessibility audit |
| Type Safety | 100% TypeScript coverage | Zero `any` types in production |
| Test Coverage | ≥ 80% | Jest coverage report |
| E2E Coverage | All critical paths | Playwright test suite |
| Error Handling | 100% of API failures | Error boundary coverage |
| Mobile Responsiveness | All breakpoints | Manual device testing |

### 3.3 Non-Goals

- Production-ready social network (it's a demo/test application)
- Real user data persistence (all writes are mocked)
- Scalability beyond JSONPlaceholder limits (100 posts, 10 users)
- Monetization or commercial features
- Real-time collaboration or WebSocket features

---

## 4. User Personas

### 4.1 Primary Persona: AI Workflow Developer

**Name**: Alex Chen
**Role**: Senior Software Engineer
**Age**: 32
**Experience**: 8 years in web development

**Goals:**
- Test AI coding assistants on realistic applications
- Validate requirement-to-implementation workflows
- Learn modern React patterns and libraries
- Demonstrate best practices to team

**Pain Points:**
- Setting up test backends takes too much time
- Authentication adds unnecessary complexity
- Real databases require maintenance
- Need complete features, not toy examples

**Usage Scenario:**
Alex receives a product brief and wants to test how well an AI assistant can translate requirements into working code. They need a realistic application scope without infrastructure overhead.

### 4.2 Secondary Persona: QA Automation Engineer

**Name**: Sarah Martinez
**Role**: QA Lead
**Age**: 29
**Experience**: 6 years in testing

**Goals:**
- Validate E2E testing frameworks and patterns
- Test optimistic UI behavior and error handling
- Create comprehensive test suites
- Train team on modern testing approaches

**Pain Points:**
- Test data management is complex
- Authentication complicates test setup
- Need stable, predictable API responses
- Real backends have too many variables

**Usage Scenario:**
Sarah wants to create a complete E2E test suite demonstrating best practices for testing modern React applications with optimistic updates.

### 4.3 Tertiary Persona: Product Manager

**Name**: Jordan Lee
**Role**: Product Manager
**Age**: 35
**Experience**: 10 years in product

**Goals:**
- Validate requirement specification processes
- Test user story breakdown approaches
- Demonstrate requirement-to-implementation cycles
- Train teams on effective documentation

**Pain Points:**
- Need complete examples showing requirements to implementation
- Want to validate story breakdown approaches
- Require realistic scope without real complexity
- Need to demonstrate value of good documentation

**Usage Scenario:**
Jordan wants to show their team how well-written requirements translate to working features by using this application as a case study.

---

## 5. User Stories and Requirements

### 5.1 Epic 1: Posts Feed

**Epic Goal**: Enable users to browse, search, and filter social posts efficiently.

#### Story 1.1: View Paginated Posts

**As a** visitor
**I want to** view posts in a paginated feed
**So that** I can browse content without overwhelming the page

**Acceptance Criteria:**
- [ ] Display 10 posts per page by default
- [ ] Show post title, body preview (truncated), author, and comment count
- [ ] Include pagination controls (Previous, Next, page numbers)
- [ ] Maintain page state in URL query parameters (`?page=2`)
- [ ] Show loading skeletons during fetch
- [ ] Display empty state if no posts available
- [ ] Cache pages using React Query

**Technical Requirements:**
- Fetch from `GET /posts?_page={page}&_limit=10`
- Use React Query with `keepPreviousData: true`
- Implement shadcn Card components for post items
- URL synchronization via Next.js router

**UI Components:**
- `Card` for post items
- `Skeleton` for loading states
- Custom `Pagination` component
- `EmptyState` component

#### Story 1.2: View Post Details

**As a** visitor
**I want to** click a post to view its full content
**So that** I can read the complete post and comments

**Acceptance Criteria:**
- [ ] Navigate to `/posts/[id]` on post click
- [ ] Display full post title and body
- [ ] Show author information with avatar
- [ ] Display comment count and list of comments
- [ ] Include back navigation to feed
- [ ] Handle invalid post IDs gracefully
- [ ] Show loading state during fetch

**Technical Requirements:**
- Fetch from `GET /posts/:id` and `GET /posts/:id/comments`
- Use React Query for data fetching
- Implement error boundary for 404s
- Breadcrumb navigation component

**UI Components:**
- `Card` for post content
- `Avatar` for author
- `Button` for navigation
- `Separator` between sections
- `Alert` for errors

#### Story 1.3: Display Author Information

**As a** visitor
**I want to** see author name and avatar on each post
**So that** I can identify who created the content

**Acceptance Criteria:**
- [ ] Display author name as clickable link to profile
- [ ] Show avatar with user initials (fallback)
- [ ] Include author information in post cards
- [ ] Make author name prominent but not overwhelming
- [ ] Fetch author data efficiently (avoid N+1 queries)

**Technical Requirements:**
- Join user data with posts (fetch users list once)
- Use `GET /users` for user information
- Implement avatar component with initials generator
- Cache user data with React Query

**UI Components:**
- `Avatar` component
- `Link` component
- `Tooltip` for author info

#### Story 1.4: Search Posts

**As a** visitor
**I want to** search posts by title or body text
**So that** I can find specific content quickly

**Acceptance Criteria:**
- [ ] Provide search input in header/above feed
- [ ] Filter posts by search query (client-side)
- [ ] Update results as user types (debounced)
- [ ] Maintain search query in URL (`?q=search+term`)
- [ ] Show count of filtered results
- [ ] Clear search button visible when searching
- [ ] Display "no results" state appropriately

**Technical Requirements:**
- Fetch all posts once, filter client-side
- Debounce search input (300ms)
- Case-insensitive search
- Search both title and body fields
- URL parameter synchronization

**UI Components:**
- `Input` with search icon
- `Button` for clear action
- `Badge` for result count
- `EmptyState` for no results

#### Story 1.5: Filter Posts by Author

**As a** visitor
**I want to** filter posts by author
**So that** I can view all content from a specific user

**Acceptance Criteria:**
- [ ] Provide author filter dropdown/select
- [ ] List all authors from users endpoint
- [ ] Filter posts to show only selected author's posts
- [ ] Allow clearing filter to show all posts
- [ ] Maintain filter state in URL (`?userId=3`)
- [ ] Combine with search if both active
- [ ] Update post count with filter active

**Technical Requirements:**
- Fetch users list for filter options
- Filter posts by `userId` field
- Support combining with search filter
- URL parameter synchronization

**UI Components:**
- `Select` for author filter
- `Badge` showing active filter
- `Button` to clear filters

---

### 5.2 Epic 2: User Profiles

**Epic Goal**: Allow users to explore and view detailed user information and content.

#### Story 2.1: View User Directory

**As a** visitor
**I want to** view a list of all users
**So that** I can explore who is in the community

**Acceptance Criteria:**
- [ ] Display all users from JSONPlaceholder (10 users)
- [ ] Show user name, email, and company in card format
- [ ] Make user cards clickable to open profile
- [ ] Display users in responsive grid layout
- [ ] Show loading skeletons during fetch
- [ ] Handle API errors gracefully

**Technical Requirements:**
- Fetch from `GET /users`
- Use React Query for caching
- Implement responsive grid (1-2-3 columns)
- Error boundary for failures

**UI Components:**
- `Card` for user items
- `Avatar` for user initials
- `Skeleton` for loading
- Grid layout with Tailwind

#### Story 2.2: View User Profile

**As a** visitor
**I want to** open a user profile with contact information
**So that** I can learn more about the user

**Acceptance Criteria:**
- [ ] Navigate to `/users/[id]` on user click
- [ ] Display full name, username, email
- [ ] Show phone and website information
- [ ] Display company name and catchphrase
- [ ] Show address with map placeholder
- [ ] Include tabs for Posts and Todos
- [ ] Handle invalid user IDs (404)

**Technical Requirements:**
- Fetch from `GET /users/:id`
- Use React Query for data fetching
- Implement tab navigation with URL sync
- Static map placeholder for address

**UI Components:**
- `Card` for profile sections
- `Tabs` for Posts/Todos
- `Avatar` for user
- `Badge` for counts
- `Separator` between sections

#### Story 2.3: View User's Posts

**As a** visitor
**I want to** view all posts by a user on their profile
**So that** I can see their content history

**Acceptance Criteria:**
- [ ] Display posts under "Posts" tab on profile
- [ ] Show post title and preview
- [ ] Make posts clickable to view details
- [ ] Display post count badge on tab
- [ ] Show empty state if no posts
- [ ] Loading state during fetch

**Technical Requirements:**
- Fetch from `GET /posts?userId={id}`
- Use React Query with user-specific key
- Implement empty state component
- Link to post detail pages

**UI Components:**
- `Card` for post items
- `Badge` for post count
- `EmptyState` component
- `Skeleton` for loading

#### Story 2.4: View User's Todos

**As a** visitor
**I want to** view todos for a user
**So that** I can see their task list

**Acceptance Criteria:**
- [ ] Display todos under "Todos" tab on profile
- [ ] Show todo title and completion status
- [ ] Display completed todos differently (strikethrough)
- [ ] Show todo count badge on tab
- [ ] Enable inline toggling of completion status
- [ ] Show empty state if no todos

**Technical Requirements:**
- Fetch from `GET /todos?userId={id}`
- Use React Query for data fetching
- Implement optimistic updates for toggle
- Mock `PATCH /todos/:id` requests

**UI Components:**
- `Checkbox` for todo items
- `Badge` for todo count
- `Card` for todo list
- `EmptyState` component

#### Story 2.5: Display Address on Map

**As a** visitor
**I want to** see the user's address location on a map
**So that** I can visualize where they are located

**Acceptance Criteria:**
- [ ] Display address string from user data
- [ ] Show static map placeholder image
- [ ] Include street, suite, city, and zipcode
- [ ] Display latitude/longitude coordinates
- [ ] Use placeholder image service (e.g., via.placeholder.com)
- [ ] Responsive map container

**Technical Requirements:**
- Parse address object from user data
- Generate static map URL with coordinates
- Fallback if coordinates missing
- Responsive image component

**UI Components:**
- `Card` for address section
- `next/image` for map
- `Separator` for sections

---

### 5.3 Epic 3: Comments System

**Epic Goal**: Enable users to view and interact with comments using optimistic UI patterns.

#### Story 3.1: View Post Comments

**As a** visitor
**I want to** view comments under a post
**So that** I can see the discussion

**Acceptance Criteria:**
- [ ] Display all comments for a post
- [ ] Show commenter name and email
- [ ] Display comment body text
- [ ] Show comment count in header
- [ ] Order comments by ID (oldest first)
- [ ] Loading skeletons for comments
- [ ] Empty state if no comments

**Technical Requirements:**
- Fetch from `GET /posts/:id/comments`
- Use React Query for caching
- Implement comment list component
- Format comment metadata

**UI Components:**
- `Card` for comment items
- `Avatar` for commenter
- `Badge` for comment count
- `Separator` between comments
- `EmptyState` component

#### Story 3.2: Add Comment (Mock)

**As a** visitor
**I want to** add a comment to a post
**So that** I can contribute to the discussion

**Acceptance Criteria:**
- [ ] Provide "Add Comment" form below comments
- [ ] Fields: Name, Email, Comment body
- [ ] Form validation (required fields, email format)
- [ ] Submit button disabled until valid
- [ ] Optimistically insert comment immediately
- [ ] Show toast notification on success
- [ ] Mock POST request to JSONPlaceholder
- [ ] Reset form after submission

**Technical Requirements:**
- Use React Hook Form + Zod validation
- Mock `POST /posts/:id/comments`
- Implement optimistic update with React Query
- Toast notification via sonner

**UI Components:**
- `Form` components (shadcn)
- `Input` for name/email
- `Textarea` for body
- `Button` for submit
- `Toast` for feedback

**Validation Schema:**
```typescript
const commentSchema = z.object({
  name: z.string().min(1, "Name is required"),
  email: z.string().email("Valid email required"),
  body: z.string().min(10, "Comment must be at least 10 characters")
});
```

#### Story 3.3: Edit Comment (Mock)

**As a** visitor
**I want to** edit a comment
**So that** I can correct mistakes

**Acceptance Criteria:**
- [ ] "Edit" button on each comment
- [ ] Open inline edit form or modal
- [ ] Pre-populate form with existing values
- [ ] Validate on submit
- [ ] Optimistically update comment
- [ ] Show toast notification
- [ ] Cancel button to discard changes
- [ ] Mock PUT request

**Technical Requirements:**
- Use React Hook Form with default values
- Mock `PUT /comments/:id`
- Implement optimistic update
- Toggle edit mode state

**UI Components:**
- `Dialog` or inline form
- `Form` components
- `Button` for edit/cancel/save
- `Toast` for feedback

#### Story 3.4: Delete Comment (Mock)

**As a** visitor
**I want to** delete a comment with undo option
**So that** I can remove unwanted content

**Acceptance Criteria:**
- [ ] "Delete" button on each comment
- [ ] Confirmation dialog before delete
- [ ] Optimistically remove comment
- [ ] Show toast with "Undo" action
- [ ] Restore comment if undo clicked within 5s
- [ ] Mock DELETE request
- [ ] Disable delete during undo period

**Technical Requirements:**
- Mock `DELETE /comments/:id`
- Implement optimistic delete with undo
- Toast with action button (sonner)
- Timeout handling for undo window

**UI Components:**
- `AlertDialog` for confirmation
- `Button` for delete action
- `Toast` with action button
- `DropdownMenu` for actions

#### Story 3.5: Comment Count Badges

**As a** visitor
**I want to** see comment counts on post cards
**So that** I can identify active discussions

**Acceptance Criteria:**
- [ ] Display comment count badge on post cards
- [ ] Update count when comments added/removed
- [ ] Show "0 comments" vs "1 comment" vs "X comments"
- [ ] Make badge clickable to jump to comments
- [ ] Badge visually distinct but not overwhelming

**Technical Requirements:**
- Count from comments array
- React Query cache provides real-time count
- Pluralization logic
- Scroll-to-comments on badge click

**UI Components:**
- `Badge` component
- `Button` variant for clickable badge
- Icon for comments (message icon)

---

### 5.4 Epic 4: Todo Management

**Epic Goal**: Provide comprehensive todo management with filtering and assignment.

#### Story 4.1: View User Todos

**As a** visitor
**I want to** view todos for a user
**So that** I can see their task list

**Acceptance Criteria:**
- [ ] Display all todos for selected user
- [ ] Show todo title and completion status
- [ ] Visual distinction for completed todos
- [ ] Display count of completed vs total
- [ ] Loading state during fetch
- [ ] Empty state if no todos

**Technical Requirements:**
- Fetch from `GET /todos?userId={id}`
- Use React Query for caching
- Calculate completion statistics
- Filter logic for completed/open

**UI Components:**
- `Card` for todo list
- `Checkbox` for todos
- `Badge` for counts
- `Progress` bar for completion
- `EmptyState` component

#### Story 4.2: Toggle Todo Completion

**As a** visitor
**I want to** toggle a todo's completed state
**So that** I can mark tasks as done or not done

**Acceptance Criteria:**
- [ ] Checkbox for each todo
- [ ] Clicking toggles completed state
- [ ] Optimistic update (immediate UI change)
- [ ] Visual feedback (strikethrough, color change)
- [ ] Show toast notification
- [ ] Mock PATCH request
- [ ] Update completion statistics

**Technical Requirements:**
- Mock `PATCH /todos/:id` with `{ completed: boolean }`
- Implement optimistic update with React Query
- Toggle animation (smooth transition)
- Update aggregate counts

**UI Components:**
- `Checkbox` component
- `Toast` for feedback
- CSS transitions for strikethrough

#### Story 4.3: Create Todo (Mock)

**As a** visitor
**I want to** create a new todo
**So that** I can add tasks to a user's list

**Acceptance Criteria:**
- [ ] "Add Todo" button above todo list
- [ ] Form with title and user selection
- [ ] Validate title (required, min length)
- [ ] Default completed to false
- [ ] Optimistically insert new todo
- [ ] Show toast notification
- [ ] Mock POST request
- [ ] Reset form after creation

**Technical Requirements:**
- Use React Hook Form + Zod
- Mock `POST /todos` with `{ userId, title, completed }`
- Implement optimistic insert
- Toast notification

**UI Components:**
- `Dialog` for add form
- `Form` components
- `Input` for title
- `Select` for user
- `Button` for submit
- `Toast` for feedback

**Validation Schema:**
```typescript
const todoSchema = z.object({
  title: z.string().min(3, "Title must be at least 3 characters"),
  userId: z.number().positive("User must be selected"),
  completed: z.boolean().default(false)
});
```

#### Story 4.4: Filter Todos

**As a** visitor
**I want to** filter todos by completed/open status
**So that** I can focus on specific tasks

**Acceptance Criteria:**
- [ ] Filter dropdown with options: All, Completed, Open
- [ ] Filter todos based on selection
- [ ] Maintain filter state in URL (`?filter=completed`)
- [ ] Update counts based on filter
- [ ] Clear filter option
- [ ] Combine with user filter on global page

**Technical Requirements:**
- Client-side filtering of todo list
- URL parameter synchronization
- Filter state management
- Update UI counts dynamically

**UI Components:**
- `Select` for filter options
- `Badge` showing active filter
- `Button` to clear filter

#### Story 4.5: Reassign Todo

**As a** visitor
**I want to** reassign a todo to a different user
**So that** I can reorganize task ownership

**Acceptance Criteria:**
- [ ] "Reassign" action on each todo
- [ ] User selection dropdown
- [ ] Optimistically update todo's userId
- [ ] Show toast notification
- [ ] Mock PATCH request
- [ ] Remove from current user's list
- [ ] Option to cancel reassignment

**Technical Requirements:**
- Mock `PATCH /todos/:id` with `{ userId: number }`
- Implement optimistic update
- Invalidate multiple query keys (old and new user)
- Toast notification

**UI Components:**
- `DropdownMenu` for actions
- `Dialog` for user selection
- `Select` for users
- `Toast` for feedback

---

## 6. Technical Requirements

### 6.1 Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Next.js App Router                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   / (feed)   │  │/users/[id]   │  │ /posts/[id]  │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    React Query Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ Query Cache  │  │ Mutations    │  │Optimistic UI │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    API Service Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  posts.ts    │  │  users.ts    │  │ comments.ts  │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  JSONPlaceholder API                         │
│         https://jsonplaceholder.typicode.com                 │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 Technology Stack

| Category | Technology | Version | Purpose |
|----------|-----------|---------|---------|
| Framework | Next.js | 15.x | React framework with App Router |
| Language | TypeScript | 5.x | Type safety and developer experience |
| UI Library | React | 19.x | Component library |
| Styling | Tailwind CSS | 3.x | Utility-first CSS |
| Components | shadcn/ui | Latest | Radix-based component library |
| State | React Query | 5.x | Server state and caching |
| Forms | React Hook Form | 7.x | Form management |
| Validation | Zod | 3.x | Schema validation |
| Notifications | Sonner | Latest | Toast notifications |
| Icons | Lucide React | Latest | Icon library |
| Testing | Jest | 29.x | Unit and integration testing |
| Testing | React Testing Library | 14.x | Component testing |
| E2E Testing | Playwright | Latest | End-to-end testing |
| Linting | ESLint | 8.x | Code linting |
| Formatting | Prettier | 3.x | Code formatting |

### 6.3 Project Structure

```
/mini-social-feed
├── /app                          # Next.js App Router
│   ├── /posts
│   │   └── /[id]
│   │       └── page.tsx         # Post detail page
│   ├── /users
│   │   ├── page.tsx             # User directory
│   │   └── /[id]
│   │       └── page.tsx         # User profile page
│   ├── /todos
│   │   └── page.tsx             # Global todos page (optional)
│   ├── layout.tsx               # Root layout
│   ├── page.tsx                 # Posts feed (home)
│   └── providers.tsx            # React Query provider
├── /components
│   ├── /ui                      # shadcn/ui components
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── input.tsx
│   │   └── ...
│   ├── /posts
│   │   ├── post-card.tsx
│   │   ├── post-detail.tsx
│   │   ├── post-list.tsx
│   │   └── post-search.tsx
│   ├── /comments
│   │   ├── comment-list.tsx
│   │   ├── comment-item.tsx
│   │   ├── comment-form.tsx
│   │   └── delete-comment-dialog.tsx
│   ├── /users
│   │   ├── user-card.tsx
│   │   ├── user-profile.tsx
│   │   └── user-avatar.tsx
│   ├── /todos
│   │   ├── todo-list.tsx
│   │   ├── todo-item.tsx
│   │   ├── todo-form.tsx
│   │   └── todo-filter.tsx
│   ├── /layout
│   │   ├── header.tsx
│   │   ├── footer.tsx
│   │   └── navigation.tsx
│   └── /shared
│       ├── empty-state.tsx
│       ├── error-boundary.tsx
│       ├── loading-skeleton.tsx
│       └── pagination.tsx
├── /lib
│   ├── /api                     # API service layer
│   │   ├── posts.ts
│   │   ├── users.ts
│   │   ├── comments.ts
│   │   ├── todos.ts
│   │   └── client.ts            # Fetch wrapper
│   ├── /hooks                   # React Query hooks
│   │   ├── use-posts.ts
│   │   ├── use-users.ts
│   │   ├── use-comments.ts
│   │   └── use-todos.ts
│   ├── /schemas                 # Zod schemas
│   │   ├── comment.ts
│   │   ├── todo.ts
│   │   └── post.ts
│   ├── /utils                   # Utility functions
│   │   ├── cn.ts                # className merger
│   │   ├── format.ts            # Formatters
│   │   └── avatar.ts            # Avatar helpers
│   └── /types                   # TypeScript types
│       ├── api.ts
│       └── index.ts
├── /public                      # Static assets
├── /__tests__                   # Test files
│   ├── /unit
│   ├── /integration
│   └── /e2e
├── .env.local                   # Environment variables
├── next.config.js               # Next.js configuration
├── tailwind.config.ts           # Tailwind configuration
├── tsconfig.json                # TypeScript configuration
├── jest.config.js               # Jest configuration
├── playwright.config.ts         # Playwright configuration
└── package.json                 # Dependencies
```

### 6.4 Data Models

#### Post

```typescript
interface Post {
  id: number;
  userId: number;
  title: string;
  body: string;
  // Extended with user data
  user?: User;
  // Extended with comment count
  commentCount?: number;
}
```

#### User

```typescript
interface User {
  id: number;
  name: string;
  username: string;
  email: string;
  address: {
    street: string;
    suite: string;
    city: string;
    zipcode: string;
    geo: {
      lat: string;
      lng: string;
    };
  };
  phone: string;
  website: string;
  company: {
    name: string;
    catchPhrase: string;
    bs: string;
  };
}
```

#### Comment

```typescript
interface Comment {
  id: number;
  postId: number;
  name: string;
  email: string;
  body: string;
}

// Form input type
interface CommentInput {
  name: string;
  email: string;
  body: string;
}
```

#### Todo

```typescript
interface Todo {
  id: number;
  userId: number;
  title: string;
  completed: boolean;
}

// Form input type
interface TodoInput {
  userId: number;
  title: string;
  completed: boolean;
}
```

### 6.5 API Integration

#### Base Configuration

```typescript
// lib/api/client.ts
const API_BASE_URL = 'https://jsonplaceholder.typicode.com';

export async function apiClient<T>(
  endpoint: string,
  options?: RequestInit
): Promise<T> {
  const response = await fetch(`${API_BASE_URL}${endpoint}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...options?.headers,
    },
  });

  if (!response.ok) {
    throw new Error(`API Error: ${response.statusText}`);
  }

  return response.json();
}
```

#### API Endpoints

| Resource | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| Posts | `/posts` | GET | List all posts |
| Posts | `/posts?_page=1&_limit=10` | GET | Paginated posts |
| Posts | `/posts/:id` | GET | Single post |
| Posts | `/posts/:id/comments` | GET | Post comments |
| Users | `/users` | GET | List all users |
| Users | `/users/:id` | GET | Single user |
| Todos | `/todos` | GET | List all todos |
| Todos | `/todos?userId=:id` | GET | User todos |
| Comments | `/comments` | POST | Create comment (mock) |
| Comments | `/comments/:id` | PUT | Update comment (mock) |
| Comments | `/comments/:id` | DELETE | Delete comment (mock) |
| Todos | `/todos` | POST | Create todo (mock) |
| Todos | `/todos/:id` | PATCH | Update todo (mock) |

### 6.6 State Management

#### React Query Configuration

```typescript
// app/providers.tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      cacheTime: 10 * 60 * 1000, // 10 minutes
      refetchOnWindowFocus: false,
      retry: 1,
    },
  },
});

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  );
}
```

#### Query Key Structure

```typescript
// lib/hooks/query-keys.ts
export const queryKeys = {
  posts: {
    all: ['posts'] as const,
    lists: () => [...queryKeys.posts.all, 'list'] as const,
    list: (filters: string) => [...queryKeys.posts.lists(), { filters }] as const,
    details: () => [...queryKeys.posts.all, 'detail'] as const,
    detail: (id: number) => [...queryKeys.posts.details(), id] as const,
  },
  users: {
    all: ['users'] as const,
    lists: () => [...queryKeys.users.all, 'list'] as const,
    list: () => [...queryKeys.users.lists()] as const,
    details: () => [...queryKeys.users.all, 'detail'] as const,
    detail: (id: number) => [...queryKeys.users.details(), id] as const,
  },
  comments: {
    all: ['comments'] as const,
    lists: () => [...queryKeys.comments.all, 'list'] as const,
    list: (postId: number) => [...queryKeys.comments.lists(), postId] as const,
  },
  todos: {
    all: ['todos'] as const,
    lists: () => [...queryKeys.todos.all, 'list'] as const,
    list: (userId?: number) => [...queryKeys.todos.lists(), { userId }] as const,
  },
};
```

#### Optimistic Update Pattern

```typescript
// Example: Optimistic comment creation
export function useCreateComment(postId: number) {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CommentInput) => createComment(postId, data),

    onMutate: async (newComment) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({
        queryKey: queryKeys.comments.list(postId)
      });

      // Snapshot previous value
      const previousComments = queryClient.getQueryData(
        queryKeys.comments.list(postId)
      );

      // Optimistically update
      queryClient.setQueryData(
        queryKeys.comments.list(postId),
        (old: Comment[] = []) => [
          ...old,
          {
            id: Date.now(), // Temporary ID
            postId,
            ...newComment,
          },
        ]
      );

      return { previousComments };
    },

    onError: (err, newComment, context) => {
      // Rollback on error
      queryClient.setQueryData(
        queryKeys.comments.list(postId),
        context?.previousComments
      );

      toast.error('Failed to add comment');
    },

    onSuccess: () => {
      toast.success('Comment added successfully');
    },

    onSettled: () => {
      // Refetch after error or success
      queryClient.invalidateQueries({
        queryKey: queryKeys.comments.list(postId)
      });
    },
  });
}
```

### 6.7 Routing Strategy

#### Route Configuration

| Route | Component | Data Fetching | Purpose |
|-------|-----------|---------------|---------|
| `/` | `app/page.tsx` | Posts list | Home feed |
| `/posts/[id]` | `app/posts/[id]/page.tsx` | Post + comments | Post detail |
| `/users` | `app/users/page.tsx` | Users list | User directory |
| `/users/[id]` | `app/users/[id]/page.tsx` | User + posts + todos | User profile |
| `/todos` | `app/todos/page.tsx` | All todos | Todos overview |

#### URL Parameters

```typescript
// Query parameters for filtering/pagination
interface FeedParams {
  page?: number;        // ?page=2
  q?: string;          // ?q=search+term
  userId?: number;     // ?userId=3
}

interface TodoParams {
  userId?: number;     // ?userId=3
  filter?: 'all' | 'completed' | 'open'; // ?filter=completed
}

interface ProfileParams {
  tab?: 'posts' | 'todos'; // ?tab=posts
}
```

### 6.8 Error Handling

#### Error Boundary Strategy

```typescript
// components/shared/error-boundary.tsx
interface ErrorBoundaryProps {
  children: React.ReactNode;
  fallback?: React.ReactNode;
}

export function ErrorBoundary({ children, fallback }: ErrorBoundaryProps) {
  // Implementation with error state
  // Provide retry mechanism
  // Log errors for debugging
}
```

#### API Error Handling

```typescript
// lib/api/client.ts
export class APIError extends Error {
  constructor(
    public status: number,
    public statusText: string,
    message?: string
  ) {
    super(message || statusText);
  }
}

// Usage in components
try {
  await fetchPosts();
} catch (error) {
  if (error instanceof APIError) {
    if (error.status === 404) {
      // Handle not found
    } else if (error.status >= 500) {
      // Handle server error
    }
  }
  toast.error('Failed to load posts');
}
```

### 6.9 Performance Optimization

#### Code Splitting

- Dynamic imports for heavy components
- Route-based code splitting (automatic with Next.js)
- Component-level lazy loading for dialogs/modals

#### Data Fetching

- Parallel fetching where possible
- Prefetching on hover (posts, profiles)
- Deduplication via React Query
- Stale-while-revalidate pattern

#### Rendering Optimization

- React.memo for expensive list items
- useMemo for complex computations
- useCallback for stable callbacks
- Virtual scrolling for large lists (stretch goal)

#### Caching Strategy

```typescript
// React Query cache times
const CACHE_CONFIG = {
  posts: {
    staleTime: 5 * 60 * 1000,  // 5 minutes
    cacheTime: 10 * 60 * 1000, // 10 minutes
  },
  users: {
    staleTime: 15 * 60 * 1000, // 15 minutes (rarely changes)
    cacheTime: 30 * 60 * 1000, // 30 minutes
  },
  comments: {
    staleTime: 2 * 60 * 1000,  // 2 minutes
    cacheTime: 5 * 60 * 1000,  // 5 minutes
  },
};
```

---

## 7. Non-Functional Requirements

### 7.1 Performance

| Metric | Target | Measurement |
|--------|--------|-------------|
| Initial Page Load | < 2s | Lighthouse Performance |
| Time to Interactive | < 3s | Lighthouse TTI |
| First Contentful Paint | < 1.5s | Lighthouse FCP |
| Largest Contentful Paint | < 2.5s | Lighthouse LCP |
| Cumulative Layout Shift | < 0.1 | Lighthouse CLS |
| API Response Time | < 500ms | Network tab average |
| Client-side Navigation | < 100ms | Subjective feel |

**Implementation:**
- Use Next.js Image optimization for all images
- Implement loading skeletons for async content
- Lazy load heavy components (dialogs, modals)
- Minimize bundle size (code splitting)
- Optimize React Query cache settings
- Implement pagination (don't load all data at once)

### 7.2 Accessibility (WCAG 2.1 Level AA)

| Requirement | Implementation |
|-------------|----------------|
| Keyboard Navigation | All interactive elements keyboard accessible |
| Screen Reader Support | ARIA labels, roles, live regions |
| Focus Management | Visible focus indicators, logical tab order |
| Color Contrast | Minimum 4.5:1 for normal text, 3:1 for large |
| Text Sizing | Support browser zoom up to 200% |
| Alternative Text | All images have alt text |
| Form Labels | All inputs have associated labels |
| Error Identification | Clear error messages with instructions |
| Skip Links | Skip to main content link |
| Semantic HTML | Proper heading hierarchy, landmarks |

**Testing:**
- axe DevTools browser extension
- Lighthouse accessibility audit
- Manual keyboard navigation testing
- Screen reader testing (NVDA/JAWS)

**Key Patterns:**
```typescript
// Accessible button example
<Button
  aria-label="Delete comment"
  aria-describedby="delete-description"
  onClick={handleDelete}
>
  <Trash2 aria-hidden="true" />
</Button>

// Live region for dynamic updates
<div role="status" aria-live="polite" aria-atomic="true">
  {message}
</div>

// Form field with error
<FormField
  control={form.control}
  name="email"
  render={({ field }) => (
    <FormItem>
      <FormLabel>Email</FormLabel>
      <FormControl>
        <Input {...field} aria-invalid={!!errors.email} />
      </FormControl>
      <FormMessage role="alert" />
    </FormItem>
  )}
/>
```

### 7.3 Browser Support

| Browser | Minimum Version |
|---------|----------------|
| Chrome | Last 2 versions |
| Firefox | Last 2 versions |
| Safari | Last 2 versions |
| Edge | Last 2 versions |
| Mobile Safari | iOS 14+ |
| Chrome Mobile | Android 10+ |

**Polyfills:**
- None required (Next.js handles necessary polyfills)
- Modern ES2020+ features used

### 7.4 Responsive Design

| Breakpoint | Width | Layout |
|------------|-------|--------|
| Mobile | < 640px | 1 column, stacked navigation |
| Tablet | 640px - 1024px | 2 columns, condensed navigation |
| Desktop | > 1024px | 3 columns, full navigation |

**Tailwind Breakpoints:**
- `sm:` 640px
- `md:` 768px
- `lg:` 1024px
- `xl:` 1280px
- `2xl:` 1536px

**Touch Targets:**
- Minimum 44x44px (iOS guidelines)
- Adequate spacing between interactive elements

### 7.5 Security

Since this is a demo application with no authentication, security concerns are minimal:

**Content Security:**
- No user-generated content is persisted
- All data from JSONPlaceholder (trusted source)
- No XSS risk (React automatically escapes)
- No SQL injection risk (no database)

**Network Security:**
- HTTPS for JSONPlaceholder API
- No sensitive data transmitted
- No credentials or tokens stored

**Best Practices:**
- Input validation (Zod schemas)
- Sanitize user input for display
- Proper CORS headers (Next.js default)
- No eval() or dangerous HTML

### 7.6 Error Recovery

**Error States:**
- Network failures → Retry button with error message
- 404 errors → Not found page with navigation
- 500 errors → Generic error with retry
- Validation errors → Inline form feedback

**Resilience Patterns:**
```typescript
// Automatic retry with exponential backoff (React Query)
const { data, error, refetch } = useQuery({
  queryKey: ['posts'],
  queryFn: fetchPosts,
  retry: 3,
  retryDelay: attemptIndex => Math.min(1000 * 2 ** attemptIndex, 30000),
});

// Error boundary with retry
<ErrorBoundary
  fallback={(error, retry) => (
    <div>
      <p>Something went wrong: {error.message}</p>
      <Button onClick={retry}>Try Again</Button>
    </div>
  )}
>
  {children}
</ErrorBoundary>
```

### 7.7 Internationalization (i18n)

**Out of scope for MVP**, but architecture should support:
- English only for MVP
- String externalization pattern (ready for i18n)
- Date/number formatting using `Intl` API
- RTL-ready layout (Tailwind supports `rtl:`)

### 7.8 Analytics & Monitoring

**Out of scope** (per product brief), but could be added:
- No tracking scripts
- No user analytics
- Console logging for debugging only
- React Query DevTools in development

### 7.9 Offline Support

**Stretch goal:**
- Service worker for caching GET requests
- Offline indicator in UI
- Queue write operations when offline
- Sync when back online

---

## 8. Design Requirements

### 8.1 Design System Foundation

#### Color Palette (shadcn/ui default)

**Light Mode:**
```css
--background: 0 0% 100%;
--foreground: 222.2 84% 4.9%;
--primary: 222.2 47.4% 11.2%;
--primary-foreground: 210 40% 98%;
--secondary: 210 40% 96.1%;
--secondary-foreground: 222.2 47.4% 11.2%;
--muted: 210 40% 96.1%;
--muted-foreground: 215.4 16.3% 46.9%;
--accent: 210 40% 96.1%;
--accent-foreground: 222.2 47.4% 11.2%;
--destructive: 0 84.2% 60.2%;
--destructive-foreground: 210 40% 98%;
--border: 214.3 31.8% 91.4%;
--input: 214.3 31.8% 91.4%;
--ring: 222.2 84% 4.9%;
```

**Dark Mode (stretch goal):**
- Inverted color scheme
- Maintained contrast ratios
- Consistent component styling

#### Typography

**Font Stack:**
```css
font-family: var(--font-sans), ui-sans-serif, system-ui, sans-serif;
```

**Type Scale:**
- `text-xs`: 0.75rem (12px)
- `text-sm`: 0.875rem (14px)
- `text-base`: 1rem (16px)
- `text-lg`: 1.125rem (18px)
- `text-xl`: 1.25rem (20px)
- `text-2xl`: 1.5rem (24px)
- `text-3xl`: 1.875rem (30px)
- `text-4xl`: 2.25rem (36px)

**Font Weights:**
- Regular: 400
- Medium: 500
- Semibold: 600
- Bold: 700

#### Spacing System

**Tailwind Scale (0.25rem = 4px):**
- `0`: 0px
- `1`: 4px
- `2`: 8px
- `3`: 12px
- `4`: 16px
- `6`: 24px
- `8`: 32px
- `12`: 48px
- `16`: 64px

**Component Spacing:**
- Card padding: `p-6` (24px)
- Section spacing: `space-y-8` (32px)
- List item spacing: `space-y-4` (16px)
- Button padding: `px-4 py-2` (16px x 8px)

#### Border Radius

- `rounded-sm`: 2px
- `rounded`: 4px
- `rounded-md`: 6px
- `rounded-lg`: 8px
- `rounded-xl`: 12px
- `rounded-full`: 9999px (circles)

### 8.2 Component Specifications

#### Post Card

**Desktop:**
```
┌────────────────────────────────────────┐
│ [Avatar] User Name          [5 💬]     │ ← Header
│                                        │
│ Post Title (text-xl, font-semibold)   │ ← Content
│                                        │
│ Post body preview (text-sm, 2 lines)  │
│ ...truncated                           │
│                                        │
│ [Read More →]                          │ ← Action
└────────────────────────────────────────┘
```

**Specifications:**
- Width: 100% of container
- Padding: 24px
- Border: 1px solid border color
- Hover: Shadow elevation + border color change
- Cursor: pointer on entire card
- Avatar: 40x40px with initials
- Badge: Absolute top-right for comment count

#### User Card

**Layout:**
```
┌────────────────────────────────────────┐
│          [Large Avatar]                │
│                                        │
│       User Full Name                   │
│       @username                        │
│                                        │
│       📧 email@example.com            │
│       🏢 Company Name                  │
│                                        │
│       [View Profile →]                 │
└────────────────────────────────────────┘
```

**Specifications:**
- Width: 300px (desktop), 100% (mobile)
- Padding: 32px
- Text alignment: center
- Avatar: 80x80px
- Hover: Subtle scale transform (1.02)

#### Comment Item

**Layout:**
```
┌────────────────────────────────────────┐
│ [Avatar] Name                   [⋮]    │
│          email@example.com             │
│                                        │
│ Comment body text goes here and can    │
│ span multiple lines with proper        │
│ wrapping and spacing.                  │
│                                        │
│ [Edit] [Delete]                        │
└────────────────────────────────────────┘
```

**Specifications:**
- Padding: 16px
- Border-bottom: 1px (except last)
- Avatar: 32x32px
- Actions: Dropdown menu (mobile)
- Hover: Background color change

#### Todo Item

**Layout:**
```
┌────────────────────────────────────────┐
│ [✓] Todo title text                    │ ← Completed
│ [ ] Another todo title                 │ ← Open
└────────────────────────────────────────┘
```

**Specifications:**
- Padding: 12px
- Checkbox: 20x20px
- Completed: Strikethrough + muted color
- Hover: Background highlight

### 8.3 Layout Structure

#### Header/Navigation

```
┌─────────────────────────────────────────────────────────┐
│ [Logo] Mini Social Feed    Posts  Users  Todos  [🔍]   │
└─────────────────────────────────────────────────────────┘
```

**Specifications:**
- Height: 64px
- Sticky position (top: 0)
- Background: background color
- Border-bottom: 1px
- Logo: 32px height
- Navigation: Horizontal on desktop, hamburger on mobile
- Search: Icon button expanding to input

#### Page Layout

**Desktop (> 1024px):**
```
┌─────────────────────────────────────────────────────────┐
│                    Navigation Header                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌────────────────────┐  ┌──────────────────────────┐  │
│  │    Sidebar         │  │    Main Content          │  │
│  │  (Filters/Nav)     │  │    (Posts/Users/etc)     │  │
│  │                    │  │                          │  │
│  │  [Filter Options]  │  │  [Content Cards...]      │  │
│  │                    │  │                          │  │
│  └────────────────────┘  └──────────────────────────┘  │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Mobile (< 640px):**
```
┌─────────────────────────┐
│    Navigation Header    │
├─────────────────────────┤
│                         │
│  [Filters - Collapsed]  │
│                         │
│  [Content Cards...]     │
│  (Stacked vertically)   │
│                         │
└─────────────────────────┘
```

#### Post Detail Layout

```
┌─────────────────────────────────────────────────────────┐
│  ← Back to Feed                                         │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Post Title (text-3xl, font-bold)                       │
│                                                          │
│  [Avatar] Author Name    Posted: Date                   │
│                                                          │
│  Full post body text with proper paragraph spacing      │
│  and line height for comfortable reading...             │
│                                                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Comments (5) ───────────────────────────────────       │
│                                                          │
│  [Add Comment Form]                                     │
│                                                          │
│  [Comment 1...]                                         │
│  [Comment 2...]                                         │
│  [Comment 3...]                                         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

#### User Profile Layout

```
┌─────────────────────────────────────────────────────────┐
│  ← Back to Users                                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│         [Large Avatar 120x120]                          │
│                                                          │
│         User Full Name (@username)                      │
│         📧 email  |  📞 phone  |  🌐 website            │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │ 📍 Address                                        │  │
│  │ Street, Suite                                     │  │
│  │ City, Zipcode                                     │  │
│  │ [Map Placeholder Image]                           │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │ 🏢 Company                                        │  │
│  │ Company Name                                      │  │
│  │ "Catchphrase here"                                │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
├─────────────────────────────────────────────────────────┤
│  [Posts Tab] [Todos Tab]                                │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  [Tab Content - Posts or Todos...]                      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### 8.4 Interaction Patterns

#### Loading States

1. **Skeleton Placeholders:**
   - Use during initial data fetch
   - Match component layout shape
   - Pulse animation
   - Gray color (muted)

2. **Spinners:**
   - Use for button loading states
   - Use for refresh/reload actions
   - Small size (16-20px)

3. **Progress Indicators:**
   - Use for multi-step processes
   - Show percentage or steps
   - Determinate when possible

#### Empty States

**Pattern:**
```
┌─────────────────────────────────────────┐
│                                         │
│          [Large Icon]                   │
│                                         │
│     No posts found                      │
│  Try adjusting your filters             │
│                                         │
│     [Clear Filters] [Create Post]       │
│                                         │
└─────────────────────────────────────────┘
```

**Guidelines:**
- Center-aligned content
- Helpful icon (related to content type)
- Clear message (what's missing)
- Guidance (what to do next)
- Action button when applicable

#### Toast Notifications

**Success:**
- Green accent color
- Checkmark icon
- Auto-dismiss (3 seconds)
- Example: "Comment added successfully"

**Error:**
- Red/destructive color
- X or alert icon
- Manual dismiss or longer timeout (5s)
- Example: "Failed to load posts. Try again."

**Info:**
- Blue accent color
- Info icon
- Auto-dismiss (3 seconds)
- Example: "Loading more posts..."

**With Action (Undo):**
- Include action button
- Longer timeout (5 seconds)
- Example: "Comment deleted [Undo]"

#### Animations

**Micro-interactions:**
- Button hover: Scale(1.02) + shadow
- Card hover: Shadow elevation
- Link hover: Color change + underline
- Focus: Ring outline (2px, offset 2px)

**Transitions:**
- Page transitions: Fade-in (200ms)
- Modal open: Scale + fade (150ms)
- Toast: Slide-in from top (200ms)
- Skeleton pulse: 2s infinite

**Guidelines:**
- Keep under 300ms
- Use easing functions (ease-in-out)
- Reduce motion for accessibility
- No animations for critical actions

### 8.5 Icon Usage

**Icon Library:** Lucide React

**Common Icons:**
- `Home`: Home/feed
- `Users`: Users directory
- `CheckSquare`: Todos
- `MessageSquare`: Comments
- `Search`: Search
- `Plus`: Add/create
- `Edit`: Edit action
- `Trash2`: Delete action
- `MoreVertical`: More actions menu
- `ChevronLeft/Right`: Navigation
- `X`: Close/dismiss
- `Check`: Success/complete
- `AlertCircle`: Error/warning

**Size Guidelines:**
- Small: 16px (inline text)
- Default: 20px (buttons, cards)
- Large: 24px (headers, empty states)
- XL: 48px+ (hero sections)

### 8.6 Form Design

#### Input Fields

**Structure:**
```
Label (text-sm, font-medium)
─────────────────────────────
│ Input field               │
─────────────────────────────
Helper text (text-xs, muted)
```

**States:**
- Default: Border, background
- Focus: Ring outline, border color
- Error: Red border, error message below
- Disabled: Reduced opacity, no interaction

#### Buttons

**Variants:**
- Primary: Solid background, high contrast
- Secondary: Outline, lower contrast
- Ghost: No background, text only
- Destructive: Red color scheme

**Sizes:**
- Small: `px-3 py-1.5 text-sm`
- Default: `px-4 py-2 text-base`
- Large: `px-6 py-3 text-lg`

**States:**
- Default: Base styling
- Hover: Background darken/lighten
- Active: Slightly pressed appearance
- Disabled: Reduced opacity, no interaction
- Loading: Spinner + disabled state

### 8.7 Accessibility Patterns

#### Focus Management

- Visible focus indicator on all interactive elements
- Focus trap in modals/dialogs
- Focus restoration when closing modals
- Skip links for keyboard navigation

#### ARIA Usage

```typescript
// Button with description
<Button
  aria-label="Delete comment"
  aria-describedby="delete-help"
>
  <Trash2 aria-hidden="true" />
</Button>
<span id="delete-help" className="sr-only">
  This will permanently delete the comment
</span>

// Live region for dynamic updates
<div role="status" aria-live="polite">
  {posts.length} posts found
</div>

// Loading state
<div role="status" aria-live="polite">
  <span className="sr-only">Loading posts...</span>
  <Spinner aria-hidden="true" />
</div>
```

#### Screen Reader Considerations

- Meaningful alt text for all images
- Hidden text for icon-only buttons
- Live regions for dynamic updates
- Proper heading hierarchy (h1 > h2 > h3)
- Landmark regions (nav, main, footer)

---

## 9. Success Metrics

### 9.1 Feature Completeness Metrics

| Metric | Target | Verification |
|--------|--------|--------------|
| User Stories Completed | 20/20 (100%) | Manual checklist |
| Acceptance Criteria Met | 100% | QA validation |
| All Routes Functional | 5/5 routes working | Manual testing |
| All Epics Delivered | 4/4 epics complete | Product review |

### 9.2 Technical Quality Metrics

| Metric | Target | Measurement Tool |
|--------|--------|------------------|
| TypeScript Coverage | 100% (no `any`) | TypeScript compiler |
| Test Coverage | ≥ 80% | Jest coverage report |
| E2E Test Coverage | All critical paths | Playwright suite |
| Lighthouse Performance | ≥ 90 | Lighthouse audit |
| Lighthouse Accessibility | ≥ 90 | Lighthouse audit |
| Lighthouse Best Practices | ≥ 90 | Lighthouse audit |
| Lighthouse SEO | ≥ 90 | Lighthouse audit |
| ESLint Errors | 0 | ESLint report |
| Build Warnings | 0 | Next.js build output |

### 9.3 Performance Metrics

| Metric | Target | Tool |
|--------|--------|------|
| Initial Page Load | < 2s | Lighthouse, DevTools |
| Time to Interactive | < 3s | Lighthouse |
| First Contentful Paint | < 1.5s | Lighthouse |
| Largest Contentful Paint | < 2.5s | Lighthouse |
| Cumulative Layout Shift | < 0.1 | Lighthouse |
| Bundle Size (Initial) | < 200KB | Next.js build analyzer |
| API Response Time (avg) | < 500ms | Network tab |

### 9.4 User Experience Metrics

| Metric | Target | Method |
|--------|--------|--------|
| Navigation Success Rate | 100% | Manual testing |
| Form Submission Success | 100% (optimistic) | Manual testing |
| Error Recovery Success | 100% | Error injection testing |
| Mobile Usability | All features work | Device testing |
| Keyboard Navigation | 100% accessible | Keyboard-only testing |
| Screen Reader Compatibility | All content accessible | NVDA/JAWS testing |

### 9.5 Code Quality Metrics

| Metric | Target | Tool |
|--------|--------|------|
| Code Duplication | < 3% | SonarQube (optional) |
| Cyclomatic Complexity | < 10 per function | ESLint complexity rule |
| Function Length | < 50 lines | Code review |
| Component Size | < 300 lines | Code review |
| Import Dependencies | Clear, minimal | Dependency graph |

### 9.6 Documentation Metrics

| Deliverable | Status | Location |
|-------------|--------|----------|
| README.md | Required | Project root |
| Component Documentation | Required | Storybook (optional) |
| API Service Documentation | Required | JSDoc comments |
| Setup Instructions | Required | README.md |
| Testing Guide | Required | /docs/testing.md |

### 9.7 Acceptance Criteria

**The application is considered complete when:**

1. ✅ All 20 user stories pass acceptance criteria
2. ✅ All Lighthouse scores ≥ 90
3. ✅ Test coverage ≥ 80%
4. ✅ Zero TypeScript errors
5. ✅ Zero ESLint errors
6. ✅ All pages load < 2s
7. ✅ Responsive on mobile, tablet, desktop
8. ✅ Keyboard navigable
9. ✅ Screen reader compatible
10. ✅ All optimistic updates work correctly
11. ✅ Error states handle gracefully
12. ✅ Loading states show appropriately
13. ✅ Empty states display correctly
14. ✅ Toast notifications work
15. ✅ Forms validate properly

---

## 10. Timeline and Milestones

### 10.1 Development Phases

#### Phase 1: Foundation (Week 1)

**Goals:** Project setup, architecture, core infrastructure

**Tasks:**
- [ ] Next.js 15 project initialization
- [ ] TypeScript configuration
- [ ] Tailwind CSS setup
- [ ] shadcn/ui component installation
- [ ] React Query configuration
- [ ] Project structure creation
- [ ] API service layer scaffold
- [ ] Basic routing setup
- [ ] Git repository and branching strategy

**Deliverables:**
- Working development environment
- Basic app shell with navigation
- API client configured for JSONPlaceholder
- Component library ready
- Testing framework configured

**Dependencies:** None

**Risk Level:** Low

---

#### Phase 2: Epic 1 - Posts Feed (Week 2)

**Goals:** Implement complete posts feed functionality

**Tasks:**
- [ ] Story 1.1: Paginated posts list
- [ ] Story 1.2: Post detail page
- [ ] Story 1.3: Author information display
- [ ] Story 1.4: Search functionality
- [ ] Story 1.5: Author filter

**Deliverables:**
- Posts feed page (/)
- Post detail page (/posts/[id])
- Search and filter components
- Pagination component
- Loading and empty states

**Dependencies:** Phase 1 complete

**Risk Level:** Low

---

#### Phase 3: Epic 2 - User Profiles (Week 3)

**Goals:** Build user directory and profile pages

**Tasks:**
- [ ] Story 2.1: User directory
- [ ] Story 2.2: User profile page
- [ ] Story 2.3: User's posts display
- [ ] Story 2.4: User's todos display
- [ ] Story 2.5: Address and map placeholder

**Deliverables:**
- Users directory page (/users)
- User profile page (/users/[id])
- Tab navigation component
- User card component
- Profile sections (info, posts, todos)

**Dependencies:** Phase 1 complete

**Risk Level:** Low

---

#### Phase 4: Epic 3 - Comments System (Week 4)

**Goals:** Implement comments with optimistic UI

**Tasks:**
- [ ] Story 3.1: View comments
- [ ] Story 3.2: Add comment (optimistic)
- [ ] Story 3.3: Edit comment (optimistic)
- [ ] Story 3.4: Delete comment with undo
- [ ] Story 3.5: Comment count badges

**Deliverables:**
- Comment list component
- Comment form component
- Edit comment dialog
- Delete confirmation with undo
- Optimistic update patterns
- Toast notifications

**Dependencies:** Phase 2 complete (posts)

**Risk Level:** Medium (optimistic updates complexity)

---

#### Phase 5: Epic 4 - Todo Management (Week 5)

**Goals:** Complete todo functionality with assignment

**Tasks:**
- [ ] Story 4.1: View user todos
- [ ] Story 4.2: Toggle completion (optimistic)
- [ ] Story 4.3: Create todo (optimistic)
- [ ] Story 4.4: Filter todos
- [ ] Story 4.5: Reassign todo

**Deliverables:**
- Todo list component
- Todo form component
- Filter controls
- Reassignment dialog
- Global todos page (optional)

**Dependencies:** Phase 3 complete (users)

**Risk Level:** Medium (optimistic updates)

---

#### Phase 6: Polish & Testing (Week 6)

**Goals:** Refinement, testing, bug fixes

**Tasks:**
- [ ] Unit tests for components
- [ ] Integration tests for pages
- [ ] E2E tests for critical paths
- [ ] Accessibility audit and fixes
- [ ] Performance optimization
- [ ] Error handling improvements
- [ ] Loading states refinement
- [ ] Mobile responsiveness testing
- [ ] Cross-browser testing
- [ ] Documentation completion

**Deliverables:**
- Comprehensive test suite
- Lighthouse scores ≥ 90
- Bug fixes and refinements
- Complete documentation
- Production-ready build

**Dependencies:** Phases 1-5 complete

**Risk Level:** Low

---

### 10.2 Milestone Schedule

| Milestone | Date | Deliverables |
|-----------|------|--------------|
| M1: Foundation Complete | End of Week 1 | Working app shell, infrastructure |
| M2: Posts Feed Live | End of Week 2 | Posts feed and detail pages functional |
| M3: User Profiles Live | End of Week 3 | User directory and profiles working |
| M4: Comments Working | End of Week 4 | Full comment system with optimistic UI |
| M5: Todos Complete | End of Week 5 | All todo functionality operational |
| M6: Production Ready | End of Week 6 | Tested, polished, documented |

### 10.3 Critical Path

**Must-Have Sequence:**
1. Foundation (Phase 1) → Blocks all other work
2. Posts Feed (Phase 2) → Required for comments
3. User Profiles (Phase 3) → Required for todos
4. Comments (Phase 4) → Can parallel with Phase 5
5. Todos (Phase 5) → Can parallel with Phase 4
6. Testing (Phase 6) → Final phase

**Parallel Work Opportunities:**
- Comments and Todos (Phases 4 & 5) can be developed simultaneously
- Testing can start incrementally during each phase
- Documentation can be written alongside development

### 10.4 Resource Requirements

**Team Composition:**
- 1 Frontend Developer (primary)
- 1 QA Engineer (part-time, Phases 4-6)
- 1 Product Manager (oversight, checkpoints)

**Time Allocation:**
- Development: 5 weeks (Phases 1-5)
- Testing & Polish: 1 week (Phase 6)
- Total: 6 weeks

**Tools & Services:**
- Next.js hosting (Vercel recommended)
- Git repository (GitHub/GitLab)
- CI/CD pipeline (GitHub Actions)
- JSONPlaceholder (free, public)

---

## 11. Risks and Mitigation

### 11.1 Technical Risks

#### Risk 1: JSONPlaceholder API Reliability

**Severity:** High
**Probability:** Low
**Impact:** Application unusable if API down

**Description:**
JSONPlaceholder is a public API with no SLA. If it goes down or becomes slow, the entire application breaks.

**Mitigation:**
- Implement robust error handling with retry logic
- Add React Query retry mechanisms (exponential backoff)
- Display clear error messages with retry buttons
- Consider adding a fallback mock API for development
- Document API dependency clearly

**Contingency Plan:**
If JSONPlaceholder becomes unreliable:
1. Switch to local JSON files as fallback
2. Create mock API server using json-server
3. Update API client to point to fallback source

---

#### Risk 2: Optimistic UI Complexity

**Severity:** Medium
**Probability:** Medium
**Impact:** Buggy user experience with incorrect state

**Description:**
Optimistic updates are complex to implement correctly. Race conditions, rollback scenarios, and state synchronization can cause bugs.

**Mitigation:**
- Use React Query's built-in optimistic update patterns
- Implement comprehensive error handling with rollback
- Add unit tests for optimistic update scenarios
- Test race conditions (rapid clicks, network failures)
- Use TypeScript for type safety in state updates

**Contingency Plan:**
If optimistic updates prove too buggy:
1. Fall back to traditional loading states
2. Show loading spinners during operations
3. Accept slower but more reliable UX

---

#### Risk 3: Performance Degradation

**Severity:** Medium
**Probability:** Low
**Impact:** Slow page loads and poor user experience

**Description:**
Large component trees, inefficient rendering, or poor React Query configuration could lead to performance issues.

**Mitigation:**
- Use React.memo for expensive list items
- Implement pagination (don't load all data at once)
- Configure appropriate React Query cache times
- Use Lighthouse audits throughout development
- Profile with React DevTools
- Lazy load heavy components

**Contingency Plan:**
If performance targets missed:
1. Add virtual scrolling for long lists
2. Implement more aggressive code splitting
3. Reduce initial bundle size
4. Optimize images and assets

---

#### Risk 4: Browser Compatibility Issues

**Severity:** Low
**Probability:** Low
**Impact:** Broken functionality on older browsers

**Description:**
Modern JavaScript/React features may not work on older browsers, despite Next.js polyfills.

**Mitigation:**
- Test on target browser versions early
- Use Next.js built-in polyfills
- Avoid cutting-edge ES features
- Check caniuse.com for feature support
- Add browserslist configuration

**Contingency Plan:**
If compatibility issues arise:
1. Add additional polyfills
2. Transpile to lower ES version
3. Adjust browser support targets
4. Provide graceful degradation

---

### 11.2 User Experience Risks

#### Risk 5: Confusing Optimistic UI Behavior

**Severity:** Medium
**Probability:** Medium
**Impact:** Users confused by temporary states

**Description:**
Users may be confused when mock operations appear to succeed but data doesn't persist across page refreshes.

**Mitigation:**
- Add clear messaging about demo nature
- Include banner: "Demo mode - changes are not saved"
- Show toast notifications for all actions
- Add "mock" badges on write operations
- Document behavior in FAQ/help section

**Contingency Plan:**
If user confusion persists:
1. Add more prominent demo disclaimers
2. Include tutorial/onboarding
3. Add help tooltips on write operations
4. Consider adding a "reset demo" button

---

#### Risk 6: Accessibility Gaps

**Severity:** Medium
**Probability:** Low
**Impact:** Unusable for screen reader or keyboard users

**Description:**
Complex interactions, custom components, or missing ARIA labels could create accessibility barriers.

**Mitigation:**
- Use shadcn/ui (built on Radix with good accessibility)
- Run Lighthouse accessibility audits
- Test with screen readers (NVDA)
- Test keyboard navigation manually
- Add ARIA labels for all interactive elements
- Follow WCAG 2.1 Level AA guidelines

**Contingency Plan:**
If accessibility issues found:
1. Prioritize critical path fixes
2. Add missing ARIA labels
3. Fix keyboard navigation
4. Improve focus management
5. Document known issues

---

### 11.3 Development Risks

#### Risk 7: Scope Creep

**Severity:** Medium
**Probability:** Medium
**Impact:** Delayed delivery, incomplete features

**Description:**
Temptation to add features beyond the 20 defined user stories (real persistence, authentication, etc.)

**Mitigation:**
- Strict adherence to PRD scope
- Clear "out of scope" section
- Regular checkpoint reviews
- Feature freeze after Phase 5
- Defer enhancements to "stretch goals"

**Contingency Plan:**
If scope expands:
1. Re-prioritize features (MVP first)
2. Push non-critical items to Phase 7
3. Consider cutting lower-priority stories
4. Adjust timeline if necessary

---

#### Risk 8: Testing Gaps

**Severity:** Medium
**Probability:** Medium
**Impact:** Bugs in production, poor quality

**Description:**
Insufficient testing coverage or missing critical test scenarios could lead to undetected bugs.

**Mitigation:**
- Define test strategy early (unit, integration, E2E)
- Aim for 80% code coverage minimum
- Write tests alongside features (not at the end)
- Automate critical path E2E tests
- Use CI/CD to run tests on every commit

**Contingency Plan:**
If testing is behind schedule:
1. Prioritize E2E tests for critical paths
2. Focus on happy paths first
3. Manual testing for edge cases
4. Accept lower coverage for stretch goals
5. Add tests post-launch

---

#### Risk 9: Learning Curve for New Technologies

**Severity:** Low
**Probability:** Medium
**Impact:** Slower initial development

**Description:**
Team may be unfamiliar with Next.js 15 App Router, React Query v5, or shadcn/ui patterns.

**Mitigation:**
- Allocate extra time in Phase 1 for learning
- Provide documentation and examples
- Pair programming for complex patterns
- Reference official docs and examples
- Build proof-of-concepts for tricky features

**Contingency Plan:**
If learning curve is steeper than expected:
1. Allocate more time to Phase 1
2. Focus on simpler approaches first
3. Use more familiar patterns where possible
4. Seek community help (Discord, Stack Overflow)

---

### 11.4 Risk Matrix

| Risk | Severity | Probability | Priority |
|------|----------|-------------|----------|
| API Reliability | High | Low | High |
| Optimistic UI Bugs | Medium | Medium | High |
| Performance Issues | Medium | Low | Medium |
| Browser Compatibility | Low | Low | Low |
| Confusing UX | Medium | Medium | High |
| Accessibility Gaps | Medium | Low | Medium |
| Scope Creep | Medium | Medium | High |
| Testing Gaps | Medium | Medium | High |
| Learning Curve | Low | Medium | Low |

---

## 12. Out of Scope

### 12.1 Authentication & Authorization

**Not Included:**
- User accounts or registration
- Login/logout functionality
- OAuth integration (Google, GitHub, etc.)
- Password management
- Session management
- JWT tokens
- Role-based access control
- Protected routes

**Rationale:**
The application is intentionally public and anonymous to avoid infrastructure complexity and security concerns.

---

### 12.2 Data Persistence

**Not Included:**
- Database (SQL or NoSQL)
- Backend API server
- Real data storage
- User-generated content persistence
- File uploads
- Data export/import (except stretch goal)

**Rationale:**
All data comes from JSONPlaceholder. Write operations are mocked with optimistic UI only.

---

### 12.3 Real-time Features

**Not Included:**
- WebSocket connections
- Real-time updates across users
- Live notifications
- Chat functionality
- Collaborative editing
- Presence indicators

**Rationale:**
No backend infrastructure to support real-time features.

---

### 12.4 Advanced Social Features

**Not Included:**
- Likes, reactions, shares
- Follow/unfollow users
- Direct messaging
- Notifications system
- Activity feed
- Trending topics
- Hashtags or tagging
- Mentions (@username)

**Rationale:**
Beyond demo scope; would require persistence and complex state.

---

### 12.5 Media Handling

**Not Included:**
- Image uploads
- Video uploads
- File attachments
- Image galleries
- Media processing
- CDN integration

**Rationale:**
JSONPlaceholder doesn't support media; would require backend.

---

### 12.6 Advanced Search

**Not Included:**
- Full-text search
- Search indexing
- Advanced filters (date ranges, etc.)
- Saved searches
- Search history
- Search suggestions

**Rationale:**
Client-side filtering sufficient for small dataset (100 posts).

---

### 12.7 Analytics & Monitoring

**Not Included:**
- User analytics (Google Analytics, etc.)
- Error tracking (Sentry)
- Performance monitoring (New Relic)
- A/B testing
- User behavior tracking
- Conversion funnels

**Rationale:**
Demo application doesn't require analytics.

---

### 12.8 Internationalization

**Not Included:**
- Multi-language support
- Translation system
- Locale-specific formatting
- RTL layouts (though architecture supports it)
- Currency conversion
- Timezone handling

**Rationale:**
English-only for MVP to reduce complexity.

---

### 12.9 Advanced UI Features

**Not Included:**
- Drag-and-drop
- Rich text editor
- WYSIWYG editor
- Markdown editor
- Emoji picker
- Advanced animations
- 3D graphics
- Video player

**Rationale:**
Standard forms and text inputs are sufficient.

---

### 12.10 Mobile Apps

**Not Included:**
- Native iOS app
- Native Android app
- React Native implementation
- Mobile app stores
- Push notifications
- Deep linking

**Rationale:**
Responsive web app only; no native mobile development.

---

### 12.11 Payment & Monetization

**Not Included:**
- Payment processing
- Subscriptions
- Ads integration
- Premium features
- In-app purchases

**Rationale:**
Non-commercial demo application.

---

### 12.12 Admin Features

**Not Included:**
- Admin dashboard
- User management
- Content moderation
- Reporting system
- Analytics dashboard
- Configuration UI

**Rationale:**
No admin needs for demo app with no persistence.

---

### 12.13 SEO & Marketing

**Not Included:**
- Advanced SEO optimization
- Social media cards (beyond basic meta tags)
- Sitemap generation
- RSS feeds
- Email newsletters
- Marketing automation

**Rationale:**
Demo app doesn't need marketing features.

---

### 12.14 API Features

**Not Included:**
- Public API for third parties
- API documentation (Swagger)
- Rate limiting
- API keys
- Webhooks
- GraphQL endpoint

**Rationale:**
No backend API provided.

---

## 13. Appendix

### 13.1 Glossary

| Term | Definition |
|------|------------|
| **API** | Application Programming Interface - interface for communication between systems |
| **CRUD** | Create, Read, Update, Delete - basic database operations |
| **E2E** | End-to-End - testing approach covering full user workflows |
| **JSONPlaceholder** | Free fake online REST API for testing and prototyping |
| **Optimistic UI** | UX pattern that updates UI before server confirmation |
| **React Query** | Data fetching and state management library for React |
| **shadcn/ui** | Component library built on Radix UI primitives |
| **SSR** | Server-Side Rendering - rendering React on the server |
| **Stale-While-Revalidate** | Caching strategy showing cached data while fetching fresh |
| **TanStack Query** | New name for React Query library |
| **Zod** | TypeScript-first schema validation library |

### 13.2 References

**Technology Documentation:**
- [Next.js 15 Documentation](https://nextjs.org/docs)
- [React Query (TanStack Query) Docs](https://tanstack.com/query/latest)
- [shadcn/ui Documentation](https://ui.shadcn.com)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [React Hook Form](https://react-hook-form.com)
- [Zod Documentation](https://zod.dev)

**APIs:**
- [JSONPlaceholder Guide](https://jsonplaceholder.typicode.com/guide/)
- [JSONPlaceholder Resources](https://jsonplaceholder.typicode.com)

**Testing:**
- [Jest Documentation](https://jestjs.io/docs/getting-started)
- [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)
- [Playwright Documentation](https://playwright.dev)

**Accessibility:**
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Radix UI Accessibility](https://www.radix-ui.com/docs/primitives/overview/accessibility)
- [axe DevTools](https://www.deque.com/axe/devtools/)

### 13.3 Example User Flows

#### User Flow 1: Browsing and Commenting

1. User lands on homepage (posts feed)
2. User scrolls through posts
3. User searches for "sunt" in search box
4. Results filter to matching posts
5. User clicks on a post
6. User reads post detail
7. User scrolls to comments section
8. User fills out comment form (name, email, comment)
9. User clicks "Add Comment"
10. Comment appears immediately (optimistic)
11. Toast notification shows "Comment added"
12. User navigates back to feed

#### User Flow 2: Exploring User Profile

1. User clicks "Users" in navigation
2. User sees grid of user cards
3. User clicks on "Leanne Graham"
4. User profile page loads
5. User sees contact info and address
6. User clicks "Posts" tab
7. User sees Leanne's posts
8. User clicks "Todos" tab
9. User sees Leanne's todo list
10. User toggles a todo complete
11. Todo updates immediately (optimistic)
12. Toast shows "Todo updated"

#### User Flow 3: Managing Todos

1. User navigates to specific user profile
2. User clicks "Todos" tab
3. User clicks "Add Todo" button
4. Dialog opens with todo form
5. User enters todo title
6. User clicks "Create"
7. Todo appears in list immediately
8. Toast shows "Todo created"
9. User toggles todo complete
10. Todo gets strikethrough
11. User filters by "Completed"
12. Only completed todos show

### 13.4 Component Hierarchy

```
App (layout.tsx)
├── Navigation
│   ├── Logo
│   ├── NavigationMenu
│   └── SearchButton
├── Page (/)
│   ├── PostList
│   │   ├── SearchInput
│   │   ├── AuthorFilter
│   │   ├── PostCard[]
│   │   │   ├── UserAvatar
│   │   │   ├── CommentBadge
│   │   │   └── PostContent
│   │   └── Pagination
│   └── EmptyState
├── Page (/posts/[id])
│   ├── PostDetail
│   │   ├── BackButton
│   │   ├── PostHeader
│   │   │   ├── UserAvatar
│   │   │   └── PostMeta
│   │   └── PostBody
│   ├── CommentList
│   │   ├── CommentForm
│   │   └── CommentItem[]
│   │       ├── UserAvatar
│   │       ├── CommentContent
│   │       └── CommentActions
│   │           ├── EditButton
│   │           └── DeleteButton
│   └── LoadingSkeleton
├── Page (/users)
│   ├── UserGrid
│   │   └── UserCard[]
│   │       ├── UserAvatar
│   │       ├── UserInfo
│   │       └── ViewProfileButton
│   └── EmptyState
├── Page (/users/[id])
│   ├── UserProfile
│   │   ├── BackButton
│   │   ├── UserHeader
│   │   │   ├── UserAvatar
│   │   │   └── UserInfo
│   │   ├── UserAddress
│   │   │   └── MapPlaceholder
│   │   └── UserCompany
│   ├── TabNavigation
│   │   ├── PostsTab
│   │   └── TodosTab
│   ├── TabContent (Posts)
│   │   └── PostCard[]
│   └── TabContent (Todos)
│       ├── TodoList
│       │   ├── TodoFilter
│       │   ├── AddTodoButton
│       │   └── TodoItem[]
│       │       ├── Checkbox
│       │       └── TodoActions
│       └── EmptyState
└── Toaster (sonner)
```

### 13.5 Sample API Response Structures

**Post:**
```json
{
  "id": 1,
  "userId": 1,
  "title": "sunt aut facere repellat provident",
  "body": "quia et suscipit\nsuscipit recusandae..."
}
```

**User:**
```json
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {
      "lat": "-37.3159",
      "lng": "81.1496"
    }
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
}
```

**Comment:**
```json
{
  "id": 1,
  "postId": 1,
  "name": "id labore ex et quam laborum",
  "email": "Eliseo@gardner.biz",
  "body": "laudantium enim quasi est quidem magnam..."
}
```

**Todo:**
```json
{
  "id": 1,
  "userId": 1,
  "title": "delectus aut autem",
  "completed": false
}
```

### 13.6 Environment Variables

```bash
# .env.local (example)

# API Configuration
NEXT_PUBLIC_API_BASE_URL=https://jsonplaceholder.typicode.com

# Feature Flags (optional)
NEXT_PUBLIC_ENABLE_DEVTOOLS=true
NEXT_PUBLIC_ENABLE_EXPORT=false

# Optional (for stretch goals)
NEXT_PUBLIC_ENABLE_OFFLINE=false
```

### 13.7 Package.json Scripts

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "lint:fix": "next lint --fix",
    "format": "prettier --write .",
    "type-check": "tsc --noEmit",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "analyze": "ANALYZE=true next build"
  }
}
```

### 13.8 CI/CD Pipeline (GitHub Actions Example)

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
      - run: npm ci
      - run: npm run lint
      - run: npm run type-check
      - run: npm run test:coverage
      - run: npm run build

  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npm run build
      - run: npm run test:e2e

  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
      - run: npm ci
      - run: npm run build
      - run: npm run start &
      - uses: treosh/lighthouse-ci-action@v9
        with:
          urls: |
            http://localhost:3000
            http://localhost:3000/users
            http://localhost:3000/posts/1
          uploadArtifacts: true
```

### 13.9 Deployment Checklist

**Pre-Deployment:**
- [ ] All tests passing
- [ ] Lighthouse scores ≥ 90
- [ ] Zero TypeScript errors
- [ ] Zero ESLint warnings
- [ ] Build succeeds without warnings
- [ ] Environment variables configured
- [ ] README updated
- [ ] CHANGELOG updated

**Deployment Steps:**
1. Create production build (`npm run build`)
2. Run production build locally (`npm run start`)
3. Test all critical paths manually
4. Deploy to Vercel/Netlify/hosting
5. Verify deployment URL works
6. Run smoke tests on production
7. Monitor for errors

**Post-Deployment:**
- [ ] All routes accessible
- [ ] All features working
- [ ] No console errors
- [ ] Performance acceptable
- [ ] Mobile responsive
- [ ] Cross-browser tested

### 13.10 Support and Maintenance

**Bug Reports:**
- GitHub Issues for tracking
- Include reproduction steps
- Provide browser/OS information
- Include screenshots if applicable

**Feature Requests:**
- Logged as GitHub Issues
- Labeled "enhancement"
- Prioritized in backlog
- Consider for future phases

**Documentation:**
- README.md in repository
- Inline code comments
- Component documentation
- API service documentation

---

## Document Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Product Manager | _______________ | __________ | ___________ |
| Engineering Lead | _______________ | __________ | ___________ |
| QA Lead | _______________ | __________ | ___________ |
| Stakeholder | _______________ | __________ | ___________ |

---

**Document History:**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-10-01 | Product Manager | Initial PRD creation |

---

**End of Product Requirements Document**
