# Coding Standards

## Critical Fullstack Rules

- **Type Safety:** Enable TypeScript strict mode; no `any` types without explicit justification
- **API Response Validation:** All API responses must be validated with Zod schemas before use
- **Error Boundaries:** Wrap all route segments with error.tsx for graceful error handling
- **Optimistic Updates:** All mutations must implement optimistic updates with rollback logic
- **Query Key Consistency:** Always use centralized queryKeys object; never hardcode strings
- **Form Validation:** Use React Hook Form + Zod for all forms; no uncontrolled inputs
- **Accessibility:** All interactive elements must have proper ARIA labels and keyboard navigation
- **Component Composition:** Prefer composition over prop drilling; use context for deep data passing
- **Immutable State:** Never mutate React Query cache directly; use setQueryData with immutable updates
- **Loading States:** Always show skeletons during data fetching; never blank screens
- **Error Handling:** Catch and display user-friendly errors; use toast notifications for feedback
- **Environment Variables:** Never hardcode URLs; use env vars for all external endpoints

## Naming Conventions

| Element | Frontend | Example |
|---------|----------|---------|
| Components | PascalCase | `PostCard.tsx`, `UserProfile.tsx` |
| Hooks | camelCase with 'use' prefix | `usePost.ts`, `useCreateComment.ts` |
| Utilities | camelCase | `formatDate.ts`, `validateEmail.ts` |
| Types/Interfaces | PascalCase | `Post`, `CommentFormData` |
| Constants | SCREAMING_SNAKE_CASE | `API_BASE_URL`, `MAX_PAGE_SIZE` |
| CSS Classes | kebab-case (Tailwind) | `bg-blue-500`, `hover:shadow-lg` |
| Files | kebab-case | `post-card.tsx`, `use-posts.ts` |
| Props Interfaces | PascalCase with 'Props' suffix | `PostCardProps`, `CommentFormProps` |

---
