# Web Application Testing Setup Template

## Quick Setup Commands

### Install Testing Dependencies
```bash
# Core testing tools
npm install --save-dev @playwright/test lighthouse axe-core

# Install browsers for Playwright
npx playwright install

# Optional: Visual regression tools
npm install --save-dev @percy/cli @percy/playwright
```

### Package.json Scripts
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

## Configuration Files

### Playwright Configuration (playwright.config.js)
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
    },
    {
      name: 'tablet',
      use: { ...devices['iPad Pro'] },
      testMatch: '**/*.tablet.spec.js'
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

### Lighthouse CI Configuration (.lighthouserc.json)
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
    },
    "upload": {
      "target": "temporary-public-storage"
    }
  }
}
```

### Axe Configuration (.axerc.json)
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

## Test Examples

### Visual Regression Test (tests/visual/homepage.visual.spec.js)
```javascript
import { test, expect } from '@playwright/test';

test.describe('Homepage Visual Tests', () => {
  test('homepage desktop layout', async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    await expect(page).toHaveScreenshot('homepage-desktop.png');
  });

  test('homepage with dark theme', async ({ page }) => {
    await page.goto('/');
    await page.click('[data-testid="theme-toggle"]');
    await page.waitForTimeout(500); // Wait for theme transition
    await expect(page).toHaveScreenshot('homepage-dark.png');
  });

  test('homepage loading state', async ({ page }) => {
    await page.route('/api/**', route => {
      // Delay API responses to capture loading state
      setTimeout(() => route.continue(), 1000);
    });
    
    await page.goto('/');
    await expect(page).toHaveScreenshot('homepage-loading.png');
  });
});
```

### Responsive Design Test (tests/visual/responsive.responsive.spec.js)
```javascript
import { test, expect } from '@playwright/test';

const viewports = [
  { name: 'mobile', width: 375, height: 667 },
  { name: 'tablet', width: 768, height: 1024 },
  { name: 'desktop', width: 1920, height: 1080 },
  { name: 'wide', width: 2560, height: 1440 }
];

test.describe('Responsive Design Tests', () => {
  for (const viewport of viewports) {
    test(`layout at ${viewport.name} (${viewport.width}x${viewport.height})`, async ({ page }) => {
      await page.setViewportSize({ width: viewport.width, height: viewport.height });
      await page.goto('/');
      await page.waitForLoadState('networkidle');
      
      // Check for horizontal scrolling
      const scrollWidth = await page.evaluate(() => document.documentElement.scrollWidth);
      const clientWidth = await page.evaluate(() => document.documentElement.clientWidth);
      expect(scrollWidth).toBeLessThanOrEqual(clientWidth + 1); // Allow 1px tolerance
      
      // Take screenshot
      await expect(page).toHaveScreenshot(`homepage-${viewport.name}.png`);
    });
  }

  test('navigation menu responsive behavior', async ({ page }) => {
    // Test mobile menu
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/');
    
    // Should show hamburger menu
    await expect(page.locator('[data-testid="mobile-menu-button"]')).toBeVisible();
    await expect(page.locator('[data-testid="desktop-nav"]')).toBeHidden();
    
    // Test desktop menu
    await page.setViewportSize({ width: 1920, height: 1080 });
    await expect(page.locator('[data-testid="mobile-menu-button"]')).toBeHidden();
    await expect(page.locator('[data-testid="desktop-nav"]')).toBeVisible();
  });
});
```

### Accessibility Test (tests/visual/accessibility.spec.js)
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
    
    // Test skip link
    await page.keyboard.press('Tab');
    const skipLink = page.locator('[data-testid="skip-link"]');
    if (await skipLink.isVisible()) {
      await expect(skipLink).toBeFocused();
    }
  });

  test('color contrast compliance', async ({ page }) => {
    await page.goto('/');
    
    const contrastResults = await new AxeBuilder({ page })
      .withRules(['color-contrast'])
      .analyze();
    
    expect(contrastResults.violations).toEqual([]);
  });
});
```

## GitHub Actions Integration (.github/workflows/design-validation.yml)
```yaml
name: Design Validation

on:
  pull_request:
    branches: [ main ]

jobs:
  visual-tests:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Install Playwright browsers
      run: npx playwright install --with-deps
    
    - name: Build application
      run: npm run build
    
    - name: Run design validation
      run: npm run test:design
    
    - name: Upload Playwright report
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: playwright-report
        path: playwright-report/
        retention-days: 30
    
    - name: Upload Lighthouse report
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: lighthouse-report
        path: lighthouse-report.json
        retention-days: 30
```

## VS Code Integration

### Settings (.vscode/settings.json)
```json
{
  "playwright.reuseBrowser": true,
  "playwright.showTrace": true,
  "axe-linter.enable": true,
  "lighthouse.enable": true
}
```

### Extensions (.vscode/extensions.json)
```json
{
  "recommendations": [
    "ms-playwright.playwright",
    "deque-systems.vscode-axe-linter",
    "googlechrome.lighthouse"
  ]
}
```

## Usage Instructions

### For Development Agents

1. **Initial Setup:**
   ```bash
   # Copy this template to your project
   cp templates/web-app-testing-setup.md ./TESTING_SETUP.md
   
   # Install dependencies
   npm install --save-dev @playwright/test lighthouse axe-core
   npx playwright install
   ```

2. **During Development:**
   ```bash
   # Run visual regression tests
   npm run test:visual
   
   # Test responsive design
   npm run test:responsive
   
   # Check accessibility
   npm run test:a11y
   ```

3. **Before Merging:**
   ```bash
   # Run complete design validation
   npm run test:design
   ```

4. **Verify Results:**
   - All Playwright tests pass
   - Lighthouse scores ≥ 90 for performance and accessibility
   - Zero axe-core violations
   - Visual screenshots match expected designs

This setup provides **professional-grade testing** with **industry-standard tools** rather than custom bash scripts.
