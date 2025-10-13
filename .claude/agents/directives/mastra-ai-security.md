# Mastra AI Framework Security Guidelines

## Overview

This directive provides comprehensive security guidelines for developing secure Mastra AI applications. Multi-provider AI applications have unique security considerations including provider key management, cross-provider data handling, and tool execution security.

## Core Security Principles

### 1. **Multi-Provider Security**
- Secure API key management across multiple providers
- Provider-specific rate limiting and access controls
- Cross-provider data isolation and privacy
- Fallback security when providers fail

### 2. **Zero Trust Architecture**
- Never trust user input without validation
- Validate all tool parameters with Zod schemas
- Implement explicit access controls for each provider
- Monitor all AI interactions across providers

## Provider Security Management

### **Secure API Key Configuration**

```typescript
// ✅ GOOD: Secure multi-provider key management
class SecureProviderManager {
  private static instance: SecureProviderManager;
  private providers: Map<string, any> = new Map();
  
  private constructor() {
    this.initializeProviders();
  }
  
  static getInstance(): SecureProviderManager {
    if (!SecureProviderManager.instance) {
      SecureProviderManager.instance = new SecureProviderManager();
    }
    return SecureProviderManager.instance;
  }
  
  private initializeProviders(): void {
    // Validate all required keys are present
    const requiredKeys = {
      'OPENAI_API_KEY': 'sk-',
      'ANTHROPIC_API_KEY': 'sk-ant-',
      'GOOGLE_API_KEY': 'AIza'
    };
    
    for (const [envVar, prefix] of Object.entries(requiredKeys)) {
      const key = process.env[envVar];
      if (!key) {
        throw new Error(`${envVar} environment variable not set`);
      }
      if (!key.startsWith(prefix)) {
        throw new Error(`Invalid ${envVar} format`);
      }
    }
    
    // Initialize providers with validated keys
    this.providers.set('openai', openai());
    this.providers.set('anthropic', anthropic());
    this.providers.set('google', google());
    
    console.log('All AI providers initialized securely');
  }
  
  getProvider(name: string): any {
    const provider = this.providers.get(name);
    if (!provider) {
      throw new Error(`Provider ${name} not available`);
    }
    return provider;
  }
  
  async rotateKeys(provider: string, newKey: string): Promise<void> {
    // Implement key rotation logic
    console.log(`Rotating keys for provider: ${provider}`);
  }
}
```

### **Provider-Specific Rate Limiting**

```typescript
// ✅ GOOD: Per-provider rate limiting
class ProviderRateLimiter {
  private limits: Map<string, { requests: number; window: number; current: number; resetTime: number }> = new Map();
  
  constructor() {
    // Configure provider-specific limits
    this.limits.set('openai', { requests: 100, window: 60000, current: 0, resetTime: Date.now() + 60000 });
    this.limits.set('anthropic', { requests: 50, window: 60000, current: 0, resetTime: Date.now() + 60000 });
    this.limits.set('google', { requests: 200, window: 60000, current: 0, resetTime: Date.now() + 60000 });
  }
  
  async checkLimit(provider: string, userId: string): Promise<boolean> {
    const limit = this.limits.get(provider);
    if (!limit) return false;
    
    const now = Date.now();
    if (now > limit.resetTime) {
      limit.current = 0;
      limit.resetTime = now + limit.window;
    }
    
    if (limit.current >= limit.requests) {
      await this.logRateLimitExceeded(provider, userId);
      return false;
    }
    
    limit.current++;
    return true;
  }
  
  private async logRateLimitExceeded(provider: string, userId: string): Promise<void> {
    console.warn(`Rate limit exceeded for provider ${provider}, user ${userId}`);
  }
}
```

## Input Validation and Sanitization

### **Multi-Provider Input Validation**

