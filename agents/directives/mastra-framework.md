# Mastra AI Framework Development Directive

## Overview

This directive provides comprehensive guidance for building secure, tested AI applications using the Mastra AI framework with multi-provider support.

**Consolidated from:**
- `mastra-ai-framework.md` - Core framework usage
- `mastra-ai-security.md` - Security best practices
- `mastra-ai-testing.md` - Testing strategies

## When to Use

Use this directive when:
- Building AI agents with multiple provider support (OpenAI, Anthropic, Google)
- Creating workflows that combine multiple AI models
- Implementing MCP servers and tools
- Building production AI applications with evaluation metrics
- Developing multi-agent systems

## Technology Stack

### Primary: TypeScript/JavaScript
- **Package:** `@mastra/core`
- **Installation:** `npm install @mastra/core @ai-sdk/openai @ai-sdk/anthropic`
- **Type Safety:** Zod for schema validation

### Python Integration
- **Note:** Mastra is TypeScript-focused
- **Pattern:** Use TypeScript for Mastra, Python for data processing
- **Integration:** REST APIs between services

## Quick Start

### Multi-Provider Agent

```typescript
import { openai } from "@ai-sdk/openai";
import { anthropic } from "@ai-sdk/anthropic";
import { Agent } from "@mastra/core/agent";

// OpenAI agent
const openaiAgent = new Agent({
  name: "openai-assistant",
  model: openai("gpt-4o"),
  instructions: "You are a helpful assistant.",
});

// Claude agent
const claudeAgent = new Agent({
  name: "claude-assistant",
  model: anthropic("claude-sonnet-4-5-20250929"),
  instructions: "You are a helpful assistant.",
});

// Use either agent
const response = await openaiAgent.generate("Hello!");
```

### Agent with Tools

```typescript
import { z } from "zod";

const weatherTool = {
  description: "Get weather for a location",
  parameters: z.object({
    location: z.string(),
    unit: z.enum(["celsius", "fahrenheit"]).default("celsius")
  }),
  execute: async ({ location, unit }) => {
    // Tool implementation
    return { temp: 72, unit, location };
  }
};

const agent = new Agent({
  name: "weather-assistant",
  model: openai("gpt-4o"),
  instructions: "Help users with weather information.",
  tools: { getWeather: weatherTool }
});
```

### Workflows

```typescript
import { Workflow } from "@mastra/core/workflow";

const analysisWorkflow = new Workflow({
  name: "code-analysis",
  steps: [
    {
      id: "analyze",
      agent: claudeAgent,
      prompt: "Analyze this code: {{code}}"
    },
    {
      id: "suggest",
      agent: openaiAgent,
      prompt: "Based on analysis: {{analyze.output}}, suggest improvements"
    }
  ]
});

const result = await analysisWorkflow.execute({ code: "const x = 1;" });
```

## Security Best Practices

### 1. Secure API Key Management

```typescript
// ✅ GOOD: Validate and manage keys securely
class SecureProviderManager {
  private providers = new Map();
  
  constructor() {
    this.validateKeys();
    this.initializeProviders();
  }
  
  private validateKeys() {
    const required = {
      'OPENAI_API_KEY': 'sk-',
      'ANTHROPIC_API_KEY': 'sk-ant-',
    };
    
    for (const [key, prefix] of Object.entries(required)) {
      const value = process.env[key];
      if (!value || !value.startsWith(prefix)) {
        throw new Error(`Invalid ${key}`);
      }
    }
  }
  
  private initializeProviders() {
    this.providers.set('openai', openai.provider({
      apiKey: process.env.OPENAI_API_KEY
    }));
    this.providers.set('anthropic', anthropic.provider({
      apiKey: process.env.ANTHROPIC_API_KEY
    }));
  }
}

// ❌ BAD: Hardcoded keys
const agent = new Agent({
  model: openai("gpt-4o", { apiKey: "sk-..." }) // Never!
});
```

### 2. Input Validation with Zod

```typescript
// ✅ GOOD: Strict validation
const userInputSchema = z.object({
  query: z.string().min(1).max(1000),
  context: z.string().optional(),
  provider: z.enum(['openai', 'anthropic', 'google'])
});

async function secureQuery(input: unknown) {
  // Validate input
  const validated = userInputSchema.parse(input);
  
  // Sanitize
  const sanitized = sanitizeInput(validated.query);
  
  // Execute with validated provider
  const agent = getAgentForProvider(validated.provider);
  return agent.generate(sanitized);
}
```

### 3. Tool Permission Controls

```typescript
// ✅ GOOD: Implement access controls
const deleteFileTool = {
  description: "Delete a file",
  parameters: z.object({
    path: z.string()
  }),
  execute: async ({ path }, context) => {
    // Check permissions
    if (!context.user?.hasPermission('file:delete')) {
      throw new Error('Insufficient permissions');
    }
    
    // Validate path
    if (!isPathAllowed(path)) {
      throw new Error('Access denied');
    }
    
    await fs.unlink(path);
    return { success: true };
  }
};
```

### 4. Rate Limiting Per Provider

```typescript
// ✅ GOOD: Provider-specific rate limits
import { RateLimiter } from 'limiter';

const rateLimiters = {
  openai: new RateLimiter({ tokensPerInterval: 50, interval: 'minute' }),
  anthropic: new RateLimiter({ tokensPerInterval: 30, interval: 'minute' }),
  google: new RateLimiter({ tokensPerInterval: 40, interval: 'minute' })
};

async function rateLimitedQuery(provider: string, prompt: string) {
  await rateLimiters[provider].removeTokens(1);
  const agent = getAgentForProvider(provider);
  return agent.generate(prompt);
}
```

