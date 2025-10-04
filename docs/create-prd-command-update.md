# /create-prd Command - Updated with Required Tools

## Overview

Updated the `/create-prd` slash command to **explicitly require** `sequential_thinking` and `context7` tools, as requested.

---

## 🔧 What Was Updated

### Before (Missing Requirements)
```markdown
## Step 2: Analyze Requirements

Think through:
- Product vision and goals
- Target users and their needs
- ...
```

**Problem**: No explicit requirement to use `sequential_thinking` or `context7`

### After (Explicit Requirements)
```markdown
## Step 2: Analyze Requirements (REQUIRED - Use sequential_thinking)

**CRITICAL**: You MUST use the `sequential_thinking` tool to analyze...

## Step 3: Research Best Practices (REQUIRED - Use context7)

**CRITICAL**: You MUST use `context7` tools to research...
```

**Solution**: Made both tools mandatory with clear instructions

---

## ✅ Key Changes

### 1. Step 2: Made sequential_thinking REQUIRED

**Added**:
- ✅ "CRITICAL" warning that sequential_thinking is required
- ✅ Specific guidance on what to think through
- ✅ Example usage showing the tool call
- ✅ Recommended number of thoughts (6-10)

**Example provided**:
```
sequential_thinking:
  thought: "Analyzing the product brief for [Product Name]..."
  thoughtNumber: 1
  totalThoughts: 8
  nextThoughtNeeded: true
```

### 2. Step 3: Made context7 REQUIRED

**Added**:
- ✅ "CRITICAL" warning that context7 is required
- ✅ Three specific research areas:
  1. PRD structure and best practices
  2. Domain-specific requirements
  3. Technology stack best practices
- ✅ Example queries for each area
- ✅ Guidance on how to use the research

**Example provided**:
```
resolve-library-id: "product requirements document best practices"
get-library-docs: [Use the library ID from resolve-library-id]
```

### 3. Step 4: Emphasize Using Research

**Added**:
```markdown
**IMPORTANT**: Base your PRD on:
- ✅ Insights from sequential_thinking analysis (Step 2)
- ✅ Best practices from context7 research (Step 3)
- ✅ Requirements from the product brief
```

### 4. Quality Checklist: Verify Tool Usage

**Added verification checklist**:
```markdown
**CRITICAL - Verify you completed all required steps**:
- ✅ Used sequential_thinking to analyze requirements (Step 2)
- ✅ Used context7 to research best practices (Step 3)
- ✅ Incorporated research into the PRD (Step 4)
```

### 5. Critical Requirements Section

**Added at the end**:
```markdown
# Critical Requirements

**YOU MUST**:
- ✅ Use `sequential_thinking` in Step 2 (not optional)
- ✅ Use `context7` in Step 3 (not optional)
- ✅ Base PRD on research and analysis (not just template)

**DO NOT**:
- ❌ Skip sequential_thinking
- ❌ Skip context7 research
- ❌ Just fill in template without research
```

---

## 📋 Updated Workflow

### Step-by-Step Process

```
1. Read Product Brief
   └─> Use `view` tool

2. Analyze Requirements (REQUIRED)
   └─> Use `sequential_thinking` tool
   └─> Think through 6-10 aspects
   └─> Complete understanding before proceeding

3. Research Best Practices (REQUIRED)
   └─> Use `resolve-library-id` to find libraries
   └─> Use `get-library-docs` to get documentation
   └─> Research 3 areas:
       - PRD best practices
       - Domain-specific requirements
       - Technology stack best practices

4. Create Comprehensive PRD
   └─> Use `save-file` to create docs/prd.md
   └─> Base on sequential_thinking insights
   └─> Incorporate context7 research
   └─> Follow PRD template structure

5. Verify Quality
   └─> Check all required tools were used
   └─> Ensure research informed the PRD
```

---

## 🎯 What This Ensures

### sequential_thinking Usage
- ✅ Forces deep analysis before writing
- ✅ Ensures all aspects are considered
- ✅ Creates better, more thoughtful PRDs
- ✅ Identifies gaps and assumptions early

