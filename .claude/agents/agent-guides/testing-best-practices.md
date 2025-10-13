# Testing Best Practices for Developer Agents
## Based on Code Review Analysis (14 Reviews, 21% Re-Review Rate)

**Last Updated**: 2025-10-13  
**Purpose**: Prevent common testing issues that cause review iterations  
**Target**: All JavaScript/TypeScript developer agents

---

## 🚨 CRITICAL: Acceptance Criteria to Test Mapping (MANDATORY)

**Problem**: 3 out of 14 stories (21%) had test configuration issues or missing tests

**Solution**: Create AC-to-Test mapping BEFORE writing any tests

### Step 1: Extract All Acceptance Criteria

From your story file, list every acceptance criterion:

```markdown
## Acceptance Criteria Test Mapping

Story: [Story Number and Title]
File: docs/stories/[story-file].md

### Acceptance Criteria from Story:
1. AC1: Time updates automatically every 1000ms
2. AC2: Hook integrated in App component
3. AC3: Time displays in HH:MM:SS format
4. AC4: Cleanup on unmount prevents memory leaks
```

### Step 2: Map Each AC to Test Cases

For each AC, identify:
- Test name (descriptive, matches AC language)
- Test file location
- Test type (Unit / Integration / E2E)
- Assertions needed

```markdown
### Test Mapping:

- [ ] AC1: Time updates automatically every 1000ms
  - Test: "should update time every 1000ms"
  - File: src/hooks/useCurrentTime.test.ts
  - Type: Unit
  - Assertions: Verify setInterval called with 1000ms, time updates after 1000ms

- [ ] AC2: Hook integrated in App component
  - Test: "should render current time from useCurrentTime hook"
  - File: src/App.test.tsx
  - Type: Integration
  - Assertions: App renders, time display shows current time

- [ ] AC3: Time displays in HH:MM:SS format
  - Test: "should format time with leading zeros"
  - File: src/components/TimeDisplay.test.tsx
  - Type: Unit
  - Assertions: "14:05:03" format, leading zeros for single digits

- [ ] AC4: Cleanup on unmount prevents memory leaks
  - Test: "should cleanup interval on unmount"
  - File: src/hooks/useCurrentTime.test.ts
  - Type: Unit
  - Assertions: clearInterval called when component unmounts
```

### Step 3: Validate Mapping

**Before writing tests, verify:**
- ✅ Every AC has at least one test
- ✅ Integration ACs have integration tests (not just unit tests)
- ✅ Test assertions match AC requirements exactly
- ✅ No tests for implementation details (test behavior, not internals)

### Common Mistakes to Avoid

❌ **Missing Integration Tests**
```typescript
// AC: "Hook integrated in App component"
// ❌ WRONG - Only unit test, no integration test
describe('useCurrentTime', () => {
  it('should return current time', () => { /* ... */ });
});

// ✅ CORRECT - Add integration test
describe('App', () => {
  it('should render current time from useCurrentTime hook', () => {
    render(<App />);
    expect(screen.getByText(/\d{2}:\d{2}:\d{2}/)).toBeInTheDocument();
  });
});
```

❌ **Wrong Test Assertions**
```typescript
// AC: "Meets WCAG 2.1 AA contrast requirements (4.5:1)"
// ❌ WRONG - Testing AAA (7:1) instead of AA (4.5:1)
expect(contrastRatio).toBeGreaterThan(7.0);

// ✅ CORRECT - Test AA requirement
expect(contrastRatio).toBeGreaterThan(4.5);
```

---

## 🔴 Critical: TypeScript Test Environment Issues

**Problem**: 2 stories had TypeScript build errors from using `global` instead of `window`

**Root Cause**: Confusion between Node.js and browser test environments

### Browser Test Environment (Vitest, Jest with jsdom)

```typescript
// ❌ WRONG - Causes TypeScript error in browser tests
vi.spyOn(global, 'clearInterval')
vi.spyOn(global, 'setInterval')
vi.spyOn(global, 'setTimeout')

// ✅ CORRECT - Use window for browser environment
vi.spyOn(window, 'clearInterval')
vi.spyOn(window, 'setInterval')
vi.spyOn(window, 'setTimeout')
```

### Node.js Test Environment

```typescript
// ✅ CORRECT - Use global in Node.js environment
vi.spyOn(global, 'clearInterval')
```

### Cross-Environment Code

```typescript
// ✅ CORRECT - Use globalThis for cross-environment
vi.spyOn(globalThis, 'clearInterval')
```

### Validation Command

```bash
# Check for incorrect global usage before committing
grep -r "global\." src/ tests/ e2e/ --include="*.test.ts" --include="*.test.tsx" --include="*.spec.ts"

# Should return no results (or only globalThis usage)
```

---

