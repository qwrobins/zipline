# Quick Start Guide

Get up and running with Zipline in minutes.

---

## Prerequisites

Before you begin, ensure you have:

- [Claude Code](https://claude.ai/code) installed
- Git 2.25+ (for worktree support)

---

## Setup

### Step 1: Create Your Project Directory

First, create and navigate to your project directory:

```bash
mkdir my-project
cd my-project
```

---

### Step 2: Create Directory Structure

Create the `.cluade` and `.cluade/agents` directories:

```bash
mkdir .cluade
mkdir .cluade/agents
```

---

### Step 3: Copy Core Agent Resources

From the zipline directory, copy the essential agent resources:

```bash
cp -r /path-to-zipline/.claude/agents/agent-guides /path-to-your-project/.cluade/agents/
cp -r /path-to-zipline/.claude/agents/directives /path-to-your-project/.cluade/agents/
cp -r /path-to-zipline/.claude/agents/lib /path-to-your-project/.cluade/agents/
```

---

### Step 4: Copy Planning Agents

Copy the following planning agents to the `.cluade/agents` directory:

- `product-manager.md`
- `product-analytics.md`
- `frontend-design.md`
- `software-architect.md`
- `planning-analyst.md`
- `scrum-master.md`

```bash
cp /path-to-zipline/.claude/agents/product-manager.md /path-to-your-project/.cluade/agents/
cp /path-to-zipline/.claude/agents/software-architect.md /path-to-your-project/.cluade/agents/
cp /path-to-zipline/.claude/agents/planning-analyst.md /path-to-your-project/.cluade/agents/
cp /path-to-zipline/.claude/agents/scrum-master.md /path-to-your-project/.cluade/agents/
```

---

### Step 5: Copy Development Agents

Copy the specific development agents you want to use. For example, to use the Next.js developer agent:

```bash
cp /path-to-zipline/.claude/agents/nextjs-developer.md /path-to-your-project/.cluade/agents/
```

---

### Step 6: Copy Configuration Files

Copy the MCP configuration and settings files:

```bash
cp /path-to-zipline/.claude/mcp.json /path-to-your-project/
cp /path-to-zipline/.claude/settings.local.json /path-to-your-project/.cluade/
```

> **Note:** Add your GitHub PAT to the `.mcp.json` file, or copy an existing `.mcp.json` file and add the required Context7 and Sequential Thinking servers.

---

### Step 7: Copy Commands Directory

Copy the commands directory from the zipline repo:

```bash
cp -r /path-to-zipline/.claude/commands /path-to-your-project/
```

---

## Planning

### Running Automated Planning

Once you have an idea for your app, you can start the planning process:

#### Option 1: With a Product Brief

Use ChatGPT or another tool to write a product brief, then run:

```bash
/automate-planning
```

#### Option 2: With a Direct Prompt

Call the automate-planning command with your prompt directly:

```bash
/automate-planning docs/product-brief.md <your prompt>
```

---

## Implementation
Once the planning process is finished, you can start the implementation process by running the implement-stories command:

```bash
/implement-stories
```
