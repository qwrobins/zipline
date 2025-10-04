# Epic 2: User Profiles & Directory

**Goal**: Create a comprehensive user directory and detailed profile pages that display user information, their posts, todos, and a visual representation of their address. This epic enables users to explore content by author and understand user context, delivering value through improved content discovery and user relationship visualization.

## Story 2.1: User Directory Page

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

## Story 2.2: User Profile - Basic Information

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

## Story 2.3: User Profile - Posts Tab

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

## Story 2.4: User Profile - Todos Tab

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

## Story 2.5: Address Visualization Enhancement

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
