#!/bin/bash

# Web Application Testing Setup Script
# Automates the setup of Playwright, Lighthouse, and axe-core testing for web projects
# Usage: ./scripts/setup-web-testing.sh [project-directory]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get project directory
PROJECT_DIR="${1:-.}"

if [[ ! -d "$PROJECT_DIR" ]]; then
    log_error "Project directory not found: $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"

log_info "Setting up web application testing in: $(pwd)"
echo

# Check if package.json exists
if [[ ! -f "package.json" ]]; then
    log_error "package.json not found. This script is for Node.js/npm projects."
    exit 1
fi

# Install testing dependencies
log_info "Installing testing dependencies..."
npm install --save-dev @playwright/test lighthouse axe-core

# Install Playwright browsers
log_info "Installing Playwright browsers..."
npx playwright install

log_success "Dependencies installed"
echo

# Create playwright.config.js
log_info "Creating Playwright configuration..."
cat > playwright.config.js << 'EOF'
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
EOF

# Create Lighthouse configuration
log_info "Creating Lighthouse configuration..."
cat > .lighthouserc.json << 'EOF'
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
EOF

# Create axe configuration
log_info "Creating axe-core configuration..."
cat > .axerc.json << 'EOF'
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
EOF

# Create test directory structure
log_info "Creating test directory structure..."
mkdir -p tests/visual

# Create example test file
cat > tests/visual/homepage.visual.spec.js << 'EOF'
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
EOF

# Update package.json scripts
log_info "Adding test scripts to package.json..."
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.scripts = pkg.scripts || {};
pkg.scripts['test:visual'] = 'playwright test --project=visual';
pkg.scripts['test:a11y'] = 'axe --dir ./build --exit';
pkg.scripts['test:performance'] = 'lighthouse http://localhost:3000 --output=json --output-path=./lighthouse-report.json';
pkg.scripts['test:design'] = 'npm run build && npm run test:visual && npm run test:a11y && npm run test:performance';
pkg.scripts['test:responsive'] = 'playwright test --project=responsive';
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"

log_success "Configuration files created"
echo

# Create .gitignore entries
log_info "Updating .gitignore..."
if [[ -f ".gitignore" ]]; then
    if ! grep -q "test-results" .gitignore; then
        echo "" >> .gitignore
        echo "# Testing" >> .gitignore
        echo "test-results/" >> .gitignore
        echo "playwright-report/" >> .gitignore
        echo "lighthouse-report.json" >> .gitignore
    fi
else
    cat > .gitignore << 'EOF'
# Testing
test-results/
playwright-report/
lighthouse-report.json
EOF
fi

log_success "Web application testing setup completed!"
echo

log_info "Next steps:"
echo "1. Start your development server: npm start"
echo "2. Run design validation: npm run test:design"
echo "3. View test results in playwright-report/"
echo
log_info "Available commands:"
echo "  npm run test:visual      - Visual regression tests"
echo "  npm run test:a11y        - Accessibility testing"
echo "  npm run test:performance - Lighthouse audit"
echo "  npm run test:design      - Full design validation"
echo
