# Step 5.5: Static Analysis Implementation Guide

**Priority**: CRITICAL
**Impact**: 40-60% reduction in code review iterations
**Effort**: 2-3 hours for all agents

## Overview

This document provides the exact content to add to each developer agent to implement **Step 5.5: Run Static Analysis Tools (MANDATORY)**.

This step should be inserted **AFTER** Step 5 (Test Implementation) and **BEFORE** Step 5.6 (Commit Changes).

---

## Python-Developer

Insert after line 136 (after "Step 5: Test Your Implementation"):

```markdown
### Step 5.5: Run Static Analysis Tools (MANDATORY)

**🚨 CRITICAL: Run ALL static analysis tools before committing 🚨**

**You MUST run these tools and fix ALL issues before proceeding to Step 5.6:**

1. **Run type checker:**
   ```bash
   mypy .
   ```
   - Fix ALL type errors
   - No `Any` types without explicit justification
   - Verify all type hints are correct
   - All functions must have parameter and return type hints

2. **Run linter:**
   ```bash
   ruff check .
   # or if ruff not available:
   pylint src/
   ```
   - Fix ALL linter violations
   - No warnings allowed
   - Follow PEP 8 standards
   - Maximum line length: 88 characters (black default)

3. **Run security scanner:**
   ```bash
   bandit -r src/
   ```
   - Fix ALL security issues (High and Medium severity)
   - No hardcoded secrets or credentials
   - No SQL injection vulnerabilities
   - No command injection vulnerabilities
   - No unsafe YAML loading

4. **Run formatter check:**
   ```bash
   black --check .
   ```
   - If formatting needed, run: `black .`
   - Verify all files are formatted consistently

**Type Hint Requirements:**
- [ ] ALL functions have type hints (parameters and return)
- [ ] ALL class attributes have type annotations
- [ ] No `Any` types without explicit justification in comments
- [ ] mypy passes with zero errors

**Security Requirements:**
- [ ] No hardcoded passwords, API keys, or secrets
- [ ] All SQL queries use parameterized queries
- [ ] All user inputs are validated
- [ ] No use of `eval()`, `exec()`, or `__import__()`
- [ ] YAML loaded with `yaml.safe_load()` only

**⚠️ CRITICAL: If ANY tool reports errors, FIX them before proceeding to Step 5.6**
**⚠️ CRITICAL: Do NOT commit code with linter errors, type errors, or security issues**

**Why This Matters:**
- Code-reviewer runs these exact tools
- If you don't run them first, review WILL fail
- Fixing issues now saves review iterations
- Security issues are review blockers
```

---

## TypeScript-Developer, Next.js-Developer, NestJS-Developer, React-Developer

Insert after Step 5 (Test Implementation):

```markdown
### Step 5.5: Run Static Analysis Tools (MANDATORY)

**🚨 CRITICAL: Run ALL static analysis tools before committing 🚨**

**You MUST run these tools and fix ALL issues before proceeding to Step 5.6:**

1. **Run TypeScript compiler:**
   ```bash
   tsc --noEmit
   ```
   - Fix ALL type errors
   - No `any` types without explicit justification
   - All function parameters must be typed
   - All return types must be explicit

2. **Run ESLint:**
   ```bash
   npm run lint
   # or
   pnpm lint
   # or
   yarn lint
   ```
   - Fix ALL linting errors
   - No warnings allowed
   - Follow project ESLint configuration

3. **Run Prettier check:**
   ```bash
   npm run format:check
   # or
   pnpm format:check
   ```
   - If formatting needed, run: `npm run format`
   - Verify all files are formatted consistently

4. **Run security audit:**
   ```bash
   npm audit
   # or
   pnpm audit
   ```
   - Fix ALL critical and high severity vulnerabilities
   - Document any vulnerabilities that cannot be fixed
   - Update dependencies to secure versions

**TypeScript Strict Mode Verification:**
- [ ] tsconfig.json has `"strict": true`
- [ ] No `any` types (use `unknown` with type guards instead)
- [ ] All function parameters have explicit types
- [ ] All return types are explicit
- [ ] tsc --noEmit passes with zero errors

**Security Requirements:**
- [ ] No `dangerouslySetInnerHTML` without sanitization
- [ ] All user inputs validated (use Zod or similar)
- [ ] No `eval()` or `Function()` constructor
- [ ] CSRF protection on state-changing operations
- [ ] No hardcoded secrets or API keys

**⚠️ CRITICAL: If ANY tool reports errors, FIX them before proceeding to Step 5.6**
**⚠️ CRITICAL: Do NOT commit code with type errors, linter errors, or security vulnerabilities**

**Why This Matters:**
- Code-reviewer runs these exact tools
- If you don't run them first, review WILL fail
- Fixing issues now saves review iterations
- Security issues are review blockers
```

---

## Rust-Developer

Insert after Step 5 (Test Implementation):

```markdown
### Step 5.5: Run Static Analysis Tools (MANDATORY)

**🚨 CRITICAL: Run ALL static analysis tools before committing 🚨**

**You MUST run these tools and fix ALL issues before proceeding to Step 5.6:**

1. **Run Clippy with pedantic lints:**
   ```bash
   cargo clippy --all-targets --all-features -- -D warnings -W clippy::pedantic
   ```
   - Fix ALL clippy warnings (including pedantic)
   - Justify any `#[allow(clippy::...)]` attributes with comments
   - No warnings allowed in final code

