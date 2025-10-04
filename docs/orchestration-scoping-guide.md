# Story Orchestration Scoping Guide

This guide explains how to scope the `/implement-stories` command to work on specific stories, ranges, or epics instead of all stories.

## 🎯 Why Use Scoping?

**Benefits**:
- ✅ Focus on a specific epic or feature
- ✅ Test orchestration with a small set of stories
- ✅ Work on high-priority stories first
- ✅ Implement stories incrementally
- ✅ Avoid overwhelming the system with too many stories

**Use Cases**:
- Working on "Authentication Epic" (stories 1.1-1.5)
- Implementing just the MVP stories
- Testing the orchestration system
- Focusing on a specific sprint's stories
- Implementing stories in phases

---

## 📖 Scoping Syntax

### 1. All Stories (Default)

```bash
/implement-stories
```

**What it does**: Implements ALL stories in `docs/stories/`

**When to use**:
- Small projects with few stories
- Want to implement everything
- First time running orchestration

---

### 2. Range Syntax

```bash
/implement-stories 1.1-1.5
```

**What it does**: Implements stories 1.1, 1.2, 1.3, 1.4, 1.5 (inclusive)

**When to use**:
- Stories are numbered sequentially
- Want to implement a contiguous set
- Working on a specific phase or sprint

**Examples**:
```bash
/implement-stories 1.1-1.3    # Stories 1.1, 1.2, 1.3
/implement-stories 2.1-2.10   # Stories 2.1 through 2.10
/implement-stories 1.0-1.99   # All stories in the 1.x series
```

---

### 3. Specific Stories

```bash
/implement-stories 1.1 1.3 1.5
```

**What it does**: Implements ONLY the specified stories

**When to use**:
- Cherry-picking specific stories
- Non-sequential story selection
- Implementing high-priority stories only

**Examples**:
```bash
/implement-stories 1.1 2.1 3.1           # First story of each epic
/implement-stories 1.1 1.5 2.3           # Specific stories
/implement-stories mvp-1 mvp-2 mvp-3     # MVP stories
```

---

### 4. Epic Scope

```bash
/implement-stories epic:auth
```

**What it does**: Implements all stories tagged with epic "auth"

**When to use**:
- Stories are organized by epic
- Want to complete an entire feature
- Working on a specific epic/theme

**How it detects epics**:

#### **Method 1: Epic Field**
```markdown
# Story 1.1: User Login

**Epic**: auth
**Status**: Not Started
```

#### **Method 2: YAML Frontmatter**
```markdown
---
epic: auth
---

# Story 1.1: User Login
```

#### **Method 3: Directory Structure**
```
docs/stories/
├── epic-auth/
│   ├── 1.1-login.md
│   ├── 1.2-logout.md
│   └── 1.3-password-reset.md
```

Use: `/implement-stories epic:auth`

#### **Method 4: Filename Prefix**
```
docs/stories/
├── auth-1.1-login.md
├── auth-1.2-logout.md
├── auth-1.3-password-reset.md
```

Use: `/implement-stories epic:auth`

**Examples**:
```bash
/implement-stories epic:auth          # All authentication stories
/implement-stories epic:profile       # All profile stories
/implement-stories epic:admin         # All admin stories
/implement-stories epic:mvp           # All MVP stories
```

---

### 5. Pattern Matching

```bash
/implement-stories 1.*
```

**What it does**: Implements all stories matching the pattern

**When to use**:
- Want all stories with a common prefix
- Flexible filtering
- Complex selection criteria

**Examples**:
```bash
/implement-stories 1.*        # All stories starting with "1."
/implement-stories 2.*        # All stories starting with "2."
/implement-stories mvp-*      # All stories starting with "mvp-"
/implement-stories *-api      # All stories ending with "-api"
```

---

## 🔗 Dependency Handling

### Out-of-Scope Dependencies

When you scope to specific stories, the system checks if dependencies are also in scope.

**Example**:
```bash
/implement-stories 1.2-1.5
```

If Story 1.2 depends on Story 1.1 (which is NOT in scope), you'll get a warning:

```
⚠️  Warning: Out-of-scope dependencies detected

Story 1.2 depends on Story 1.1, which is not in scope.
Story 1.3 depends on Story 1.1, which is not in scope.

Options:
1. Add Story 1.1 to scope (recommended)
   Run: /implement-stories 1.1-1.5

2. Continue anyway (Stories 1.2 and 1.3 will be blocked)

3. Cancel and adjust scope

What would you like to do?
```

**Best Practice**: Always include dependencies in your scope!

---

## 📊 Examples by Use Case

### Use Case 1: Implement an Epic

**Scenario**: You want to implement all authentication stories