### context7 Usage
- ✅ Incorporates industry best practices
- ✅ Ensures domain-specific requirements
- ✅ Leverages proven patterns
- ✅ Creates more professional PRDs

### Combined Effect
- ✅ PRDs are research-based, not template-based
- ✅ Higher quality output
- ✅ Better alignment with industry standards
- ✅ More comprehensive requirements

---

## 📊 Comparison: Before vs After

| Aspect | Before | After |
|--------|--------|-------|
| **sequential_thinking** | Optional (implied) | **REQUIRED** (explicit) |
| **context7** | Optional (implied) | **REQUIRED** (explicit) |
| **Research Areas** | Unspecified | 3 specific areas |
| **Examples** | None | Multiple examples |
| **Verification** | None | Quality checklist |
| **Enforcement** | Weak | Strong (CRITICAL warnings) |

---

## 🔍 Example Usage

### User Invokes Command
```bash
/create-prd docs/product-brief.md
```

### What Happens Now

**Step 1**: Read product brief
```
view: docs/product-brief.md
```

**Step 2**: Analyze with sequential_thinking (REQUIRED)
```
sequential_thinking:
  thought: "The product is a real-time world clock app..."
  thoughtNumber: 1
  totalThoughts: 8
  nextThoughtNeeded: true

[Continues for 6-10 thoughts]
```

**Step 3**: Research with context7 (REQUIRED)
```
resolve-library-id: "product requirements document best practices"
get-library-docs: /some/library/id

resolve-library-id: "web application requirements"
get-library-docs: /some/library/id

resolve-library-id: "Next.js best practices"
get-library-docs: /some/library/id
```

**Step 4**: Create PRD incorporating research
```
save-file:
  path: docs/prd.md
  file_content: [Comprehensive PRD based on analysis and research]
```

**Step 5**: Verify and summarize
```
✅ Used sequential_thinking: Yes (8 thoughts)
✅ Used context7: Yes (3 research areas)
✅ Created PRD: docs/prd.md
✅ Epics: 4
✅ Stories: 12
```

---

## 💡 Why This Matters

### Without Required Tools
- ❌ Agent might skip analysis
- ❌ Agent might skip research
- ❌ PRD becomes just a filled template
- ❌ Lower quality output
- ❌ Missing best practices

### With Required Tools
- ✅ Agent must analyze deeply
- ✅ Agent must research thoroughly
- ✅ PRD is research-informed
- ✅ Higher quality output
- ✅ Incorporates best practices

---

## 🎯 Expected Behavior

When you run `/create-prd`, you should now see:

1. **sequential_thinking calls** - Multiple thoughts analyzing the brief
2. **context7 calls** - Multiple research queries
3. **Comprehensive PRD** - Based on analysis and research
4. **Summary** - Confirming tools were used

**If you don't see sequential_thinking and context7 calls, the command is not working correctly.**

---

## 📁 Files Updated

- ✅ `.claude/commands/create-prd.md` (UPDATED)
  - Added REQUIRED sequential_thinking in Step 2
  - Added REQUIRED context7 in Step 3
  - Added quality checklist
  - Added critical requirements section
  - Added examples and guidance

---

## ✅ Summary

**Problem**: `/create-prd` wasn't using sequential_thinking and context7

**Solution**: Made both tools **explicitly required** with:
- ✅ "CRITICAL" warnings
- ✅ Detailed instructions
- ✅ Example usage
- ✅ Verification checklist
- ✅ Clear enforcement

**Result**: The command now **requires** both tools and provides guidance on how to use them effectively.

---

## 🚀 Try It Now

Run the command and verify you see:
```bash
/create-prd docs/product-brief.md
```

**Expected output**:
1. ✅ sequential_thinking calls (6-10 thoughts)
2. ✅ context7 calls (3+ research queries)
3. ✅ Comprehensive PRD at docs/prd.md
4. ✅ Summary confirming tool usage

If you don't see these, let me know and I'll investigate further!

---

**Version**: 2.0 (With Required Tools)  
**Last Updated**: 2025-10-02  
**Status**: Active

