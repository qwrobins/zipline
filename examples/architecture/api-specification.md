# API Specification

## External API: JSONPlaceholder

The application exclusively uses JSONPlaceholder as its data source. All API calls are RESTful HTTP requests.

**Base URL:** `https://jsonplaceholder.typicode.com`

**Authentication:** None required (public API)

**Rate Limits:** No documented rate limits; reasonable use expected

**Key Endpoints Used:**

| Method | Endpoint | Purpose | Response |
|--------|----------|---------|----------|
| GET | `/posts` | Fetch all posts | Array of Post objects |
| GET | `/posts?userId={id}` | Fetch posts by user | Filtered Post array |
| GET | `/posts/{id}` | Fetch single post | Single Post object |
| GET | `/posts/{id}/comments` | Fetch comments for post | Array of Comment objects |
| POST | `/posts/{postId}/comments` | Create comment (mock) | Created Comment object |
| PUT | `/comments/{id}` | Update comment (mock) | Updated Comment object |
| DELETE | `/comments/{id}` | Delete comment (mock) | Empty response |
| GET | `/users` | Fetch all users | Array of User objects |
| GET | `/users/{id}` | Fetch single user | Single User object |
| GET | `/users/{id}/posts` | Fetch user's posts | Array of Post objects |
| GET | `/users/{id}/todos` | Fetch user's todos | Array of Todo objects |
| GET | `/todos` | Fetch all todos | Array of Todo objects |
| POST | `/todos` | Create todo (mock) | Created Todo object |
| PATCH | `/todos/{id}` | Update todo (mock) | Updated Todo object |

**Integration Notes:**

- **Mock CRUD Behavior:** JSONPlaceholder accepts POST/PUT/PATCH/DELETE requests and returns proper HTTP status codes (201, 200) but does NOT persist data. The API returns simulated responses with IDs.
- **Optimistic UI Strategy:** All write operations must implement optimistic updates since JSONPlaceholder won't reflect changes on subsequent GET requests.
- **Cache Invalidation:** React Query cache must be manually updated after mutations to maintain consistency.
- **Fake IDs:** Created resources receive temporary IDs (e.g., 101) that won't exist on next fetch. Store optimistic data in React Query cache with negative IDs or UUID prefixes to distinguish from real data.

---
