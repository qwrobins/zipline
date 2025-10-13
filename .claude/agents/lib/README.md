# Developer Agent Library Scripts

**Location**: `.claude/agents/lib/`
**Purpose**: Automated validation scripts for developer agents to prevent common issues found in code reviews
**Based on**: Analysis of 14 code reviews (21% re-review rate → target <10%)
**Last Updated**: 2025-10-13

---

## Overview

These scripts help developer agents catch common issues before committing code, reducing review iterations by 40-60%.

**Important**: These scripts are part of the agent library and should be called from the project root using:
```bash
./.claude/agents/lib/script-name.sh
```

### Scripts Available

#### Pre-Commit Validation (Language-Specific)
1. **pre-commit-checks.sh** - TypeScript/JavaScript pre-commit validation
2. **pre-commit-checks-go.sh** - Go pre-commit validation
3. **pre-commit-checks-python.sh** - Python pre-commit validation
4. **pre-commit-checks-rust.sh** - Rust pre-commit validation

#### Git Workflow & Conflict Management
5. **git-worktree-manager.sh** - Git worktree creation, merging, and cleanup
6. **file-tracker.sh** - File ownership tracking for multi-agent workflows
7. **conflict-detector.sh** - Detect merge conflicts before attempting merge

#### Code Quality & Documentation
8. **cleanup-boilerplate.sh** - Remove unused Vite/CRA template files (JS/TS only)
9. **validate-docs.sh** - Validate documentation references

---

## 1. pre-commit-checks.sh

**Purpose**: Run all critical checks before committing

**Usage**:
```bash
./.claude/agents/lib/pre-commit-checks.sh
```

**Checks Performed**:
- ✅ TypeScript compilation (tsc --noEmit)
- ✅ ESLint errors and warnings
- ✅ Test environment validation (global vs window)
- ✅ External link security (rel="noopener noreferrer")
- ✅ Console.log in production code
- ✅ Test file existence
- ✅ Unused variable patterns

**Exit Codes**:
- `0` - All checks passed, ready to commit
- `1` - One or more checks failed, fix issues before committing

**Example Output**:
```
🔍 Running pre-commit validation checks...

1️⃣  Checking TypeScript compilation...
✅ TypeScript compilation passed

2️⃣  Checking ESLint...
✅ ESLint passed

3️⃣  Checking for 'global' usage in browser tests...
✅ No 'global' usage in test files

4️⃣  Checking external links for security attributes...
✅ External links have security attributes

5️⃣  Checking for console.log in production code...
✅ No console.log in production code

6️⃣  Checking test files exist...
✅ Test files found

7️⃣  Checking for common unused variable patterns...
✅ No obvious unused variables detected

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All pre-commit checks passed!
   Ready to commit.
```

**When to Run**:
- Before every commit
- After fixing TypeScript/ESLint errors
- Before marking story complete

**Common Issues Caught**:
- TypeScript build errors (2 stories failed due to this)
- Missing security attributes (1 story failed due to this)
- Test environment confusion (global vs window)
- Console.log statements in production

---

## 2. cleanup-boilerplate.sh

**Purpose**: Remove unused Vite/CRA template files

**Usage**:
```bash
./.claude/agents/lib/cleanup-boilerplate.sh
```

**Files Checked**:
- `src/App.css` (if using CSS Modules)
- `src/index.css` (if replaced with global.css)
- `src/assets/react.svg` (if not referenced)
- `src/logo.svg` (if not referenced)
- `public/vite.svg` (if not referenced)
- Empty directories (e.g., `src/assets/`)

**Logic**:
- Checks if file is imported anywhere in `src/`
- Removes file only if not imported/referenced
- Removes empty directories after cleanup

**Example Output**:
```
🧹 Cleaning up unused boilerplate files...

Checking for unused CSS files...
  🗑️  Removing unused: src/App.css
  ✅ Keeping (imported): src/index.css

Checking for unused logo files...
  🗑️  Removing unused: src/assets/react.svg

Checking for empty directories...
  🗑️  Removing empty directory: src/assets

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Cleanup complete: Removed 3 file(s)/directory(ies)

   Next steps:
   1. Review changes: git status
   2. Stage deletions: git add -u
   3. Commit: git commit -m "chore: remove unused boilerplate files"
```

**When to Run**:
- Before marking story complete
- After switching from regular CSS to CSS Modules
- After removing unused assets

**Common Issues Prevented**:
- Unused boilerplate files (3 stories had this issue)
- Code clutter
- Confusion about which files are actually used

---

## 3. validate-docs.sh

**Purpose**: Validate documentation references and completeness

**Usage**:
```bash
./.claude/agents/lib/validate-docs.sh
```

