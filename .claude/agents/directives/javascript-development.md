# JavaScript Development Directive

This directive contains common JavaScript development practices, testing setup, and quality standards shared across all JavaScript-based agents (React, Next.js, TypeScript, etc.).

## ⚠️ CRITICAL WORKFLOW REQUIREMENTS ⚠️

### ALWAYS Use Enhanced Git Worktree Workflow
**YOU MUST use the enhanced git worktree workflow with design validation to prevent conflicts AND ensure professional UI quality.**

**See `.claude/agents/directives/git-worktree-workflow.md` for complete enhanced workflow details.**

### ALWAYS Use Sequential Thinking Before Coding
**YOU MUST use the `sequential_thinking` tool to plan BEFORE writing any code.**
- Break down the task into logical steps
- Identify challenges and edge cases
- Plan file structure and approach
- Consider testing strategy

### ALWAYS Consult Documentation When Uncertain
**YOU MUST use `context7` tools to consult official documentation whenever there is ANY uncertainty.**
- How to implement a feature or pattern
- Correct API usage for frameworks
- Best practices for libraries
- Proper syntax or method signatures

## Complete Web Application Testing Setup

**When building web applications, you MUST implement professional design validation:**

### 1. Install Testing Dependencies
```bash
npm install --save-dev @playwright/test lighthouse axe-core
npx playwright install
```

### 2. Add Scripts to package.json
```json
{
  "scripts": {
    "test:visual": "playwright test --project=visual",
    "test:a11y": "axe --dir ./build --exit",
    "test:performance": "lighthouse http://localhost:3000 --output=json --output-path=./lighthouse-report.json",
    "test:design": "npm run build && npm run test:visual && npm run test:a11y && npm run test:performance",
    "test:responsive": "playwright test --project=responsive",
    "test:cross-browser": "playwright test --project=chromium --project=firefox --project=webkit"
  }
}
```

### 3. Create playwright.config.js
```javascript
const { defineConfig, devices } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests/visual',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
  },

  projects: [
    {
      name: 'visual',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/*.visual.spec.js'
    },
    {
      name: 'responsive',
      use: { ...devices['Desktop Chrome'] },
      testMatch: '**/*.responsive.spec.js'
    },
    {
      name: 'mobile',
      use: { ...devices['iPhone 12'] },
      testMatch: '**/*.mobile.spec.js'
    }
  ],

  expect: {
    toHaveScreenshot: { 
      threshold: 0.2, 
      mode: 'pixel',
      animations: 'disabled'
    }
  },

  webServer: {
    command: 'npm start',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### 4. Create .lighthouserc.json
```json
{
  "ci": {
    "collect": {
      "url": ["http://localhost:3000"],
      "numberOfRuns": 3,
      "settings": {
        "chromeFlags": "--no-sandbox"
      }
    },
    "assert": {
      "assertions": {
        "categories:performance": ["error", {"minScore": 0.9}],
        "categories:accessibility": ["error", {"minScore": 0.9}],
        "categories:best-practices": ["error", {"minScore": 0.9}],
        "categories:seo": ["error", {"minScore": 0.9}]
      }
    }
  }
}
```

### 5. Create .axerc.json
```json
{
  "rules": {
    "color-contrast": { "enabled": true },
    "keyboard-navigation": { "enabled": true },
    "focus-management": { "enabled": true }
  },
  "tags": ["wcag2a", "wcag2aa", "wcag21aa"],
  "exclude": [
    ["#third-party-widget"]
  ]
}
```

### 6. Create tests/visual/homepage.visual.spec.js
```javascript
import { test, expect } from '@playwright/test';

