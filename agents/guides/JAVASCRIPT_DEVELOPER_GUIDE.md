# JavaScript Developer Agent Guide

This guide provides comprehensive information about the `javascript-developer` agent, the first specialized development agent for implementing features in JavaScript/TypeScript projects.

## Overview

The `javascript-developer` agent is an expert AI assistant specialized in modern JavaScript ecosystem development. It can implement features, fix bugs, refactor code, and provide technical guidance for projects using JavaScript, TypeScript, Node.js, React, and Next.js.

## When to Use This Agent

Use the `javascript-developer` agent when you need to:

- ✅ Implement React components with TypeScript
- ✅ Create Next.js pages, layouts, or API routes
- ✅ Build Node.js backend services or APIs
- ✅ Fix bugs in JavaScript/TypeScript codebases
- ✅ Refactor code for better performance or maintainability
- ✅ Set up testing infrastructure (Jest, Vitest, React Testing Library)
- ✅ Implement state management solutions (Context, Zustand, React Query)
- ✅ Optimize React application performance
- ✅ Add TypeScript types to existing JavaScript code
- ✅ Write tests for components, hooks, or utilities

## Technology Expertise

### Languages & Runtimes
- **JavaScript (ES6+)**: Modern syntax, async/await, modules, destructuring
- **TypeScript**: Type systems, interfaces, generics, strict mode
- **Node.js**: Runtime APIs, event loop, streams, file system

### Frameworks & Libraries
- **React**: Hooks, component patterns, performance optimization
- **Next.js**: App Router, Pages Router, Server Components, API routes
- **State Management**: React Context, Zustand, Redux Toolkit, React Query
- **Styling**: Tailwind CSS, CSS Modules, styled-components

### Tooling
- **Package Managers**: npm, yarn, pnpm
- **Code Quality**: ESLint, Prettier, TypeScript compiler
- **Testing**: Jest, Vitest, React Testing Library, Playwright, Cypress

## How to Invoke

In Claude Code, use the `/agents` command:

```
/agents javascript-developer
```

Then provide your request. Examples:

### Example 1: Implement a Component

```
/agents javascript-developer

Create a reusable Card component in React with TypeScript that:
- Accepts title, description, and children props
- Supports different variants (default, outlined, elevated)
- Is fully accessible (WCAG AA)
- Uses Tailwind CSS for styling
- Includes TypeScript prop types
```

### Example 2: Fix a Bug

```
/agents javascript-developer

Fix the memory leak in the useWebSocket hook at hooks/useWebSocket.ts.
The WebSocket connection is not being cleaned up properly when the component unmounts.
```

### Example 3: Implement from User Story

```
/agents javascript-developer

Please implement user story 2.3 from docs/stories/2.3.post-detail-view.md

Follow the acceptance criteria and use the architecture patterns from docs/architecture.md
```

### Example 4: Add Tests

```
/agents javascript-developer

Add comprehensive tests for the useAuth hook at hooks/useAuth.ts using React Testing Library and Jest.
```

## What the Agent Does

### 1. Understands Your Codebase

The agent will:
- Use `codebase-retrieval` to understand existing patterns
- Use `view` to examine relevant files
- Check for similar implementations to maintain consistency
- Identify the tech stack and coding conventions

### 2. Researches Best Practices

When needed, the agent will:
- Look up framework documentation (React, Next.js, etc.)
- Research common solutions to specific problems
- Find performance optimization techniques

### 3. Plans the Implementation

For complex tasks, the agent will:
- Break down the feature into smaller steps
- Identify potential edge cases
- Plan the file structure
- Consider testing strategy

### 4. Implements with Best Practices

The agent follows these principles:
- **Type Safety**: Uses TypeScript strict mode, avoids `any` types
- **Component Design**: Keeps components small, focused, and reusable
- **Performance**: Memoizes expensive computations, avoids unnecessary re-renders
- **Error Handling**: Implements proper error boundaries and try-catch blocks
- **Accessibility**: Follows WCAG guidelines, uses semantic HTML
- **Code Style**: Follows existing conventions