## 🧪 Edge Case Testing Checklist

**Problem**: 2 stories had missing edge case tests

**Solution**: Test these edge cases for every public function

### Input Validation Tests

```typescript
describe('myFunction edge cases', () => {
  // Null/Undefined
  it('should handle null input', () => {
    expect(() => myFunction(null)).toThrow('Input cannot be null');
  });

  it('should handle undefined input', () => {
    expect(() => myFunction(undefined)).toThrow('Input is required');
  });

  // Empty values
  it('should handle empty string', () => {
    expect(() => myFunction('')).toThrow('Input cannot be empty');
  });

  it('should handle empty array', () => {
    expect(myFunction([])).toEqual([]);
  });

  // Invalid types
  it('should throw error for invalid type', () => {
    expect(() => myFunction('not-a-number')).toThrow('Expected number');
  });

  // Malformed data
  it('should throw error for invalid format', () => {
    expect(() => hexToRgb('invalid')).toThrow('Invalid hex color');
    expect(() => hexToRgb('#GGG')).toThrow('Invalid hex color');
  });
});
```

### Boundary Value Tests

```typescript
describe('myFunction boundary values', () => {
  // Minimum
  it('should handle minimum value', () => {
    expect(myFunction(0)).toBe(expectedMin);
  });

  // Maximum
  it('should handle maximum value', () => {
    expect(myFunction(Number.MAX_SAFE_INTEGER)).toBe(expectedMax);
  });

  // Negative
  it('should handle negative values', () => {
    expect(myFunction(-1)).toBe(expectedNegative);
  });

  // Boundary crossing
  it('should handle boundary crossing', () => {
    expect(myFunction(59)).toBe('59');  // Just before boundary
    expect(myFunction(60)).toBe('00');  // At boundary
  });
});
```

### Example: Color Utility Function

```typescript
describe('hexToRgb', () => {
  // Valid inputs
  it('should convert valid 6-character hex', () => {
    expect(hexToRgb('#FFFFFF')).toEqual({ r: 255, g: 255, b: 255 });
    expect(hexToRgb('#000000')).toEqual({ r: 0, g: 0, b: 0 });
  });

  // Edge case: 3-character hex
  it('should handle 3-character hex codes', () => {
    expect(hexToRgb('#FFF')).toEqual({ r: 255, g: 255, b: 255 });
    expect(hexToRgb('#000')).toEqual({ r: 0, g: 0, b: 0 });
  });

  // Edge case: Case insensitivity
  it('should handle lowercase hex codes', () => {
    expect(hexToRgb('#ffffff')).toEqual({ r: 255, g: 255, b: 255 });
    expect(hexToRgb('#FfFfFf')).toEqual({ r: 255, g: 255, b: 255 });
  });

  // Edge case: Invalid format
  it('should throw error for invalid hex format', () => {
    expect(() => hexToRgb('invalid')).toThrow('Invalid hex color');
    expect(() => hexToRgb('#GGG')).toThrow('Invalid hex color');
    expect(() => hexToRgb('')).toThrow('Invalid hex color');
    expect(() => hexToRgb('#12')).toThrow('Invalid hex color');
  });

  // Boundary: Min/Max RGB values
  it('should handle boundary RGB values', () => {
    expect(hexToRgb('#000000')).toEqual({ r: 0, g: 0, b: 0 });
    expect(hexToRgb('#FFFFFF')).toEqual({ r: 255, g: 255, b: 255 });
  });
});
```

---

## 🔗 Integration Testing Patterns

**Problem**: Stories with "integrated in" ACs need integration tests, not just unit tests

### When to Write Integration Tests

Write integration tests when AC mentions:
- "Integrated in [Component]"
- "Works with [Other Component]"
- "Displays in [Parent Component]"
- "User can [action] in the app"

### Integration Test Pattern

```typescript
// src/App.test.tsx
import { render, screen } from '@testing-library/react';
import App from './App';

describe('App Integration', () => {
  // AC: "Hook integrated in App component"
  it('should render current time from useCurrentTime hook', () => {
    render(<App />);
    
    // Verify hook output is displayed
    expect(screen.getByText(/\d{2}:\d{2}:\d{2}/)).toBeInTheDocument();
  });

  // AC: "TimeDisplay and DateDisplay components work together"
  it('should render both time and date displays', () => {
    render(<App />);
    
    expect(screen.getByText(/\d{2}:\d{2}:\d{2}/)).toBeInTheDocument();  // Time
    expect(screen.getByText(/\w+, \w+ \d+, \d{4}/)).toBeInTheDocument();  // Date
  });

  // AC: "Components update together when time changes"
  it('should update both displays when time changes', async () => {
    vi.useFakeTimers();
    render(<App />);
    
    const initialTime = screen.getByText(/\d{2}:\d{2}:\d{2}/).textContent;
    
    act(() => {
      vi.advanceTimersByTime(1000);
    });
    
    const updatedTime = screen.getByText(/\d{2}:\d{2}:\d{2}/).textContent;
    expect(updatedTime).not.toBe(initialTime);
    
    vi.restoreAllMocks();
  });
});
```

