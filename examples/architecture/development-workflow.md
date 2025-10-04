# Development Workflow

## Local Development Setup

### Prerequisites

```bash
# Install Node.js 18+ LTS
node --version  # Should be v18.0.0 or higher

# Install pnpm globally
npm install -g pnpm

# Verify pnpm installation
pnpm --version
```

### Initial Setup

```bash
# Clone repository (if from git)
git clone <repository-url>
cd mini-social-feed

# Install dependencies
pnpm install

# Copy environment template (no secrets needed for this app)
cp .env.example .env.local

# Run development server
pnpm dev

# Open browser to http://localhost:3000
```

### Development Commands

```bash
# Start development server with hot reload
pnpm dev

# Run linting
pnpm lint

# Run type checking
pnpm type-check

# Run unit tests
pnpm test

# Run unit tests in watch mode
pnpm test:watch

# Run E2E tests (requires dev server running)
pnpm test:e2e

# Run E2E tests in UI mode
pnpm test:e2e:ui

# Build for production
pnpm build

# Start production server locally
pnpm start

# Format code with Prettier
pnpm format

# Run all quality checks (lint + type-check + test)
pnpm validate
```

## Environment Configuration

### Required Environment Variables

```bash
# Frontend (.env.local)
# No environment variables required for core functionality
# JSONPlaceholder API is public and requires no authentication

# Optional: Analytics and monitoring
NEXT_PUBLIC_VERCEL_ANALYTICS_ID=<analytics-id>

# Optional: Development settings
NEXT_PUBLIC_API_BASE_URL=https://jsonplaceholder.typicode.com
```

**Note:** The application intentionally has no required environment variables, supporting the PRD requirement for zero-setup accessibility (NFR3).

---
