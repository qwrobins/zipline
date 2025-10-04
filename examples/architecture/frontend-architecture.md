# Frontend Architecture

## Component Architecture

### Component Organization

```
src/
├── components/
│   ├── ui/                      # shadcn/ui primitives
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── input.tsx
│   │   ├── avatar.tsx
│   │   ├── badge.tsx
│   │   ├── skeleton.tsx
│   │   ├── tabs.tsx
│   │   ├── dialog.tsx
│   │   └── ...
│   ├── posts/                   # Post-related components
│   │   ├── post-card.tsx
│   │   ├── post-detail.tsx
│   │   ├── post-list.tsx
│   │   └── post-filters.tsx
│   ├── comments/                # Comment components
│   │   ├── comment-list.tsx
│   │   ├── comment-item.tsx
│   │   ├── comment-form.tsx
│   │   └── comment-actions.tsx
│   ├── users/                   # User components
│   │   ├── user-card.tsx
│   │   ├── user-profile.tsx
│   │   ├── user-directory.tsx
│   │   └── user-avatar.tsx
│   ├── todos/                   # Todo components
│   │   ├── todo-list.tsx
│   │   ├── todo-item.tsx
│   │   ├── todo-form.tsx
│   │   └── todo-filters.tsx
│   └── shared/                  # Shared components
│       ├── navigation.tsx
│       ├── pagination.tsx
│       ├── search-input.tsx
│       ├── error-boundary.tsx
│       └── loading-skeleton.tsx
```

### Component Template

```typescript
import { FC } from 'react';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';

interface PostCardProps {
  post: Post;
  onClick?: (id: number) => void;
  showAuthor?: boolean;
}

/**
 * PostCard - Displays a post summary with optional author information
 *
 * @example
 * <PostCard post={post} onClick={handleClick} showAuthor />
 */
export const PostCard: FC<PostCardProps> = ({
  post,
  onClick,
  showAuthor = true
}) => {
  const { data: user } = useUser(post.userId);

  return (
    <Card
      className="cursor-pointer hover:shadow-lg transition-shadow"
      onClick={() => onClick?.(post.id)}
    >
      <CardHeader>
        <CardTitle>{post.title}</CardTitle>
        {showAuthor && user && (
          <div className="flex items-center gap-2 text-sm text-muted-foreground">
            <UserAvatar user={user} size="sm" />
            <span>{user.name}</span>
          </div>
        )}
      </CardHeader>
      <CardContent>
        <p className="text-sm text-muted-foreground line-clamp-3">
          {post.body}
        </p>
      </CardContent>
    </Card>
  );
};
```

## State Management Architecture

### State Structure

```typescript
// React Query manages ALL server state - no global state needed for this app

// Query Keys (centralized for consistency)
export const queryKeys = {
  posts: {
    all: ['posts'] as const,
    lists: () => [...queryKeys.posts.all, 'list'] as const,
    list: (filters: PostFilters) => [...queryKeys.posts.lists(), filters] as const,
    details: () => [...queryKeys.posts.all, 'detail'] as const,
    detail: (id: number) => [...queryKeys.posts.details(), id] as const,
  },
  comments: {
    all: ['comments'] as const,
    lists: () => [...queryKeys.comments.all, 'list'] as const,
    list: (postId: number) => [...queryKeys.comments.lists(), postId] as const,
  },
  users: {
    all: ['users'] as const,
    lists: () => [...queryKeys.users.all, 'list'] as const,
    list: () => [...queryKeys.users.lists()] as const,
    details: () => [...queryKeys.users.all, 'detail'] as const,
    detail: (id: number) => [...queryKeys.users.details(), id] as const,
  },
  todos: {
    all: ['todos'] as const,
    lists: () => [...queryKeys.todos.all, 'list'] as const,
    list: (filters: TodoFilters) => [...queryKeys.todos.lists(), filters] as const,
  },
} as const;

// React Query Configuration
export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      cacheTime: 10 * 60 * 1000, // 10 minutes
      retry: 2,
      refetchOnWindowFocus: false,
    },
    mutations: {
      retry: 1,
    },
  },
});
```

### State Management Patterns

- **Server State Only:** All data managed by React Query; no Redux/Zustand needed
- **Optimistic Updates:** All mutations update cache immediately before API confirmation
- **Query Key Hierarchy:** Structured keys enable precise cache invalidation (e.g., invalidate all posts or specific post)
- **Temporary IDs:** Client-generated IDs (negative numbers or UUIDs) for optimistic creates
- **Rollback on Failure:** Automatic cache rollback if API returns error
- **Prefetching:** Hover-triggered prefetching on post/user links
- **Background Refetching:** Automatic refetch on mount for fresh data

## Routing Architecture

### Route Organization

```
app/
├── layout.tsx                   # Root layout with providers
├── page.tsx                     # Posts feed (/)
├── posts/
│   └── [id]/
│       └── page.tsx            # Post detail (/posts/[id])
├── users/
│   ├── page.tsx                # User directory (/users)
│   └── [id]/
│       └── page.tsx            # User profile (/users/[id])
├── todos/
│   └── page.tsx                # Global todos (/todos)
├── error.tsx                   # Error boundary
├── loading.tsx                 # Loading UI
└── not-found.tsx               # 404 page
```

### Route Patterns

- **App Router File Conventions:** Use Next.js 15 file-based routing
- **Dynamic Routes:** `[id]` for post and user detail pages
- **URL State Management:** Search params for filters (`?page=2&q=foo&userId=3`)
- **Server Components:** Use RSC for initial data fetching where beneficial
- **Client Components:** Mark interactive components with 'use client'

## Frontend Services Layer

### API Client Setup

```typescript
// lib/api/client.ts
import { z } from 'zod';

const BASE_URL = 'https://jsonplaceholder.typicode.com';

class APIError extends Error {
  constructor(
    message: string,
    public statusCode: number,
    public response?: unknown
  ) {
    super(message);
    this.name = 'APIError';
  }
}

async function apiFetch<T>(
  endpoint: string,
  options?: RequestInit,
  schema?: z.ZodSchema<T>
): Promise<T> {
  const url = `${BASE_URL}${endpoint}`;

  try {
    const response = await fetch(url, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options?.headers,
      },
    });

    if (!response.ok) {
      throw new APIError(
        `API request failed: ${response.statusText}`,
        response.status
      );
    }

    const data = await response.json();

    // Validate response with Zod schema
    if (schema) {
      return schema.parse(data);
    }

    return data as T;
  } catch (error) {
    if (error instanceof APIError) {
      throw error;
    }
    throw new APIError('Network request failed', 0, error);
  }
}

export { apiFetch, APIError };
```

### Service Example

```typescript
// lib/api/posts.ts
import { apiFetch } from './client';
import { postSchema, postArraySchema } from './schemas';
import type { Post } from '@/types';

export async function fetchPosts(params?: {
  userId?: number;
  page?: number;
}): Promise<Post[]> {
  const searchParams = new URLSearchParams();
  if (params?.userId) searchParams.set('userId', params.userId.toString());

  const query = searchParams.toString();
  const endpoint = `/posts${query ? `?${query}` : ''}`;

  return apiFetch(endpoint, undefined, postArraySchema);
}

export async function fetchPost(id: number): Promise<Post> {
  return apiFetch(`/posts/${id}`, undefined, postSchema);
}

export async function createComment(
  postId: number,
  data: { name: string; email: string; body: string }
): Promise<Comment> {
  return apiFetch(`/posts/${postId}/comments`, {
    method: 'POST',
    body: JSON.stringify(data),
  });
}
```

---
