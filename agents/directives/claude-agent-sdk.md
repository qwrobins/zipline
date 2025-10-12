# Claude Agent SDK Developer Directive

This directive provides specialized guidance for building custom AI agents using the Claude Agent SDK, with primary focus on TypeScript/JavaScript implementation and secondary support for Python.

## When to Use This Directive

Use this directive when:
- Building custom AI agents with the Claude Agent SDK
- Creating custom tools and MCP servers
- Implementing hooks for tool execution control
- Configuring permissions and security controls
- Debugging agent applications and handling errors
- Setting up cost tracking and usage monitoring

## Technology Stack Preference

### Primary: TypeScript/JavaScript
- **Package:** `@anthropic-ai/claude-agent-sdk`
- **Installation:** `npm install @anthropic-ai/claude-agent-sdk`
- **Use Cases:** Node.js applications, web applications, modern JavaScript projects
- **Type Safety:** Zod for schema validation and type definitions

### Secondary: Python
- **Package:** `claude-agent-sdk`
- **Installation:** `pip install claude-agent-sdk`
- **Use Cases:** Python codebases, data science workflows, existing Python projects
- **Requirements:** Python 3.10+, Node.js for Claude Code CLI

**Default Behavior:** Provide TypeScript examples and patterns unless explicitly requested otherwise or when working in Python codebases.

---

## Core Capabilities

### 1. Basic Agent Queries

#### TypeScript Pattern
```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";

// Simple query
const result = await query({
  prompt: "Analyze this codebase and suggest improvements",
  options: {
    systemPrompt: { type: "preset", preset: "claude_code" },
    maxTurns: 3
  }
});

// Process streaming responses
for await (const message of result) {
  if (message.type === "result" && message.subtype === "success") {
    console.log(message.result);
  }
}
```

#### Python Pattern
```python
from claude_agent_sdk import query, ClaudeAgentOptions

options = ClaudeAgentOptions(
    system_prompt="You are a helpful coding assistant",
    max_turns=3
)

async for message in query(
    prompt="Analyze this codebase and suggest improvements",
    options=options
):
    print(message)
```

### 2. Custom Tool Creation

#### TypeScript with Zod
```typescript
import { tool, createSdkMcpServer } from "@anthropic-ai/claude-agent-sdk";
import { z } from "zod";

const customServer = createSdkMcpServer({
  name: "development-tools",
  version: "1.0.0",
  tools: [
    tool(
      "analyze_code",
      "Analyze code quality and suggest improvements",
      {
        filePath: z.string().describe("Path to the file to analyze"),
        language: z.enum(["typescript", "javascript", "python"])
          .default("typescript")
          .describe("Programming language")
      },
      async (args) => {
        // Implementation logic
        return {
          content: [{
            type: "text",
            text: `Analysis complete for ${args.filePath}`
          }]
        };
      }
    )
  ]
});
```

#### Python with Decorators
```python
from claude_agent_sdk import tool, create_sdk_mcp_server

@tool("analyze_code", "Analyze code quality", {"file_path": str, "language": str})
async def analyze_code(args):
    return {
        "content": [{
            "type": "text",
            "text": f"Analysis complete for {args['file_path']}"
        }]
    }

custom_server = create_sdk_mcp_server(
    name="development-tools",
    version="1.0.0",
    tools=[analyze_code]
)
```

### 3. Hook Implementation

#### TypeScript Hooks
```typescript
import { query, ClaudeAgentOptions } from "@anthropic-ai/claude-agent-sdk";

const options: ClaudeAgentOptions = {
  hooks: {
    PreToolUse: [
      {
        matcher: "Bash",
        hooks: [async (input, toolUseId, context) => {
          const command = input.tool_input?.command;
          if (command?.includes("rm -rf")) {
            return {
              hookSpecificOutput: {
                hookEventName: "PreToolUse",
                permissionDecision: "deny",
                permissionDecisionReason: "Dangerous command blocked"
              }
            };
          }
          return {};
        }]
      }
    ]
  },
  allowedTools: ["Read", "Write", "Bash"]
};
```

### 4. Permission Management

#### TypeScript Permission Modes
```typescript
const secureOptions: ClaudeAgentOptions = {
  permissionMode: "default",  // Prompt for each tool use
  allowedTools: [
    "Read",
    "Write", 
    "mcp__development-tools__analyze_code"
  ],
  mcpServers: {
    "development-tools": customServer
  }
};
```

### 5. Error Handling Patterns

