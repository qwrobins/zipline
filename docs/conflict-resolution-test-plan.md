# Conflict Resolution System - Test Plan

## Overview

This document outlines the test plan for the conflict prevention and resolution system.

## Test Environment Setup

### Prerequisites

```bash
# Ensure all scripts are executable
chmod +x agents/lib/file-tracker.sh
chmod +x agents/lib/conflict-detector.sh
chmod +x agents/lib/git-worktree-manager.sh

# Verify jq is installed
jq --version

# Verify git version
git --version  # Should be 2.5+
```

### Test Repository Setup

```bash
# Create a test branch
git checkout -b test-conflict-resolution

# Create test files
mkdir -p src/test
echo "// Test file" > src/test/example.ts
git add src/test/example.ts
git commit -m "Add test file"

# Return to main
git checkout main
```

## Test Scenarios

### Test 1: File Ownership Tracking

**Objective:** Verify file tracking works correctly

**Steps:**

1. **Create worktree:**
   ```bash
   WORKTREE_1=$(./agents/lib/git-worktree-manager.sh create "test-1.1" "test-agent-1")
   echo "Worktree 1: $WORKTREE_1"
   ```

2. **Register files:**
   ```bash
   ./agents/lib/file-tracker.sh register "test-1.1" "test-agent-1" "$WORKTREE_1" "src/test/example.ts"
   ```

3. **List ownership:**
   ```bash
   ./agents/lib/file-tracker.sh list
   ```

4. **Create second worktree and check for conflicts:**
   ```bash
   WORKTREE_2=$(./agents/lib/git-worktree-manager.sh create "test-1.2" "test-agent-2")
   ./agents/lib/file-tracker.sh check "test-1.2" "src/test/example.ts"
   ```

5. **Verify conflict detected:**
   - Should show conflict warning
   - Should list story test-1.1 as owner

6. **Cleanup:**
   ```bash
   ./agents/lib/file-tracker.sh unregister "test-1.1"
   ./agents/lib/file-tracker.sh unregister "test-1.2"
   ./agents/lib/git-worktree-manager.sh cleanup "$WORKTREE_1"
   ./agents/lib/git-worktree-manager.sh cleanup "$WORKTREE_2"
   ```

**Expected Results:**
- ✅ Files registered successfully
- ✅ Conflict detected when second story tries to use same file
- ✅ Cleanup successful

### Test 2: No Conflicts (Happy Path)

**Objective:** Verify workflow when no conflicts exist

**Steps:**

1. **Create worktree:**
   ```bash
   WORKTREE=$(./agents/lib/git-worktree-manager.sh create "test-2.1" "test-agent")
   ```

2. **Make changes in worktree:**
   ```bash
   cd "$WORKTREE"
   echo "// New feature" > src/test/feature-a.ts
   git add src/test/feature-a.ts
   git commit -m "Add feature A"
   cd ../../
   ```

3. **Detect conflicts:**
   ```bash
   ./agents/lib/conflict-detector.sh detect "$WORKTREE"
   ```

4. **Verify no conflicts:**
   - Should show: `"conflicts": []`
   - Should show: `"severity": "none"`

5. **Merge and cleanup:**
   ```bash
   ./agents/lib/git-worktree-manager.sh merge "$WORKTREE"
   ./agents/lib/git-worktree-manager.sh cleanup "$WORKTREE"
   ```

**Expected Results:**
- ✅ No conflicts detected
- ✅ Merge successful
- ✅ Cleanup successful

### Test 3: Complementary Changes (Low Severity)

**Objective:** Test detection of complementary changes

**Steps:**

1. **Create worktree:**
   ```bash
   WORKTREE=$(./agents/lib/git-worktree-manager.sh create "test-3.1" "test-agent")
   ```

2. **Make changes in main:**
   ```bash
   echo "// Main branch change" >> src/test/example.ts
   git add src/test/example.ts
   git commit -m "Update from main"
   ```

