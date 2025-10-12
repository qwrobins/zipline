# Agent Library

This directory contains reusable utilities and scripts for agent workflows.

## Files

### git-worktree-manager.sh

**Purpose:** Manages git worktrees for multi-agent development to prevent conflicts.

**Usage:**
```bash
# Create a worktree for a story
./.claude/agents/lib/git-worktree-manager.sh create "<story-id>" "<agent-name>" [base-branch]

# List all active worktrees
./.claude/agents/lib/git-worktree-manager.sh list

# Merge worktree back to target branch
./.claude/agents/lib/git-worktree-manager.sh merge "<worktree-path>" [target-branch]

# Cleanup worktree and delete branch
./.claude/agents/lib/git-worktree-manager.sh cleanup "<worktree-path>"

# Cleanup abandoned worktrees (older than 24 hours)
./.claude/agents/lib/git-worktree-manager.sh cleanup-abandoned
```

**Features:**
- ✅ Automatic branch name generation with timestamps
- ✅ Worktree registry tracking
- ✅ Conflict detection and reporting
- ✅ Automatic cleanup of abandoned worktrees
- ✅ Comprehensive error handling
- ✅ Color-coded output for clarity

**Requirements:**
- Git 2.5+ (for worktree support)
- Bash 4.0+
- jq (for JSON processing)

**See Also:**
- `.claude/agents/directives/git-worktree-workflow.md` - Complete workflow guide
- `.claude/commands/cleanup-worktrees.md` - Cleanup command documentation

## Installation

### Install jq (if not already installed)

**macOS:**
```bash
brew install jq
```

**Ubuntu/Debian:**
```bash
sudo apt-get install jq
```

**CentOS/RHEL:**
```bash
sudo yum install jq
```

**Windows (Git Bash):**
```bash
# Download from https://stedolan.github.io/jq/download/
# Or use chocolatey
choco install jq
```

### Verify Installation

```bash
# Check git version (should be 2.5+)
git --version

# Check jq is installed
jq --version

# Make script executable (if not already)
chmod +x .claude/agents/lib/git-worktree-manager.sh
```

## Troubleshooting

### Error: jq command not found

**Solution:** Install jq using the instructions above.

### Error: Permission denied

**Solution:** Make the script executable:
```bash
chmod +x .claude/agents/lib/git-worktree-manager.sh
```

### Error: Git version too old

**Solution:** Upgrade git to version 2.5 or later:
```bash
# macOS
brew upgrade git

# Ubuntu/Debian
sudo apt-get update
sudo apt-get upgrade git
```

### Error: Worktree creation fails

**Possible causes:**
1. Disk space full - Check with `df -h`
2. Permission issues - Check directory permissions
3. Git repository corrupted - Run `git fsck`

**Solution:**
```bash
# Check disk space
df -h

# Check permissions
ls -la .worktrees/

# Verify git repository
git fsck
```

## Development

### Adding New Features

When adding new features to the git-worktree-manager:

1. **Follow the existing pattern:**
   - Add function with descriptive name
   - Include error handling
   - Use logging functions (log_info, log_error, etc.)
   - Update the help text

2. **Test thoroughly:**
   - Test with valid inputs
   - Test with invalid inputs
   - Test error conditions
   - Test edge cases

3. **Update documentation:**
   - Update this README
   - Update `.claude/agents/directives/git-worktree-workflow.md`
   - Update `.claude/commands/cleanup-worktrees.md`

### Code Style

- Use `set -euo pipefail` for safety
- Quote all variables: `"$variable"`
- Use descriptive function names
- Add comments for complex logic
- Use color-coded logging
- Handle errors gracefully

## Examples

### Example 1: Create Worktree for Story 1.1

```bash
$ ./.claude/agents/lib/git-worktree-manager.sh create "1.1" "javascript-developer"
[INFO] Creating worktree for story: 1.1, agent: javascript-developer
[INFO] Creating worktree at: .worktrees/agent-javascript-developer-1-1-20240107-120000
[SUCCESS] Worktree created successfully
[INFO] Registered worktree in registry
.worktrees/agent-javascript-developer-1-1-20240107-120000
```

### Example 2: List Active Worktrees

```bash
$ ./.claude/agents/lib/git-worktree-manager.sh list
[INFO] Active worktrees:
/path/to/repo/.worktrees/agent-javascript-developer-1-1-20240107-120000  abc123 [agent-javascript-developer-1-1-20240107-120000]
/path/to/repo                                                             def456 [main]

[INFO] Registry information:
  Story: 1.1 | Agent: javascript-developer | Branch: agent-javascript-developer-1-1-20240107-120000 | Created: 2024-01-07T12:00:00Z
```