test.describe('Homepage Visual Tests', () => {
  test('homepage desktop layout', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await expect(page).toHaveScreenshot('homepage-desktop.png');
  });

  test('homepage responsive design', async ({ page }) => {
    const viewports = [
      { width: 375, height: 667 },   // Mobile
      { width: 768, height: 1024 },  // Tablet
      { width: 1920, height: 1080 }  // Desktop
    ];
    
    for (const viewport of viewports) {
      await page.setViewportSize(viewport);
      await page.goto('/');
      await page.waitForLoadState('networkidle');
      await expect(page).toHaveScreenshot(`homepage-${viewport.width}x${viewport.height}.png`);
    }
  });
});
```

### 7. Create tests/visual/accessibility.spec.js
```javascript
import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test.describe('Accessibility Tests', () => {
  test('homepage accessibility scan', async ({ page }) => {
    await page.goto('/');
    
    const accessibilityScanResults = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21aa'])
      .analyze();
    
    expect(accessibilityScanResults.violations).toEqual([]);
  });

  test('keyboard navigation', async ({ page }) => {
    await page.goto('/');
    
    // Test tab navigation
    await page.keyboard.press('Tab');
    const firstFocusable = await page.locator(':focus');
    await expect(firstFocusable).toBeVisible();
  });
});
```

### 8. Update .gitignore
```
# Testing
test-results/
playwright-report/
lighthouse-report.json
```

## Code Quality Configuration

### ESLint Configuration (.eslintrc.js or eslint.config.js)

**Enhanced with Security Rules** (based on code review analysis)

```javascript
module.exports = {
  root: true,
  env: {
    browser: true,
    es2020: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
  ],
  ignorePatterns: ['dist', '.eslintrc.cjs'],
  parser: '@typescript-eslint/parser',
  plugins: ['react-refresh'],
  rules: {
    // React rules
    'react-refresh/only-export-components': [
      'warn',
      { allowConstantExport: true },
    ],
    'react/react-in-jsx-scope': 'off',
    'react/prop-types': 'off',

    // TypeScript rules
    '@typescript-eslint/no-unused-vars': ['error', {
      argsIgnorePattern: '^_',
      varsIgnorePattern: '^_'
    }],
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',

    // Security rules (CRITICAL - prevents review failures)
    'react/jsx-no-target-blank': ['error', {
      allowReferrer: false,
      enforceDynamicLinks: 'always'
    }],
    'no-eval': 'error',
    'no-implied-eval': 'error',
    'no-new-func': 'error',
    'no-console': ['warn', {
      allow: ['warn', 'error']
    }],
  },
  settings: {
    react: {
      version: 'detect',
    },
  },
};
```

**Key Security Rules Added:**
- `react/jsx-no-target-blank`: Prevents tabnabbing attacks (1 story failed without this)
- `no-eval`: Prevents code injection vulnerabilities
- `no-console`: Warns about console.log in production code
- `@typescript-eslint/no-unused-vars`: Catches unused variables (2 stories had this issue)

### Prettier Configuration (.prettierrc)
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
```

## Performance Optimization Patterns

### Bundle Analysis
```bash
# Add to package.json scripts
"analyze": "npm run build && npx vite-bundle-analyzer dist"
```

### Code Splitting Patterns
```javascript
// Lazy loading components
import { lazy, Suspense } from 'react';

const LazyComponent = lazy(() => import('./LazyComponent'));

function App() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <LazyComponent />
    </Suspense>
  );
}

// Dynamic imports for utilities
const loadUtility = async () => {
  const { heavyUtility } = await import('./heavyUtility');
  return heavyUtility;
};
```

### Web Vitals Monitoring
```javascript
// src/utils/webVitals.js
import { getCLS, getFID, getFCP, getLCP, getTTFB } from 'web-vitals';

function sendToAnalytics(metric) {
  // Send to your analytics service
  console.log(metric);
}

getCLS(sendToAnalytics);
getFID(sendToAnalytics);
getFCP(sendToAnalytics);
getLCP(sendToAnalytics);
getTTFB(sendToAnalytics);
```

## Security Best Practices

