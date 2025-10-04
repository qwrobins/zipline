# Data Models

The application works with four primary entities from the JSONPlaceholder API. These TypeScript interfaces serve as the shared data contracts across the entire application.

## Post

**Purpose:** Represents a social media post with title and body content authored by a user.

**Key Attributes:**
- `id`: number - Unique post identifier
- `userId`: number - Foreign key to user who created the post
- `title`: string - Post headline (displayed prominently)
- `body`: string - Full post content (can be truncated in list views)

**TypeScript Interface:**

```typescript
interface Post {
  id: number;
  userId: number;
  title: string;
  body: string;
}
```

**Relationships:**
- Many-to-one with User (posts.userId → users.id)
- One-to-many with Comment (post.id → comments.postId)

## User

**Purpose:** Represents a system user with profile information, contact details, and company affiliation.

**Key Attributes:**
- `id`: number - Unique user identifier
- `name`: string - Full display name
- `username`: string - Unique username handle
- `email`: string - Contact email address
- `phone`: string - Contact phone number
- `website`: string - Personal or company website
- `address`: Address - Nested address object with geo coordinates
- `company`: Company - Nested company object

**TypeScript Interface:**

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

**Relationships:**
- One-to-many with Post (user.id → posts.userId)
- One-to-many with Todo (user.id → todos.userId)

## Comment

**Purpose:** Represents a comment on a post with commenter information and body text.

**Key Attributes:**
- `id`: number - Unique comment identifier
- `postId`: number - Foreign key to parent post
- `name`: string - Commenter name (may differ from User.name)
- `email`: string - Commenter email
- `body`: string - Comment text content

**TypeScript Interface:**

```typescript
interface Comment {
  id: number;
  postId: number;
  name: string;
  email: string;
  body: string;
}
```

**Relationships:**
- Many-to-one with Post (comments.postId → posts.id)

## Todo

**Purpose:** Represents a task item with title and completion status assigned to a user.

**Key Attributes:**
- `id`: number - Unique todo identifier
- `userId`: number - Foreign key to assigned user
- `title`: string - Task description
- `completed`: boolean - Completion status

**TypeScript Interface:**

```typescript
interface Todo {
  id: number;
  userId: number;
  title: string;
  completed: boolean;
}
```

**Relationships:**
- Many-to-one with User (todos.userId → users.id)

---