2. **Run security audit:**
   ```bash
   cargo audit
   ```
   - Fix ALL vulnerabilities
   - Update dependencies to secure versions
   - Document any vulnerabilities that cannot be fixed

3. **Run formatter check:**
   ```bash
   cargo fmt --check
   ```
   - If formatting needed, run: `cargo fmt`
   - Verify all files are formatted consistently

4. **Check for unsafe code:**
   ```bash
   rg "unsafe" --type rust
   ```
   - Review each `unsafe` block
   - Justify why each unsafe block is necessary
   - Document safety invariants in comments
   - Minimize unsafe code surface area

**Rust Quality Requirements:**
- [ ] Clippy passes with pedantic lints (zero warnings)
- [ ] All `unsafe` blocks have justification comments
- [ ] No unwrap() or expect() in production code (use proper error handling)
- [ ] All errors use Result types with proper error types
- [ ] rustfmt applied to all files

**Security Requirements:**
- [ ] All `unsafe` blocks reviewed for memory safety
- [ ] No integer overflow in release mode
- [ ] No data races in unsafe code
- [ ] All FFI boundaries are safe
- [ ] cargo audit passes with zero vulnerabilities

**⚠️ CRITICAL: If ANY tool reports errors, FIX them before proceeding to Step 5.6**
**⚠️ CRITICAL: Do NOT commit code with clippy warnings or security vulnerabilities**

**Why This Matters:**
- Code-reviewer runs these exact tools
- If you don't run them first, review WILL fail
- Unsafe code requires extra scrutiny
- Security issues are review blockers
```

---

## Golang-Developer

Insert after Step 5 (Test Implementation):

```markdown
### Step 5.5: Run Static Analysis Tools (MANDATORY)

**🚨 CRITICAL: Run ALL static analysis tools before committing 🚨**

**You MUST run these tools and fix ALL issues before proceeding to Step 5.6:**

1. **Run go vet:**
   ```bash
   go vet ./...
   ```
   - Fix ALL issues reported
   - No suspicious constructs allowed

2. **Run staticcheck:**
   ```bash
   staticcheck ./...
   ```
   - Fix ALL issues reported
   - No warnings allowed

3. **Run security scanner:**
   ```bash
   gosec ./...
   ```
   - Fix ALL security issues (High and Medium severity)
   - No SQL injection vulnerabilities
   - No command injection vulnerabilities
   - No hardcoded credentials

4. **Run formatter check:**
   ```bash
   gofmt -l .
   ```
   - If any files listed, run: `gofmt -w .`
   - Verify all files are formatted

5. **Check error handling:**
   ```bash
   errcheck ./...
   ```
   - Fix ALL unchecked errors
   - Every error must be handled

**Go Quality Requirements:**
- [ ] go vet passes with zero issues
- [ ] staticcheck passes with zero issues
- [ ] ALL errors are checked and handled
- [ ] No panic() in production code
- [ ] gofmt applied to all files

**Error Handling Requirements:**
- [ ] ALL errors are handled (no ignored errors)
- [ ] Error messages provide context
- [ ] Errors are wrapped with fmt.Errorf or errors.Wrap
- [ ] No panic() in production code
- [ ] Defer statements used correctly

**Security Requirements:**
- [ ] No SQL injection (use parameterized queries)
- [ ] No command injection
- [ ] No hardcoded credentials
- [ ] All user inputs validated
- [ ] gosec passes with zero high/medium issues

**⚠️ CRITICAL: If ANY tool reports errors, FIX them before proceeding to Step 5.6**
**⚠️ CRITICAL: Do NOT commit code with unhandled errors or security issues**

**Why This Matters:**
- Code-reviewer runs these exact tools
- If you don't run them first, review WILL fail
- Unhandled errors cause production bugs
- Security issues are review blockers
```

---

## Implementation Checklist

For each developer agent:

1. **Locate Step 5** (Test Your Implementation)
2. **Insert Step 5.5** immediately after Step 5
3. **Update Step 5** to say "before proceeding to Step 5.5" instead of "before proceeding to Step 6"
4. **Update Step 5.6** (Commit Changes) to reference Step 5.5 in prerequisites
5. **Update Step 6** (Update Story Status) prerequisites to include "All static analysis passing"
6. **Test** by having agent implement a simple story and verify tools are run

---

## Verification

After implementing, verify each agent:

1. **Check prerequisites in Step 5.6 (Commit)**:
   ```markdown
   **Prerequisites:**
   - [ ] All tests passing
   - [ ] All static analysis tools passing (Step 5.5)
   - [ ] All changes committed to git
   ```

2. **Check prerequisites in Step 6 (Update Story Status)**:
   ```markdown
   **Prerequisites:**
   - [ ] All tests passing
   - [ ] All static analysis passing
   - [ ] All changes committed to git
   - [ ] Working directory clean
   ```

3. **Check Critical Reminders section**:
   ```markdown
   **ALWAYS:**
   - ✅ Run ALL static analysis tools before committing (Step 5.5)
   ```

---

## Expected Outcome

After implementation:
- ✅ Agents run linters before committing
- ✅ Agents run type checkers before committing
- ✅ Agents run security scanners before committing
- ✅ Agents run formatters before committing
- ✅ Code-reviewer finds 40-60% fewer issues
- ✅ Review iterations reduced significantly
- ✅ First-pass quality dramatically improved

