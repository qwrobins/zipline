# Claude Agent Testing Patterns

## Overview

This directive provides comprehensive testing strategies for Claude Agent SDK applications. Testing AI applications requires specialized patterns that differ significantly from traditional software testing.

## Testing Philosophy

### **AI-Specific Testing Challenges**
- **Non-deterministic responses**: Claude may provide different valid answers
- **Cost considerations**: API calls cost money during testing
- **Latency**: Real API calls can be slow
- **Rate limits**: API throttling affects test execution
- **Context sensitivity**: Responses depend on conversation history

### **Testing Strategy Pyramid**

```
    E2E Tests (Few)
   ├─ Real Claude API
   ├─ Full integration
   └─ Production scenarios

  Integration Tests (Some)
 ├─ Mocked Claude responses
 ├─ Tool execution testing
 └─ Hook behavior verification

Unit Tests (Many)
├─ Tool function testing
├─ Input validation
├─ Utility functions
└─ Configuration logic
```

## Unit Testing Patterns

### **Testing Tool Functions in Isolation**

```typescript
// ✅ GOOD: Test tool logic without Claude SDK
import { describe, it, expect, vi } from 'vitest';

// Tool function extracted for testing
export async function analyzeCodeLogic(code: string, language: string) {
  if (!code.trim()) {
    throw new Error('Code cannot be empty');
  }
  
  if (!['typescript', 'javascript', 'python'].includes(language)) {
    throw new Error('Unsupported language');
  }
  
  // Analysis logic here
  return {
    complexity: calculateComplexity(code),
    issues: findIssues(code, language),
    suggestions: generateSuggestions(code)
  };
}

// Tool wrapper that uses the logic
@tool("analyze_code", "Analyze code quality", {
  code: z.string().min(1),
  language: z.enum(['typescript', 'javascript', 'python'])
})
async function analyzeCode(args: { code: string; language: string }) {
  const result = await analyzeCodeLogic(args.code, args.language);
  return {
    content: [{
      type: "text",
      text: JSON.stringify(result, null, 2)
    }]
  };
}

// Unit tests for the logic
describe('analyzeCodeLogic', () => {
  it('should analyze valid TypeScript code', async () => {
    const code = 'function hello() { return "world"; }';
    const result = await analyzeCodeLogic(code, 'typescript');
    
    expect(result.complexity).toBeGreaterThan(0);
    expect(result.issues).toBeInstanceOf(Array);
    expect(result.suggestions).toBeInstanceOf(Array);
  });
  
  it('should throw error for empty code', async () => {
    await expect(analyzeCodeLogic('', 'typescript'))
      .rejects.toThrow('Code cannot be empty');
  });
  
  it('should throw error for unsupported language', async () => {
    await expect(analyzeCodeLogic('code', 'ruby'))
      .rejects.toThrow('Unsupported language');
  });
});
```

### **Testing Input Validation**

```typescript
// ✅ GOOD: Test Zod schema validation
import { z } from 'zod';

const FileAnalysisSchema = z.object({
  filePath: z.string()
    .min(1, 'File path cannot be empty')
    .refine(path => path.startsWith('./src/'), 'Must be in src directory')
    .refine(path => !path.includes('..'), 'Path traversal not allowed'),
  maxLines: z.number().min(1).max(10000).default(1000)
});

describe('FileAnalysisSchema', () => {
  it('should validate correct input', () => {
    const input = { filePath: './src/utils.ts', maxLines: 500 };
    const result = FileAnalysisSchema.parse(input);
    expect(result.filePath).toBe('./src/utils.ts');
    expect(result.maxLines).toBe(500);
  });
  
  it('should reject path traversal attempts', () => {
    const input = { filePath: './src/../config.ts' };
    expect(() => FileAnalysisSchema.parse(input))
      .toThrow('Path traversal not allowed');
  });
  
  it('should apply default maxLines', () => {
    const input = { filePath: './src/utils.ts' };
    const result = FileAnalysisSchema.parse(input);
    expect(result.maxLines).toBe(1000);
  });
});
```

### **Testing Hook Functions**