#### TypeScript Error Handling
```typescript
import { 
  ClaudeSDKError,
  CLINotFoundError,
  ProcessError,
  CLIJSONDecodeError 
} from "@anthropic-ai/claude-agent-sdk";

try {
  for await (const message of query({ prompt: "Hello" })) {
    // Process messages
  }
} catch (error) {
  if (error instanceof CLINotFoundError) {
    console.error("Claude Code not installed. Run: npm install -g @anthropic-ai/claude-code");
  } else if (error instanceof ProcessError) {
    console.error(`Process failed with exit code: ${error.exitCode}`);
  } else if (error instanceof CLIJSONDecodeError) {
    console.error(`Failed to parse response: ${error.message}`);
  }
}
```

---

## Best Practices

### 1. Type Safety (TypeScript)
- Always use Zod schemas for tool input validation
- Define proper TypeScript interfaces for custom tools
- Use strict type checking in tsconfig.json

### 2. Security Controls
- Implement PreToolUse hooks for dangerous operations
- Use allowlists for tool permissions
- Validate all user inputs in custom tools
- Block potentially harmful commands (rm -rf, etc.)

### 3. Performance Optimization
- Use streaming responses for long-running operations
- Implement proper async/await patterns
- Handle backpressure in message processing
- Use connection pooling for external API calls

### 4. Error Recovery
- Implement retry logic for transient failures
- Provide meaningful error messages to users
- Log errors for debugging and monitoring
- Gracefully handle tool execution failures

### 5. Cost Management
- Monitor token usage with onMessage callbacks
- Set appropriate maxTurns limits
- Use efficient prompting strategies
- Track usage across different tool invocations

---

## Common Patterns

### 1. Development Workflow Agent
```typescript
// Agent for code review and improvement
const developmentAgent = createSdkMcpServer({
  name: "dev-workflow",
  tools: [
    tool("review_code", "Review code for issues", reviewCodeSchema, reviewCodeImpl),
    tool("suggest_tests", "Suggest test cases", testSuggestionSchema, testSuggestionImpl),
    tool("refactor_code", "Refactor code", refactorSchema, refactorImpl)
  ]
});
```

### 2. Multi-Tool Orchestration
```typescript
const options: ClaudeAgentOptions = {
  mcpServers: {
    "development": developmentServer,
    "testing": testingServer,
    "deployment": deploymentServer
  },
  allowedTools: [
    "mcp__development__review_code",
    "mcp__testing__run_tests",
    "mcp__deployment__deploy_app"
  ]
};
```

### 3. Progressive Enhancement
```typescript
// Start with basic tools, add more based on context
let allowedTools = ["Read", "Write"];

if (isProductionEnvironment) {
  allowedTools.push("mcp__deployment__deploy");
}

if (hasTestSuite) {
  allowedTools.push("mcp__testing__run_tests");
}
```

---

## Troubleshooting Guide

### Common Issues

1. **CLINotFoundError**
   - Install Claude Code: `npm install -g @anthropic-ai/claude-code`
   - Verify PATH includes npm global binaries

2. **Permission Denied**
   - Check allowedTools configuration
   - Verify tool names match exactly (including mcp__ prefix)
   - Review permission mode settings

3. **Tool Not Found**
   - Ensure MCP server is properly registered
   - Check tool name formatting: `mcp__server-name__tool-name`
   - Verify server initialization

4. **JSON Parse Errors**
   - Check tool return format matches expected schema
   - Ensure proper content structure in tool responses
   - Validate async function implementations

---

## Quality Checklist

Before deploying an agent, verify:

- [ ] All custom tools have proper type definitions
- [ ] Error handling implemented for all failure modes
- [ ] Security hooks prevent dangerous operations
- [ ] Permission modes configured appropriately
- [ ] Tool allowlists are restrictive and specific
- [ ] Streaming responses handled correctly
- [ ] Cost tracking implemented for production use
- [ ] Integration tests cover all tool interactions
- [ ] Documentation includes usage examples
- [ ] Logging configured for debugging

---

## Related Resources

- Claude Agent SDK Documentation: Context7 `/websites/claude_ja`
- Python SDK: Context7 `/anthropics/claude-agent-sdk-python`
- MCP Protocol: Model Context Protocol specification
- Zod Documentation: Schema validation for TypeScript
- Testing: Jest/Vitest for TypeScript, pytest for Python

## Related Resources

- **Security Guidelines**: `agents/directives/claude-agent-security.md` - Comprehensive security patterns for Claude agents
- **Testing Patterns**: `agents/directives/claude-agent-testing.md` - Testing strategies for AI applications
- **Claude Agent SDK Documentation**: Context7 `/websites/claude_ja` and `/anthropics/claude-agent-sdk-python`
- **TypeScript Development**: `agents/directives/javascript-development.md`
- **Development Server Management**: `agents/directives/development-server-management.md`
- **Git Worktree Workflow**: `agents/directives/git-worktree-workflow.md`