### Environment Variables
```javascript
// Use environment variables for sensitive data
const API_URL = import.meta.env.VITE_API_URL;
const API_KEY = import.meta.env.VITE_API_KEY;

// Validate environment variables
if (!API_URL) {
  throw new Error('VITE_API_URL is required');
}
```

### Content Security Policy
```html
<!-- Add to index.html -->
<meta http-equiv="Content-Security-Policy" 
      content="default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';">
```

### Input Sanitization
```javascript
// Sanitize user inputs
import DOMPurify from 'dompurify';

const sanitizeHTML = (dirty) => {
  return DOMPurify.sanitize(dirty);
};

// Use in components
function UserContent({ content }) {
  return (
    <div 
      dangerouslySetInnerHTML={{ 
        __html: sanitizeHTML(content) 
      }} 
    />
  );
}
```

## Common JavaScript Patterns

### Error Handling
```javascript
// Error boundary for React
class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true };
  }

  componentDidCatch(error, errorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return <h1>Something went wrong.</h1>;
    }

    return this.props.children;
  }
}

// Async error handling
const fetchWithErrorHandling = async (url) => {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('Fetch error:', error);
    throw error;
  }
};
```

### Type Safety Patterns
```typescript
// Utility types
type Optional<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>;
type RequiredFields<T, K extends keyof T> = T & Required<Pick<T, K>>;

// API response typing
interface ApiResponse<T> {
  data: T;
  status: 'success' | 'error';
  message?: string;
}

// Event handler typing
type EventHandler<T = HTMLElement> = (event: React.SyntheticEvent<T>) => void;
```

## 🚨 MANDATORY: Static Analysis and Pre-Commit Checks 🚨

**CRITICAL: Run ALL static analysis tools BEFORE committing code**

### Why This Matters
- Code-reviewer runs these exact tools during review
- If you don't run them first, review WILL fail
- Fixing issues during implementation saves 40-60% of review iterations
- Security issues are review blockers
- **Analysis of 14 reviews**: 21% required re-review due to preventable issues

### Quick Pre-Commit Check (Recommended)

```bash
# Run automated pre-commit validation script
./.claude/agents/lib/pre-commit-checks.sh
```

This script checks:
- ✅ TypeScript compilation
- ✅ ESLint errors
- ✅ Test environment issues (global vs window)
- ✅ External link security
- ✅ Console.log in production
- ✅ Test file existence

**If script passes, proceed to commit. If it fails, fix issues below.**

---

### Step 1: Run TypeScript Compiler (MANDATORY)

```bash
tsc --noEmit
# or
npm run build
```

**Requirements:**
- [ ] Fix ALL type errors
- [ ] No `any` types without explicit justification
- [ ] All function parameters have explicit types
- [ ] All return types are explicit
- [ ] tsconfig.json has `"strict": true`

**TypeScript Strict Mode Verification:**
- [ ] No `any` types (use `unknown` with type guards instead)
- [ ] All function parameters typed
- [ ] All return types explicit
- [ ] tsc --noEmit passes with zero errors

**🚨 CRITICAL: Test Environment Validation**

**Common Issue**: Using `global` instead of `window` in browser tests (2 stories failed due to this)

```bash
# Check for incorrect global usage in test files
grep -r "global\." src/ tests/ e2e/ --include="*.test.ts" --include="*.test.tsx" --include="*.spec.ts"
```

**If found, fix immediately:**
```typescript
// ❌ WRONG - Causes TypeScript errors in browser tests
vi.spyOn(global, 'clearInterval')
vi.spyOn(global, 'setInterval')

// ✅ CORRECT - Use window for browser environment
vi.spyOn(window, 'clearInterval')
vi.spyOn(window, 'setInterval')

// ✅ CORRECT - Use globalThis for cross-environment
vi.spyOn(globalThis, 'clearInterval')
```

### Step 2: Run ESLint (MANDATORY)

```bash
npm run lint
# or
pnpm lint
# or
yarn lint
```