### 5. Suggests Testing

The agent will:
- Write unit tests for utility functions and hooks
- Write component tests using React Testing Library
- Suggest integration tests for complex workflows
- Recommend running tests to verify implementation

## Code Quality Standards

The agent ensures:

### Type Safety
- TypeScript strict mode enabled
- No `any` types (uses `unknown` when appropriate)
- Clear interfaces for all data structures
- Proper generic types for reusable components

### Code Quality
- Follows existing code style
- Meaningful variable and function names
- Small, focused functions (single responsibility)
- JSDoc comments for complex functions
- No unused imports or variables

### Performance
- Memoizes expensive computations with `useMemo`
- Memoizes callbacks with `useCallback`
- Uses `React.memo` for expensive components
- Implements proper loading states

### Accessibility
- Semantic HTML elements
- Proper ARIA labels and roles
- Keyboard navigation support
- Proper heading hierarchy

### Testing
- Unit tests for utility functions
- Component tests for UI components
- Tests for error scenarios and edge cases
- Meaningful test coverage

## Common Use Cases

### 1. Building a New Feature

**Scenario**: You have a user story and need to implement it.

```
/agents javascript-developer

Implement user story 3.1 from docs/stories/3.1.comment-system.md

The story requires:
- A CommentList component to display comments
- A CommentForm component to add new comments
- Integration with the API at /api/comments
- Real-time updates using React Query
- Full TypeScript types
```

**What the agent will do**:
1. Read the user story and acceptance criteria
2. Review the architecture document for technical details
3. Check existing component patterns
4. Implement the components following best practices
5. Add TypeScript types
6. Suggest tests

### 2. Fixing a Bug

**Scenario**: You have a bug that needs fixing.

```
/agents javascript-developer

Bug in the SearchBar component at components/SearchBar.tsx:
- The debounce function is not working correctly
- Search triggers on every keystroke instead of after 300ms delay
- This is causing too many API calls

Please fix this and add a test to prevent regression.
```

**What the agent will do**:
1. Examine the SearchBar component
2. Identify the issue with the debounce implementation
3. Fix the bug (likely a useCallback dependency issue)
4. Explain what was wrong
5. Add a test to verify the fix

### 3. Refactoring Code

**Scenario**: You want to improve existing code.

```
/agents javascript-developer

Refactor the Dashboard component at pages/dashboard.tsx to:
- Extract reusable components (StatCard, ChartWidget)
- Improve performance with proper memoization
- Add loading and error states
- Improve TypeScript types
- Make it more maintainable

Explain the changes and why they improve the code.
```

**What the agent will do**:
1. Analyze the current Dashboard component
2. Identify areas for improvement
3. Extract reusable components
4. Add memoization where appropriate
5. Improve type safety
6. Explain each change

### 4. Adding Tests

**Scenario**: You need tests for existing code.

```
/agents javascript-developer

Add comprehensive tests for the UserService class at lib/UserService.ts

Include tests for:
- getAllUsers method
- getUserById method
- createUser method
- updateUser method
- deleteUser method
- Error handling for each method
- Edge cases (empty responses, network errors, etc.)

Use Jest and mock the fetch calls.
```

**What the agent will do**:
1. Examine the UserService class
2. Write tests for all methods
3. Mock external dependencies (fetch)
4. Test error scenarios
5. Test edge cases
6. Ensure good test coverage

## Best Practices for Working with the Agent

### 1. Provide Context

Always reference relevant files, stories, or documentation:

```
/agents javascript-developer

Implement the LoginForm component.

Context:
- User story: docs/stories/1.3.authentication.md
- Architecture: docs/architecture.md (see Authentication section)
- Existing pattern: components/RegisterForm.tsx (follow this structure)
```

### 2. Be Specific About Requirements

