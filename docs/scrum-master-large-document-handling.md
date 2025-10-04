# Scrum Master Agent: Large Document Handling Update

**Date**: 2025-10-03
**Agent Updated**: `agents/definitions/scrum-master.md`
**Issue Addressed**: Planning documents (PRD, Architecture, Design) can exceed context window limits

## Problem Statement

The scrum-master agent was designed to read full planning documents:
- `docs/prd.md` - Full PRD
- `docs/architecture.md` - Full Architecture document
- `docs/design/frontend-design-spec.md` - Full Frontend Design Specification

**Issue**: These documents can easily exceed 500-1000+ lines for complex projects, causing:
- Context window overflow
- Truncated document reading
- Missing requirements in user stories
- Incomplete epic coverage
- Agent failures or degraded performance

## Solution: Multi-Strategy Document Handling

The scrum-master agent now uses an intelligent, adaptive approach to handle documents of any size.

### Strategy 1: Check Document Sizes First

Before reading, the agent now checks file sizes:
```bash
view: docs/prd.md (check line count)
view: docs/architecture.md (check line count)
view: docs/design/frontend-design-spec.md (check line count)
```

### Strategy 2: Adaptive Reading Based on Size

**For Small Documents (< 500 lines):**
- Read the full document directly
- Process all content in one pass
- Original behavior preserved

**For Large Documents (> 500 lines):**

The agent now has **three options**:

#### **Option A: Use Sharded Versions** (Preferred)
If sharded versions exist, read them instead:

**PRD Sharding:**
```
docs/prd/
├── overview.md              # Executive summary
├── epic-1-foundation.md     # Epic 1 only
├── epic-2-user-profiles.md  # Epic 2 only
├── epic-3-comments.md       # Epic 3 only
└── non-functional.md        # NFRs
```

**Architecture Sharding:**
```
docs/architecture/
├── overview.md
├── tech-stack.md
├── data-fetching.md
├── components/
│   ├── server-components.md
│   └── client-components.md
└── testing.md
```

**Design Sharding:**
```
docs/design/
├── design-system.md
├── accessibility.md
├── components/
│   ├── button.md
│   └── card.md
└── features/
    ├── posts-feed.md
    └── user-profile.md
```

#### **Option B: Strategic Partial Reading**
If no sharded versions exist:
- Read document in sections using `view_range`
- Start with: Table of Contents, Executive Summary, Epic List
- Read each epic section individually
- Use `grep-search` to find specific sections by epic name

**Example Workflow:**
```bash
# Step 1: Read TOC
view: docs/prd.md (lines 1-50)

# Step 2: Find epic sections
grep-search: "Epic 1:" in docs/prd.md

# Step 3: Read each epic
view: docs/prd.md (lines 100-250)  # Epic 1
view: docs/prd.md (lines 251-400)  # Epic 2
```

#### **Option C: Use Codebase Retrieval**
For targeted information extraction:
```bash
codebase-retrieval: "What are all the epics and their user stories in the PRD?"
codebase-retrieval: "What are the technical architecture decisions for the frontend?"
codebase-retrieval: "What are the design system tokens and component specifications?"
```

### Strategy 3: Smart Story References

User stories now reference the most specific documents available:

**If Sharded Docs Exist** (Preferred):
```markdown
## Dev Notes

### Tech Stack
[Source: docs/architecture/tech-stack.md]
- Framework: Next.js 15
- Language: TypeScript

### Data Fetching
[Source: docs/architecture/data-fetching.md]
- React Query patterns
- Optimistic updates
```

**If Only Full Docs Exist** (Fallback):
```markdown
## Dev Notes

### Tech Stack
[Source: docs/architecture.md - Section 2]
[Relevant details]

### Data Fetching
[Source: docs/architecture.md - Section 4.2]
[Relevant details]
```

**Benefits:**
- Developers read only focused, relevant sections
- Reduced context window pressure
- Faster story comprehension
- More maintainable references

## New Tool Usage Guidelines

### Grep Search
Added guidance for finding sections in large documents:
- Search for epic names in PRD
- Find specific technical sections
- Locate component specifications
- Search for requirements

### View with Range
Added guidance for incremental reading:
- Read TOC first (lines 1-50)
- Read specific sections (use grep to find line numbers)
- Avoid loading entire large documents

### Codebase Retrieval
Enhanced usage for large documents:
- Query documents without reading them entirely
- Extract specific epic or feature requirements
- Get targeted information efficiently

## Document Sharding Recommendations

The agent now provides recommendations when encountering large documents:

### When to Recommend Sharding

**Triggers:**
- PRD > 500 lines
- Architecture doc > 500 lines
- Design spec > 500 lines

**Recommendation Format:**
```
⚠️ RECOMMENDATION: The PRD is 1,200 lines long, which may cause context window issues.
Consider sharding it into epic-specific files in docs/prd/ directory.

Suggested structure:
docs/prd/
├── overview.md
├── epic-1-foundation.md
├── epic-2-user-profiles.md
└── non-functional.md
```

### Benefits of Sharding

1. **Reduced Context Window Pressure**: Read only relevant sections
2. **Faster Story Creation**: Targeted section reading
3. **Better Maintainability**: Easier to update specific sections
4. **Parallel Reading**: Multiple agents can read different shards
5. **Clearer References**: Stories reference specific, focused documents

## Updated Workflow

### Step 1: Analyze Planning Documents (Enhanced)

**Old Approach:**
- Read full PRD
- Read full architecture doc
- Read full design spec

**New Approach:**
1. Check document sizes
2. Choose reading strategy based on size
3. Use sharded versions if available
4. Use partial reading or retrieval for large docs
5. Synthesize information from multiple sources

### Story Creation (Enhanced)

**Design References** now support both approaches:
```markdown
## Design Reference

**If sharded design docs exist**:
- **Design System**: docs/design/design-system.md
- **Component Spec**: docs/design/components/button.md
- **Accessibility**: docs/design/accessibility.md

**If only full design spec exists**:
- **Design System**: Section 3 - Design tokens
- **Component Spec**: Section 5.2 - Button component
- **Accessibility**: Section 9 - WCAG requirements
```

## Impact on Existing Workflows

### For Users

**No Breaking Changes:**
- Agent still works with full documents (< 500 lines)
- Backward compatible with existing document structures
- Gracefully handles both sharded and full documents

**New Capabilities:**
- Can handle very large documents (1000+ lines)
- Provides sharding recommendations
- More efficient context window usage

### For Development Agents

**Better Story References:**
- More specific document pointers
- Smaller, focused documents to read
- Faster story comprehension
- Reduced context window pressure

## Files Modified

- `agents/definitions/scrum-master.md` - Complete update with large document handling

## Next Steps

### Recommended Actions

1. **For New Projects**: Consider sharding from the start if documents will be large
2. **For Existing Projects**: Shard documents if they exceed 500 lines
3. **For All Projects**: Monitor document sizes and shard proactively

### Creating Sharded Documents

If you have large planning documents, consider creating sharded versions:

**Example: Shard a Large PRD**
```bash
# Original: docs/prd.md (1200 lines)

# Create sharded versions:
mkdir -p docs/prd
# Split by epic into separate files
# Update scrum-master to read from docs/prd/ instead
```

## Summary

The scrum-master agent is now **context-window aware** and can handle planning documents of any size through:

1. **Intelligent size detection**
2. **Multi-strategy reading** (sharded, partial, retrieval)
3. **Smart story references** (most specific docs)
4. **Proactive recommendations** (suggest sharding)
5. **Backward compatibility** (works with existing docs)

This ensures reliable user story generation regardless of project complexity or document size.

