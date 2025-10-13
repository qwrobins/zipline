# Claude Agent SDK Development Directive

## Overview

This directive provides comprehensive guidance for building secure, tested AI agents using the Claude Agent SDK.

**Consolidated from:**
- `claude-agent-sdk.md` - Core SDK usage patterns
- `claude-agent-security.md` - Security best practices
- `claude-agent-testing.md` - Testing strategies

## When to Use

Use this directive when:
- Building custom AI agents with Claude Agent SDK
- Creating custom tools and MCP servers
- Implementing security controls for AI applications
- Writing tests for AI-powered features
- Debugging agent applications

## Technology Stack

### Primary: TypeScript/JavaScript
- **Package:** `@anthropic-ai/claude-agent-sdk`
- **Installation:** `npm install @anthropic-ai/claude-agent-sdk`
- **Type Safety:** Zod for schema validation

### Secondary: Python
- **Package:** `claude-agent-sdk`
- **Installation:** `pip install claude-agent-sdk`
- **Requirements:** Python 3.10+

**Default:** Provide TypeScript examples unless explicitly requested otherwise.

## Quick Start

### Basic Query (TypeScript)

```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";

const result = await query({
  prompt: "Analyze this codebase and suggest improvements",
  options: {
    systemPrompt: { type: "preset", preset: "claude_code" },
    maxTurns: 3
  }
});
```

### Basic Query (Python)

```python
from claude_agent_sdk import query

result = query(
    prompt="Analyze this codebase and suggest improvements",
    options={
        "system_prompt": {"type": "preset", "preset": "claude_code"},
        "max_turns": 3
    }
)
```

## Custom Tools

### Tool Definition (TypeScript)

```typescript
import { z } from "zod";

const tools = {
  analyzeCode: {
    description: "Analyze code for potential issues",
    parameters: z.object({
      code: z.string().describe("Code to analyze"),
      language: z.enum(["typescript", "python", "javascript"])
    }),
    execute: async ({ code, language }) => {
      // Tool implementation
      return { issues: [], suggestions: [] };
    }
  }
};

const result = await query({
  prompt: "Analyze this TypeScript code",
  tools: tools
});
```

### Tool Definition (Python)

```python
from pydantic import BaseModel

class AnalyzeCodeParams(BaseModel):
    code: str
    language: str

async def analyze_code(params: AnalyzeCodeParams):
    # Tool implementation
    return {"issues": [], "suggestions": []}

tools = {
    "analyze_code": {
        "description": "Analyze code for potential issues",
        "parameters": AnalyzeCodeParams,
        "execute": analyze_code
    }
}
```

## Security Best Practices

### 1. Input Sanitization

```typescript
// ✅ GOOD: Sanitize user input
function sanitizeUserInput(input: string): string {
  return input
    .replace(/```[\s\S]*?```/g, '[CODE_BLOCK_REMOVED]')
    .replace(/\[SYSTEM\]/gi, '[SYSTEM_REMOVED]')
    .slice(0, 4000); // Limit length
}

const securePrompt = `
Analyze the following user data:
---
${sanitizeUserInput(userInput)}
---
`;
```

### 2. Tool Permission Controls

```typescript
// ✅ GOOD: Implement permission checks
const tools = {
  deleteFile: {
    description: "Delete a file",
    parameters: z.object({
      path: z.string()
    }),
    execute: async ({ path }, context) => {
      // Check permissions before executing
      if (!context.user.hasPermission('file:delete')) {
        throw new Error('Insufficient permissions');
      }
      
      // Validate path is within allowed directories
      if (!isPathAllowed(path)) {
        throw new Error('Access denied');
      }
      
      await fs.unlink(path);
      return { success: true };
    }
  }
};
```

### 3. API Key Management

```typescript
// ✅ GOOD: Use environment variables
const apiKey = process.env.ANTHROPIC_API_KEY;
if (!apiKey) {
  throw new Error('ANTHROPIC_API_KEY not set');
}

// ❌ BAD: Hardcoded keys
const apiKey = "sk-ant-..."; // Never do this!
```

### 4. Rate Limiting

```typescript
// ✅ GOOD: Implement rate limiting
import { RateLimiter } from 'limiter';

const limiter = new RateLimiter({
  tokensPerInterval: 10,
  interval: 'minute'
});

async function secureQuery(prompt: string) {
  await limiter.removeTokens(1);
  return query({ prompt });
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

const result = await query({
  prompt: "Analyze code and return JSON",
  options: { responseFormat: "json" }
});

const validated = responseSchema.parse(JSON.parse(result.text));
```

## Testing Patterns

### Unit Tests

```typescript
import { describe, it, expect, vi } from 'vitest';

// Test tool logic without Claude SDK
describe('analyzeCode', () => {
  it('should detect syntax errors', async () => {
    const result = await analyzeCodeLogic('const x =', 'typescript');
    expect(result.issues).toContain('Syntax error');
  });
  
  it('should reject empty code', async () => {
    await expect(analyzeCodeLogic('', 'typescript'))
      .rejects.toThrow('Code cannot be empty');
  });
});
```

### Integration Tests with Mocks