3. **Make different changes in worktree:**
   ```bash
   cd "$WORKTREE"
   echo "// Worktree change" >> src/test/example.ts
   git add src/test/example.ts
   git commit -m "Update from worktree"
   cd ../../
   ```

4. **Detect conflicts:**
   ```bash
   ./agents/lib/conflict-detector.sh detect "$WORKTREE"
   ```

5. **Verify conflict detected:**
   - Should show file in conflicts array
   - Should assess severity (likely low/medium)

6. **Test merge:**
   ```bash
   ./agents/lib/conflict-detector.sh test-merge "$WORKTREE"
   ```

7. **Cleanup:**
   ```bash
   ./agents/lib/git-worktree-manager.sh cleanup "$WORKTREE"
   git reset --hard HEAD~1  # Undo main branch change
   ```

**Expected Results:**
- ✅ Conflict detected
- ✅ Severity assessed
- ✅ Test merge shows result

### Test 4: Conflict-Resolver Agent (Manual Test)

**Objective:** Test AI-assisted conflict resolution

**Steps:**

1. **Create conflicting scenario:**
   ```bash
   # Create worktree
   WORKTREE=$(./agents/lib/git-worktree-manager.sh create "test-4.1" "test-agent")
   
   # Make change in main
   cat > src/test/conflict.ts << 'EOF'
   function login(username, password) {
     if (!username || !password) throw new Error('Invalid credentials');
     return authenticate(username, password);
   }
   EOF
   git add src/test/conflict.ts
   git commit -m "Add validation"
   
   # Make different change in worktree
   cd "$WORKTREE"
   cat > src/test/conflict.ts << 'EOF'
   function login(username, password) {
     logger.info('Login attempt', { username });
     return authenticate(username, password);
   }
   EOF
   git add src/test/conflict.ts
   git commit -m "Add logging"
   cd ../../
   ```

2. **Detect conflict:**
   ```bash
   ./agents/lib/conflict-detector.sh detect "$WORKTREE"
   ```

3. **Invoke conflict-resolver agent:**
   ```
   @agent-conflict-resolver, please analyze the following conflict:
   
   File: src/test/conflict.ts
   
   Version A (main): Added input validation
   Version B (worktree): Added logging
   
   Please propose a resolution.
   ```

4. **Review agent's proposal:**
   - Should identify both changes
   - Should propose merging both (complementary)
   - Should provide resolved code
   - Should assess confidence (likely high)

5. **Cleanup:**
   ```bash
   ./agents/lib/git-worktree-manager.sh cleanup "$WORKTREE"
   git reset --hard HEAD~1
   ```

**Expected Results:**
- ✅ Agent analyzes both versions
- ✅ Proposes intelligent resolution
- ✅ Provides clear reasoning
- ✅ Assesses confidence level

### Test 5: Auto-Register Files

**Objective:** Test automatic file detection and registration

**Steps:**

1. **Create worktree:**
   ```bash
   WORKTREE=$(./agents/lib/git-worktree-manager.sh create "test-5.1" "test-agent")
   ```

2. **Make changes:**
   ```bash
   cd "$WORKTREE"
   echo "// Feature 1" > src/test/feature1.ts
   echo "// Feature 2" > src/test/feature2.ts
   git add src/test/
   git commit -m "Add features"
   cd ../../
   ```

3. **Auto-register:**
   ```bash
   ./agents/lib/file-tracker.sh auto-register "test-5.1" "test-agent" "$WORKTREE"
   ```

4. **List ownership:**
   ```bash
   ./agents/lib/file-tracker.sh list
   ```

5. **Verify:**
   - Should show both files registered
   - Should show correct story and agent

6. **Cleanup:**
   ```bash
   ./agents/lib/file-tracker.sh unregister "test-5.1"
   ./agents/lib/git-worktree-manager.sh cleanup "$WORKTREE"
   ```

**Expected Results:**
- ✅ Files auto-detected
- ✅ Files registered correctly
- ✅ Ownership tracked