```typescript
// ✅ GOOD: Provider-aware input validation
import { z } from 'zod';

const ProviderInputSchema = z.object({
  message: z.string()
    .min(1, 'Message cannot be empty')
    .max(100000, 'Message too long')
    .refine(msg => !containsMaliciousPatterns(msg), 'Potentially malicious input detected'),
  provider: z.enum(['openai', 'anthropic', 'google']),
  model: z.string().refine(model => isValidModelForProvider(model), 'Invalid model for provider'),
  temperature: z.number().min(0).max(2).optional(),
  maxTokens: z.number().min(1).max(4096).optional()
});

function containsMaliciousPatterns(input: string): boolean {
  const maliciousPatterns = [
    /\[SYSTEM\]/gi,
    /\[ASSISTANT\]/gi,
    /\[HUMAN\]/gi,
    /<script.*?>.*?<\/script>/gi,
    /javascript:/gi,
    /data:text\/html/gi
  ];
  
  return maliciousPatterns.some(pattern => pattern.test(input));
}

function isValidModelForProvider(model: string): boolean {
  const validModels = {
    openai: ['gpt-4o', 'gpt-4o-mini', 'gpt-3.5-turbo'],
    anthropic: ['claude-3-5-sonnet-20241022', 'claude-3-haiku-20240307'],
    google: ['gemini-pro', 'gemini-pro-vision']
  };
  
  return Object.values(validModels).flat().includes(model);
}

// Secure agent creation with validation
function createSecureAgent(config: z.infer<typeof ProviderInputSchema>) {
  const validatedConfig = ProviderInputSchema.parse(config);
  
  const providerManager = SecureProviderManager.getInstance();
  const provider = providerManager.getProvider(validatedConfig.provider);
  
  return new Agent({
    name: `secure-${validatedConfig.provider}-agent`,
    model: provider(validatedConfig.model),
    instructions: sanitizeInstructions(validatedConfig.message),
    tools: getSecureToolsForProvider(validatedConfig.provider)
  });
}
```

## Tool Security Patterns

### **Secure Tool Implementation**

```typescript
// ✅ GOOD: Secure tool with comprehensive validation
const secureFileReadTool = createTool({
  id: "secure-file-read",
  description: "Securely read files from allowed directories",
  inputSchema: z.object({
    filePath: z.string()
      .refine(path => path.startsWith('./src/'), 'Only src/ directory allowed')
      .refine(path => !path.includes('..'), 'Path traversal not allowed')
      .refine(path => !path.includes('node_modules'), 'Node modules access denied')
      .refine(path => path.match(/\.(ts|js|json|md)$/), 'Only specific file types allowed'),
    maxSize: z.number().max(1024 * 1024).default(100000) // 100KB default, 1MB max
  }),
  outputSchema: z.object({
    content: z.string(),
    size: z.number(),
    lastModified: z.string()
  }),
  execute: async ({ context: { filePath, maxSize } }) => {
    // Additional security checks
    const resolvedPath = path.resolve('./src/', filePath);
    const allowedDir = path.resolve('./src/');
    
    if (!resolvedPath.startsWith(allowedDir)) {
      throw new Error('Access denied: Path outside allowed directory');
    }
    
    // Check file exists and get stats
    const stats = await fs.stat(resolvedPath);
    if (stats.size > maxSize) {
      throw new Error(`File too large: ${stats.size} bytes (max: ${maxSize})`);
    }
    
    // Rate limiting per file access
    await enforceFileAccessRateLimit(resolvedPath);
    
    const content = await fs.readFile(resolvedPath, 'utf-8');
    
    // Log access for audit
    await logFileAccess({
      path: filePath,
      size: stats.size,
      timestamp: new Date().toISOString(),
      success: true
    });
    
    return {
      content: content,
      size: stats.size,
      lastModified: stats.mtime.toISOString()
    };
  }
});
```

### **Tool Access Control**

```typescript
// ✅ GOOD: Role-based tool access control
interface UserRole {
  name: string;
  allowedTools: string[];
  allowedProviders: string[];
  maxRequestsPerHour: number;
}

const roles: Record<string, UserRole> = {
  basic: {
    name: 'basic',
    allowedTools: ['search', 'weather'],
    allowedProviders: ['openai'],
    maxRequestsPerHour: 10
  },
  premium: {
    name: 'premium',
    allowedTools: ['search', 'weather', 'file-read', 'code-analysis'],
    allowedProviders: ['openai', 'anthropic'],
    maxRequestsPerHour: 100
  },
  enterprise: {
    name: 'enterprise',
    allowedTools: ['*'], // All tools
    allowedProviders: ['openai', 'anthropic', 'google'],
    maxRequestsPerHour: 1000
  }
};

function createRoleBasedAgent(userId: string, userRole: string, provider: string) {
  const role = roles[userRole];
  if (!role) {
    throw new Error(`Invalid role: ${userRole}`);
  }
  
  if (!role.allowedProviders.includes(provider)) {
    throw new Error(`Provider ${provider} not allowed for role ${userRole}`);
  }
  
  // Filter tools based on role
  const availableTools = getAllTools().filter(tool => 
    role.allowedTools.includes('*') || role.allowedTools.includes(tool.id)
  );
  
  return new Agent({
    name: `${userRole}-agent-${userId}`,
    model: getProviderModel(provider),
    instructions: `You are an assistant with ${userRole} access level.`,
    tools: Object.fromEntries(availableTools.map(tool => [tool.id, tool]))
  });
}
```

## Cross-Provider Security

### **Provider Isolation**

