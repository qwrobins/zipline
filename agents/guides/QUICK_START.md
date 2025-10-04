# Quick Start Guide: Using Specialized Agents

This guide provides quick examples of how to use the specialized agents for common development tasks.

## Table of Contents

1. [Planning Phase](#planning-phase)
2. [Development Phase](#development-phase)
3. [Common Workflows](#common-workflows)
4. [Tips and Best Practices](#tips-and-best-practices)

## Planning Phase

### Create a PRD from a Product Brief

```
/agents product-manager

I have a product brief for a task management application. Here's the brief:

[Paste your product brief here]
```

**Output**: `docs/prd.md`

### Design System Architecture

```
/agents software-architect

Please create the architecture document based on the PRD at docs/prd.md
```

**Output**: `docs/architecture.md`

### Create User Stories

```
/agents scrum-master

Create user stories from the PRD and architecture docs.
PRD location: docs/prd.md
Architecture location: docs/architecture.md
```

**Output**: `docs/stories/*.md` (individual story files)

## Development Phase

### Implement a React Component

```
/agents javascript-developer

Create a reusable Button component in React with TypeScript that supports:
- Variants: primary, secondary, outline, ghost
- Sizes: sm, md, lg
- Loading state with spinner
- Disabled state
- Full accessibility (WCAG AA)

Use Tailwind CSS for styling and follow the existing component patterns in the codebase.
```

### Implement a User Story

```
/agents javascript-developer

Please implement user story 2.1 from docs/stories/2.1.user-directory.md

Make sure to:
1. Follow the acceptance criteria exactly
2. Use the architecture patterns from docs/architecture.md
3. Write tests for the implementation
4. Ensure TypeScript strict mode compliance
```

### Fix a Bug

```
/agents javascript-developer

There's an infinite re-render issue in the UserProfile component at components/UserProfile.tsx. 

The useEffect hook is triggering continuously. Please:
1. Analyze the component and identify the issue
2. Fix the dependency array
3. Explain what was causing the problem
4. Add a test to prevent regression
```

### Create a Next.js API Route

```
/agents javascript-developer

Create a Next.js API route at /api/users that:
- Handles GET requests to fetch all users
- Handles POST requests to create a new user
- Uses TypeScript for type safety
- Includes proper error handling
- Validates input with Zod
- Returns appropriate HTTP status codes
```

### Refactor Code for Performance

```
/agents javascript-developer

The ProductList component at components/ProductList.tsx is re-rendering too frequently and causing performance issues.

Please refactor it to:
1. Use React.memo appropriately
2. Memoize expensive computations with useMemo
3. Memoize callbacks with useCallback
4. Explain the performance improvements
```

### Add Tests to Existing Code

```
/agents javascript-developer

Add comprehensive tests for the useAuth hook at hooks/useAuth.ts

Include tests for:
- Login functionality
- Logout functionality
- Token refresh
- Error handling
- Loading states

Use React Testing Library and Jest.
```

## Common Workflows

### Full Feature Implementation Workflow

1. **Start with Planning**
   ```
   /agents product-manager
   [Provide product brief]
   ```

2. **Design Architecture**
   ```
   /agents software-architect
   [Reference the PRD]
   ```

3. **Create Stories**
   ```
   /agents scrum-master
   [Reference PRD and architecture]
   ```

4. **Implement First Story**
   ```
   /agents javascript-developer
   Implement story 1.1 from docs/stories/1.1.project-initialization.md
   ```

5. **Test Implementation**
   ```
   Run the tests suggested by the agent
   ```

6. **Continue with Next Stories**
   ```
   /agents javascript-developer
   Implement story 1.2 from docs/stories/1.2.shadcn-ui-setup.md
   ```

### Bug Fix Workflow

1. **Identify the Bug**
   - Locate the problematic file/component
   - Understand the expected vs actual behavior

2. **Use Development Agent**
   ```
   /agents javascript-developer
   
   Bug: [Describe the bug]
   Location: [File path]
   Expected: [Expected behavior]
   Actual: [Actual behavior]
   
   Please fix this bug and add a test to prevent regression.
   ```

3. **Verify the Fix**
   - Run the suggested tests
   - Manually test the functionality
   - Check for any side effects

### Code Review Workflow

1. **Request Review**
   ```
   /agents javascript-developer
   
   Please review the code in components/UserForm.tsx and suggest improvements for:
   - Type safety
   - Performance
   - Accessibility
   - Error handling
   - Code organization
   ```

2. **Implement Suggestions**
   ```
   /agents javascript-developer
   
   Please implement the improvements you suggested for UserForm.tsx
   ```

## Tips and Best Practices

### For Planning Agents

1. **Provide Detailed Input**: The more context you provide, the better the output
2. **Use Sequential Workflow**: Follow the recommended order (PRD → Architecture → Stories)
3. **Review and Iterate**: Don't hesitate to ask for refinements
4. **Keep Context**: Reference previous documents when moving to the next phase

### For Development Agents

1. **Reference Existing Patterns**: Ask the agent to check existing code patterns first
   ```
   /agents javascript-developer
   
   Before implementing, please check how similar components are structured in this codebase.
   Then create a new Modal component following those patterns.
   ```

2. **Be Specific About Requirements**: Include all constraints and requirements
   ```
   /agents javascript-developer
   
   Create a form component that:
   - Uses React Hook Form
   - Validates with Zod
   - Follows our existing form patterns
   - Includes loading and error states
   - Is fully accessible
   ```

3. **Request Tests**: Always ask for tests or testing suggestions
   ```
   /agents javascript-developer
   
   Implement the SearchBar component and include comprehensive tests.
   ```

4. **Iterate on Feedback**: If the first implementation isn't perfect, provide feedback
   ```
   /agents javascript-developer
   
   The Button component you created works well, but please update it to:
   - Use forwardRef for ref forwarding
   - Add a leftIcon and rightIcon prop
   - Support asChild pattern for composition
   ```

### General Tips

1. **Start Small**: Begin with simple tasks to understand how the agent works
2. **Provide Context**: Reference relevant files, stories, or documentation
3. **Ask Questions**: If you're unsure, ask the agent to explain its approach first
4. **Review Output**: Always review the generated code before using it
5. **Run Tests**: Execute suggested tests to verify implementations
6. **Maintain Consistency**: Ask agents to follow existing patterns in your codebase

### Common Patterns

**Pattern 1: Understand Before Implementing**
```
/agents javascript-developer

Before implementing the new feature, please:
1. Review the existing authentication implementation
2. Check how we handle API errors
3. Look at similar components for patterns
Then implement the new LoginForm component following those patterns.
```

**Pattern 2: Implement with Tests**
```
/agents javascript-developer

Implement the UserService class with:
- CRUD operations for users
- Error handling
- TypeScript types
- Unit tests for all methods
```

**Pattern 3: Refactor with Explanation**
```
/agents javascript-developer

Refactor the Dashboard component to improve performance.
Please explain:
- What issues you found
- What changes you made
- Why those changes improve performance
```

## Getting Help

- **Planning Agents**: See [README.md](./README.md)
- **Development Agents**: See [DEVELOPMENT_AGENTS.md](./DEVELOPMENT_AGENTS.md)
- **Parallel Development**: See [PARALLEL_DEVELOPMENT.md](./PARALLEL_DEVELOPMENT.md)
- **Documentation Standards**: See [DOCS_DIRECTORY_CONVENTION.md](./DOCS_DIRECTORY_CONVENTION.md)

## Examples Directory

Check the `examples/` directory for:
- Sample product briefs
- Example PRDs
- Example architecture documents
- Example user stories

---

**Version**: 1.0  
**Last Updated**: 2025-10-01  
**Maintained By**: AI Agent Development Team

