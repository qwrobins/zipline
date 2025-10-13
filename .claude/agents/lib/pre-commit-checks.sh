#!/bin/bash
# Pre-commit validation script for developer agents
# Run this before committing to catch common issues
# Based on analysis of 14 code reviews (21% re-review rate → target <10%)

set -e  # Exit on first error

echo "🔍 Running pre-commit validation checks..."
echo ""

# Track failures
FAILURES=0

# Check 1: TypeScript compilation
echo "1️⃣  Checking TypeScript compilation..."
if npm run build > /dev/null 2>&1 || tsc --noEmit > /dev/null 2>&1; then
  echo "✅ TypeScript compilation passed"
else
  echo "❌ TypeScript compilation failed"
  echo "   Run: npm run build OR tsc --noEmit"
  echo "   Fix all type errors before committing"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 2: ESLint
echo "2️⃣  Checking ESLint..."
if npm run lint > /dev/null 2>&1; then
  echo "✅ ESLint passed"
else
  echo "❌ ESLint failed"
  echo "   Run: npm run lint"
  echo "   Fix all linting errors and warnings before committing"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 3: Test environment validation (global vs window)
echo "3️⃣  Checking for 'global' usage in browser tests..."
if grep -r "global\." src/ tests/ e2e/ --include="*.test.ts" --include="*.test.tsx" --include="*.spec.ts" 2>/dev/null | grep -v "globalThis" > /dev/null; then
  echo "❌ Found 'global' usage in test files"
  echo "   Replace with 'window' for browser tests or 'globalThis' for cross-environment"
  echo ""
  echo "   Files with issues:"
  grep -r "global\." src/ tests/ e2e/ --include="*.test.ts" --include="*.test.tsx" --include="*.spec.ts" 2>/dev/null | grep -v "globalThis" | head -5
  echo ""
  echo "   Example fix:"
  echo "   ❌ vi.spyOn(global, 'clearInterval')"
  echo "   ✅ vi.spyOn(window, 'clearInterval')"
  FAILURES=$((FAILURES + 1))
else
  echo "✅ No 'global' usage in test files"
fi
echo ""

# Check 4: External links security
echo "4️⃣  Checking external links for security attributes..."
if grep -r 'target="_blank"' src/ --include="*.tsx" --include="*.jsx" 2>/dev/null | grep -v 'rel="noopener noreferrer"' > /dev/null; then
  echo "❌ Found external links without rel=\"noopener noreferrer\""
  echo "   Add security attributes to all target=\"_blank\" links"
  echo ""
  echo "   Files with issues:"
  grep -r 'target="_blank"' src/ --include="*.tsx" --include="*.jsx" 2>/dev/null | grep -v 'rel="noopener noreferrer"' | head -5
  echo ""
  echo "   Example fix:"
  echo "   ❌ <a href=\"https://external.com\" target=\"_blank\">Link</a>"
  echo "   ✅ <a href=\"https://external.com\" target=\"_blank\" rel=\"noopener noreferrer\">Link</a>"
  FAILURES=$((FAILURES + 1))
else
  echo "✅ External links have security attributes"
fi
echo ""

# Check 5: Console.log in production code
echo "5️⃣  Checking for console.log in production code..."
if grep -r "console\.log\|console\.debug" src/ --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" --exclude="*.test.*" --exclude="*.spec.*" 2>/dev/null > /dev/null; then
  echo "⚠️  Warning: Found console.log in production code"
  echo "   Remove or replace with proper logging"
  echo ""
  echo "   Files with console.log:"
  grep -r "console\.log\|console\.debug" src/ --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" --exclude="*.test.*" --exclude="*.spec.*" 2>/dev/null | head -5
  echo ""
  # This is a warning, not a failure
else
  echo "✅ No console.log in production code"
fi
echo ""

# Check 6: Tests exist
echo "6️⃣  Checking test files exist..."
if [ ! -d "src" ] || [ -z "$(find src -name '*.test.ts' -o -name '*.test.tsx' -o -name '*.spec.ts' 2>/dev/null)" ]; then
  echo "⚠️  Warning: No test files found in src/"
  echo "   Consider adding tests for your implementation"
else
  echo "✅ Test files found"
fi
echo ""

# Check 7: Unused variables (quick check)
echo "7️⃣  Checking for common unused variable patterns..."
if grep -r "const .* = \[" src/ --include="*.test.ts" --include="*.test.tsx" 2>/dev/null | grep -v "expect\|assert\|toBe\|toEqual" > /dev/null; then
  echo "⚠️  Warning: Possible unused variables in test files"
  echo "   Review test files for unused variable assignments"
  # This is a warning, not a failure
else
  echo "✅ No obvious unused variables detected"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $FAILURES -eq 0 ]; then
  echo "✅ All pre-commit checks passed!"
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
  echo "   - TypeScript errors: Check types, imports, and tsconfig.json"
  echo "   - ESLint errors: Run 'npm run lint' for details"
  echo "   - global usage: Replace with 'window' in browser tests"
  echo "   - Security: Add rel=\"noopener noreferrer\" to external links"
  exit 1
fi

