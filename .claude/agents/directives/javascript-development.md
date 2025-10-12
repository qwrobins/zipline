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

### ESLint Configuration (.eslintrc.js)
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
    'react-refresh/only-export-components': [
      'warn',
      { allowConstantExport: true },
    ],
    'react/react-in-jsx-scope': 'off',
    'react/prop-types': 'off',
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
  },
  settings: {
    react: {
      version: 'detect',
    },
  },
};
```

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