### Example 3: Merge and Cleanup

```bash
$ ./.claude/agents/lib/git-worktree-manager.sh merge ".worktrees/agent-javascript-developer-1-1-20240107-120000"
[INFO] Merging worktree: .worktrees/agent-javascript-developer-1-1-20240107-120000 into main
[INFO] Switching to main
[INFO] Merging agent-javascript-developer-1-1-20240107-120000 into main
[SUCCESS] Merge completed successfully

$ ./.claude/agents/lib/git-worktree-manager.sh cleanup ".worktrees/agent-javascript-developer-1-1-20240107-120000"
[INFO] Cleaning up worktree: .worktrees/agent-javascript-developer-1-1-20240107-120000
[INFO] Removing worktree
[SUCCESS] Worktree removed
[INFO] Deleting branch: agent-javascript-developer-1-1-20240107-120000
[SUCCESS] Branch deleted
[INFO] Unregistered worktree from registry
[SUCCESS] Cleanup completed
```

### Example 4: Cleanup Abandoned Worktrees

```bash
$ ./.claude/agents/lib/git-worktree-manager.sh cleanup-abandoned
[INFO] Checking for abandoned worktrees (older than 24h)
[WARNING] Found abandoned worktree: .worktrees/agent-javascript-developer-1-1-20240106-120000
[INFO] Cleaning up worktree: .worktrees/agent-javascript-developer-1-1-20240106-120000
[INFO] Removing worktree
[SUCCESS] Worktree removed
[INFO] Deleting branch: agent-javascript-developer-1-1-20240106-120000
[SUCCESS] Branch deleted
[INFO] Unregistered worktree from registry
[SUCCESS] Cleanup completed
[SUCCESS] Abandoned worktree cleanup completed
```

## Integration with Agents

### In Agent Definitions

Agents should follow the workflow in `.claude/agents/directives/git-worktree-workflow.md`:

```bash
# 1. Create worktree
WORKTREE_PATH=$(./.claude/agents/lib/git-worktree-manager.sh create "1.1" "javascript-developer")

# 2. Switch to worktree
cd "$WORKTREE_PATH"

# 3. Do work
# ... implementation ...

# 4. Return to repo root
cd ../../

# 5. Merge
./.claude/agents/lib/git-worktree-manager.sh merge "$WORKTREE_PATH"

# 6. Cleanup
./.claude/agents/lib/git-worktree-manager.sh cleanup "$WORKTREE_PATH"
```

### In Orchestration System

The `/implement-stories` command should:

```bash
# Before assigning story
WORKTREE_PATH=$(./.claude/agents/lib/git-worktree-manager.sh create "$STORY_ID" "$AGENT_NAME")

# Save in task state
echo "worktree_path: $WORKTREE_PATH" >> .agent-orchestration/tasks/$STORY_ID-task.json

# After story completion
./.claude/agents/lib/git-worktree-manager.sh merge "$WORKTREE_PATH"
./.claude/agents/lib/git-worktree-manager.sh cleanup "$WORKTREE_PATH"
```

## Best Practices

1. **Always create worktrees** before making changes
2. **Commit regularly** within the worktree
3. **Merge promptly** after work is complete
4. **Cleanup immediately** after successful merge
5. **Run cleanup-abandoned** regularly (daily/weekly)
6. **Monitor disk space** - worktrees consume space
7. **Don't manually edit** the registry file
8. **Use the script** - don't manually create/remove worktrees

## Security Considerations

- The script uses `set -euo pipefail` for safety
- All user inputs are sanitized before use
- No arbitrary code execution
- Registry file is JSON (safe format)
- Worktrees are created in controlled location

## Performance

- Worktree creation: ~1-2 seconds
- Merge operation: ~2-5 seconds (depends on changes)
- Cleanup operation: ~1-2 seconds
- Abandoned cleanup: ~5-10 seconds (depends on count)

## Limitations

- Requires Git 2.5+ (worktree feature)
- Requires jq for JSON processing
- Registry file must be valid JSON
- Maximum worktree age is 24 hours (configurable)
- Worktrees consume disk space

## Future Enhancements

Potential improvements:

- [ ] Support for custom worktree age limits
- [ ] Automatic conflict resolution strategies
- [ ] Integration with CI/CD systems
- [ ] Worktree usage statistics
- [ ] Disk space monitoring and warnings
- [ ] Parallel worktree operations
- [ ] Worktree templates
- [ ] Integration with git hooks

## Contributing

When contributing to this library:

1. Follow the existing code style
2. Add tests for new features
3. Update documentation
4. Test on multiple platforms
5. Handle errors gracefully
6. Use descriptive commit messages

## License

This library is part of the Zipline agent system and follows the same license as the parent project.