---

## 🎯 Test Quality Checklist

Before marking tests complete, verify:

### Unit Tests
- [ ] All public functions tested
- [ ] All custom hooks tested
- [ ] All edge cases covered
- [ ] All error conditions tested
- [ ] Test coverage >90%

### Integration Tests
- [ ] All component interactions tested
- [ ] All "integrated in" ACs have tests
- [ ] State management tested
- [ ] Event handling tested

### E2E Tests
- [ ] Critical user paths tested
- [ ] Accessibility tested (axe-core)
- [ ] Responsive design tested
- [ ] Cross-browser tested (if applicable)

### Test Code Quality
- [ ] No unused variables in tests
- [ ] Clear, descriptive test names
- [ ] Proper setup/teardown (beforeEach, afterEach)
- [ ] No test interdependencies
- [ ] Tests are deterministic (no flakiness)

---

## 🔒 Security Testing Patterns

### External Link Security

```typescript
describe('External Links Security', () => {
  it('should have rel="noopener noreferrer" on external links', () => {
    render(<App />);
    
    const externalLinks = screen.getAllByRole('link').filter(link => 
      link.getAttribute('target') === '_blank'
    );
    
    externalLinks.forEach(link => {
      expect(link).toHaveAttribute('rel', 'noopener noreferrer');
    });
  });
});
```

### XSS Prevention

```typescript
describe('XSS Prevention', () => {
  it('should sanitize user input', () => {
    const maliciousInput = '<script>alert("XSS")</script>';
    render(<UserContent content={maliciousInput} />);
    
    // Should not execute script
    expect(screen.queryByText('alert("XSS")')).not.toBeInTheDocument();
  });
});
```

---

## 📊 Test Coverage Best Practices

### Minimum Coverage Requirements

- **Functions**: 100% coverage
- **Components**: 90% coverage
- **Hooks**: 100% coverage
- **Edge cases**: 80% coverage

### Coverage Report

```bash
# Generate coverage report
npm test -- --coverage

# View coverage report
open coverage/lcov-report/index.html
```

### Coverage Gaps to Address

```typescript
// If coverage report shows uncovered lines, add tests:

// Uncovered: Error handling branch
it('should handle error condition', () => {
  expect(() => myFunction(invalidInput)).toThrow();
});

// Uncovered: Edge case branch
it('should handle edge case', () => {
  expect(myFunction(edgeCaseInput)).toBe(expectedOutput);
});
```

---

## 🎨 Accessibility Testing Patterns

### axe-core Integration

```typescript
import { axe, toHaveNoViolations } from 'jest-axe';
expect.extend(toHaveNoViolations);

describe('Accessibility', () => {
  it('should have no accessibility violations', async () => {
    const { container } = render(<App />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });
});
```

### WCAG Compliance Testing

```typescript
describe('WCAG 2.1 Compliance', () => {
  it('should meet color contrast requirements', () => {
    const contrastRatio = calculateContrast('#1C1B1F', '#FFFFFF');
    expect(contrastRatio).toBeGreaterThanOrEqual(4.5);  // AA requirement
  });

  it('should have semantic HTML', () => {
    render(<App />);
    expect(screen.getByRole('main')).toBeInTheDocument();
    expect(screen.getByRole('time')).toBeInTheDocument();
  });

  it('should have proper ARIA attributes', () => {
    render(<App />);
    const main = screen.getByRole('main');
    expect(main).toHaveAttribute('role', 'main');
  });
});
```

---

## 🚀 Performance Testing Patterns

### React.memo Validation

```typescript
describe('Performance Optimization', () => {
  it('should not re-render when props unchanged', () => {
    const renderSpy = vi.fn();
    
    const TestComponent = memo(() => {
      renderSpy();
      return <div>Test</div>;
    });

    const { rerender } = render(<TestComponent />);
    expect(renderSpy).toHaveBeenCalledTimes(1);

    rerender(<TestComponent />);
    expect(renderSpy).toHaveBeenCalledTimes(1);  // Should not re-render
  });
});
```

### Memory Leak Prevention

```typescript
describe('Memory Leak Prevention', () => {
  it('should cleanup interval on unmount', () => {
    const clearIntervalSpy = vi.spyOn(window, 'clearInterval');
    
    const { unmount } = renderHook(() => useCurrentTime());
    
    unmount();
    
    expect(clearIntervalSpy).toHaveBeenCalled();
  });

  it('should cleanup event listeners on unmount', () => {
    const removeEventListenerSpy = vi.spyOn(window, 'removeEventListener');
    
    const { unmount } = render(<Component />);
    
    unmount();
    
    expect(removeEventListenerSpy).toHaveBeenCalled();
  });
});
```

