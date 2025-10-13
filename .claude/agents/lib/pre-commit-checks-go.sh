#!/bin/bash
# Pre-commit validation script for Go projects
# Run this before committing to catch common issues

set -e  # Exit on first error

echo "🔍 Running Go pre-commit validation checks..."
echo ""

# Track failures
FAILURES=0

# Check 1: Go formatting
echo "1️⃣  Checking Go formatting (gofmt)..."
UNFORMATTED=$(gofmt -l . 2>/dev/null | grep -v vendor || true)
if [ -z "$UNFORMATTED" ]; then
  echo "✅ Go formatting passed"
else
  echo "❌ Go formatting failed"
  echo "   Files need formatting:"
  echo "$UNFORMATTED" | sed 's/^/   - /'
  echo ""
  echo "   Fix with: gofmt -w ."
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 2: Go vet
echo "2️⃣  Checking Go vet..."
if go vet ./... > /dev/null 2>&1; then
  echo "✅ Go vet passed"
else
  echo "❌ Go vet failed"
  echo "   Run: go vet ./..."
  echo "   Fix all issues before committing"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 3: golangci-lint (if available)
echo "3️⃣  Checking golangci-lint..."
if command -v golangci-lint &> /dev/null; then
  if golangci-lint run ./... > /dev/null 2>&1; then
    echo "✅ golangci-lint passed"
  else
    echo "❌ golangci-lint failed"
    echo "   Run: golangci-lint run ./..."
    echo "   Fix all linting errors before committing"
    FAILURES=$((FAILURES + 1))
  fi
else
  echo "⚠️  golangci-lint not installed (recommended)"
  echo "   Install: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
fi
echo ""

# Check 4: Go build
echo "4️⃣  Checking Go build..."
if go build ./... > /dev/null 2>&1; then
  echo "✅ Go build passed"
else
  echo "❌ Go build failed"
  echo "   Run: go build ./..."
  echo "   Fix all build errors before committing"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 5: Go tests
echo "5️⃣  Checking Go tests..."
if go test ./... -short > /dev/null 2>&1; then
  echo "✅ Go tests passed"
else
  echo "❌ Go tests failed"
  echo "   Run: go test ./... -v"
  echo "   Fix all failing tests before committing"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 6: Go mod tidy
echo "6️⃣  Checking go.mod is tidy..."
go mod tidy
if git diff --exit-code go.mod go.sum > /dev/null 2>&1; then
  echo "✅ go.mod is tidy"
else
  echo "❌ go.mod needs tidying"
  echo "   Run: go mod tidy"
  echo "   Commit the changes to go.mod and go.sum"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 7: Unused imports
echo "7️⃣  Checking for unused imports..."
if command -v goimports &> /dev/null; then
  UNFORMATTED=$(goimports -l . 2>/dev/null | grep -v vendor || true)
  if [ -z "$UNFORMATTED" ]; then
    echo "✅ No unused imports"
  else
    echo "⚠️  Warning: Files with import issues:"
    echo "$UNFORMATTED" | sed 's/^/   - /'
    echo ""
    echo "   Fix with: goimports -w ."
    # This is a warning, not a failure
  fi
else
  echo "ℹ️  goimports not installed (optional)"
  echo "   Install: go install golang.org/x/tools/cmd/goimports@latest"
fi
echo ""

# Check 8: Security vulnerabilities (if govulncheck available)
echo "8️⃣  Checking for security vulnerabilities..."
if command -v govulncheck &> /dev/null; then
  if govulncheck ./... > /dev/null 2>&1; then
    echo "✅ No known vulnerabilities"
  else
    echo "⚠️  Warning: Potential security vulnerabilities found"
    echo "   Run: govulncheck ./..."
    echo "   Review and address vulnerabilities"
    # This is a warning, not a failure
  fi
else
  echo "ℹ️  govulncheck not installed (recommended)"
  echo "   Install: go install golang.org/x/vuln/cmd/govulncheck@latest"
fi
echo ""

# Check 9: Test coverage (if requested)
if [ "${CHECK_COVERAGE:-false}" = "true" ]; then
  echo "9️⃣  Checking test coverage..."
  COVERAGE=$(go test ./... -cover -coverprofile=coverage.out 2>/dev/null | grep "coverage:" | awk '{print $NF}' | sed 's/%//' || echo "0")
  if [ -n "$COVERAGE" ] && [ "$(echo "$COVERAGE >= 80" | bc -l 2>/dev/null || echo 0)" -eq 1 ]; then
    echo "✅ Test coverage: ${COVERAGE}%"
  else
    echo "⚠️  Warning: Test coverage below 80%: ${COVERAGE}%"
    echo "   Run: go test ./... -cover"
    echo "   Consider adding more tests"
    # This is a warning, not a failure
  fi
  rm -f coverage.out
  echo ""
fi

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $FAILURES -eq 0 ]; then
  echo "✅ All Go pre-commit checks passed!"
  echo "   Ready to commit."
  echo ""
  echo "   Next steps:"
  echo "   1. Review your changes: git diff"
  echo "   2. Stage your changes: git add ."
  echo "   3. Commit: git commit -m \"Your message\""
  exit 0
else
  echo "❌ $FAILURES check(s) failed"
  echo "   Fix the issues above before committing"
  echo ""
  echo "   Common fixes:"
  echo "   - Formatting: gofmt -w ."
  echo "   - Vet issues: go vet ./..."
  echo "   - Linting: golangci-lint run ./..."
  echo "   - Build errors: go build ./..."
  echo "   - Test failures: go test ./... -v"
  echo "   - Module tidiness: go mod tidy"
  exit 1
fi