```typescript
// ✅ GOOD: Secure cross-provider data handling
class SecureMultiProviderAgent {
  private providers: Map<string, Agent> = new Map();
  private dataIsolation: Map<string, Set<string>> = new Map();
  
  constructor(userId: string, allowedProviders: string[]) {
    for (const provider of allowedProviders) {
      this.providers.set(provider, this.createProviderAgent(provider, userId));
      this.dataIsolation.set(provider, new Set());
    }
  }
  
  async processWithProvider(
    provider: string, 
    message: string, 
    sensitiveData?: string[]
  ): Promise<string> {
    const agent = this.providers.get(provider);
    if (!agent) {
      throw new Error(`Provider ${provider} not available`);
    }
    
    // Check data isolation rules
    if (sensitiveData) {
      const providerData = this.dataIsolation.get(provider) || new Set();
      const hasConflict = sensitiveData.some(data => 
        Array.from(this.dataIsolation.values())
          .some(otherSet => otherSet !== providerData && otherSet.has(data))
      );
      
      if (hasConflict) {
        throw new Error('Data isolation violation: sensitive data already used with different provider');
      }
      
      // Mark data as used with this provider
      sensitiveData.forEach(data => providerData.add(data));
    }
    
    // Sanitize message for provider
    const sanitizedMessage = this.sanitizeForProvider(message, provider);
    
    const response = await agent.generate(sanitizedMessage);
    
    // Filter response for sensitive information
    return this.filterSensitiveOutput(response.text, provider);
  }
  
  private sanitizeForProvider(message: string, provider: string): string {
    // Provider-specific sanitization rules
    const sanitizationRules = {
      openai: (msg: string) => msg.replace(/\[SYSTEM\]/gi, '[INSTRUCTION]'),
      anthropic: (msg: string) => msg.replace(/Human:/gi, 'User:'),
      google: (msg: string) => msg.replace(/<[^>]*>/g, '') // Remove HTML tags
    };
    
    const sanitizer = sanitizationRules[provider as keyof typeof sanitizationRules];
    return sanitizer ? sanitizer(message) : message;
  }
  
  private filterSensitiveOutput(output: string, provider: string): string {
    // Remove potential API keys, tokens, etc.
    const sensitivePatterns = [
      /sk-[a-zA-Z0-9]{48}/g, // OpenAI keys
      /sk-ant-[a-zA-Z0-9-]{95}/g, // Anthropic keys
      /AIza[a-zA-Z0-9-_]{35}/g, // Google API keys
      /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g, // Emails
      /\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b/g // Credit cards
    ];
    
    let filtered = output;
    sensitivePatterns.forEach(pattern => {
      filtered = filtered.replace(pattern, '[REDACTED]');
    });
    
    return filtered;
  }
}
```

## Evaluation and Monitoring Security

### **Security Evaluation Metrics**

```typescript
// ✅ GOOD: Security-focused evaluation metrics
class SecurityEvaluationMetric {
  constructor(private model: any) {}
  
  async measure(input: string, output: string): Promise<{
    score: number;
    issues: string[];
    severity: 'low' | 'medium' | 'high' | 'critical';
  }> {
    const securityChecks = await Promise.all([
      this.checkForDataLeaks(output),
      this.checkForInjectionAttempts(input),
      this.checkForMaliciousContent(output),
      this.checkForPrivacyViolations(output)
    ]);
    
    const issues = securityChecks.flatMap(check => check.issues);
    const maxSeverity = this.getMaxSeverity(securityChecks);
    const score = this.calculateSecurityScore(securityChecks);
    
    return {
      score,
      issues,
      severity: maxSeverity
    };
  }
  
  private async checkForDataLeaks(output: string): Promise<{
    issues: string[];
    severity: 'low' | 'medium' | 'high' | 'critical';
  }> {
    const dataLeakPatterns = [
      { pattern: /sk-[a-zA-Z0-9]{48}/, severity: 'critical' as const, type: 'API Key' },
      { pattern: /password[:\s=]+\S+/gi, severity: 'high' as const, type: 'Password' },
      { pattern: /token[:\s=]+\S+/gi, severity: 'medium' as const, type: 'Token' }
    ];
    
    const issues: string[] = [];
    let maxSeverity: 'low' | 'medium' | 'high' | 'critical' = 'low';
    
    for (const { pattern, severity, type } of dataLeakPatterns) {
      if (pattern.test(output)) {
        issues.push(`Potential ${type} leak detected`);
        if (this.severityLevel(severity) > this.severityLevel(maxSeverity)) {
          maxSeverity = severity;
        }
      }
    }
    
    return { issues, severity: maxSeverity };
  }
  
  private severityLevel(severity: string): number {
    const levels = { low: 1, medium: 2, high: 3, critical: 4 };
    return levels[severity as keyof typeof levels] || 0;
  }
}

// Use security metrics with agents
const secureAgent = new Agent({
  name: "secure-agent",
  model: openai("gpt-4o"),
  instructions: "You are a secure assistant.",
  evals: {
    security: new SecurityEvaluationMetric(openai("gpt-4o-mini"))
  }
});
```