**Story Organization**:
```
docs/stories/
├── 1.1-user-login.md          (Epic: auth)
├── 1.2-user-logout.md         (Epic: auth)
├── 1.3-password-reset.md      (Epic: auth)
├── 2.1-view-profile.md        (Epic: profile)
└── 2.2-edit-profile.md        (Epic: profile)
```

**Command**:
```bash
/implement-stories epic:auth
```

**Result**: Implements stories 1.1, 1.2, 1.3

---

### Use Case 2: Implement a Sprint

**Scenario**: Sprint 1 includes stories 1.1, 1.2, 1.3

**Command**:
```bash
/implement-stories 1.1-1.3
```

**Result**: Implements stories 1.1, 1.2, 1.3 in dependency order

---

### Use Case 3: Test Orchestration

**Scenario**: You want to test the orchestration system with a few stories

**Command**:
```bash
/implement-stories 1.1 1.2
```

**Result**: Implements just stories 1.1 and 1.2

---

### Use Case 4: MVP Stories Only

**Scenario**: You tagged MVP stories and want to implement them first

**Story Files**:
```
docs/stories/
├── mvp-1.1-core-feature.md
├── mvp-1.2-basic-ui.md
├── 2.1-advanced-feature.md
└── 2.2-premium-feature.md
```

**Command**:
```bash
/implement-stories mvp-*
```

**Result**: Implements only MVP stories

---

### Use Case 5: Incremental Implementation

**Scenario**: Large project, want to implement in phases

**Phase 1**:
```bash
/implement-stories 1.1-1.5
```

**Phase 2** (after Phase 1 completes):
```bash
/implement-stories 2.1-2.5
```

**Phase 3** (after Phase 2 completes):
```bash
/implement-stories 3.1-3.5
```

---

## 🎓 Best Practices

### ✅ DO:

1. **Include dependencies in scope**
   ```bash
   # Good: Includes dependency 1.1
   /implement-stories 1.1-1.5
   
   # Bad: Missing dependency 1.1
   /implement-stories 1.2-1.5
   ```

2. **Use epics for logical grouping**
   ```bash
   /implement-stories epic:auth
   ```

3. **Test with small scopes first**
   ```bash
   # Test with 2 stories first
   /implement-stories 1.1 1.2
   ```

4. **Use ranges for sequential stories**
   ```bash
   /implement-stories 1.1-1.10
   ```

### ❌ DON'T:

1. **Don't exclude dependencies**
   ```bash
   # Bad: Story 1.3 depends on 1.1 and 1.2
   /implement-stories 1.3
   ```

2. **Don't use overly complex patterns**
   ```bash
   # Too complex, hard to understand
   /implement-stories 1.* 2.* epic:auth mvp-*
   ```

3. **Don't scope too narrowly**
   ```bash
   # Too narrow, will be blocked by dependencies
   /implement-stories 1.5
   ```

---

## 🔍 Checking Scope

After running `/implement-stories` with a scope, check the roadmap:

```bash
# View the generated roadmap
cat .agent-orchestration/roadmap.md
```

The roadmap will show:
- Which stories are in scope
- Which stories are out of scope
- Any dependency warnings
- Implementation order

---

## 🚀 Quick Reference

| Goal | Command |
|------|---------|
| All stories | `/implement-stories` |
| Stories 1.1-1.5 | `/implement-stories 1.1-1.5` |
| Specific stories | `/implement-stories 1.1 1.3 1.5` |
| Authentication epic | `/implement-stories epic:auth` |
| All 1.x stories | `/implement-stories 1.*` |
| MVP stories | `/implement-stories epic:mvp` |
| Sprint 1 stories | `/implement-stories 1.1-1.10` |

---

## 💡 Tips

1. **Start small**: Test with 2-3 stories first
2. **Use epics**: Organize stories by epic for easier scoping
3. **Check dependencies**: Always include dependencies in scope
4. **Review roadmap**: Check `.agent-orchestration/roadmap.md` after scoping
5. **Iterate**: Implement in phases using scoping

---

## 🆘 Troubleshooting

### "Story X is blocked by out-of-scope dependency Y"

**Solution**: Add the dependency to your scope
```bash
# Instead of:
/implement-stories 1.2-1.5

# Use:
/implement-stories 1.1-1.5
```

### "No stories found matching scope"

**Solution**: Check your scope syntax and story files
```bash
# Check what stories exist
ls docs/stories/

# Try a broader scope
/implement-stories 1.*
```

### "Epic 'auth' not found"

**Solution**: Verify epic tags in story files
- Check for `**Epic**: auth` field
- Or YAML frontmatter: `epic: auth`
- Or directory: `docs/stories/epic-auth/`
- Or filename prefix: `auth-1.1-login.md`

---

## 📚 Related Documentation

- **Main Guide**: `docs/orchestration-system.md`
- **Commands README**: `.claude/commands/README.md`
- **Setup Guide**: `docs/orchestration-system-setup.md`

---

**Happy scoping!** 🎯

