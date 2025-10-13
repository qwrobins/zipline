#!/bin/bash
# Validate documentation references
# Based on code review analysis: 4 stories had outdated documentation

echo "📚 Validating documentation..."
echo ""

ERRORS=0

# Check if README exists
if [ ! -f "README.md" ]; then
  echo "⚠️  Warning: No README.md found"
  echo ""
else
  echo "Checking README.md for broken file references..."
  
  # Extract file paths from backticks (e.g., `src/App.tsx`)
  grep -o '\`[^`]*\.[a-z]*\`' README.md 2>/dev/null | sed 's/`//g' | while read file; do
    # Skip URLs and special patterns
    if [[ "$file" =~ ^http ]] || [[ "$file" =~ ^npm ]] || [[ "$file" =~ ^\. ]]; then
      continue
    fi
    
    if [ ! -f "$file" ] && [ ! -d "$file" ]; then
      echo "  ❌ README references non-existent file: $file"
      ERRORS=$((ERRORS + 1))
    fi
  done
  
  # Check for outdated ESLint config references
  if grep -q "\.eslintrc" README.md 2>/dev/null; then
    if [ ! -f ".eslintrc.cjs" ] && [ ! -f ".eslintrc.js" ] && [ ! -f ".eslintrc.json" ]; then
      if [ -f "eslint.config.js" ]; then
        echo "  ⚠️  README mentions .eslintrc but project uses eslint.config.js"
        echo "     Update README to reference eslint.config.js"
      fi
    fi
  fi
  
  # Check for outdated package manager references
  if [ -f "pnpm-lock.yaml" ]; then
    if grep -q "npm install\|npm run" README.md 2>/dev/null; then
      echo "  ℹ️  Info: Project uses pnpm but README shows npm commands"
      echo "     Consider updating README to use pnpm commands"
    fi
  fi
  
  if [ $ERRORS -eq 0 ]; then
    echo "  ✅ No broken file references found"
  fi
  echo ""
fi

# Check package.json for outdated script references
if [ -f "package.json" ]; then
  echo "Checking package.json scripts..."
  
  # Check if test script exists
  if ! grep -q '"test"' package.json 2>/dev/null; then
    echo "  ⚠️  Warning: No 'test' script defined in package.json"
  else
    echo "  ✅ Test script defined"
  fi
  
  # Check if lint script exists
  if ! grep -q '"lint"' package.json 2>/dev/null; then
    echo "  ⚠️  Warning: No 'lint' script defined in package.json"
  else
    echo "  ✅ Lint script defined"
  fi
  
  # Check if build script exists
  if ! grep -q '"build"' package.json 2>/dev/null; then
    echo "  ⚠️  Warning: No 'build' script defined in package.json"
  else
    echo "  ✅ Build script defined"
  fi
  echo ""
fi

# Check for common documentation files
echo "Checking for documentation files..."
DOC_FILES=("README.md" "CONTRIBUTING.md" "LICENSE" ".gitignore")
for doc in "${DOC_FILES[@]}"; do
  if [ -f "$doc" ]; then
    echo "  ✅ Found: $doc"
  else
    if [ "$doc" = "README.md" ]; then
      echo "  ❌ Missing: $doc (required)"
      ERRORS=$((ERRORS + 1))
    else
      echo "  ℹ️  Optional: $doc (not found)"
    fi
  fi
done
echo ""

# Check .gitignore completeness
if [ -f ".gitignore" ]; then
  echo "Checking .gitignore completeness..."
  
  REQUIRED_PATTERNS=("node_modules" "dist" ".env")
  RECOMMENDED_PATTERNS=("dist-ssr" "*.local" ".DS_Store" "coverage")
  
  for pattern in "${REQUIRED_PATTERNS[@]}"; do
    if grep -q "$pattern" .gitignore 2>/dev/null; then
      echo "  ✅ Required pattern: $pattern"
    else
      echo "  ❌ Missing required pattern: $pattern"
      ERRORS=$((ERRORS + 1))
    fi
  done
  
  for pattern in "${RECOMMENDED_PATTERNS[@]}"; do
    if grep -q "$pattern" .gitignore 2>/dev/null; then
      echo "  ✅ Recommended pattern: $pattern"
    else
      echo "  ⚠️  Missing recommended pattern: $pattern"
    fi
  done
  echo ""
fi

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ]; then
  echo "✅ Documentation validation passed"
  echo "   All references are valid"
else
  echo "❌ Documentation validation failed with $ERRORS error(s)"
  echo "   Fix the issues above before finalizing"
  exit 1
fi
echo ""