```typescript
import { vi } from 'vitest';

// Mock Claude SDK
vi.mock('@anthropic-ai/claude-agent-sdk', () => ({
  query: vi.fn().mockResolvedValue({
    text: 'Mocked response',
    toolCalls: []
  })
}));

describe('AI Integration', () => {
  it('should call Claude with correct prompt', async () => {
    const { query } = await import('@anthropic-ai/claude-agent-sdk');
    
    await analyzeWithClaude('test code');
    
    expect(query).toHaveBeenCalledWith({
      prompt: expect.stringContaining('test code'),
      tools: expect.any(Object)
    });
  });
});
```

### E2E Tests (Sparingly)

```typescript
// Only for critical paths - costs money!
describe('E2E: Code Analysis', () => {
  it('should analyze real code', async () => {
    const result = await query({
      prompt: 'Analyze: const x = 1;',
      options: { maxTurns: 1 }
    });
    
    expect(result.text).toBeDefined();
    expect(result.text.length).toBeGreaterThan(0);
  });
});
```

### Testing Best Practices

**DO:**
- ✅ Test tool functions in isolation
- ✅ Mock Claude SDK for integration tests
- ✅ Use E2E tests sparingly (they cost money)
- ✅ Test error handling and edge cases
- ✅ Validate input/output schemas

**DON'T:**
- ❌ Make real API calls in unit tests
- ❌ Test Claude's responses (non-deterministic)
- ❌ Skip security validation tests
- ❌ Ignore rate limiting in tests

## Error Handling

### Graceful Degradation

```typescript
try {
  const result = await query({ prompt: userPrompt });
  return result.text;
} catch (error) {
  if (error instanceof APIError) {
    if (error.status === 429) {
      return "Rate limit exceeded. Please try again later.";
    }
    if (error.status === 500) {
      return "Service temporarily unavailable.";
    }
  }
  
  // Log error for monitoring
  logger.error('Claude query failed', { error, prompt: userPrompt });
  
  return "An error occurred. Please try again.";
}
```

### Retry Logic

```typescript
async function queryWithRetry(prompt: string, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await query({ prompt });
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      
      // Exponential backoff
      await new Promise(resolve => 
        setTimeout(resolve, Math.pow(2, i) * 1000)
      );
    }
  }
}
```

## Streaming Responses

```typescript
// TypeScript
const stream = await query({
  prompt: "Write a long article",
  options: { stream: true }
});

for await (const chunk of stream) {
  process.stdout.write(chunk.text);
}
```

```python
# Python
stream = query(
    prompt="Write a long article",
    options={"stream": True}
)

for chunk in stream:
    print(chunk.text, end='', flush=True)
```

## Cost Optimization

### 1. Cache Responses

```typescript
const cache = new Map<string, string>();

async function cachedQuery(prompt: string) {
  const cacheKey = hashPrompt(prompt);
  
  if (cache.has(cacheKey)) {
    return cache.get(cacheKey);
  }
  
  const result = await query({ prompt });
  cache.set(cacheKey, result.text);
  
  return result.text;
}
```

### 2. Set Token Limits

```typescript
// Prevent runaway costs
const result = await query({
  prompt: userPrompt,
  options: {
    maxTokens: 1024, // Limit response length
    maxTurns: 3      // Limit conversation turns
  }
});
```

### 3. Monitor Usage

```typescript
let totalTokens = 0;
const MONTHLY_LIMIT = 1000000;

async function monitoredQuery(prompt: string) {
  const result = await query({ prompt });
  
  totalTokens += result.usage.totalTokens;
  
  if (totalTokens > MONTHLY_LIMIT) {
    throw new Error('Monthly token limit exceeded');
  }
  
  return result;
}
```

## Integration Patterns

### Next.js API Route

```typescript
// app/api/analyze/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { query } from '@anthropic-ai/claude-agent-sdk';

export async function POST(req: NextRequest) {
  const { code } = await req.json();
  
  // Validate input
  if (!code || typeof code !== 'string') {
    return NextResponse.json(
      { error: 'Invalid input' },
      { status: 400 }
    );
  }
  
  // Sanitize and query
  const sanitized = sanitizeUserInput(code);
  const result = await query({
    prompt: `Analyze this code:\n${sanitized}`,
    options: { maxTokens: 1024 }
  });
  
  return NextResponse.json({ analysis: result.text });
}
```

### FastAPI Endpoint

```python
from fastapi import FastAPI, HTTPException
from claude_agent_sdk import query

app = FastAPI()

@app.post("/analyze")
async def analyze_code(code: str):
    if not code:
        raise HTTPException(status_code=400, detail="Code required")
    
    result = query(
        prompt=f"Analyze this code:\n{code}",
        options={"max_tokens": 1024}
    )
    
    return {"analysis": result.text}
```

## Resources

**Full Documentation:**
- SDK Usage: `.claude/agents/directives/claude-agent-sdk.md`
- Security: `.claude/agents/directives/claude-agent-security.md`
- Testing: `.claude/agents/directives/claude-agent-testing.md`

**External:**
- Anthropic API Documentation
- Claude Agent SDK GitHub
- Security best practices