Include all constraints and requirements:

```
/agents javascript-developer

Create a Modal component that:
- Uses React Portal for rendering
- Supports keyboard navigation (Esc to close)
- Traps focus inside the modal
- Prevents body scroll when open
- Supports custom header, body, and footer
- Is fully accessible (WCAG AA)
- Uses Tailwind CSS
- Includes TypeScript types
```

### 3. Request Tests

Always ask for tests or testing suggestions:

```
/agents javascript-developer

Implement the useLocalStorage hook and include comprehensive tests.
```

### 4. Iterate on Feedback

If the first implementation isn't perfect, provide feedback:

```
/agents javascript-developer

The Button component works well, but please update it to:
- Use forwardRef for ref forwarding
- Support polymorphic "as" prop
- Add leftIcon and rightIcon props
- Support loading state with spinner
```

### 5. Ask for Explanations

If you want to understand the implementation:

```
/agents javascript-developer

Before implementing the feature, please explain:
1. Your approach to solving this problem
2. What patterns you'll use
3. How you'll handle edge cases
4. What tests you'll write

Then implement it.
```

## Integration with Planning Agents

The `javascript-developer` agent works seamlessly with planning agents:

```
Planning Phase:
[product-manager] → docs/prd.md
[software-architect] → docs/architecture.md
[scrum-master] → docs/stories/*.md

Development Phase:
[javascript-developer] → Implements features from stories
```

### Typical Workflow

1. **Planning agents create documentation**
   - PRD defines requirements
   - Architecture defines technical approach
   - Scrum master creates user stories

2. **Development agent implements features**
   ```
   /agents javascript-developer
   Implement story 1.1 from docs/stories/1.1.project-initialization.md
   ```

3. **Agent reads context**
   - Reads the user story
   - Reviews architecture document
   - Checks existing code patterns

4. **Agent implements**
   - Creates/modifies files
   - Follows best practices
   - Adds TypeScript types
   - Suggests tests

5. **You verify**
   - Run suggested tests
   - Review the code
   - Test manually if needed

## Troubleshooting

### Agent Not Following Existing Patterns

**Problem**: The agent creates code that doesn't match your codebase style.

**Solution**: Be explicit about patterns to follow:
```
/agents javascript-developer

Before implementing, please review how we structure components in:
- components/ui/Button.tsx
- components/ui/Input.tsx

Then create the Select component following the same patterns.
```

### Agent Making Too Many Changes

**Problem**: The agent modifies more than you wanted.

**Solution**: Be more specific:
```
/agents javascript-developer

Only modify the handleSubmit function in components/LoginForm.tsx.
Do not change any other parts of the file.
```

### TypeScript Errors

**Problem**: The generated code has TypeScript errors.

**Solution**: Ask the agent to check diagnostics:
```
/agents javascript-developer

The code you generated has TypeScript errors. Please:
1. Check the diagnostics for the file
2. Fix all type errors
3. Ensure strict mode compliance
```

### Tests Not Passing

**Problem**: The suggested tests fail.

**Solution**: Provide the error output:
```
/agents javascript-developer

The tests you wrote are failing with this error:
[paste error message]

Please fix the tests.
```

## Related Documentation

- **[DEVELOPMENT_AGENTS.md](./DEVELOPMENT_AGENTS.md)**: Overview of all development agents
- **[README.md](./README.md)**: Main agents documentation
- **[QUICK_START.md](./QUICK_START.md)**: Quick start guide with examples

## Support

For issues or questions:
1. Review this guide
2. Check [DEVELOPMENT_AGENTS.md](./DEVELOPMENT_AGENTS.md) for detailed information
3. Review the agent's system prompt at `agents/javascript-developer.md`
4. Try the examples in [QUICK_START.md](./QUICK_START.md)

---

**Version**: 1.0  
**Last Updated**: 2025-10-01  
**Maintained By**: AI Agent Development Team