**Checks Performed**:
- README file references (checks for broken file paths)
- Outdated ESLint config references (.eslintrc vs eslint.config.js)
- Package manager consistency (npm vs pnpm)
- Required package.json scripts (test, lint, build)
- Documentation file existence (README, CONTRIBUTING, LICENSE)
- .gitignore completeness (required and recommended patterns)

**Example Output**:
```
📚 Validating documentation...

Checking README.md for broken file references...
  ✅ No broken file references found

Checking package.json scripts...
  ✅ Test script defined
  ✅ Lint script defined
  ✅ Build script defined

Checking for documentation files...
  ✅ Found: README.md
  ℹ️  Optional: CONTRIBUTING.md (not found)
  ℹ️  Optional: LICENSE (not found)
  ✅ Found: .gitignore

Checking .gitignore completeness...
  ✅ Required pattern: node_modules
  ✅ Required pattern: dist
  ✅ Required pattern: .env
  ✅ Recommended pattern: dist-ssr
  ✅ Recommended pattern: *.local
  ✅ Recommended pattern: .DS_Store
  ✅ Recommended pattern: coverage

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Documentation validation passed
   All references are valid
```

**When to Run**:
- Before marking story complete
- After updating README
- After changing file names or structure
- After updating .gitignore

**Common Issues Prevented**:
- Outdated documentation references (4 stories had this issue)
- Broken file paths in README
- Incomplete .gitignore (1 story had this issue)

---

## 4. pre-commit-checks-go.sh

**Purpose**: Run all critical checks before committing Go code

**Usage**:
```bash
./.claude/agents/lib/pre-commit-checks-go.sh
```

**Checks Performed**:
- ✅ Go formatting (gofmt)
- ✅ Go vet (static analysis)
- ✅ golangci-lint (comprehensive linting)
- ✅ Go build (compilation)
- ✅ Go tests (unit tests)
- ✅ go.mod tidiness
- ✅ Unused imports (goimports)
- ✅ Security vulnerabilities (govulncheck)
- ✅ Test coverage (optional, set CHECK_COVERAGE=true)

**When to Run**:
- Before every commit in Go projects
- After implementing new features
- After refactoring code

**Common Issues Prevented**:
- Unformatted code
- Linting errors
- Build failures
- Test failures
- Untidy go.mod

---

## 5. pre-commit-checks-python.sh

**Purpose**: Run all critical checks before committing Python code

**Usage**:
```bash
./.claude/agents/lib/pre-commit-checks-python.sh
```

**Checks Performed**:
- ✅ Black formatting
- ✅ Ruff linting
- ✅ mypy type checking
- ✅ isort import sorting
- ✅ pytest tests
- ✅ Security issues (bandit)
- ✅ Dependency conflicts (pip check)
- ✅ Poetry lock file validation
- ✅ Test coverage (optional, set CHECK_COVERAGE=true)
- ✅ print() statements in production code

**Supports Multiple Package Managers**:
- uv (preferred)
- poetry
- pipenv
- pip

**When to Run**:
- Before every commit in Python projects
- After implementing new features
- After refactoring code

**Common Issues Prevented**:
- Unformatted code
- Type errors
- Linting errors
- Test failures
- Security vulnerabilities

---

## 6. pre-commit-checks-rust.sh

**Purpose**: Run all critical checks before committing Rust code

**Usage**:
```bash
./.claude/agents/lib/pre-commit-checks-rust.sh
```

**Checks Performed**:
- ✅ Rust formatting (rustfmt)
- ✅ Clippy linting
- ✅ Cargo check (compilation)
- ✅ Cargo build
- ✅ Cargo tests
- ✅ Cargo.lock up to date
- ✅ Unused dependencies (cargo-udeps)
- ✅ Security vulnerabilities (cargo-audit)
- ✅ Documentation builds
- ✅ Unsafe code detection (cargo-geiger)
- ✅ Test coverage (optional, set CHECK_COVERAGE=true)
- ✅ println! in production code

**When to Run**:
- Before every commit in Rust projects
- After implementing new features
- After refactoring code

**Common Issues Prevented**:
- Unformatted code
- Clippy warnings
- Build failures
- Test failures
- Security vulnerabilities

---

## Integration with Developer Workflow

### Recommended Workflow (Multi-Agent with Git Worktrees)