**Requirements:**
- [ ] Fix ALL linting errors
- [ ] Fix ALL warnings (warnings are not allowed)
- [ ] Follow project ESLint configuration
- [ ] No disabled rules without justification

**Common ESLint Issues to Check:**
- Unused variables in test files
- Missing dependencies in useEffect
- Incorrect hook usage
- Missing accessibility attributes

### Step 3: Run Prettier Check (MANDATORY)

```bash
npm run format:check
# or
pnpm format:check
```

**If formatting needed:**
```bash
npm run format
# or
pnpm format
```

**Requirements:**
- [ ] All files formatted consistently
- [ ] No formatting errors
- [ ] Prettier config followed

### Step 4: Run Security Audit (MANDATORY)

```bash
npm audit
# or
pnpm audit
```

**Requirements:**
- [ ] Fix ALL critical and high severity vulnerabilities
- [ ] Document any vulnerabilities that cannot be fixed
- [ ] Update dependencies to secure versions
- [ ] No hardcoded secrets or API keys

**🚨 CRITICAL: Security Validation Checks**

**1. External Link Security** (1 story failed due to this)

```bash
# Check for target="_blank" without security attributes
grep -r 'target="_blank"' src/ --include="*.tsx" --include="*.jsx" | grep -v 'rel="noopener noreferrer"'
```

**If found, fix immediately:**
```tsx
// ❌ WRONG - Security vulnerability (tabnabbing)
<a href="https://external.com" target="_blank">Link</a>

// ✅ CORRECT - Prevents tabnabbing and performance issues
<a href="https://external.com" target="_blank" rel="noopener noreferrer">Link</a>
```

**2. No Hardcoded Secrets**

```bash
# Check for potential secrets
grep -r "api[_-]key\|secret\|password\|token" src/ --include="*.ts" --include="*.tsx" | grep -v "// Example\|//"
```

**3. No Console Logs in Production**

```bash
# Check for console.log in production code
grep -r "console\.log\|console\.debug" src/ --include="*.ts" --include="*.tsx" --exclude="*.test.*" --exclude="*.spec.*"
```

**Security Checklist:**
- [ ] All external links have `rel="noopener noreferrer"`
- [ ] No hardcoded API keys or secrets
- [ ] No console.log in production code
- [ ] No eval() or Function() constructor
- [ ] No dangerouslySetInnerHTML without sanitization
- [ ] All user inputs validated
- [ ] HTTPS used for all API calls

### Step 5: Run Tests with Coverage (MANDATORY)

```bash
npm test -- --coverage
# or
pnpm test --coverage
```

**Requirements:**
- [ ] All tests passing
- [ ] Test coverage > 90%
- [ ] All acceptance criteria have tests
- [ ] Edge cases tested
- [ ] Error conditions tested

**🚨 CRITICAL: Acceptance Criteria to Test Mapping**

**Problem**: 3 stories (21%) had test configuration issues or missing tests

**Solution**: Create AC-to-Test mapping BEFORE writing tests

**See `.claude/agents/agent-guides/testing-best-practices.md` for complete guide**

**Quick Checklist:**
1. **Extract all ACs** from story file
2. **Map each AC to test cases** (test name, file, type, assertions)
3. **Verify mapping**:
   - [ ] Every AC has at least one test
   - [ ] Integration ACs have integration tests (not just unit tests)
   - [ ] Test assertions match AC requirements exactly
4. **Write tests** following the mapping
5. **Validate coverage** (>90% target)

**Example Mapping:**
```markdown
- [ ] AC1: Time updates automatically every 1000ms
  - Test: "should update time every 1000ms"
  - File: src/hooks/useCurrentTime.test.ts
  - Type: Unit

- [ ] AC2: Hook integrated in App component
  - Test: "should render current time from hook"
  - File: src/App.test.tsx
  - Type: Integration  ← IMPORTANT: Integration test required!
```

