# Mastra AI Agent Framework

## Overview

This directive provides comprehensive guidance for developing AI applications using the Mastra AI agent framework. Mastra offers multi-provider flexibility, supporting OpenAI, Anthropic, Google, and other AI providers, making it ideal for building provider-agnostic AI applications.

## When to Use This Directive

Use this directive when:
- Building AI agents with multiple provider support
- Creating workflows that combine multiple AI models
- Implementing MCP (Model Context Protocol) servers and tools
- Building production AI applications with evaluation metrics
- Developing AI-powered APIs and web applications
- Creating multi-agent systems and workflows

## Technology Stack Preference

### Primary: TypeScript/JavaScript
- **Package:** `@mastra/core`
- **Installation:** `npm install @mastra/core @ai-sdk/openai @ai-sdk/anthropic`
- **Use Cases:** Node.js applications, web applications, multi-provider AI systems
- **Type Safety:** Zod for schema validation and structured outputs

### Secondary: Python Support
- **Note:** Mastra is primarily TypeScript-focused
- **Alternative:** Use TypeScript for Mastra, Python for data processing/ML pipelines
- **Integration:** REST APIs between TypeScript Mastra and Python services

## Core Capabilities

### 1. **Multi-Provider Agent Creation**

```typescript
import { openai } from "@ai-sdk/openai";
import { anthropic } from "@ai-sdk/anthropic";
import { Agent } from "@mastra/core/agent";

// OpenAI-powered agent
const openaiAgent = new Agent({
  name: "openai-assistant",
  model: openai("gpt-4o"),
  instructions: "You are a helpful assistant using OpenAI.",
});

// Anthropic-powered agent
const claudeAgent = new Agent({
  name: "claude-assistant", 
  model: anthropic("claude-3-5-sonnet-20241022"),
  instructions: "You are a helpful assistant using Claude.",
});

// Multi-model workflow
const mastra = new Mastra({
  agents: {
    openaiAgent,
    claudeAgent
  }
});
```

### 2. **Custom Tool Creation**

```typescript
import { createTool } from "@mastra/core/tools";
import { z } from "zod";

const weatherTool = createTool({
  id: "get-weather",
  description: "Get current weather for a city",
  inputSchema: z.object({
    city: z.string().describe("The city to get weather for"),
    units: z.enum(["celsius", "fahrenheit"]).default("celsius")
  }),
  outputSchema: z.object({
    temperature: z.number(),
    condition: z.string(),
    humidity: z.number()
  }),
  execute: async ({ context: { city, units } }) => {
    // Weather API integration
    const weather = await fetchWeatherData(city, units);
    return {
      temperature: weather.temp,
      condition: weather.condition,
      humidity: weather.humidity
    };
  }
});

const agent = new Agent({
  name: "weather-agent",
  model: openai("gpt-4o"),
  instructions: "Help users with weather information.",
  tools: { weatherTool }
});
```

### 3. **Workflow Integration**

```typescript
import { Step, Workflow } from "@mastra/core/workflows";

const weatherWorkflow = new Workflow({
  name: "weatherWorkflow",
  steps: {
    getWeather: new Step({
      id: "getWeather",
      inputSchema: z.object({
        city: z.string()
      }),
      outputSchema: z.object({
        activities: z.array(z.string())
      }),
      execute: async ({ context: { city } }) => {
        // Multi-step weather analysis
        const weather = await getWeatherData(city);
        const activities = await generateActivities(weather);
        return { activities };
      }
    })
  }
});

// Expose workflow as agent tool
const activityPlannerTool = createTool({
  id: "get-weather-activities",
  description: "Get weather-specific activities for a city",
  inputSchema: z.object({
    city: z.string()
  }),
  outputSchema: z.object({
    activities: z.array(z.string())
  }),
  execute: async ({ context: { city }, mastra }) => {
    const workflow = mastra?.vnext_getWorkflow("weatherWorkflow");
    const run = workflow.createRun();
    const result = await run.start({ inputData: { city } });
    
    if (result.status === "success") {
      return { activities: result.result.activities };
    }
    throw new Error(`Workflow failed: ${result.status}`);
  }
});
```

### 4. **MCP Server Integration**

```typescript
import { MCPClient } from "@mastra/mcp";

const mcp = new MCPClient({
  servers: {
    filesystem: {
      command: "npx",
      args: ["@modelcontextprotocol/server-filesystem"],
      env: {
        ALLOWED_PATHS: "/workspace/src"
      },
      timeout: 20000
    },
    database: {
      url: new URL("http://localhost:8080/mcp"),
      requestInit: {
        headers: {
          Authorization: `Bearer ${process.env.DB_TOKEN}`
        }
      }
    }
  },
  timeout: 30000
});

// Use MCP tools with agents
const agent = new Agent({
  name: "development-assistant",
  model: openai("gpt-4o"),
  instructions: "Help with development tasks using available tools.",
  tools: await mcp.getTools()
});

// Or dynamically provide tools
const response = await agent.stream("List files in src/", {
  toolsets: await mcp.getToolsets()
});
```

