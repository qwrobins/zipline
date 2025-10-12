# AI Integration Guide

## Overview

This guide covers integrating AI capabilities into applications using Claude Agent SDK and Mastra AI framework.

## When to Use Each Framework

### Claude Agent SDK

**Use when:**
- Building single-provider AI applications
- Need deep Claude-specific features
- Want official Anthropic support
- Prefer TypeScript/Python native integration

**Best for:**
- Custom AI tools and agents
- Claude-powered chatbots
- Document processing with Claude
- Code generation assistants

### Mastra AI Framework

**Use when:**
- Need multi-provider support (Claude, OpenAI, Google)
- Want cost optimization across providers
- Require provider fallback/redundancy
- Building complex AI orchestration

**Best for:**
- Production AI applications
- Cost-sensitive deployments
- Multi-model workflows
- Provider-agnostic systems

## Claude Agent SDK Integration

### Quick Start

**Installation:**
```bash
# TypeScript/JavaScript
npm install @anthropic-ai/sdk

# Python
pip install anthropic
```

**Basic Usage (TypeScript):**
```typescript
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

const message = await client.messages.create({
  model: 'claude-sonnet-4-5-20250929',
  max_tokens: 1024,
  messages: [
    { role: 'user', content: 'Hello, Claude!' }
  ],
});

console.log(message.content);
```

**Basic Usage (Python):**
```python
import anthropic

client = anthropic.Anthropic(
    api_key=os.environ.get("ANTHROPIC_API_KEY"),
)

message = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Hello, Claude!"}
    ]
)

print(message.content)
```

### Custom Tools

**TypeScript Tool Definition:**
```typescript
import { z } from 'zod';

const tools = [
  {
    name: 'get_weather',
    description: 'Get current weather for a location',
    input_schema: {
      type: 'object',
      properties: {
        location: {
          type: 'string',
          description: 'City name or coordinates',
        },
        unit: {
          type: 'string',
          enum: ['celsius', 'fahrenheit'],
          description: 'Temperature unit',
        },
      },
      required: ['location'],
    },
  },
];

const message = await client.messages.create({
  model: 'claude-sonnet-4-5-20250929',
  max_tokens: 1024,
  tools: tools,
  messages: [
    { role: 'user', content: 'What is the weather in San Francisco?' }
  ],
});
```

**Python Tool Definition:**
```python
tools = [
    {
        "name": "get_weather",
        "description": "Get current weather for a location",
        "input_schema": {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "City name or coordinates"
                },
                "unit": {
                    "type": "string",
                    "enum": ["celsius", "fahrenheit"],
                    "description": "Temperature unit"
                }
            },
            "required": ["location"]
        }
    }
]

message = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=1024,
    tools=tools,
    messages=[
        {"role": "user", "content": "What is the weather in San Francisco?"}
    ]
)
```

### Streaming Responses

**TypeScript:**
```typescript
const stream = await client.messages.stream({
  model: 'claude-sonnet-4-5-20250929',
  max_tokens: 1024,
  messages: [
    { role: 'user', content: 'Write a story' }
  ],
});

for await (const chunk of stream) {
  if (chunk.type === 'content_block_delta') {
    process.stdout.write(chunk.delta.text);
  }
}
```

**Python:**
```python
with client.messages.stream(
    model="claude-sonnet-4-5-20250929",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Write a story"}
    ]
) as stream:
    for chunk in stream:
        if chunk.type == 'content_block_delta':
            print(chunk.delta.text, end='', flush=True)
```

### Error Handling

**TypeScript:**
```typescript
try {
  const message = await client.messages.create({...});
} catch (error) {
  if (error instanceof Anthropic.APIError) {
    console.error('API Error:', error.status, error.message);
  } else {
    console.error('Unexpected error:', error);
  }
}
```

**Python:**
```python
from anthropic import APIError

try:
    message = client.messages.create(...)
except APIError as e:
    print(f"API Error: {e.status_code} - {e.message}")
except Exception as e:
    print(f"Unexpected error: {e}")
```

## Mastra AI Framework Integration

### Quick Start

**Installation:**
```bash
npm install @mastra/core
```

**Basic Setup:**
```typescript
import { Mastra } from '@mastra/core';
import { AnthropicProvider } from '@mastra/anthropic';
import { OpenAIProvider } from '@mastra/openai';

const mastra = new Mastra({
  providers: [
    new AnthropicProvider({
      apiKey: process.env.ANTHROPIC_API_KEY,
      model: 'claude-sonnet-4-5-20250929',
    }),
    new OpenAIProvider({
      apiKey: process.env.OPENAI_API_KEY,
      model: 'gpt-4',
    }),
  ],
  defaultProvider: 'anthropic',
});
```

### Multi-Provider Usage

**With Fallback:**
```typescript
const response = await mastra.generate({
  prompt: 'Explain quantum computing',
  providers: ['anthropic', 'openai'], // Try Anthropic first, fallback to OpenAI
  maxTokens: 1024,
});
```

