# Developer Agent Quick Reference
## Common Issues & Quick Fixes

**Last Updated**: 2025-10-13  
**For**: react-developer agent  
**Based on**: Analysis of 14 code reviews

---

## 🚨 Critical Issues (Fix Immediately)

### Issue 1: TypeScript Build Error - `global` vs `window`

**Symptom**: TypeScript compilation fails with "Cannot find name 'global'"

**Cause**: Using Node.js `global` object in browser test environment

**Quick Fix**:
```typescript
// ❌ WRONG - Causes build error
vi.spyOn(global, 'clearInterval')
vi.spyOn(global, 'setInterval')

// ✅ CORRECT - Use window for browser tests
vi.spyOn(window, 'clearInterval')
vi.spyOn(window, 'setInterval')
```

**Prevention**:
```bash
# Check before committing
grep -r "global\." src/ tests/ --include="*.test.ts" --include="*.spec.ts"
```

---

### Issue 2: Missing Integration Tests

**Symptom**: Code reviewer asks "Where is the integration test for AC X?"

**Cause**: Only wrote unit tests, forgot integration tests for "integrated in" ACs

**Quick Fix**:
```typescript
// If AC says "Hook integrated in App component"
// You need BOTH:

// 1. Unit test for hook
describe('useCurrentTime', () => {
  it('should return current time', () => { /* ... */ });
});

// 2. Integration test in App
describe('App', () => {
  it('should render current time from hook', () => {
    render(<App />);
    expect(screen.getByText(/\d{2}:\d{2}:\d{2}/)).toBeInTheDocument();
  });
});
```

**Prevention**: Create AC-to-Test mapping before writing tests

---

## ⚠️ High Priority Issues (Fix Before Commit)

### Issue 3: External Links Missing Security Attributes

**Symptom**: Code reviewer flags security vulnerability

**Cause**: `target="_blank"` without `rel="noopener noreferrer"`

**Quick Fix**:
```tsx
// ❌ WRONG - Security vulnerability
<a href="https://external.com" target="_blank">Link</a>

// ✅ CORRECT - Prevents tabnabbing
<a href="https://external.com" target="_blank" rel="noopener noreferrer">Link</a>
```

**Prevention**:
```bash
# Check before committing
grep -r 'target="_blank"' src/ --include="*.tsx" | grep -v 'rel="noopener noreferrer"'
```

---

### Issue 4: Unused Variables in Tests

**Symptom**: ESLint error "Variable is assigned but never used"

**Cause**: Declared variable but didn't use it in assertions

**Quick Fix**:
```typescript
// ❌ WRONG - Variable never used
const allRatios = [results.time.ratio, results.date.ratio];
expect(results.time.ratio).toBeGreaterThan(4.5);

// ✅ CORRECT - Remove unused variable
expect(results.time.ratio).toBeGreaterThan(4.5);
expect(results.date.ratio).toBeGreaterThan(4.5);
```

**Prevention**: Run `npm run lint` before committing

---

## 📝 Medium Priority Issues (Clean Up)

### Issue 5: Unused Boilerplate Files

**Symptom**: Code reviewer asks "Why is App.css still here?"

**Cause**: Forgot to remove Vite template files after switching to CSS Modules

**Quick Fix**:
```bash
# Remove unused CSS files
rm src/App.css src/index.css

# Remove unused logo files
rm src/assets/react.svg
```

**Prevention**: Run cleanup script before finalizing

---

### Issue 6: Outdated Documentation References

**Symptom**: README mentions files that don't exist

**Cause**: Didn't update README after changing file names

**Quick Fix**:
```markdown
<!-- ❌ WRONG - File doesn't exist -->
ESLint configuration in `.eslintrc.cjs`

<!-- ✅ CORRECT - Current file name -->
ESLint configuration in `eslint.config.js`
```

**Prevention**: Validate docs before committing

---

### Issue 7: Incomplete .gitignore

**Symptom**: Editor files or build artifacts committed to git

**Cause**: Missing patterns in .gitignore

**Quick Fix**:
```gitignore
# Add these patterns
dist-ssr/
*.local
.vscode/
.idea/
.DS_Store
Thumbs.db
```

**Prevention**: Use comprehensive .gitignore template

---

## 🔍 Pre-Commit Checklist

Run these checks before committing:

```bash
# 1. TypeScript compilation
npm run build

# 2. ESLint
npm run lint

# 3. Tests
npm test

# 4. Check for global usage
grep -r "global\." src/ tests/ --include="*.test.ts" --include="*.spec.ts"

# 5. Check external links
grep -r 'target="_blank"' src/ --include="*.tsx" | grep -v 'rel="noopener noreferrer"'

# 6. Check for console.log
grep -r "console\.log" src/ --include="*.ts" --include="*.tsx" --exclude="*.test.*"
```

**Or use the automated script**:
```bash
./scripts/pre-commit-checks.sh
```

---

## 📋 AC-to-Test Mapping Template

Before writing tests, create this mapping:

```markdown
## Acceptance Criteria Test Mapping

- [ ] AC1: Time updates automatically every 1000ms
  - Test: "should update time every 1000ms"
  - File: src/hooks/useCurrentTime.test.ts
  - Type: Unit

- [ ] AC2: Hook integrated in App component
  - Test: "should render current time from hook"
  - File: src/App.test.tsx
  - Type: Integration

- [ ] AC3: Time displays in HH:MM:SS format
  - Test: "should format time with leading zeros"
  - File: src/components/TimeDisplay.test.tsx
  - Type: Unit
```