### 5. **Streaming and Real-time Responses**

```typescript
// Basic streaming
const stream = await agent.stream("Tell me about TypeScript", {
  temperature: 0.7,
  maxSteps: 3,
  memory: {
    thread: "user-123",
    resource: "typescript-help"
  },
  toolChoice: "auto"
});

for await (const chunk of stream.textStream) {
  console.log(chunk);
}

// Advanced streaming with callbacks
const stream = await agent.streamVNext("Analyze this code", {
  format: 'aisdk',
  stopWhen: stepCountIs(5),
  modelSettings: {
    temperature: 0.3
  },
  structuredOutput: {
    schema: z.object({
      issues: z.array(z.string()),
      suggestions: z.array(z.string()),
      complexity: z.number()
    }),
    model: openai("gpt-4o-mini"),
    errorStrategy: 'warn'
  },
  onFinish: (result) => {
    console.log('Analysis complete:', result);
  },
  onStepFinish: (step) => {
    console.log('Step completed:', step);
  },
  onError: ({ error }) => {
    console.error('Analysis error:', error);
  }
});
```

## Best Practices

### **1. Provider Selection Strategy**
- ✅ **Choose providers based on task requirements**
  - OpenAI: General purpose, coding, structured outputs
  - Anthropic: Long context, reasoning, safety
  - Google: Multimodal, specialized domains
- ✅ **Implement fallback providers for reliability**
- ✅ **Use cost-effective models for simple tasks**
- ✅ **Monitor usage and costs across providers**

### **2. Tool Design Patterns**
- ✅ **Use Zod schemas for input/output validation**
- ✅ **Implement proper error handling in tools**
- ✅ **Design tools to be composable and reusable**
- ✅ **Include comprehensive descriptions for AI understanding**

### **3. Workflow Architecture**
- ✅ **Break complex tasks into discrete workflow steps**
- ✅ **Use workflows for multi-agent coordination**
- ✅ **Implement proper state management between steps**
- ✅ **Design for observability and debugging**

### **4. Memory and Context Management**
- ✅ **Use thread-based memory for user sessions**
- ✅ **Implement resource-based context isolation**
- ✅ **Design for context window optimization**
- ✅ **Handle long conversations gracefully**

## Common Patterns

### **Development Workflow Agent**
```typescript
const devAgent = new Agent({
  name: "dev-assistant",
  model: openai("gpt-4o"),
  instructions: `
    You are a development assistant that helps with:
    - Code analysis and review
    - Bug fixing and debugging
    - Architecture recommendations
    - Testing strategies
  `,
  tools: {
    analyzeCode: codeAnalysisTool,
    runTests: testRunnerTool,
    checkSecurity: securityScanTool
  }
});
```

### **Multi-Agent Orchestration**
```typescript
const researchAgent = new Agent({
  name: "researcher",
  model: anthropic("claude-3-5-sonnet-20241022"),
  instructions: "Research and gather information on topics."
});

const writerAgent = new Agent({
  name: "writer", 
  model: openai("gpt-4o"),
  instructions: "Write content based on research."
});

const editorAgent = new Agent({
  name: "editor",
  model: openai("gpt-4o-mini"),
  instructions: "Edit and refine written content."
});

const contentWorkflow = new Workflow({
  name: "contentCreation",
  steps: {
    research: createAgentStep(researchAgent),
    write: createAgentStep(writerAgent),
    edit: createAgentStep(editorAgent)
  }
});
```

### **Progressive Enhancement**
```typescript
// Start simple, add complexity gradually
const basicAgent = new Agent({
  name: "basic-assistant",
  model: openai("gpt-4o-mini"),
  instructions: "Basic helpful assistant"
});

// Add tools as needed
const enhancedAgent = new Agent({
  name: "enhanced-assistant",
  model: openai("gpt-4o"),
  instructions: "Advanced assistant with tools",
  tools: { weatherTool, calculatorTool, searchTool }
});

// Add evaluation metrics
const productionAgent = new Agent({
  name: "production-assistant",
  model: openai("gpt-4o"),
  instructions: "Production assistant with monitoring",
  tools: { weatherTool, calculatorTool, searchTool },
  evals: {
    safety: new SafetyMetric(openai("gpt-4o-mini")),
    quality: new QualityMetric(anthropic("claude-3-haiku-20240307"))
  }
});
```

## Deployment Patterns