## Deployment Security

### **Environment Security Configuration**

```typescript
// ✅ GOOD: Secure deployment configuration
interface SecurityConfig {
  enableRateLimiting: boolean;
  enableInputValidation: boolean;
  enableOutputFiltering: boolean;
  allowedProviders: string[];
  maxRequestsPerUser: number;
  enableAuditLogging: boolean;
  encryptionEnabled: boolean;
}

function loadSecurityConfig(): SecurityConfig {
  const config: SecurityConfig = {
    enableRateLimiting: process.env.ENABLE_RATE_LIMITING !== 'false',
    enableInputValidation: process.env.ENABLE_INPUT_VALIDATION !== 'false',
    enableOutputFiltering: process.env.ENABLE_OUTPUT_FILTERING !== 'false',
    allowedProviders: process.env.ALLOWED_PROVIDERS?.split(',') || ['openai'],
    maxRequestsPerUser: parseInt(process.env.MAX_REQUESTS_PER_USER || '100'),
    enableAuditLogging: process.env.ENABLE_AUDIT_LOGGING === 'true',
    encryptionEnabled: process.env.ENCRYPTION_ENABLED === 'true'
  };
  
  // Validate configuration
  if (config.maxRequestsPerUser < 1 || config.maxRequestsPerUser > 10000) {
    throw new Error('Invalid maxRequestsPerUser configuration');
  }
  
  if (config.allowedProviders.length === 0) {
    throw new Error('At least one provider must be allowed');
  }
  
  return config;
}

// Secure middleware for Express.js
function createSecurityMiddleware(config: SecurityConfig) {
  return async (req: any, res: any, next: any) => {
    try {
      // Rate limiting
      if (config.enableRateLimiting) {
        const rateLimiter = new ProviderRateLimiter();
        const allowed = await rateLimiter.checkLimit('global', req.ip);
        if (!allowed) {
          return res.status(429).json({ error: 'Rate limit exceeded' });
        }
      }
      
      // Input validation
      if (config.enableInputValidation && req.body) {
        const sanitized = sanitizeInput(req.body);
        req.body = sanitized;
      }
      
      // Audit logging
      if (config.enableAuditLogging) {
        await logSecurityEvent({
          type: 'api_request',
          ip: req.ip,
          userAgent: req.get('User-Agent'),
          endpoint: req.path,
          timestamp: new Date().toISOString()
        });
      }
      
      next();
    } catch (error) {
      console.error('Security middleware error:', error);
      res.status(500).json({ error: 'Security check failed' });
    }
  };
}
```

## Security Checklist

### **Pre-Deployment Security Review**

- [ ] **Provider Security**
  - [ ] All API keys stored securely in environment variables
  - [ ] Provider-specific rate limiting implemented
  - [ ] Key rotation procedures documented and tested
  - [ ] Provider fallback security measures in place

- [ ] **Input/Output Security**
  - [ ] All inputs validated with Zod schemas
  - [ ] Malicious pattern detection implemented
  - [ ] Output filtering for sensitive data enabled
  - [ ] Cross-provider data isolation enforced

- [ ] **Tool Security**
  - [ ] Tools follow principle of least privilege
  - [ ] File system access properly restricted
  - [ ] Role-based access control implemented
  - [ ] Tool execution monitoring enabled

- [ ] **Monitoring and Compliance**
  - [ ] Security evaluation metrics configured
  - [ ] Audit logging enabled for all interactions
  - [ ] Security alerts and monitoring set up
  - [ ] Compliance requirements documented and met

### **Common Security Mistakes to Avoid**

- ❌ **NEVER** store API keys in code or version control
- ❌ **NEVER** trust user input without validation
- ❌ **NEVER** allow unrestricted cross-provider data sharing
- ❌ **NEVER** disable security controls in production
- ❌ **NEVER** ignore security evaluation results
- ❌ **NEVER** log sensitive data in plain text

## Related Resources

- **Main Development Guide**: `.claude/agents/directives/mastra-ai-framework.md`
- **Testing Patterns**: `.claude/agents/directives/mastra-ai-testing.md`
- **Claude Agent Security**: `.claude/agents/directives/claude-agent-security.md`
- **Development Server Management**: `.claude/agents/directives/development-server-management.md`