```typescript
// ✅ GOOD: Test hook logic separately
export async function validateBashCommand(command: string): Promise<{
  allowed: boolean;
  reason?: string;
}> {
  const dangerousPatterns = ['rm -rf', 'sudo', 'eval'];
  
  for (const pattern of dangerousPatterns) {
    if (command.includes(pattern)) {
      return {
        allowed: false,
        reason: `Dangerous pattern detected: ${pattern}`
      };
    }
  }
  
  return { allowed: true };
}

// Hook wrapper
async function securityPreToolUseHook(input_data: any) {
  if (input_data.tool_name === 'Bash') {
    const validation = await validateBashCommand(input_data.tool_input.command);
    
    if (!validation.allowed) {
      return {
        hookSpecificOutput: {
          hookEventName: "PreToolUse",
          permissionDecision: "deny",
          permissionDecisionReason: validation.reason,
        }
      };
    }
  }
  
  return {};
}

describe('validateBashCommand', () => {
  it('should allow safe commands', async () => {
    const result = await validateBashCommand('ls -la');
    expect(result.allowed).toBe(true);
    expect(result.reason).toBeUndefined();
  });
  
  it('should block dangerous commands', async () => {
    const result = await validateBashCommand('rm -rf /');
    expect(result.allowed).toBe(false);
    expect(result.reason).toContain('rm -rf');
  });
  
  it('should block sudo commands', async () => {
    const result = await validateBashCommand('sudo apt install');
    expect(result.allowed).toBe(false);
    expect(result.reason).toContain('sudo');
  });
});
```

## Integration Testing with Mocks

### **Mocking Claude SDK Responses**

```typescript
// ✅ GOOD: Mock Claude SDK for integration tests
import { vi, describe, it, expect, beforeEach } from 'vitest';
import { query } from '@anthropic-ai/claude-agent-sdk';

// Mock the Claude SDK
vi.mock('@anthropic-ai/claude-agent-sdk', () => ({
  query: vi.fn(),
  createSdkMcpServer: vi.fn()
}));

const mockQuery = vi.mocked(query);

describe('Claude Agent Integration', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });
  
  it('should handle successful tool execution', async () => {
    // Mock successful response
    const mockMessages = [
      {
        type: 'tool_use',
        tool_name: 'analyze_code',
        tool_input: { code: 'test code', language: 'typescript' }
      },
      {
        type: 'result',
        subtype: 'success',
        result: { complexity: 5, issues: [] }
      }
    ];
    
    mockQuery.mockImplementation(async function* () {
      for (const message of mockMessages) {
        yield message;
      }
    });
    
    const results = [];
    for await (const message of query({
      prompt: 'Analyze this code',
      options: { maxTurns: 1 }
    })) {
      results.push(message);
    }
    
    expect(results).toHaveLength(2);
    expect(results[1].result.complexity).toBe(5);
  });
  
  it('should handle tool execution errors', async () => {
    const mockMessages = [
      {
        type: 'tool_use',
        tool_name: 'analyze_code',
        tool_input: { code: '', language: 'typescript' }
      },
      {
        type: 'result',
        subtype: 'error',
        error: 'Code cannot be empty'
      }
    ];
    
    mockQuery.mockImplementation(async function* () {
      for (const message of mockMessages) {
        yield message;
      }
    });
    
    const results = [];
    for await (const message of query({
      prompt: 'Analyze empty code',
      options: { maxTurns: 1 }
    })) {
      results.push(message);
    }
    
    expect(results[1].subtype).toBe('error');
    expect(results[1].error).toContain('empty');
  });
});
```

### **Testing Tool Registration and Execution**

```typescript
// ✅ GOOD: Test MCP server configuration
import { createSdkMcpServer } from '@anthropic-ai/claude-agent-sdk';

describe('MCP Server Configuration', () => {
  it('should register tools correctly', () => {
    const server = createSdkMcpServer({
      name: 'test-server',
      version: '1.0.0',
      tools: [analyzeCode, readFile]
    });
    
    expect(server.name).toBe('test-server');
    expect(server.version).toBe('1.0.0');
    // Additional assertions based on SDK API
  });
  
  it('should validate tool configurations', () => {
    expect(() => {
      createSdkMcpServer({
        name: '', // Invalid empty name
        tools: []
      });
    }).toThrow();
  });
});
```

