#!/bin/bash
# Pre-commit validation script for Rust projects
# Run this before committing to catch common issues

set -e  # Exit on first error

echo "🔍 Running Rust pre-commit validation checks..."
echo ""

# Track failures
FAILURES=0

# Check 1: Rust formatting
echo "1️⃣  Checking Rust formatting (rustfmt)..."
if cargo fmt -- --check > /dev/null 2>&1; then
  echo "✅ Rust formatting passed"
else
  echo "❌ Rust formatting failed"
  echo "   Files need formatting"
  echo ""
  echo "   Fix with: cargo fmt"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 2: Clippy linting
echo "2️⃣  Checking Clippy linting..."
if cargo clippy --all-targets --all-features -- -D warnings > /dev/null 2>&1; then
  echo "✅ Clippy linting passed"
else
  echo "❌ Clippy linting failed"
  echo "   Run: cargo clippy --all-targets --all-features"
  echo "   Fix all linting errors and warnings before committing"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 3: Cargo check
echo "3️⃣  Checking Cargo check..."
if cargo check --all-targets --all-features > /dev/null 2>&1; then
  echo "✅ Cargo check passed"
else
  echo "❌ Cargo check failed"
  echo "   Run: cargo check --all-targets --all-features"
  echo "   Fix all compilation errors before committing"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 4: Cargo build
echo "4️⃣  Checking Cargo build..."
if cargo build --all-targets --all-features > /dev/null 2>&1; then
  echo "✅ Cargo build passed"
else
  echo "❌ Cargo build failed"
  echo "   Run: cargo build --all-targets --all-features"
  echo "   Fix all build errors before committing"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 5: Cargo tests
echo "5️⃣  Checking Cargo tests..."
if cargo test --all-features > /dev/null 2>&1; then
  echo "✅ Cargo tests passed"
else
  echo "❌ Cargo tests failed"
  echo "   Run: cargo test --all-features -- --nocapture"
  echo "   Fix all failing tests before committing"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 6: Cargo.lock is up to date
echo "6️⃣  Checking Cargo.lock is up to date..."
cargo update --dry-run > /dev/null 2>&1
if git diff --exit-code Cargo.lock > /dev/null 2>&1; then
  echo "✅ Cargo.lock is up to date"
else
  echo "❌ Cargo.lock needs updating"
  echo "   Run: cargo update"
  echo "   Commit the changes to Cargo.lock"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Check 7: Unused dependencies (if cargo-udeps available)
echo "7️⃣  Checking for unused dependencies..."
if command -v cargo-udeps &> /dev/null; then
  if cargo +nightly udeps --all-targets > /dev/null 2>&1; then
    echo "✅ No unused dependencies"
  else
    echo "⚠️  Warning: Unused dependencies found"
    echo "   Run: cargo +nightly udeps --all-targets"
    echo "   Consider removing unused dependencies"
    # This is a warning, not a failure
  fi
else
  echo "ℹ️  cargo-udeps not installed (optional)"
  echo "   Install: cargo install cargo-udeps --locked"
fi
echo ""

# Check 8: Security vulnerabilities (cargo-audit)
echo "8️⃣  Checking for security vulnerabilities..."
if command -v cargo-audit &> /dev/null; then
  if cargo audit > /dev/null 2>&1; then
    echo "✅ No known vulnerabilities"
  else
    echo "⚠️  Warning: Security vulnerabilities found"
    echo "   Run: cargo audit"
    echo "   Review and address vulnerabilities"
    # This is a warning, not a failure
  fi
else
  echo "ℹ️  cargo-audit not installed (recommended)"
  echo "   Install: cargo install cargo-audit --locked"
fi
echo ""

# Check 9: Documentation
echo "9️⃣  Checking documentation..."
if cargo doc --no-deps --all-features > /dev/null 2>&1; then
  echo "✅ Documentation builds successfully"
else
  echo "⚠️  Warning: Documentation has issues"
  echo "   Run: cargo doc --no-deps --all-features"
  echo "   Fix documentation errors"
  # This is a warning, not a failure
fi
echo ""

# Check 10: Unsafe code (if cargo-geiger available)
echo "🔟 Checking for unsafe code..."
if command -v cargo-geiger &> /dev/null; then
  UNSAFE_COUNT=$(cargo geiger --output-format Json 2>/dev/null | grep -o '"used":[0-9]*' | head -1 | grep -o '[0-9]*' || echo "0")
  if [ "$UNSAFE_COUNT" -eq 0 ]; then
    echo "✅ No unsafe code found"
  else
    echo "ℹ️  Info: Found $UNSAFE_COUNT unsafe block(s)"
    echo "   Run: cargo geiger"
    echo "   Review unsafe code usage"
  fi
else
  echo "ℹ️  cargo-geiger not installed (optional)"
  echo "   Install: cargo install cargo-geiger --locked"
fi
echo ""

# Check 11: Test coverage (if cargo-tarpaulin available)
if [ "${CHECK_COVERAGE:-false}" = "true" ]; then
  echo "1️⃣1️⃣  Checking test coverage..."
  if command -v cargo-tarpaulin &> /dev/null; then
    COVERAGE=$(cargo tarpaulin --out Stdout 2>/dev/null | grep "^[0-9]" | awk '{print $1}' | sed 's/%//' || echo "0")
    if [ -n "$COVERAGE" ] && [ "$(echo "$COVERAGE >= 80" | bc -l 2>/dev/null || echo 0)" -eq 1 ]; then
      echo "✅ Test coverage: ${COVERAGE}%"
    else
      echo "⚠️  Warning: Test coverage below 80%: ${COVERAGE}%"
      echo "   Run: cargo tarpaulin --out Html"
      echo "   Consider adding more tests"
      # This is a warning, not a failure
    fi
  else
    echo "ℹ️  cargo-tarpaulin not installed (optional)"
    echo "   Install: cargo install cargo-tarpaulin --locked"
  fi
  echo ""
fi

# Check 12: println! in production code
echo "1️⃣2️⃣  Checking for println! in production code..."
if grep -r "println!" src/ --include="*.rs" 2>/dev/null | grep -v "// allow-println" | grep -v "#\[cfg(test)\]" > /dev/null; then
  echo "⚠️  Warning: Found println! in production code"
  echo "   Files with println!:"
  grep -r "println!" src/ --include="*.rs" 2>/dev/null | grep -v "// allow-println" | grep -v "#\[cfg(test)\]" | head -5 | sed 's/^/   - /'
  echo ""
  echo "   Consider using log macros (info!, debug!, etc.) instead"
  # This is a warning, not a failure
else
  echo "✅ No println! in production code"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $FAILURES -eq 0 ]; then
  echo "✅ All Rust pre-commit checks passed!"
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
  echo "   - Formatting: cargo fmt"
  echo "   - Linting: cargo clippy --all-targets --all-features --fix"
  echo "   - Compilation: cargo check --all-targets --all-features"
  echo "   - Build errors: cargo build --all-targets --all-features"
  echo "   - Test failures: cargo test --all-features -- --nocapture"
  echo "   - Lock file: cargo update"
  exit 1
fi

