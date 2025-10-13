#!/bin/bash
# Pre-commit validation script for Python projects
# Run this before committing to catch common issues

set -e  # Exit on first error

echo "🔍 Running Python pre-commit validation checks..."
echo ""

# Track failures
FAILURES=0

# Detect Python package manager
if [ -f "pyproject.toml" ] && command -v uv &> /dev/null; then
  PKG_MANAGER="uv"
  RUN_CMD="uv run"
elif [ -f "pyproject.toml" ] && command -v poetry &> /dev/null; then
  PKG_MANAGER="poetry"
  RUN_CMD="poetry run"
elif [ -f "Pipfile" ] && command -v pipenv &> /dev/null; then
  PKG_MANAGER="pipenv"
  RUN_CMD="pipenv run"
else
  PKG_MANAGER="pip"
  RUN_CMD=""
fi

echo "ℹ️  Detected package manager: $PKG_MANAGER"
echo ""

# Check 1: Black formatting
echo "1️⃣  Checking Black formatting..."
if command -v black &> /dev/null || [ -n "$RUN_CMD" ]; then
  if $RUN_CMD black --check . > /dev/null 2>&1; then
    echo "✅ Black formatting passed"
  else
    echo "❌ Black formatting failed"
    echo "   Files need formatting:"
    $RUN_CMD black --check . 2>&1 | grep "would reformat" | sed 's/^/   - /'
    echo ""
    echo "   Fix with: black ."
    FAILURES=$((FAILURES + 1))
  fi
else
  echo "⚠️  Black not installed (recommended)"
  echo "   Install: pip install black"
fi
echo ""

# Check 2: Ruff linting
echo "2️⃣  Checking Ruff linting..."
if command -v ruff &> /dev/null || [ -n "$RUN_CMD" ]; then
  if $RUN_CMD ruff check . > /dev/null 2>&1; then
    echo "✅ Ruff linting passed"
  else
    echo "❌ Ruff linting failed"
    echo "   Run: ruff check ."
    echo "   Fix all linting errors before committing"
    FAILURES=$((FAILURES + 1))
  fi
else
  echo "⚠️  Ruff not installed (recommended)"
  echo "   Install: pip install ruff"
fi
echo ""

# Check 3: mypy type checking
echo "3️⃣  Checking mypy type checking..."
if command -v mypy &> /dev/null || [ -n "$RUN_CMD" ]; then
  if $RUN_CMD mypy . > /dev/null 2>&1; then
    echo "✅ mypy type checking passed"
  else
    echo "❌ mypy type checking failed"
    echo "   Run: mypy ."
    echo "   Fix all type errors before committing"
    FAILURES=$((FAILURES + 1))
  fi
else
  echo "⚠️  mypy not installed (recommended)"
  echo "   Install: pip install mypy"
fi
echo ""

# Check 4: isort import sorting
echo "4️⃣  Checking isort import sorting..."
if command -v isort &> /dev/null || [ -n "$RUN_CMD" ]; then
  if $RUN_CMD isort --check-only . > /dev/null 2>&1; then
    echo "✅ isort import sorting passed"
  else
    echo "⚠️  Warning: Imports need sorting"
    echo "   Fix with: isort ."
    # This is a warning, not a failure (black/ruff can handle this)
  fi
else
  echo "ℹ️  isort not installed (optional, ruff can handle imports)"
fi
echo ""

# Check 5: pytest tests
echo "5️⃣  Checking pytest tests..."
if command -v pytest &> /dev/null || [ -n "$RUN_CMD" ]; then
  if $RUN_CMD pytest -x > /dev/null 2>&1; then
    echo "✅ pytest tests passed"
  else
    echo "❌ pytest tests failed"
    echo "   Run: pytest -v"
    echo "   Fix all failing tests before committing"
    FAILURES=$((FAILURES + 1))
  fi
else
  echo "⚠️  pytest not installed"
  echo "   Install: pip install pytest"
fi
echo ""

# Check 6: Security vulnerabilities (bandit)
echo "6️⃣  Checking for security issues (bandit)..."
if command -v bandit &> /dev/null || [ -n "$RUN_CMD" ]; then
  if $RUN_CMD bandit -r . -ll > /dev/null 2>&1; then
    echo "✅ No security issues found"
  else
    echo "⚠️  Warning: Potential security issues found"
    echo "   Run: bandit -r . -ll"
    echo "   Review and address security issues"
    # This is a warning, not a failure
  fi
else
  echo "ℹ️  bandit not installed (recommended)"
  echo "   Install: pip install bandit"
fi
echo ""

# Check 7: Requirements files (if using pip)
if [ "$PKG_MANAGER" = "pip" ] && [ -f "requirements.txt" ]; then
  echo "7️⃣  Checking requirements.txt..."
  if pip check > /dev/null 2>&1; then
    echo "✅ No dependency conflicts"
  else
    echo "⚠️  Warning: Dependency conflicts detected"
    echo "   Run: pip check"
    echo "   Resolve dependency conflicts"
    # This is a warning, not a failure
  fi
  echo ""
fi

# Check 8: Poetry lock file (if using poetry)
if [ "$PKG_MANAGER" = "poetry" ]; then
  echo "8️⃣  Checking poetry.lock..."
  if poetry check > /dev/null 2>&1; then
    echo "✅ poetry.lock is valid"
  else
    echo "❌ poetry.lock is invalid"
    echo "   Run: poetry lock"
    echo "   Commit the updated poetry.lock"
    FAILURES=$((FAILURES + 1))
  fi
  echo ""
fi

# Check 9: Test coverage (if requested)
if [ "${CHECK_COVERAGE:-false}" = "true" ]; then
  echo "9️⃣  Checking test coverage..."
  if command -v pytest &> /dev/null || [ -n "$RUN_CMD" ]; then
    COVERAGE=$($RUN_CMD pytest --cov --cov-report=term-missing 2>/dev/null | grep "TOTAL" | awk '{print $NF}' | sed 's/%//' || echo "0")
    if [ -n "$COVERAGE" ] && [ "$(echo "$COVERAGE >= 80" | bc -l 2>/dev/null || echo 0)" -eq 1 ]; then
      echo "✅ Test coverage: ${COVERAGE}%"
    else
      echo "⚠️  Warning: Test coverage below 80%: ${COVERAGE}%"
      echo "   Run: pytest --cov --cov-report=term-missing"
      echo "   Consider adding more tests"
      # This is a warning, not a failure
    fi
  fi
  echo ""
fi

# Check 10: Print statements in production code
echo "🔟 Checking for print statements in production code..."
if grep -r "print(" . --include="*.py" --exclude-dir=tests --exclude-dir=test 2>/dev/null | grep -v "# noqa" > /dev/null; then
  echo "⚠️  Warning: Found print() statements in production code"
  echo "   Files with print():"
  grep -r "print(" . --include="*.py" --exclude-dir=tests --exclude-dir=test 2>/dev/null | grep -v "# noqa" | head -5 | sed 's/^/   - /'
  echo ""
  echo "   Consider using logging instead"
  # This is a warning, not a failure
else
  echo "✅ No print() statements in production code"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $FAILURES -eq 0 ]; then
  echo "✅ All Python pre-commit checks passed!"
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
  echo "   - Formatting: black ."
  echo "   - Linting: ruff check . --fix"
  echo "   - Type errors: mypy ."
  echo "   - Import sorting: isort ."
  echo "   - Test failures: pytest -v"
  echo "   - Poetry lock: poetry lock"
  exit 1
fi