## End-to-End Testing

### **Testing with Real Claude API**

```typescript
// ✅ GOOD: E2E tests with real API (use sparingly)
import { query, ClaudeAgentOptions } from '@anthropic-ai/claude-agent-sdk';

describe('E2E Claude Integration', () => {
  // Only run E2E tests when explicitly requested
  const runE2E = process.env.RUN_E2E_TESTS === 'true';
  
  it.skipIf(!runE2E)('should perform real code analysis', async () => {
    const options: ClaudeAgentOptions = {
      mcpServers: { 'analyzer': codeAnalyzerServer },
      allowedTools: ['mcp__analyzer__analyze_code'],
      maxTurns: 1
    };
    
    const results = [];
    for await (const message of query({
      prompt: 'Analyze this TypeScript function: function add(a: number, b: number) { return a + b; }',
      options
    })) {
      results.push(message);
    }
    
    // Verify we got a meaningful response
    expect(results.length).toBeGreaterThan(0);
    
    const finalResult = results[results.length - 1];
    expect(finalResult.type).toBe('result');
    expect(finalResult.subtype).toBe('success');
  }, 30000); // Longer timeout for real API calls
});
```

### **Cost-Effective E2E Testing**

```typescript
// ✅ GOOD: Minimize API costs in E2E tests
class E2ETestManager {
  private static testResults = new Map<string, any>();
  
  static async runWithCaching(
    testName: string,
    testFn: () => Promise<any>
  ): Promise<any> {
    // Use cached results to avoid repeated API calls
    if (this.testResults.has(testName)) {
      return this.testResults.get(testName);
    }
    
    const result = await testFn();
    this.testResults.set(testName, result);
    return result;
  }
  
  static clearCache(): void {
    this.testResults.clear();
  }
}

describe('E2E with Caching', () => {
  afterAll(() => {
    E2ETestManager.clearCache();
  });
  
  it('should analyze code (cached)', async () => {
    const result = await E2ETestManager.runWithCaching(
      'basic-code-analysis',
      async () => {
        // Expensive API call here
        return await performRealAnalysis();
      }
    );
    
    expect(result).toBeDefined();
  });
});
```

## Performance Testing

### **Response Time Testing**

```typescript
// ✅ GOOD: Test response times and timeouts
describe('Performance Tests', () => {
  it('should complete analysis within reasonable time', async () => {
    const startTime = Date.now();
    
    const results = [];
    for await (const message of query({
      prompt: 'Quick analysis of: const x = 1;',
      options: { maxTurns: 1 }
    })) {
      results.push(message);
    }
    
    const duration = Date.now() - startTime;
    expect(duration).toBeLessThan(10000); // 10 seconds max
  });
  
  it('should handle timeout gracefully', async () => {
    const timeoutPromise = new Promise((_, reject) => {
      setTimeout(() => reject(new Error('Test timeout')), 5000);
    });
    
    const queryPromise = query({
      prompt: 'Complex analysis that might take long...',
      options: { maxTurns: 1 }
    });
    
    await expect(Promise.race([
      Array.fromAsync(queryPromise),
      timeoutPromise
    ])).rejects.toThrow('Test timeout');
  });
});
```

### **Load Testing**

```typescript
// ✅ GOOD: Test concurrent requests
describe('Load Testing', () => {
  it('should handle multiple concurrent requests', async () => {
    const concurrentRequests = 5;
    const promises = Array.from({ length: concurrentRequests }, (_, i) =>
      Array.fromAsync(query({
        prompt: `Test request ${i}`,
        options: { maxTurns: 1 }
      }))
    );
    
    const results = await Promise.allSettled(promises);
    
    // Verify all requests completed
    const successful = results.filter(r => r.status === 'fulfilled');
    expect(successful.length).toBeGreaterThan(0);
    
    // Some might fail due to rate limits, which is expected
    console.log(`${successful.length}/${concurrentRequests} requests succeeded`);
  });
});
```

