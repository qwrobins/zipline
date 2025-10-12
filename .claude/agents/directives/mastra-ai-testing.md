# Mastra AI Framework Testing Patterns

## Overview

This directive provides comprehensive testing strategies for Mastra AI applications. Testing multi-provider AI applications requires specialized patterns that handle provider differences, cost optimization, and non-deterministic responses.

## Testing Philosophy

### **Multi-Provider Testing Challenges**
- **Provider differences**: Different models may give different valid responses
- **Cost optimization**: Testing across multiple providers can be expensive
- **Provider availability**: Services may be down or rate-limited
- **Non-deterministic responses**: Same input may yield different outputs
- **Cross-provider consistency**: Ensuring behavior consistency across providers

### **Testing Strategy Pyramid**

```
    E2E Tests (Few)
   ├─ Real multi-provider testing
   ├─ Full integration scenarios
   └─ Production-like workflows

  Integration Tests (Some)
 ├─ Mocked provider responses
 ├─ Tool execution testing
 ├─ Workflow coordination
 └─ MCP server integration

Unit Tests (Many)
├─ Tool function testing
├─ Provider configuration
├─ Input validation
├─ Utility functions
└─ Security controls
```

## Unit Testing Patterns

### **Testing Tool Functions in Isolation**

```typescript
import { describe, it, expect, vi } from 'vitest';
import { z } from 'zod';

// Extract tool logic for testing
export async function analyzeCodeLogic(
  code: string, 
  language: string,
  provider: 'openai' | 'anthropic' | 'google'
) {
  if (!code.trim()) {
    throw new Error('Code cannot be empty');
  }
  
  const supportedLanguages = ['typescript', 'javascript', 'python'];
  if (!supportedLanguages.includes(language)) {
    throw new Error(`Unsupported language: ${language}`);
  }
  
  const supportedProviders = ['openai', 'anthropic', 'google'];
  if (!supportedProviders.includes(provider)) {
    throw new Error(`Unsupported provider: ${provider}`);
  }
  
  // Provider-specific analysis logic
  const analysisConfig = {
    openai: { focus: 'performance', depth: 'detailed' },
    anthropic: { focus: 'security', depth: 'comprehensive' },
    google: { focus: 'best-practices', depth: 'moderate' }
  };
  
  const config = analysisConfig[provider];
  return {
    complexity: calculateComplexity(code),
    issues: findIssues(code, language, config),
    suggestions: generateSuggestions(code, config),
    provider: provider
  };
}

// Tool wrapper
const codeAnalysisTool = createTool({
  id: "analyze-code",
  description: "Analyze code quality with provider-specific insights",
  inputSchema: z.object({
    code: z.string().min(1),
    language: z.enum(['typescript', 'javascript', 'python']),
    provider: z.enum(['openai', 'anthropic', 'google']).default('openai')
  }),
  execute: async ({ context }) => {
    const result = await analyzeCodeLogic(
      context.code, 
      context.language, 
      context.provider
    );
    return {
      content: [{
        type: "text",
        text: JSON.stringify(result, null, 2)
      }]
    };
  }
});

// Unit tests
describe('analyzeCodeLogic', () => {
  it('should analyze valid TypeScript code with OpenAI', async () => {
    const code = 'function hello(): string { return "world"; }';
    const result = await analyzeCodeLogic(code, 'typescript', 'openai');
    
    expect(result.complexity).toBeGreaterThan(0);
    expect(result.provider).toBe('openai');
    expect(result.issues).toBeInstanceOf(Array);
  });
  
  it('should handle different providers differently', async () => {
    const code = 'function test() { console.log("test"); }';
    
    const openaiResult = await analyzeCodeLogic(code, 'javascript', 'openai');
    const anthropicResult = await analyzeCodeLogic(code, 'javascript', 'anthropic');
    
    expect(openaiResult.provider).toBe('openai');
    expect(anthropicResult.provider).toBe('anthropic');
    // Provider-specific analysis may differ
  });
  
  it('should throw error for unsupported provider', async () => {
    await expect(analyzeCodeLogic('code', 'typescript', 'invalid' as any))
      .rejects.toThrow('Unsupported provider');
  });
});
```

### **Testing Provider Configuration**

