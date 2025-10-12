# AI Framework Selection Guide

This guide provides comprehensive information for selecting and configuring AI frameworks in projects.

## Framework Options

### Claude Agent SDK

**Best for:**
- Simple, straightforward AI needs
- Teams new to AI development
- Projects specifically requiring Anthropic/Claude features
- Single-provider approach is acceptable
- Budget allows for Claude pricing

**Key Features:**
- Direct integration with Claude models
- Custom MCP tool creation
- Streaming responses
- Built-in security patterns
- Simple setup and configuration

**Documentation:** See `agents/directives/claude-sdk.md`

### Mastra AI Framework

**Best for:**
- High availability with provider fallbacks
- Cost optimization (switch to cheaper providers for simple tasks)
- Multi-agent workflows with different models
- Flexibility to switch providers in the future
- Complex AI orchestration requirements

**Key Features:**
- Multi-provider support (OpenAI, Anthropic, Google)
- Automatic fallback handling
- Cost optimization strategies
- Multi-agent workflows
- Provider abstraction layer

**Documentation:** See `agents/directives/mastra-framework.md`

## AI Provider Comparison

### OpenAI (Most Popular)

**Strengths:**
- Excellent for coding and general tasks
- Multimodal capabilities (text + images)
- Large ecosystem and community support

**Models:**
- **GPT-4o** (Recommended): Best overall performance, ~$2.50 per 1M tokens
- **GPT-4o Mini** (Budget): Fast and cost-effective, ~$0.15 per 1M tokens

**Cost:** Moderate, good performance/price ratio

### Anthropic Claude (Best Reasoning)

**Strengths:**
- Superior complex reasoning and analysis
- Safety-focused design
- Excellent for long-form content

**Models:**
- **Claude Sonnet** (Recommended): Best overall, ~$3 per 1M tokens
- **Claude Haiku** (Budget): Fast and economical, ~$0.25 per 1M tokens

**Cost:** Moderate to high, excellent quality

### Google Gemini (Most Affordable)

**Strengths:**
- Fast response times
- Cost-effective for high-volume usage
- Good for simple tasks

**Models:**
- **Gemini Pro** (Recommended): Best balance, ~$0.50 per 1M tokens
- **Gemini Pro Vision** (Multimodal): Text and images, ~$0.50 per 1M tokens

**Cost:** Low, great for high-volume usage

## Configuration Options

### Temperature Settings

- **0.0-0.3**: Deterministic, factual responses (documentation, analysis)
- **0.4-0.7**: Balanced creativity and consistency (most applications)
- **0.8-1.0**: Creative, varied responses (content generation, brainstorming)

**Default:** 0.7 for most applications

### Fallback Providers

**Recommended for production:**
- Prevents downtime if primary provider has issues
- Automatic failover to backup provider
- Adds complexity but improves reliability

**Configuration:**
- Primary provider for normal operations
- Fallback provider for high availability
- Cost-optimized fallback for budget constraints

### Multi-Agent Workflows

**Use cases:**
- Different models for different tasks (research vs writing)
- Specialized agents for specific domains
- Cost optimization (expensive models for complex tasks, cheap for simple)

**Configuration:**
- Define agent roles and responsibilities
- Assign appropriate models to each agent
- Configure communication patterns

## Detection Patterns

### AI Requirements in Product Briefs

**Conversational AI:**
- Keywords: "chatbot", "AI assistant", "virtual assistant", "conversational interface"

**Content Generation:**
- Keywords: "content generation", "text generation", "writing assistant", "summarization"

**Code Analysis:**
- Keywords: "code analysis", "code review", "code generation", "AI-powered IDE"

**Natural Language Processing:**
- Keywords: "NLP", "natural language", "sentiment analysis", "text classification"

**AI-Powered Features:**
- Keywords: "AI-powered", "machine learning", "intelligent", "smart recommendations"

**Model Integration:**
- Keywords: "LLM", "language model", "GPT", "Claude", "AI model"

### Framework Detection

**Claude Agent SDK:**
- Keywords: "Claude Agent SDK", "Anthropic Claude", "claude-agent-sdk"

**Mastra:**
- Keywords: "Mastra", "Mastra AI", "multi-provider AI", "provider fallback"

**OpenAI:**
- Keywords: "OpenAI", "GPT-4", "gpt-4o", "ChatGPT"

**Google:**
- Keywords: "Google Gemini", "Gemini Pro", "Google AI"

### Model Detection

**Claude Models:**
- "claude-3-5-sonnet", "claude-3-5-haiku", "claude-3-opus"

**OpenAI Models:**
- "gpt-4o", "gpt-4o-mini", "gpt-4-turbo", "gpt-3.5-turbo"

**Google Models:**
- "gemini-pro", "gemini-pro-vision", "gemini-ultra"

### Configuration Detection

**Temperature:**
- Patterns: "temperature 0.7", "temp=0.5"

**Provider Preferences:**
- Patterns: "primary provider", "fallback to", "backup provider"

**Cost Considerations:**
- Patterns: "cost optimization", "budget constraints", "cheaper models"

**Multi-Agent:**
- Patterns: "different models for different tasks", "specialized agents"

## Recommendations by Project Type

### Simple Business Applications
- **Framework:** Claude Agent SDK
- **Provider:** OpenAI GPT-4o
- **Temperature:** 0.7
- **Fallback:** Optional

### High-Volume Applications
- **Framework:** Mastra AI
- **Primary:** Google Gemini Pro (cost-effective)
- **Fallback:** OpenAI GPT-4o Mini
- **Temperature:** 0.5

### Complex Reasoning Applications
- **Framework:** Mastra AI
- **Primary:** Anthropic Claude Sonnet
- **Fallback:** OpenAI GPT-4o
- **Temperature:** 0.7

### Multi-Agent Systems
- **Framework:** Mastra AI (required)
- **Research Agent:** Claude Sonnet (0.7)
- **Writing Agent:** GPT-4o (0.8)
- **Analysis Agent:** Claude Sonnet (0.3)

## Configuration Validation

### Required Fields
- Framework choice (Claude Agent SDK or Mastra AI)
- Primary model specification
- Temperature setting (default 0.7 if not specified)

### Optional Fields
- Fallback provider (recommended for production)
- Multi-agent setup
- Custom tools configuration
- Cost optimization preferences

### Compatibility Checks
- Verify model names are current and available
- Check provider/model compatibility
- Ensure framework supports selected features
- Validate temperature range (0.0-1.0)

## Cost Estimation

**Reference:** 1M tokens ≈ 750,000 words of text

**Example Costs (per 1M tokens):**
- GPT-4o: ~$2.50
- GPT-4o Mini: ~$0.15
- Claude Sonnet: ~$3.00
- Claude Haiku: ~$0.25
- Gemini Pro: ~$0.50

**Optimization Strategies:**
- Use cheaper models for simple tasks
- Implement caching for repeated queries
- Configure fallback to cost-effective providers
- Monitor usage and adjust model selection