**Validation**:
- ✅ Every AC has at least one test
- ✅ Integration ACs have integration tests
- ✅ Test assertions match AC requirements

---

## 🧪 Edge Case Testing Checklist

For every public function, test:

```typescript
describe('myFunction edge cases', () => {
  // Invalid inputs
  it('should handle null input', () => {
    expect(() => myFunction(null)).toThrow();
  });

  it('should handle undefined input', () => {
    expect(() => myFunction(undefined)).toThrow();
  });

  it('should handle empty string', () => {
    expect(() => myFunction('')).toThrow();
  });

  // Boundary values
  it('should handle minimum value', () => {
    expect(myFunction(0)).toBe(expectedMin);
  });

  it('should handle maximum value', () => {
    expect(myFunction(Number.MAX_SAFE_INTEGER)).toBe(expectedMax);
  });

  // Type mismatches
  it('should throw error for invalid type', () => {
    expect(() => myFunction('not-a-number')).toThrow();
  });
});
```

---

## 🔒 Security Checklist

Before committing, verify:

- [ ] All external links have `rel="noopener noreferrer"`
- [ ] No hardcoded API keys or secrets
- [ ] No `console.log` in production code
- [ ] No `eval()` or `Function()` constructor
- [ ] No `dangerouslySetInnerHTML` without sanitization
- [ ] All user input is validated and sanitized

---

## 🧹 Cleanup Checklist

Before marking story complete:

- [ ] Remove unused CSS files (App.css, index.css if using CSS Modules)
- [ ] Remove unused logo files
- [ ] Remove TODO/FIXME comments
- [ ] Remove commented-out code
- [ ] Update README if needed
- [ ] Verify .gitignore is complete

---

## 📊 Test Coverage Checklist

Ensure you have:

- [ ] **Unit tests** for all functions and hooks
- [ ] **Integration tests** for component interactions
- [ ] **E2E tests** for user workflows (if applicable)
- [ ] **Accessibility tests** with axe-core
- [ ] **Edge case tests** for invalid inputs
- [ ] **Boundary tests** for min/max values

**Minimum coverage**:
- Functions: 100%
- Components: 90%
- Edge cases: 80%

---

## 🎯 Common Test Patterns

### Pattern 1: Testing Hooks
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
});
```

### Pattern 2: Testing Components
```typescript
import { render, screen } from '@testing-library/react';

describe('TimeDisplay', () => {
  it('should render time in HH:MM:SS format', () => {
    const testTime = new Date('2025-10-13T14:35:42');
    render(<TimeDisplay currentTime={testTime} />);
    
    expect(screen.getByText('14:35:42')).toBeInTheDocument();
  });
});
```

### Pattern 3: Testing Accessibility
```typescript
import { axe, toHaveNoViolations } from 'jest-axe';
expect.extend(toHaveNoViolations);

describe('App accessibility', () => {
  it('should have no accessibility violations', async () => {
    const { container } = render(<App />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });
});
```

---

## 🚀 Quick Commands

```bash
# Development
npm run dev              # Start dev server
npm run build            # Build for production
npm run preview          # Preview production build

# Testing
npm test                 # Run all tests
npm run test:unit        # Run unit tests only
npm run test:e2e         # Run E2E tests only
npm run test:coverage    # Generate coverage report

# Code Quality
npm run lint             # Run ESLint
npm run lint:fix         # Auto-fix ESLint issues
npm run type-check       # Run TypeScript compiler

# Validation
./scripts/pre-commit-checks.sh      # Run all pre-commit checks
./scripts/cleanup-boilerplate.sh    # Remove unused files
./scripts/validate-docs.sh          # Validate documentation
```

---

## 📚 Additional Resources

- **Full Analysis**: See `code-review-analysis.md` for detailed patterns
- **Implementation Guide**: See `implementation-guide.md` for step-by-step fixes
- **Testing Patterns**: See `.claude/agents/agent-guides/testing-patterns.md`
- **Agent Definition**: See `.claude/agents/definitions/react-developer.md`

---

## 💡 Pro Tips

1. **Always create AC-to-Test mapping first** - Prevents missing tests
2. **Run pre-commit checks before every commit** - Catches 95% of issues
3. **Test edge cases for every public function** - Prevents runtime errors
4. **Use window, not global, in browser tests** - Prevents TypeScript errors
5. **Add security attributes to all external links** - Prevents vulnerabilities
6. **Clean up boilerplate files before finalizing** - Keeps codebase clean
7. **Validate documentation references** - Prevents confusion
8. **Run full test suite before marking complete** - Ensures quality

---

## 🆘 When You Get Stuck

If you encounter an issue not covered here:

1. **Check the full analysis**: `code-review-analysis.md`
2. **Check implementation guide**: `implementation-guide.md`
3. **Search previous code reviews**: `code_reviews/` folder
4. **Ask for help**: Document the issue for future reference

---

**Remember**: The goal is first-pass approval. These checks help you get there!

**Current Stats**:
- First-pass approval rate: 79%
- Target: >90%
- You can do it! 🎉