```typescript
// ✅ GOOD: Test provider setup and validation
describe('ProviderManager', () => {
  beforeEach(() => {
    // Reset environment
    delete process.env.OPENAI_API_KEY;
    delete process.env.ANTHROPIC_API_KEY;
    delete process.env.GOOGLE_API_KEY;
  });
  
  it('should initialize with valid API keys', () => {
    process.env.OPENAI_API_KEY = 'sk-test123';
    process.env.ANTHROPIC_API_KEY = 'sk-ant-test123';
    process.env.GOOGLE_API_KEY = 'AIzatest123';
    
    expect(() => new ProviderManager()).not.toThrow();
  });
  
  it('should throw error for missing API keys', () => {
    expect(() => new ProviderManager())
      .toThrow('OPENAI_API_KEY environment variable not set');
  });
  
  it('should validate API key formats', () => {
    process.env.OPENAI_API_KEY = 'invalid-key';
    
    expect(() => new ProviderManager())
      .toThrow('Invalid OPENAI_API_KEY format');
  });
  
  it('should provide fallback providers', () => {
    const manager = new ProviderManager();
    const fallback = manager.getFallbackProvider('openai');
    
    expect(fallback).toBe('anthropic');
  });
});
```

### **Testing Input Validation Schemas**

```typescript
// ✅ GOOD: Test Zod schemas for multi-provider inputs
describe('MultiProviderInputSchema', () => {
  const validInput = {
    message: 'Test message',
    provider: 'openai' as const,
    model: 'gpt-4o',
    temperature: 0.7
  };
  
  it('should validate correct multi-provider input', () => {
    const result = MultiProviderInputSchema.parse(validInput);
    expect(result.provider).toBe('openai');
    expect(result.model).toBe('gpt-4o');
  });
  
  it('should reject invalid provider', () => {
    const invalidInput = { ...validInput, provider: 'invalid' };
    expect(() => MultiProviderInputSchema.parse(invalidInput))
      .toThrow();
  });
  
  it('should validate provider-model combinations', () => {
    const invalidCombination = { 
      ...validInput, 
      provider: 'anthropic' as const,
      model: 'gpt-4o' // OpenAI model with Anthropic provider
    };
    
    expect(() => MultiProviderInputSchema.parse(invalidCombination))
      .toThrow('Invalid model for provider');
  });
  
  it('should apply provider-specific defaults', () => {
    const anthropicInput = {
      message: 'Test',
      provider: 'anthropic' as const
    };
    
    const result = MultiProviderInputSchema.parse(anthropicInput);
    expect(result.model).toBe('claude-3-5-sonnet-20241022'); // Default for Anthropic
  });
});
```

## Integration Testing with Mocks

### **Mocking Multi-Provider Responses**

```typescript
// ✅ GOOD: Mock different provider responses
import { vi, describe, it, expect, beforeEach } from 'vitest';

// Mock provider modules
vi.mock('@ai-sdk/openai', () => ({
  openai: vi.fn(() => ({
    provider: 'openai',
    model: 'gpt-4o'
  }))
}));

vi.mock('@ai-sdk/anthropic', () => ({
  anthropic: vi.fn(() => ({
    provider: 'anthropic',
    model: 'claude-3-5-sonnet-20241022'
  }))
}));

// Mock Mastra Agent
vi.mock('@mastra/core/agent', () => ({
  Agent: vi.fn().mockImplementation((config) => ({
    name: config.name,
    model: config.model,
    generate: vi.fn(),
    stream: vi.fn()
  }))
}));

describe('Multi-Provider Agent Integration', () => {
  let mockOpenAIAgent: any;
  let mockAnthropicAgent: any;
  
  beforeEach(() => {
    vi.clearAllMocks();
    
    mockOpenAIAgent = {
      generate: vi.fn(),
      stream: vi.fn()
    };
    
    mockAnthropicAgent = {
      generate: vi.fn(),
      stream: vi.fn()
    };
  });
  
  it('should handle successful responses from different providers', async () => {
    // Mock provider-specific responses
    mockOpenAIAgent.generate.mockResolvedValue({
      text: 'OpenAI response: The code looks good.',
      provider: 'openai'
    });
    
    mockAnthropicAgent.generate.mockResolvedValue({
      text: 'Claude response: I notice some security concerns.',
      provider: 'anthropic'
    });
    
    const openaiResult = await mockOpenAIAgent.generate('Analyze this code');
    const anthropicResult = await mockAnthropicAgent.generate('Analyze this code');
    
    expect(openaiResult.text).toContain('OpenAI response');
    expect(anthropicResult.text).toContain('Claude response');
    expect(openaiResult.provider).toBe('openai');
    expect(anthropicResult.provider).toBe('anthropic');
  });
  
  it('should handle provider failures with fallback', async () => {
    // Mock primary provider failure
    mockOpenAIAgent.generate.mockRejectedValue(new Error('OpenAI API unavailable'));
    
    // Mock fallback provider success
    mockAnthropicAgent.generate.mockResolvedValue({
      text: 'Fallback response from Claude',
      provider: 'anthropic'
    });
    
    // Test fallback logic
    let result;
    try {
      result = await mockOpenAIAgent.generate('Test message');
    } catch (error) {
      result = await mockAnthropicAgent.generate('Test message');
    }
    
    expect(result.text).toContain('Fallback response');
    expect(result.provider).toBe('anthropic');
  });
});
```