---

## 📝 Test Documentation

### Test File Header

```typescript
/**
 * Tests for useCurrentTime hook
 * 
 * Coverage:
 * - AC1: Time updates automatically every 1000ms
 * - AC2: Hook integrated in App component
 * - AC4: Cleanup on unmount prevents memory leaks
 * 
 * Edge cases:
 * - Minute boundary crossing
 * - Hour boundary crossing
 * - Midnight crossing
 */
```

### Test Name Conventions

```typescript
// ✅ GOOD - Descriptive, matches AC language
it('should update time every 1000ms', () => { /* ... */ });
it('should format time with leading zeros', () => { /* ... */ });
it('should cleanup interval on unmount', () => { /* ... */ });

// ❌ BAD - Vague, doesn't match AC
it('should work', () => { /* ... */ });
it('test time', () => { /* ... */ });
it('updates', () => { /* ... */ });
```

---

## 🔍 Common Test Patterns

### Pattern 1: Testing Hooks with Fake Timers

```typescript
import { renderHook, act } from '@testing-library/react';

describe('useCurrentTime', () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it('should update time every second', () => {
    const { result } = renderHook(() => useCurrentTime());
    const initialTime = result.current;

    act(() => {
      vi.advanceTimersByTime(1000);
    });

    expect(result.current).not.toBe(initialTime);
  });

  it('should cleanup interval on unmount', () => {
    const clearIntervalSpy = vi.spyOn(window, 'clearInterval');
    const { unmount } = renderHook(() => useCurrentTime());
    
    unmount();
    
    expect(clearIntervalSpy).toHaveBeenCalled();
  });
});
```

### Pattern 2: Testing Components with User Interaction

```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

describe('Button', () => {
  it('should call onClick when clicked', async () => {
    const handleClick = vi.fn();
    const user = userEvent.setup();
    
    render(<Button onClick={handleClick}>Click me</Button>);
    
    await user.click(screen.getByRole('button'));
    
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

### Pattern 3: Testing Async Operations

```typescript
describe('AsyncComponent', () => {
  it('should display loading state', () => {
    render(<AsyncComponent />);
    expect(screen.getByText('Loading...')).toBeInTheDocument();
  });

  it('should display data after loading', async () => {
    render(<AsyncComponent />);
    
    const data = await screen.findByText('Data loaded');
    expect(data).toBeInTheDocument();
  });

  it('should display error on failure', async () => {
    // Mock API to fail
    vi.mocked(fetchData).mockRejectedValue(new Error('API Error'));
    
    render(<AsyncComponent />);
    
    const error = await screen.findByText(/error/i);
    expect(error).toBeInTheDocument();
  });
});
```

---

## ✅ Pre-Test Checklist

Before writing tests:

1. **Create AC-to-Test mapping** (see above)
2. **Identify test types needed** (unit, integration, E2E)
3. **List edge cases to test** (invalid inputs, boundaries, errors)
4. **Plan test file structure** (one file per component/hook/utility)
5. **Set up test environment** (fake timers, mocks, spies)

During testing:

6. **Write tests for each AC** (follow mapping)
7. **Add edge case tests** (see checklist)
8. **Verify test coverage** (>90% target)
9. **Run tests locally** (all must pass)
10. **Check for unused variables** (ESLint will catch)

After testing:

11. **Run pre-commit checks** (`./scripts/pre-commit-checks.sh`)
12. **Verify all tests pass** (`npm test`)
13. **Check coverage report** (`npm test -- --coverage`)
14. **Review test quality** (clear names, good assertions)

---

## 🎯 Success Metrics

**Target Metrics** (based on analysis of 14 reviews):
- ✅ 100% AC coverage (every AC has tests)
- ✅ >90% code coverage
- ✅ Zero TypeScript errors in tests
- ✅ Zero ESLint errors in tests
- ✅ All tests passing on first run
- ✅ No unused variables in tests

**Current Performance**:
- Stories with zero test issues: 79% (11/14)
- Target: >90% (13/14)

**Your Goal**: First-pass approval with comprehensive test coverage

---

## 📚 Additional Resources

- **Full Analysis**: See `/code-review-analysis.md` for detailed patterns
- **Quick Reference**: See `/QUICK-REFERENCE.md` for common fixes
- **Implementation Guide**: See `/implementation-guide.md` for step-by-step instructions

---

**Remember**: Testing is not just about coverage—it's about confidence. Write tests that give you confidence your code works correctly in all scenarios.

