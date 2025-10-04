# Testing Strategy

## Testing Pyramid

```
           E2E Tests (Playwright)
          /                      \
         /   Integration Tests    \
        /    (React Testing Lib)   \
       /                            \
      /   Unit Tests (Jest + RTL)   \
     /________________________________\
```

**Test Coverage Targets:**
- Unit Tests: 70%+ component and utility coverage
- Integration Tests: All critical user flows (forms, CRUD operations)
- E2E Tests: 100% coverage of PRD functional requirements

## Test Organization

### Frontend Tests

```
tests/
├── unit/
│   ├── components/
│   │   ├── posts/
│   │   │   ├── post-card.test.tsx
│   │   │   └── post-list.test.tsx
│   │   ├── comments/
│   │   │   ├── comment-form.test.tsx
│   │   │   └── comment-item.test.tsx
│   │   └── shared/
│   │       ├── pagination.test.tsx
│   │       └── search-input.test.tsx
│   ├── hooks/
│   │   ├── use-posts.test.ts
│   │   ├── use-comments.test.ts
│   │   └── use-todos.test.ts
│   └── utils/
│       ├── format.test.ts
│       └── validators.test.ts
└── integration/
    ├── post-viewing.test.tsx
    ├── comment-crud.test.tsx
    └── todo-management.test.tsx
```

### E2E Tests

```
tests/e2e/
├── posts/
│   ├── view-posts-feed.spec.ts
│   ├── view-post-detail.spec.ts
│   ├── search-posts.spec.ts
│   └── filter-posts.spec.ts
├── comments/
│   ├── create-comment.spec.ts
│   ├── edit-comment.spec.ts
│   └── delete-comment.spec.ts
├── users/
│   ├── view-user-directory.spec.ts
│   └── view-user-profile.spec.ts
└── todos/
    ├── toggle-todo.spec.ts
    ├── create-todo.spec.ts
    ├── reassign-todo.spec.ts
    └── filter-todos.spec.ts
```

## Test Examples

### Frontend Component Test

```typescript
// tests/unit/components/posts/post-card.test.tsx
import { render, screen } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { PostCard } from '@/components/posts/post-card';
import type { Post } from '@/types';

const mockPost: Post = {
  id: 1,
  userId: 1,
  title: 'Test Post',
  body: 'This is a test post body',
};

const createWrapper = () => {
  const queryClient = new QueryClient({
    defaultOptions: { queries: { retry: false } },
  });
  return ({ children }: { children: React.ReactNode }) => (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  );
};

describe('PostCard', () => {
  it('renders post title and body excerpt', () => {
    render(<PostCard post={mockPost} />, { wrapper: createWrapper() });

    expect(screen.getByText('Test Post')).toBeInTheDocument();
    expect(screen.getByText('This is a test post body')).toBeInTheDocument();
  });

  it('calls onClick when card is clicked', async () => {
    const handleClick = jest.fn();
    const { user } = render(
      <PostCard post={mockPost} onClick={handleClick} />,
      { wrapper: createWrapper() }
    );

    await user.click(screen.getByRole('article'));

    expect(handleClick).toHaveBeenCalledWith(1);
  });
});
```

### Integration Test

```typescript
// tests/integration/comment-crud.test.tsx
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { rest } from 'msw';
import { setupServer } from 'msw/node';
import { PostDetail } from '@/app/posts/[id]/page';

const server = setupServer(
  rest.post('https://jsonplaceholder.typicode.com/posts/1/comments', (req, res, ctx) => {
    return res(
      ctx.status(201),
      ctx.json({ id: 501, postId: 1, name: 'Test User', email: 'test@example.com', body: 'Test comment' })
    );
  })
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

describe('Comment CRUD Flow', () => {
  it('creates a new comment with optimistic UI', async () => {
    const user = userEvent.setup();
    const queryClient = new QueryClient();

    render(
      <QueryClientProvider client={queryClient}>
        <PostDetail params={{ id: '1' }} />
      </QueryClientProvider>
    );

    // Wait for post to load
    await screen.findByRole('heading', { name: /post title/i });

    // Fill comment form
    await user.type(screen.getByLabelText(/name/i), 'Test User');
    await user.type(screen.getByLabelText(/email/i), 'test@example.com');
    await user.type(screen.getByLabelText(/comment/i), 'Test comment');

    // Submit form
    await user.click(screen.getByRole('button', { name: /submit/i }));

    // Verify optimistic update (comment appears immediately)
    expect(await screen.findByText('Test comment')).toBeInTheDocument();

    // Verify success toast
    await waitFor(() => {
      expect(screen.getByText(/comment added/i)).toBeInTheDocument();
    });
  });
});
```

### E2E Test

```typescript
// tests/e2e/comments/create-comment.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Comment Creation', () => {
  test('user can create a comment on a post', async ({ page }) => {
    // Navigate to post detail
    await page.goto('/posts/1');

    // Wait for page to load
    await expect(page.locator('h1')).toBeVisible();

    // Scroll to comment form
    await page.locator('[data-testid="comment-form"]').scrollIntoViewIfNeeded();

    // Fill out comment form
    await page.fill('input[name="name"]', 'E2E Test User');
    await page.fill('input[name="email"]', 'e2e@example.com');
    await page.fill('textarea[name="body"]', 'This is an E2E test comment');

    // Submit form
    await page.click('button[type="submit"]');

    // Verify optimistic update
    await expect(page.locator('text=This is an E2E test comment')).toBeVisible();

    // Verify success toast
    await expect(page.locator('text=/comment added/i')).toBeVisible();

    // Verify comment appears in list
    const commentList = page.locator('[data-testid="comment-list"]');
    await expect(commentList.locator('text=E2E Test User')).toBeVisible();
  });

  test('shows validation errors for invalid input', async ({ page }) => {
    await page.goto('/posts/1');

    // Try to submit empty form
    await page.click('button[type="submit"]');

    // Verify validation errors
    await expect(page.locator('text=/name is required/i')).toBeVisible();
    await expect(page.locator('text=/email is required/i')).toBeVisible();
    await expect(page.locator('text=/comment is required/i')).toBeVisible();
  });
});
```

---
