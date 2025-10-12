# Orchestrator Quick Reference

## Parallel Execution Strategy

### Default Behavior
✅ **PARALLEL** - Launch multiple agents simultaneously for independent stories  
❌ **SEQUENTIAL** - Only when stories have explicit dependencies

### Wave-Based Execution

```
Wave 1: Stories with NO dependencies
  → Launch ALL agents simultaneously
  → Wait for ALL to complete

Wave 2: Stories depending only on Wave 1
  → Launch ALL agents simultaneously
  → Wait for ALL to complete

Wave 3: Stories depending on Wave 1 or 2
  → Launch ALL agents simultaneously
  → Wait for ALL to complete
```

### Example

**Stories:**
- 1.1: Project Init (no dependencies)
- 1.2: API Client (depends on 1.1)
- 1.3: UI Setup (depends on 1.1)
- 1.4: Posts Feed (depends on 1.2, 1.3)
- 1.5: Error Logging (no dependencies)

**Execution:**
```
Wave 1 (Parallel): 1.1, 1.5 → 4 hours
Wave 2 (Parallel): 1.2, 1.3 → 4 hours
Wave 3 (Sequential): 1.4 → 4 hours
Total: 12 hours (vs 20 hours sequential = 40% faster)
```

## Correct Path References

### In User Projects

All agent resources are in `.claude/agents/`:

```bash
# Agent definitions
.claude/agents/react-developer.md
.claude/agents/nextjs-developer.md
.claude/agents/python-developer.md
# etc.

# Shared directives
agents/directives/git-worktree-workflow.md
agents/directives/javascript-development.md

# Utility scripts
.claude/agents/lib/git-worktree-manager.sh
.claude/agents/lib/conflict-detector.sh
.claude/agents/lib/file-tracker.sh
```

### Script Usage

```bash
# Create worktree
./.claude/agents/lib/git-worktree-manager.sh create "1.1" "react-developer"

# Merge worktree
./.claude/agents/lib/git-worktree-manager.sh merge "$WORKTREE_PATH"

# Cleanup worktree
./.claude/agents/lib/git-worktree-manager.sh cleanup "$WORKTREE_PATH"

# Detect conflicts
./.claude/agents/lib/conflict-detector.sh detect "$WORKTREE_PATH"

# Track files
./.claude/agents/lib/file-tracker.sh auto-register "1.1" "react-developer" "$WORKTREE_PATH"
./.claude/agents/lib/file-tracker.sh unregister "1.1"
```

### Directive References

In agent definitions:
```markdown
See `agents/directives/git-worktree-workflow.md` for workflow details.
See `agents/directives/javascript-development.md` for common patterns.
```

## Directory Structure

### User Project
```
user-project/
├── .agent-orchestration/     ← State files
│   ├── dependency-graph.json
│   ├── progress.json
│   ├── roadmap.md
│   └── tasks/
├── .claude/                  ← Agent resources
│   ├── agents/
│   │   ├── *.md             ← Agent definitions
│   │   ├── directives/      ← Shared directives
│   │   └── lib/             ← Utility scripts
│   └── commands/            ← Orchestration commands
├── docs/
│   └── stories/             ← User stories (flat)
└── src/                     ← Project code
```

### Zipline Repository (Development)
```
zipline/
├── .claude/
│   └── commands/            ← Orchestration commands
├── agents/                  ← Agent source files
│   ├── definitions/         ← Agent definitions
│   ├── directives/          ← Shared directives
│   └── lib/                 ← Utility scripts
└── docs/                    ← Documentation
```

**Note:** When agents are copied to user projects, they go into `.claude/agents/`.

## Common Patterns

### Parallel Execution Check
```markdown
**Before launching stories:**
1. Build dependency graph
2. Identify waves (stories with satisfied dependencies)
3. For each wave:
   - Launch ALL agents simultaneously
   - Wait for ALL to complete
   - Proceed to next wave
```

### Path Resolution Check
```markdown
**Before running scripts:**
1. Verify you're in project root
2. Use `./.claude/agents/lib/` prefix for scripts
3. Use `agents/directives/` for directives
4. Never use `agents/` at repo root in user projects
```

## Troubleshooting

### Parallel Execution Not Working
- [ ] Check dependency graph has `parallel_waves` field
- [ ] Verify stories in same wave have no dependencies on each other
- [ ] Confirm orchestrator is launching multiple agents at once
- [ ] Check roadmap shows wave-based execution

### Path Resolution Errors
- [ ] Verify `.claude/agents/` directory exists
- [ ] Check script paths use `./.claude/agents/lib/` prefix
- [ ] Confirm directive paths use `agents/directives/`
- [ ] Ensure you're in project root when running scripts

### Script Not Found
```bash
# Wrong (will fail in user projects)
./agents/lib/git-worktree-manager.sh create "1.1" "react-developer"

# Correct (works in user projects)
./.claude/agents/lib/git-worktree-manager.sh create "1.1" "react-developer"
```

### Directive Not Found
```markdown
# Old path (deprecated)
See `.claude/agents/directives/git-worktree-workflow.md`

# Correct (current location)
See `agents/directives/git-worktree-workflow.md`
```

## Performance Metrics

### Expected Time Savings

| Project Size | Stories | Sequential | Parallel | Savings |
|--------------|---------|------------|----------|---------|
| Small | 10 | 40h | 24h | 40% |
| Medium | 25 | 100h | 50h | 50% |
| Large | 50 | 200h | 80h | 60% |

### Wave Efficiency

| Wave Size | Agents | Time | Efficiency |
|-----------|--------|------|------------|
| 1 story | 1 | 4h | Baseline |
| 2 stories | 2 | 4h | 2x faster |
| 4 stories | 4 | 4h | 4x faster |
| 8 stories | 8 | 4h | 8x faster |

## Quick Commands

### Check Parallel Opportunities
```bash
# View dependency graph
cat .agent-orchestration/dependency-graph.json | jq '.parallel_waves'

# View roadmap
cat .agent-orchestration/roadmap.md
```

### Verify Paths
```bash
# Check agent resources exist
ls -la .claude/agents/
ls -la agents/directives/
ls -la .claude/agents/lib/

# Test script execution
./.claude/agents/lib/git-worktree-manager.sh --help
```

### Monitor Execution
```bash
# Check active worktrees
cat .agent-orchestration/worktree-registry.json

# Check story progress
cat .agent-orchestration/progress.json

# View task states
ls -la .agent-orchestration/tasks/
```

## Best Practices

### Maximize Parallelism
1. Break large stories into smaller independent stories
2. Minimize dependencies between stories
3. Group related work into waves
4. Use clear dependency declarations

### Ensure Path Correctness
1. Always use `.claude/agents/` prefix in user projects
2. Test scripts from project root
3. Verify directive references are correct
4. Use relative paths, not absolute paths

### Monitor Performance
1. Track actual vs. estimated time savings
2. Identify bottlenecks in dependency chains
3. Optimize wave sizes for maximum parallelism
4. Document real-world performance improvements