**Cost Optimization:**
```typescript
const response = await mastra.generate({
  prompt: 'Simple task',
  providers: ['openai'], // Use cheaper provider for simple tasks
  maxTokens: 256,
});

const complexResponse = await mastra.generate({
  prompt: 'Complex analysis task',
  providers: ['anthropic'], // Use Claude for complex reasoning
  maxTokens: 4096,
});
```

### Tool Integration

**Define Tools:**
```typescript
const tools = {
  searchDatabase: {
    description: 'Search the database for information',
    parameters: {
      query: { type: 'string', required: true },
      limit: { type: 'number', default: 10 },
    },
    execute: async ({ query, limit }) => {
      // Implementation
      return await database.search(query, limit);
    },
  },
};

const response = await mastra.generate({
  prompt: 'Find users named John',
  tools: tools,
  providers: ['anthropic'],
});
```

### Streaming with Mastra

```typescript
const stream = await mastra.generateStream({
  prompt: 'Write a long article',
  providers: ['anthropic'],
  maxTokens: 4096,
});

for await (const chunk of stream) {
  process.stdout.write(chunk.text);
}
```

## Integration Patterns

### Next.js API Routes

**Claude SDK:**
```typescript
// app/api/chat/route.ts
import { NextRequest, NextResponse } from 'next/server';
import Anthropic from '@anthropic-ai/sdk';

export async function POST(req: NextRequest) {
  const { message } = await req.json();
  
  const client = new Anthropic({
    apiKey: process.env.ANTHROPIC_API_KEY,
  });
  
  const response = await client.messages.create({
    model: 'claude-sonnet-4-5-20250929',
    max_tokens: 1024,
    messages: [{ role: 'user', content: message }],
  });
  
  return NextResponse.json({ response: response.content });
}
```

**Mastra:**
```typescript
// app/api/chat/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { mastra } from '@/lib/mastra';

export async function POST(req: NextRequest) {
  const { message } = await req.json();
  
  const response = await mastra.generate({
    prompt: message,
    providers: ['anthropic', 'openai'],
    maxTokens: 1024,
  });
  
  return NextResponse.json({ response: response.text });
}
```

### FastAPI Integration

**Claude SDK:**
```python
from fastapi import FastAPI
from anthropic import Anthropic

app = FastAPI()
client = Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))

@app.post("/chat")
async def chat(message: str):
    response = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        max_tokens=1024,
        messages=[{"role": "user", "content": message}]
    )
    return {"response": response.content}
```

### NestJS Integration

**Claude SDK:**
```typescript
import { Injectable } from '@nestjs/common';
import Anthropic from '@anthropic-ai/sdk';

@Injectable()
export class ClaudeService {
  private client: Anthropic;
  
  constructor() {
    this.client = new Anthropic({
      apiKey: process.env.ANTHROPIC_API_KEY,
    });
  }
  
  async chat(message: string) {
    const response = await this.client.messages.create({
      model: 'claude-sonnet-4-5-20250929',
      max_tokens: 1024,
      messages: [{ role: 'user', content: message }],
    });
    
    return response.content;
  }
}
```

## Best Practices

### Security

- ✅ Store API keys in environment variables
- ✅ Never commit API keys to version control
- ✅ Use server-side API calls only
- ✅ Implement rate limiting
- ✅ Validate user inputs
- ✅ Sanitize AI outputs

### Performance

- ✅ Cache responses when appropriate
- ✅ Use streaming for long responses
- ✅ Implement timeouts
- ✅ Handle errors gracefully
- ✅ Monitor token usage
- ✅ Optimize prompt length

### Cost Optimization

- ✅ Use appropriate models for task complexity
- ✅ Implement caching strategies
- ✅ Set reasonable max_tokens limits
- ✅ Monitor and alert on usage
- ✅ Use cheaper providers for simple tasks
- ✅ Batch requests when possible

## Testing AI Integrations

**Mock Responses:**
```typescript
import { vi } from 'vitest';

vi.mock('@anthropic-ai/sdk', () => ({
  default: vi.fn(() => ({
    messages: {
      create: vi.fn().mockResolvedValue({
        content: [{ text: 'Mocked response' }],
      }),
    },
  })),
}));
```

**Integration Tests:**
```typescript
describe('AI Integration', () => {
  it('should generate response', async () => {
    const response = await generateAIResponse('test prompt');
    expect(response).toBeDefined();
    expect(response.length).toBeGreaterThan(0);
  });
});
```

## Resources

**Official Documentation:**
- Claude SDK: `agents/directives/claude-agent-sdk.md`
- Mastra Framework: `agents/directives/mastra-ai-framework.md`
- Security: `agents/directives/claude-agent-security.md`
- Testing: `agents/directives/claude-agent-testing.md`

**External Links:**
- Anthropic API Documentation
- Mastra AI Documentation
- Best practices guides