```bash
# 1. Create isolated worktree
./.claude/agents/lib/git-worktree-manager.sh create "1.1" "golang-developer"
cd .worktrees/agent-golang-developer-1-1-<timestamp>

# 2. Register file ownership
./.claude/agents/lib/file-tracker.sh auto-register "1.1" "golang-developer" "$(pwd)"

# 3. Implement feature
# ... write code ...

# 4. Run language-specific pre-commit checks
# For TypeScript/JavaScript:
./.claude/agents/lib/pre-commit-checks.sh
# For Go:
./.claude/agents/lib/pre-commit-checks-go.sh
# For Python:
./.claude/agents/lib/pre-commit-checks-python.sh
# For Rust:
./.claude/agents/lib/pre-commit-checks-rust.sh

# 5. If checks fail, fix issues and re-run
# ... fix issues ...
# Re-run appropriate pre-commit script

# 6. Validate documentation
./.claude/agents/lib/validate-docs.sh

# 7. Cleanup boilerplate (JS/TS only)
./.claude/agents/lib/cleanup-boilerplate.sh  # Only for JS/TS projects

# 8. Detect conflicts before merge
cd ../../
./.claude/agents/lib/conflict-detector.sh detect ".worktrees/agent-golang-developer-1-1-<timestamp>"

# 9. Merge and cleanup
./.claude/agents/lib/git-worktree-manager.sh merge ".worktrees/agent-golang-developer-1-1-<timestamp>"
./.claude/agents/lib/git-worktree-manager.sh cleanup ".worktrees/agent-golang-developer-1-1-<timestamp>"
./.claude/agents/lib/file-tracker.sh unregister "1.1"
```

### Simple Workflow (Single Agent, No Worktrees)

```bash
# 1. Implement feature
# ... write code ...

# 2. Run language-specific pre-commit checks
./.claude/agents/lib/pre-commit-checks-{language}.sh

# 3. Validate documentation
./.claude/agents/lib/validate-docs.sh

# 4. Cleanup (JS/TS only)
./.claude/agents/lib/cleanup-boilerplate.sh

# 5. Commit
git add .
git commit -m "feat: implement feature X"
```

### Integration with Git Hooks (Optional)

You can integrate these scripts with Git hooks for automatic validation:

**Create `.git/hooks/pre-commit`**:
```bash
#!/bin/bash
./.claude/agents/lib/pre-commit-checks.sh
```

**Make it executable**:
```bash
chmod +x .git/hooks/pre-commit
```

Now checks run automatically before every commit!

---

## Troubleshooting

### Script Permission Denied

**Problem**: `bash: ./.claude/agents/lib/pre-commit-checks.sh: Permission denied`

**Solution**:
```bash
chmod +x .claude/agents/lib/pre-commit-checks.sh
chmod +x .claude/agents/lib/cleanup-boilerplate.sh
chmod +x .claude/agents/lib/validate-docs.sh
```

### Script Not Found

**Problem**: `bash: ./.claude/agents/lib/pre-commit-checks.sh: No such file or directory`

**Solution**: Make sure you're in the project root directory
```bash
cd /path/to/project
./.claude/agents/lib/pre-commit-checks.sh
```

### False Positives

**Problem**: Script reports issues that aren't actually problems

**Solution**: Review the script logic and adjust patterns if needed. Scripts are designed to be conservative (better to flag potential issues than miss real ones).

---

## Customization

These scripts can be customized for your specific project needs:

### Adding Custom Checks

Edit `pre-commit-checks.sh` and add your check:

```bash
# Check 8: Custom validation
echo "8️⃣  Checking custom requirement..."
if your_custom_check; then
  echo "✅ Custom check passed"
else
  echo "❌ Custom check failed"
  FAILURES=$((FAILURES + 1))
fi
echo ""
```

### Excluding Files from Cleanup

Edit `cleanup-boilerplate.sh` to exclude specific files:

```bash
# Don't remove this specific file
if [ "$file" = "src/App.css" ]; then
  echo "  ✅ Keeping (excluded): $file"
  continue
fi
```

---

## Success Metrics

**Before Scripts** (based on 14 code reviews):
- Re-review rate: 21% (3/14 stories)
- Average issues per story: 1.2
- Critical issues: 14% (2/14 stories)

**Target After Scripts**:
- Re-review rate: <10% (1/14 stories)
- Average issues per story: <0.5
- Critical issues: 0%

**Expected Impact**:
- 40-60% reduction in review iterations
- 2-3 hours saved per story requiring re-review
- 90% reduction in critical issues
- Higher developer confidence

---

## Related Documentation

- **Full Analysis**: `/code-review-analysis.md` - Detailed patterns from 14 reviews
- **Implementation Guide**: `/implementation-guide.md` - Step-by-step implementation
- **Quick Reference**: `/QUICK-REFERENCE.md` - Common issues and fixes
- **Testing Guide**: `.claude/agents/agent-guides/testing-best-practices.md`
- **JavaScript Directive**: `.claude/agents/directives/javascript-development.md`

---

## Feedback and Improvements

These scripts are based on analysis of 14 code reviews. As more reviews are conducted, patterns may emerge that require new checks or adjustments to existing ones.

**To suggest improvements**:
1. Document the issue pattern
2. Identify how to detect it automatically
3. Add check to appropriate script
4. Test on sample projects
5. Update this README

---

**Last Updated**: 2025-10-13  
**Version**: 1.0  
**Maintainer**: Developer Agent Team