**Common Test Mistakes to Avoid:**
- ❌ Missing integration tests for "integrated in" ACs
- ❌ Testing wrong compliance level (AAA vs AA)
- ❌ Unused variables in test files
- ❌ Using `global` instead of `window` in browser tests

### Security Requirements Checklist

- [ ] No `dangerouslySetInnerHTML` without sanitization
- [ ] All user inputs validated (use Zod or similar)
- [ ] No `eval()` or `Function()` constructor
- [ ] CSRF protection on state-changing operations
- [ ] No hardcoded secrets or API keys
- [ ] All API calls use HTTPS
- [ ] Authentication tokens stored securely
- [ ] XSS prevention implemented

### ⚠️ CRITICAL: Pre-Commit Verification

**Before committing, verify:**
- [ ] `tsc --noEmit` passes with zero errors
- [ ] `npm run lint` passes with zero errors
- [ ] `npm run format:check` passes
- [ ] `npm audit` shows no critical/high vulnerabilities
- [ ] `npm test` passes with >90% coverage
- [ ] All security requirements met

**⚠️ If ANY check fails, FIX it before committing**
**⚠️ Do NOT commit code with type errors, linter errors, or security vulnerabilities**

**💡 TIP: Use the automated script**
```bash
./.claude/agents/lib/pre-commit-checks.sh
```

---

## 🧹 Finalization: Cleanup Before Marking Complete

**Problem**: 3 stories (21%) had unused boilerplate files

**Before marking story complete, run cleanup:**

### Step 1: Remove Unused Boilerplate Files

```bash
# Automated cleanup script
./.claude/agents/lib/cleanup-boilerplate.sh
```

**Manual Cleanup Checklist:**
- [ ] Remove unused CSS files (App.css, index.css if using CSS Modules)
- [ ] Remove unused logo files (react.svg, vite.svg if not referenced)
- [ ] Remove TODO/FIXME comments
- [ ] Remove commented-out code
- [ ] Remove unused imports (ESLint should catch these)

### Step 2: Validate Documentation

```bash
# Check documentation references
./.claude/agents/lib/validate-docs.sh
```

**Documentation Checklist:**
- [ ] README references correct file names
- [ ] No references to deleted files
- [ ] Package.json scripts are documented
- [ ] .gitignore is comprehensive

**Common .gitignore patterns to include:**
```gitignore
# Dependencies
node_modules
dist
dist-ssr
*.local

# Editor directories
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store
Thumbs.db

# Environment
.env
.env.local
.env.*.local

# Testing
coverage
.nyc_output
```

### Step 3: Final Verification

```bash
# Run all checks one more time
./.claude/agents/lib/pre-commit-checks.sh

# Verify tests pass
npm test

# Verify build succeeds
npm run build
```

**Final Checklist:**
- [ ] All pre-commit checks pass
- [ ] All tests pass
- [ ] Build succeeds
- [ ] No unused files
- [ ] Documentation is accurate
- [ ] .gitignore is complete

---

## Quality Standards

### Code Quality Checklist
- [ ] TypeScript strict mode enabled
- [ ] ESLint and Prettier configured
- [ ] All components properly typed
- [ ] Error boundaries implemented
- [ ] Loading and error states handled
- [ ] Accessibility requirements met (WCAG 2.1 Level AA)
- [ ] Performance optimizations applied
- [ ] Security best practices followed
- [ ] Tests written and passing
- [ ] Bundle size optimized

### Design Quality Requirements
- [ ] **Playwright visual tests** pass (pixel-perfect regression testing)
- [ ] **Lighthouse audit** scores ≥ 90 (performance, accessibility, SEO)
- [ ] **axe-core accessibility** scan with zero violations
- [ ] **Responsive design** verified across mobile, tablet, desktop
- [ ] **Cross-browser compatibility** tested (Chrome, Firefox, Safari)

**This directive provides the foundation for all JavaScript-based development. Specialized agents should reference this for common patterns and focus on their framework-specific expertise.**