### **Testing Workflow Coordination**

```typescript
// ✅ GOOD: Test multi-agent workflows
describe('Multi-Agent Workflow', () => {
  it('should coordinate multiple agents in sequence', async () => {
    const mockResearchAgent = {
      generate: vi.fn().mockResolvedValue({
        text: 'Research findings: TypeScript is popular',
        data: { popularity: 95, trends: ['increasing'] }
      })
    };
    
    const mockWriterAgent = {
      generate: vi.fn().mockResolvedValue({
        text: 'Article: TypeScript continues to grow...',
        wordCount: 500
      })
    };
    
    const mockEditorAgent = {
      generate: vi.fn().mockResolvedValue({
        text: 'Edited: TypeScript continues its remarkable growth...',
        changes: ['improved clarity', 'fixed grammar']
      })
    };
    
    // Simulate workflow execution
    const researchResult = await mockResearchAgent.generate('Research TypeScript trends');
    const writeResult = await mockWriterAgent.generate(`Write article based on: ${researchResult.text}`);
    const finalResult = await mockEditorAgent.generate(`Edit this article: ${writeResult.text}`);
    
    expect(mockResearchAgent.generate).toHaveBeenCalledWith('Research TypeScript trends');
    expect(mockWriterAgent.generate).toHaveBeenCalledWith(expect.stringContaining('Research findings'));
    expect(mockEditorAgent.generate).toHaveBeenCalledWith(expect.stringContaining('Article:'));
    expect(finalResult.text).toContain('Edited:');
  });
});
```

## End-to-End Testing

### **Cost-Effective Multi-Provider E2E Testing**

```typescript
// ✅ GOOD: E2E tests with cost optimization
describe('E2E Multi-Provider Testing', () => {
  const runE2E = process.env.RUN_E2E_TESTS === 'true';
  const testProvider = process.env.E2E_TEST_PROVIDER || 'openai'; // Single provider for E2E
  
  it.skipIf(!runE2E)('should perform real analysis with selected provider', async () => {
    const mastra = new Mastra({
      agents: {
        analyst: new Agent({
          name: 'test-analyst',
          model: getProviderModel(testProvider),
          instructions: 'Analyze the provided code briefly.',
          tools: { codeAnalysisTool }
        })
      }
    });
    
    const agent = mastra.getAgent('analyst');
    const result = await agent.generate(
      'Analyze this function: function add(a, b) { return a + b; }'
    );
    
    expect(result.text).toBeDefined();
    expect(result.text.length).toBeGreaterThan(10);
  }, 30000);
  
  it.skipIf(!runE2E)('should handle provider switching', async () => {
    const providers = ['openai', 'anthropic'];
    const results = [];
    
    for (const provider of providers) {
      if (!isProviderAvailable(provider)) continue;
      
      const agent = new Agent({
        name: `test-${provider}`,
        model: getProviderModel(provider),
        instructions: 'Respond with your provider name.'
      });
      
      const result = await agent.generate('What provider are you?');
      results.push({ provider, response: result.text });
    }
    
    expect(results.length).toBeGreaterThan(0);
    results.forEach(result => {
      expect(result.response).toBeDefined();
    });
  }, 60000);
});
```

### **Provider Availability Testing**