### **Express.js API Integration**
```typescript
import express from 'express';
import { Mastra } from '@mastra/core';

const app = express();
app.use(express.json());

const mastra = new Mastra({
  agents: { assistantAgent }
});

app.post('/api/agents/:agentName/generate', async (req, res) => {
  try {
    const { agentName } = req.params;
    const { messages } = req.body;
    
    const agent = mastra.getAgent(agentName);
    const response = await agent.generate(messages[0].content);
    
    res.json({ text: response.text });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/agents/:agentName/stream', async (req, res) => {
  const { agentName } = req.params;
  const { message } = req.body;
  
  const agent = mastra.getAgent(agentName);
  const stream = await agent.streamVNext(message, {
    format: 'aisdk'
  });
  
  return stream.toUIMessageStreamResponse();
});
```

### **Next.js Integration**
```typescript
// app/api/chat/route.ts
import { mastra } from '@/lib/mastra';

export async function POST(request: Request) {
  const { message, agentName } = await request.json();
  
  const agent = mastra.getAgent(agentName);
  const stream = await agent.streamVNext(message, {
    format: 'aisdk',
    memory: {
      thread: request.headers.get('x-user-id') || 'anonymous',
      resource: 'chat-app'
    }
  });
  
  return stream.toUIMessageStreamResponse();
}
```

### **Lambda Function Deployment**
```typescript
import { APIGatewayProxyHandler } from 'aws-lambda';
import { Mastra } from '@mastra/core';

const mastra = new Mastra({
  agents: { assistantAgent }
});

export const handler: APIGatewayProxyHandler = async (event) => {
  try {
    const { agentName, message } = JSON.parse(event.body || '{}');
    
    const agent = mastra.getAgent(agentName);
    const response = await agent.generate(message, {
      memory: {
        thread: event.requestContext.requestId,
        resource: 'lambda-chat'
      }
    });
    
    return {
      statusCode: 200,
      body: JSON.stringify({ text: response.text })
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message })
    };
  }
};
```

## Troubleshooting

### **Common Issues and Solutions**

**Provider Authentication Errors:**
```typescript
// ❌ Missing API keys
const agent = new Agent({
  model: openai("gpt-4o") // Will fail without OPENAI_API_KEY
});

// ✅ Proper environment setup
if (!process.env.OPENAI_API_KEY) {
  throw new Error('OPENAI_API_KEY environment variable required');
}
```

**Tool Execution Failures:**
```typescript
// ✅ Proper error handling in tools
const robustTool = createTool({
  id: "robust-tool",
  execute: async ({ context }) => {
    try {
      const result = await externalAPI(context);
      return result;
    } catch (error) {
      console.error('Tool execution failed:', error);
      throw new Error(`Tool failed: ${error.message}`);
    }
  }
});
```

**Memory and Context Issues:**
```typescript
// ✅ Proper memory configuration
const response = await agent.stream(message, {
  memory: {
    thread: userId, // Unique per user
    resource: appName // Unique per application
  },
  maxSteps: 10 // Prevent infinite loops
});
```

## Quality Checklist

### **Pre-Deployment Verification**
- [ ] **Provider Configuration**
  - [ ] API keys properly configured in environment
  - [ ] Fallback providers implemented for critical paths
  - [ ] Rate limiting and error handling implemented
  - [ ] Cost monitoring and alerts configured

- [ ] **Agent Design**
  - [ ] Clear, specific instructions provided
  - [ ] Appropriate model selection for task complexity
  - [ ] Tools properly validated with Zod schemas
  - [ ] Memory and context management implemented

- [ ] **Tool Implementation**
  - [ ] Input/output schemas defined and validated
  - [ ] Error handling implemented for all failure modes
  - [ ] Tools are idempotent where appropriate
  - [ ] Comprehensive descriptions for AI understanding

- [ ] **Workflow Design**
  - [ ] Steps are atomic and well-defined
  - [ ] State management between steps implemented
  - [ ] Error recovery and retry logic included
  - [ ] Observability and logging configured

- [ ] **Security and Compliance**
  - [ ] Input validation and sanitization implemented
  - [ ] Output filtering for sensitive information
  - [ ] Access controls and authentication configured
  - [ ] Audit logging for compliance requirements

## Related Resources

- **Security Guidelines**: `agents/directives/mastra-ai-security.md` - Comprehensive security patterns for multi-provider AI applications
- **Testing Patterns**: `agents/directives/mastra-ai-testing.md` - Testing strategies for multi-provider AI applications with cost optimization
- **Claude Agent SDK**: `agents/directives/claude-agent-sdk.md` - Alternative single-provider approach with Anthropic focus
- **Mastra AI Documentation**: Context7 `/mastra-ai/mastra` - Official framework documentation
- **Development Server Management**: `agents/directives/development-server-management.md`
- **Git Worktree Workflow**: `agents/directives/git-worktree-workflow.md`