### 5. Output Validation

```typescript
// ✅ GOOD: Validate AI responses
const responseSchema = z.object({
  analysis: z.string(),
  confidence: z.number().min(0).max(1),
  suggestions: z.array(z.string())
});

const agent = new Agent({
  name: "analyzer",
  model: openai("gpt-4o"),
  instructions: "Return JSON with analysis, confidence, and suggestions.",
  output: responseSchema // Mastra validates output
});

const result = await agent.generate("Analyze this code");
// result is typed and validated
```

## Testing Patterns

### Unit Tests

```typescript
import { describe, it, expect, vi } from 'vitest';

// Test tool logic without AI
describe('weatherTool', () => {
  it('should fetch weather data', async () => {
    const result = await weatherTool.execute({
      location: 'San Francisco',
      unit: 'celsius'
    });
    
    expect(result).toHaveProperty('temp');
    expect(result.location).toBe('San Francisco');
  });
  
  it('should validate parameters', async () => {
    await expect(weatherTool.execute({
      location: '',
      unit: 'invalid'
    })).rejects.toThrow();
  });
});
```

### Integration Tests with Mocks

```typescript
import { vi } from 'vitest';

// Mock AI SDK
vi.mock('@ai-sdk/openai', () => ({
  openai: vi.fn(() => ({
    doGenerate: vi.fn().mockResolvedValue({
      text: 'Mocked response',
      usage: { totalTokens: 100 }
    })
  }))
}));

describe('Agent Integration', () => {
  it('should generate response', async () => {
    const agent = new Agent({
      name: 'test',
      model: openai('gpt-4o'),
      instructions: 'Test'
    });
    
    const result = await agent.generate('Hello');
    expect(result.text).toBe('Mocked response');
  });
});
```

### Multi-Provider Testing

```typescript
describe('Multi-Provider Workflow', () => {
  it('should fallback to secondary provider', async () => {
    const primaryAgent = new Agent({
      name: 'primary',
      model: openai('gpt-4o')
    });
    
    const fallbackAgent = new Agent({
      name: 'fallback',
      model: anthropic('claude-sonnet-4-5-20250929')
    });
    
    async function resilientQuery(prompt: string) {
      try {
        return await primaryAgent.generate(prompt);
      } catch (error) {
        return await fallbackAgent.generate(prompt);
      }
    }
    
    const result = await resilientQuery('Test');
    expect(result.text).toBeDefined();
  });
});
```

### E2E Tests (Sparingly)

```typescript
// Only for critical paths - costs money!
describe('E2E: Real AI Providers', () => {
  it('should work with real OpenAI', async () => {
    const agent = new Agent({
      name: 'real-test',
      model: openai('gpt-4o'),
      instructions: 'Be concise'
    });
    
    const result = await agent.generate('Say hello');
    expect(result.text).toBeDefined();
    expect(result.text.length).toBeGreaterThan(0);
  });
});
```

## Cost Optimization

### 1. Provider Selection by Task

```typescript
// Use cheaper models for simple tasks
const simpleAgent = new Agent({
  name: 'simple',
  model: openai('gpt-4o-mini'), // Cheaper
  instructions: 'Handle simple queries'
});

const complexAgent = new Agent({
  name: 'complex',
  model: anthropic('claude-sonnet-4-5-20250929'), // More capable
  instructions: 'Handle complex reasoning'
});

async function smartQuery(prompt: string, complexity: 'simple' | 'complex') {
  const agent = complexity === 'simple' ? simpleAgent : complexAgent;
  return agent.generate(prompt);
}
```

### 2. Response Caching

```typescript
const cache = new Map<string, any>();

async function cachedGenerate(agent: Agent, prompt: string) {
  const key = `${agent.name}:${prompt}`;
  
  if (cache.has(key)) {
    return cache.get(key);
  }
  
  const result = await agent.generate(prompt);
  cache.set(key, result);
  
  return result;
}
```

### 3. Token Limits

```typescript
const agent = new Agent({
  name: 'limited',
  model: openai('gpt-4o'),
  instructions: 'Be concise',
  maxTokens: 500 // Limit response length
});
```

## Integration Patterns

### Next.js API Route

```typescript
// app/api/chat/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { Agent } from '@mastra/core/agent';
import { openai } from '@ai-sdk/openai';

const agent = new Agent({
  name: 'chat',
  model: openai('gpt-4o'),
  instructions: 'Be helpful and concise'
});

export async function POST(req: NextRequest) {
  const { message } = await req.json();
  
  if (!message) {
    return NextResponse.json(
      { error: 'Message required' },
      { status: 400 }
    );
  }
  
  const result = await agent.generate(message);
  return NextResponse.json({ response: result.text });
}
```

### Streaming Responses

```typescript
export async function POST(req: NextRequest) {
  const { message } = await req.json();
  
  const stream = await agent.generateStream(message);
  
  return new Response(stream, {
    headers: { 'Content-Type': 'text/event-stream' }
  });
}
```

## Resources

**Full Documentation:**
- Framework: `agents/directives/mastra-ai-framework.md`
- Security: `agents/directives/mastra-ai-security.md`
- Testing: `agents/directives/mastra-ai-testing.md`

**External:**
- Mastra Documentation
- AI SDK Documentation
- Provider-specific docs

