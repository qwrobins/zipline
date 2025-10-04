# Epic 3: Comments & Engagement

**Goal**: Implement full comment functionality allowing users to view, create, edit, and delete comments on posts using optimistic UI patterns. This epic delivers core engagement features that make the application feel interactive and dynamic, demonstrating complete CRUD operations with immediate user feedback despite mock backend operations.

## Story 3.1: View Comments on Post Detail

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

## Story 3.2: Add New Comment (Optimistic UI)

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

## Story 3.3: Edit Comment (Optimistic UI)

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

## Story 3.4: Delete Comment (Optimistic UI with Undo)

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

## Story 3.5: Comment Count Badges on Feed

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
