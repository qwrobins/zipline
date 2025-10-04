# Deployment Architecture

## Deployment Strategy

**Frontend Deployment:**
- **Platform:** Vercel (optimized for Next.js)
- **Build Command:** `pnpm build`
- **Output Directory:** `.next` (automatic)
- **CDN/Edge:** Vercel Edge Network with automatic global distribution

**Deployment Method:**
- Git-based continuous deployment (push to main = production deploy)
- Automatic preview deployments for all pull requests
- Instant rollback capability via Vercel dashboard

**Deployment Regions:** Automatic global edge deployment (no configuration needed)

## CI/CD Pipeline

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  quality-checks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'

      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: 8

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Lint
        run: pnpm lint

      - name: Type check
        run: pnpm type-check

      - name: Unit tests
        run: pnpm test

      - name: Build
        run: pnpm build

  e2e-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'

      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: 8

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Install Playwright browsers
        run: pnpx playwright install --with-deps

      - name: Run E2E tests
        run: pnpm test:e2e

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-report
          path: playwright-report/
```

## Environments

| Environment | Frontend URL | Backend URL | Purpose |
|-------------|--------------|-------------|---------|
| Development | http://localhost:3000 | N/A (JSONPlaceholder) | Local development |
| Staging | https://mini-social-feed-staging.vercel.app | N/A (JSONPlaceholder) | Pre-production testing |
| Production | https://mini-social-feed.vercel.app | N/A (JSONPlaceholder) | Live environment |

**Note:** No separate backend URLs needed; all environments use the public JSONPlaceholder API directly.

---