### Test 6: High Severity Conflict

**Objective:** Test handling of complex conflicts

**Steps:**

1. **Create complex conflict:**
   ```bash
   WORKTREE=$(./agents/lib/git-worktree-manager.sh create "test-6.1" "test-agent")
   
   # Large change in main
   cat > src/test/complex.ts << 'EOF'
   // 50+ lines of code
   function complexFunction() {
     // Many lines...
   }
   EOF
   git add src/test/complex.ts
   git commit -m "Add complex function"
   
   # Different large change in worktree
   cd "$WORKTREE"
   cat > src/test/complex.ts << 'EOF'
   // 50+ lines of different code
   function complexFunction() {
     // Different implementation...
   }
   EOF
   git add src/test/complex.ts
   git commit -m "Add different implementation"
   cd ../../
   ```

2. **Detect conflict:**
   ```bash
   ./agents/lib/conflict-detector.sh detect "$WORKTREE"
   ```

3. **Verify high severity:**
   - Should show high or critical severity
   - Should recommend caution

4. **Cleanup:**
   ```bash
   ./agents/lib/git-worktree-manager.sh cleanup "$WORKTREE"
   git reset --hard HEAD~1
   ```

**Expected Results:**
- ✅ High severity detected
- ✅ Appropriate warning given

## Integration Tests

### Integration Test 1: Full Workflow

**Objective:** Test complete workflow from start to finish

**Steps:**

1. Create worktree
2. Auto-register files
3. Make changes
4. Detect conflicts
5. If conflicts, invoke resolver
6. Merge
7. Cleanup
8. Verify all registries cleared

**Expected Results:**
- ✅ Complete workflow executes successfully
- ✅ All cleanup performed
- ✅ No leftover state

### Integration Test 2: Multiple Parallel Stories

**Objective:** Test with 2-3 parallel stories

**Steps:**

1. Create 3 worktrees for different stories
2. Each modifies different files
3. Register all files
4. Verify no conflicts
5. Merge all in sequence
6. Cleanup all

**Expected Results:**
- ✅ No conflicts detected
- ✅ All merges successful
- ✅ Parallel work enabled

## Performance Tests

### Performance Test 1: Detection Speed

**Objective:** Measure conflict detection performance

**Steps:**

1. Create worktree with 100+ file changes
2. Time conflict detection
3. Verify < 5 seconds

**Expected Results:**
- ✅ Detection completes in < 5 seconds

### Performance Test 2: Resolution Proposal Speed

**Objective:** Measure AI resolution proposal time

**Steps:**

1. Create conflict scenario
2. Time conflict-resolver agent response
3. Verify < 30 seconds

**Expected Results:**
- ✅ Proposal generated in < 30 seconds

## Success Criteria

**All tests must pass:**
- ✅ File tracking works correctly
- ✅ Conflict detection accurate
- ✅ Severity assessment reasonable
- ✅ Conflict-resolver provides good proposals
- ✅ Auto-registration works
- ✅ Integration workflow complete
- ✅ Performance acceptable

## Test Execution

### Manual Testing

Run each test scenario manually and document results.

### Automated Testing (Future)

Create automated test suite:
```bash
# Future: ./tests/run-conflict-resolution-tests.sh
```

## Test Results Template

```markdown
## Test Results - [Date]

### Test 1: File Ownership Tracking
- Status: ✅ PASS / ❌ FAIL
- Notes: [Any observations]

### Test 2: No Conflicts
- Status: ✅ PASS / ❌ FAIL
- Notes: [Any observations]

[Continue for all tests...]

## Summary
- Total Tests: X
- Passed: Y
- Failed: Z
- Success Rate: Y/X %

## Issues Found
[List any issues discovered]

## Recommendations
[Any improvements needed]
```

## Next Steps After Testing

1. Document test results
2. Fix any issues found
3. Refine resolution strategies based on results
4. Update documentation with learnings
5. Deploy to production use