## Test Data Management

### **Creating Realistic Test Data**

```typescript
// ✅ GOOD: Structured test data generation
export class TestDataGenerator {
  static generateCodeSamples(): Array<{
    code: string;
    language: string;
    expectedComplexity: number;
    expectedIssues: string[];
  }> {
    return [
      {
        code: 'function simple() { return 42; }',
        language: 'typescript',
        expectedComplexity: 1,
        expectedIssues: []
      },
      {
        code: `
          function complex(a, b, c) {
            if (a > 0) {
              for (let i = 0; i < b; i++) {
                if (i % 2 === 0) {
                  console.log(c);
                }
              }
            } else {
              return null;
            }
          }
        `,
        language: 'javascript',
        expectedComplexity: 5,
        expectedIssues: ['missing-return-type', 'console-log']
      }
    ];
  }
  
  static generatePrompts(): Array<{
    prompt: string;
    expectedToolCalls: string[];
    category: 'analysis' | 'generation' | 'refactoring';
  }> {
    return [
      {
        prompt: 'Analyze this code for issues',
        expectedToolCalls: ['analyze_code'],
        category: 'analysis'
      },
      {
        prompt: 'Generate a TypeScript interface for user data',
        expectedToolCalls: ['generate_interface'],
        category: 'generation'
      }
    ];
  }
}
```

### **Environment-Specific Test Configuration**

```typescript
// ✅ GOOD: Environment-aware test configuration
interface TestConfig {
  useRealAPI: boolean;
  apiTimeout: number;
  maxConcurrentTests: number;
  enableE2ETests: boolean;
  testDataPath: string;
}

function getTestConfig(): TestConfig {
  const env = process.env.NODE_ENV || 'test';
  
  const configs: Record<string, TestConfig> = {
    test: {
      useRealAPI: false,
      apiTimeout: 5000,
      maxConcurrentTests: 10,
      enableE2ETests: false,
      testDataPath: './test-data'
    },
    e2e: {
      useRealAPI: true,
      apiTimeout: 30000,
      maxConcurrentTests: 3,
      enableE2ETests: true,
      testDataPath: './e2e-test-data'
    },
    ci: {
      useRealAPI: false,
      apiTimeout: 10000,
      maxConcurrentTests: 5,
      enableE2ETests: false,
      testDataPath: './ci-test-data'
    }
  };
  
  return configs[env] || configs.test;
}
```

## Testing Checklist

### **Pre-Deployment Testing**

- [ ] **Unit Tests**
  - [ ] All tool functions tested in isolation
  - [ ] Input validation schemas tested
  - [ ] Hook logic tested separately
  - [ ] Utility functions have 100% coverage

- [ ] **Integration Tests**
  - [ ] Tool registration and configuration tested
  - [ ] Mocked Claude responses handled correctly
  - [ ] Error scenarios covered
  - [ ] Hook integration tested

- [ ] **Performance Tests**
  - [ ] Response time requirements met
  - [ ] Timeout handling verified
  - [ ] Concurrent request handling tested
  - [ ] Memory usage within limits

- [ ] **E2E Tests**
  - [ ] Critical user journeys tested with real API
  - [ ] Cost-effective test strategy implemented
  - [ ] Production-like environment tested
  - [ ] Error recovery scenarios verified

### **Common Testing Mistakes to Avoid**

- ❌ **NEVER** run expensive E2E tests in every CI run
- ❌ **NEVER** test with production API keys
- ❌ **NEVER** ignore flaky tests due to AI non-determinism
- ❌ **NEVER** test only happy path scenarios
- ❌ **NEVER** skip testing error conditions
- ❌ **NEVER** forget to test rate limiting and timeouts

## Related Resources

- **Main Development Guide**: `.claude/agents/directives/claude-agent-sdk.md`
- **Security Guidelines**: `.claude/agents/directives/claude-agent-security.md`
- **Development Server Management**: `.claude/agents/directives/development-server-management.md`