```typescript
// ✅ GOOD: Test provider health and availability
describe('Provider Health Checks', () => {
  const providers = ['openai', 'anthropic', 'google'];
  
  providers.forEach(provider => {
    it(`should check ${provider} availability`, async () => {
      const healthCheck = new ProviderHealthChecker();
      const isHealthy = await healthCheck.checkProvider(provider);
      
      if (isHealthy) {
        console.log(`✅ ${provider} is available`);
      } else {
        console.warn(`⚠️ ${provider} is unavailable`);
      }
      
      // Don't fail test if provider is down, just log
      expect(typeof isHealthy).toBe('boolean');
    });
  });
  
  it('should have at least one provider available', async () => {
    const healthCheck = new ProviderHealthChecker();
    const availableProviders = await healthCheck.getAvailableProviders();
    
    expect(availableProviders.length).toBeGreaterThan(0);
  });
});

class ProviderHealthChecker {
  async checkProvider(provider: string): Promise<boolean> {
    try {
      const agent = new Agent({
        name: `health-${provider}`,
        model: getProviderModel(provider),
        instructions: 'Respond with "OK"'
      });
      
      const result = await agent.generate('Health check');
      return result.text.length > 0;
    } catch (error) {
      console.warn(`Provider ${provider} health check failed:`, error.message);
      return false;
    }
  }
  
  async getAvailableProviders(): Promise<string[]> {
    const providers = ['openai', 'anthropic', 'google'];
    const checks = await Promise.allSettled(
      providers.map(p => this.checkProvider(p))
    );
    
    return providers.filter((_, index) => 
      checks[index].status === 'fulfilled' && checks[index].value
    );
  }
}
```

## Performance and Load Testing

### **Multi-Provider Performance Testing**

```typescript
// ✅ GOOD: Test performance across providers
describe('Multi-Provider Performance', () => {
  it('should measure response times across providers', async () => {
    const providers = ['openai', 'anthropic'];
    const results = new Map<string, number>();
    
    for (const provider of providers) {
      const startTime = Date.now();
      
      try {
        const agent = new Agent({
          name: `perf-${provider}`,
          model: getProviderModel(provider),
          instructions: 'Respond briefly.'
        });
        
        await agent.generate('Hello');
        const duration = Date.now() - startTime;
        results.set(provider, duration);
        
        console.log(`${provider}: ${duration}ms`);
      } catch (error) {
        console.warn(`${provider} failed:`, error.message);
      }
    }
    
    // Verify at least one provider responded within reasonable time
    const fastestTime = Math.min(...Array.from(results.values()));
    expect(fastestTime).toBeLessThan(10000); // 10 seconds max
  });
  
  it('should handle concurrent requests across providers', async () => {
    const concurrentRequests = 3;
    const providers = ['openai', 'anthropic'];
    
    const promises = providers.flatMap(provider =>
      Array.from({ length: concurrentRequests }, (_, i) =>
        createTestRequest(provider, `Request ${i}`)
      )
    );
    
    const results = await Promise.allSettled(promises);
    const successful = results.filter(r => r.status === 'fulfilled');
    
    expect(successful.length).toBeGreaterThan(0);
    console.log(`${successful.length}/${results.length} requests succeeded`);
  });
});

async function createTestRequest(provider: string, message: string) {
  const agent = new Agent({
    name: `concurrent-${provider}`,
    model: getProviderModel(provider),
    instructions: 'Respond briefly to the message.'
  });
  
  return await agent.generate(message);
}
```

## Test Data Management

### **Provider-Specific Test Data**

```typescript
// ✅ GOOD: Manage test data for different providers
export class MultiProviderTestDataGenerator {
  static generateTestCases(): Array<{
    input: string;
    expectedPatterns: Record<string, RegExp>;
    providers: string[];
  }> {
    return [
      {
        input: 'Explain TypeScript interfaces',
        expectedPatterns: {
          openai: /interface|type|TypeScript/i,
          anthropic: /interface|contract|structure/i,
          google: /interface|definition|TypeScript/i
        },
        providers: ['openai', 'anthropic', 'google']
      },
      {
        input: 'What is async/await?',
        expectedPatterns: {
          openai: /async|await|Promise/i,
          anthropic: /asynchronous|Promise|await/i,
          google: /async|await|JavaScript/i
        },
        providers: ['openai', 'anthropic', 'google']
      }
    ];
  }
  
  static generateProviderConfigs(): Record<string, {
    model: string;
    temperature: number;
    maxTokens: number;
  }> {
    return {
      openai: {
        model: 'gpt-4o-mini',
        temperature: 0.3,
        maxTokens: 500
      },
      anthropic: {
        model: 'claude-3-haiku-20240307',
        temperature: 0.3,
        maxTokens: 500
      },
      google: {
        model: 'gemini-pro',
        temperature: 0.3,
        maxTokens: 500
      }
    };
  }
  
  static getTestEnvironmentConfig(): {
    enabledProviders: string[];
    testMode: 'unit' | 'integration' | 'e2e';
    costLimit: number;
  } {
    return {
      enabledProviders: process.env.TEST_PROVIDERS?.split(',') || ['openai'],
      testMode: (process.env.TEST_MODE as any) || 'unit',
      costLimit: parseFloat(process.env.TEST_COST_LIMIT || '1.0') // $1 default
    };
  }
}
```

### **Cost Tracking for Tests**

```typescript
// ✅ GOOD: Track and limit testing costs
class TestCostTracker {
  private costs: Map<string, number> = new Map();
  private limits: Map<string, number> = new Map();
  
  constructor() {
    // Set cost limits per provider (in USD)
    this.limits.set('openai', 0.50);
    this.limits.set('anthropic', 0.30);
    this.limits.set('google', 0.20);
  }
  
  async trackRequest(provider: string, inputTokens: number, outputTokens: number): Promise<void> {
    const cost = this.calculateCost(provider, inputTokens, outputTokens);
    const currentCost = this.costs.get(provider) || 0;
    const newTotal = currentCost + cost;
    
    this.costs.set(provider, newTotal);
    
    const limit = this.limits.get(provider) || 1.0;
    if (newTotal > limit) {
      throw new Error(`Test cost limit exceeded for ${provider}: $${newTotal.toFixed(4)} > $${limit}`);
    }
    
    console.log(`${provider} cost: $${cost.toFixed(4)} (total: $${newTotal.toFixed(4)})`);
  }
  
  private calculateCost(provider: string, inputTokens: number, outputTokens: number): number {
    const pricing = {
      openai: { input: 0.00015, output: 0.0006 }, // GPT-4o-mini per 1K tokens
      anthropic: { input: 0.00025, output: 0.00125 }, // Claude 3 Haiku per 1K tokens
      google: { input: 0.000125, output: 0.000375 } // Gemini Pro per 1K tokens
    };
    
    const rates = pricing[provider as keyof typeof pricing] || { input: 0.001, output: 0.002 };
    return (inputTokens * rates.input + outputTokens * rates.output) / 1000;
  }
  
  getTotalCost(): number {
    return Array.from(this.costs.values()).reduce((sum, cost) => sum + cost, 0);
  }
  
  getCostByProvider(): Record<string, number> {
    return Object.fromEntries(this.costs);
  }
}
```

## Testing Checklist

### **Pre-Deployment Testing**

- [ ] **Unit Tests**
  - [ ] All tool functions tested in isolation
  - [ ] Provider configuration validation tested
  - [ ] Input validation schemas tested
  - [ ] Multi-provider logic tested

- [ ] **Integration Tests**
  - [ ] Mocked provider responses tested
  - [ ] Workflow coordination tested
  - [ ] MCP server integration tested
  - [ ] Fallback mechanisms tested

- [ ] **Performance Tests**
  - [ ] Response time requirements met across providers
  - [ ] Concurrent request handling tested
  - [ ] Provider availability monitoring implemented
  - [ ] Cost tracking and limits verified

- [ ] **E2E Tests**
  - [ ] Critical user journeys tested with real providers
  - [ ] Provider switching scenarios tested
  - [ ] Cost-effective test strategy implemented
  - [ ] Error recovery across providers verified

### **Common Testing Mistakes to Avoid**

- ❌ **NEVER** run expensive E2E tests on every commit
- ❌ **NEVER** test with production API keys
- ❌ **NEVER** ignore provider-specific differences
- ❌ **NEVER** skip cost tracking in tests
- ❌ **NEVER** test only one provider in isolation
- ❌ **NEVER** forget to test fallback scenarios

## Related Resources

- **Main Development Guide**: `.claude/agents/directives/mastra-ai-framework.md`
- **Security Guidelines**: `.claude/agents/directives/mastra-ai-security.md`
- **Claude Agent Testing**: `.claude/agents/directives/claude-agent-testing.md`
- **Development Server Management**: `.claude/agents/directives/development-server-management.md`
