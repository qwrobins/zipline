# Quick Agent Creation Guide

**Purpose**: Step-by-step checklist for creating new workflow-integrated agents by merging our template with acca/ expertise.

**Time per agent**: ~70 minutes

---

## Prerequisites

- [ ] Identify the language/domain for the new agent
- [ ] Locate the corresponding acca/ agent(s)
- [ ] Have a sample user story ready for testing

---

## Step 1: Copy Template (10 minutes)

### 1.1 Copy Base File

```bash
# For language-specific agents
cp agents/javascript-developer.md agents/[language]-developer.md

# Examples:
cp agents/javascript-developer.md agents/python-developer.md
cp agents/javascript-developer.md agents/go-developer.md
cp agents/javascript-developer.md agents/rust-developer.md
```

### 1.2 Update YAML Frontmatter

```yaml
---
name: [language]-developer
description: Use this agent when you need to implement features, fix bugs, or refactor code in [Language] projects, especially those using [Framework1], [Framework2], or [Framework3]. This agent is an expert in modern [Language] ecosystem development with deep knowledge of best practices, common patterns, and tooling. Examples:

<example>
Context: User needs to implement a [Language] component with proper types.
user: "Create a reusable [Component] in [Language] with [Framework]."
assistant: "I'll use the [language]-developer agent to create a properly typed [Language] component following best practices."
</example>

[Add 2-3 more examples specific to the language]

model: sonnet
---
```

### 1.3 Global Find & Replace

**Find and replace these terms throughout the file**:

| Find | Replace |
|------|---------|
| `javascript-developer` | `[language]-developer` |
| `JavaScript/TypeScript` | `[Language]` |
| `React, Next.js` | `[Framework1, Framework2]` |
| `npm, yarn, pnpm` | `[package-manager]` |
| `Jest, Vitest` | `[test-framework]` |
| `ESLint, Prettier` | `[linter, formatter]` |

**Example for Python**:
- `JavaScript/TypeScript` → `Python`
- `React, Next.js` → `Django, FastAPI, Flask`
- `npm, yarn, pnpm` → `pip, poetry, conda`
- `Jest, Vitest` → `pytest, unittest`
- `ESLint, Prettier` → `ruff, black`

---

## Step 2: Review acca/ Agent (20 minutes)

### 2.1 Open Corresponding acca/ Agent

```bash
# Find the agent
find acca/categories -name "*[language]*.md"

# Examples:
# acca/categories/02-language-specialists/python-pro.md
# acca/categories/02-language-specialists/golang-pro.md
# acca/categories/02-language-specialists/rust-engineer.md
```

### 2.2 Extract Key Sections

**Copy these sections to a scratch file**:

```markdown
## From acca/[language]-pro.md

### Language Mastery
[Copy the language-specific features section]

### Framework Expertise
[Copy framework/library expertise]

### Performance Optimization
[Copy performance patterns]

### Testing Methodology
[Copy testing approaches]

### Common Patterns
[Copy design patterns and best practices]

### Tools & Ecosystem
[Copy tool listings]

### Checklists
[Copy quality checklists]
```

### 2.3 Identify Best Features

**Mark sections to integrate**:
- ✅ Language-specific features (e.g., Python 3.12+, Go generics, Rust ownership)
- ✅ Framework patterns (e.g., Django ORM, Gin routing, Actix actors)
- ✅ Performance techniques (e.g., async patterns, memory optimization)
- ✅ Testing frameworks and patterns
- ✅ Common pitfalls and solutions
- ✅ Tool recommendations

---

## Step 3: Integrate acca/ Content (30 minutes)

### 3.1 Update "Core Expertise" Section

**Location**: Right after the opening paragraph

**Add**:
```markdown
## Your Core Expertise

### Languages & Runtimes
- **[Language] [Version]+**: [Key features from acca/]
- **Type System**: [Type system details from acca/]
- **[Runtime/VM]**: [Runtime details from acca/]

### Frameworks & Libraries
- **[Framework1]**: [Key features from acca/]
- **[Framework2]**: [Key features from acca/]
- **[Framework3]**: [Key features from acca/]
- **Testing**: [Testing frameworks from acca/]

### Tooling & Ecosystem
- **Package Managers**: [From acca/]
- **Build Tools**: [From acca/]
- **Code Quality**: [From acca/]
- **Testing**: [From acca/]
```

### 3.2 Add Language-Specific Best Practices Section

**Location**: After "Development Workflow" section, before "Testing & Quality"

**Add new section**:
```markdown
## [Language]-Specific Best Practices

### Modern [Language] Features
[Copy from acca/ - language features]

### Performance Optimization
[Copy from acca/ - performance section]

### [Framework1] Best Practices
[Copy from acca/ - framework patterns]

### [Framework2] Patterns
[Copy from acca/ - framework patterns]

### Common Patterns
[Copy from acca/ - design patterns]

### Error Handling
[Copy from acca/ - error handling patterns]

### Concurrency/Async Patterns
[Copy from acca/ - async patterns if applicable]
```

### 3.3 Update Testing Section

**Location**: Find the "Testing & Quality" section

**Enhance with**:
```markdown
### Testing Frameworks & Tools
- **[Primary Test Framework]**: [Details from acca/]
- **Coverage**: [Coverage tools from acca/] with >85% target
- **Mocking**: [Mocking libraries from acca/]
- **Integration**: [Integration testing approaches from acca/]
- **Performance**: [Performance testing tools from acca/]

### Testing Patterns
[Copy testing patterns from acca/]
```

### 3.4 Update Examples

**Find all code examples** and replace with language-appropriate syntax:

```markdown
Example query for [Language]:
```[language]
[Language-specific code example]
```

Example [Framework] implementation:
```[language]
[Framework-specific code example]
```
```

---

## Step 4: Validate (10 minutes)

### 4.1 Mandatory Sections Checklist

**Verify these sections are UNCHANGED**:
- [ ] ⚠️ CRITICAL WORKFLOW REQUIREMENTS (lines ~39-74)
- [ ] Development Workflow - Step 1: Understand the Codebase
- [ ] Development Workflow - Step 2: Consult Official Documentation
- [ ] Development Workflow - Step 3: Plan with Sequential Thinking
- [ ] Development Workflow - Step 4: Implement
- [ ] Development Workflow - Step 5: Test Thoroughly
- [ ] Development Workflow - Step 6: Review and Refactor
- [ ] Development Workflow - Step 7: Update Documentation
- [ ] Development Workflow - Step 8: Update User Story Status
- [ ] Problem-Solving Protocol section
- [ ] User Story Integration section

### 4.2 Customization Checklist

**Verify these are properly customized**:
- [ ] Agent name in frontmatter
- [ ] Description with language-specific examples
- [ ] Core Expertise section has language details
- [ ] Framework references are correct
- [ ] Tool names are correct (package manager, test framework, etc.)
- [ ] Code examples use correct syntax
- [ ] Testing frameworks are language-appropriate
- [ ] Performance patterns are language-specific

### 4.3 Quality Checklist

- [ ] No references to JavaScript/TypeScript remain (unless relevant)
- [ ] No references to React/Next.js remain (unless relevant)
- [ ] All code examples are syntactically correct
- [ ] Tool names are spelled correctly
- [ ] Framework versions are current
- [ ] No broken markdown formatting
- [ ] File is 600-900 lines
- [ ] All sections are complete

---

## Step 5: Test (10 minutes)

### 5.1 Create Test User Story

Create a simple user story in `docs/stories/test-[language]-agent.md`:

```markdown
# Test Story: [Language] Feature Implementation

**Status**: Approved

## User Story
As a developer, I want to implement a simple [feature] in [Language] so that I can validate the [language]-developer agent.

## Acceptance Criteria
- [ ] AC1: Implement [simple feature]
- [ ] AC2: Add unit tests
- [ ] AC3: Follow [Language] best practices

## Dev Notes
- Use [Framework]
- Follow [Language] conventions
- Ensure type safety
```

### 5.2 Test the Agent

```bash
# In Claude Code, invoke the agent
/agents [language]-developer

# Provide the test user story
# Verify the agent:
# - Uses sequential_thinking
# - Consults context7 for documentation
# - Implements correctly
# - Writes tests
# - Updates story status
```

### 5.3 Verify Output

- [ ] Agent used sequential_thinking before coding
- [ ] Agent consulted context7 for framework docs
- [ ] Code is syntactically correct
- [ ] Code follows language best practices
- [ ] Tests are included
- [ ] Story status updated to "Ready for Review"
- [ ] Dev Agent Record section filled out

---

## Step 6: Document (10 minutes)

### 6.1 Update agents/README.md

Add to the Development Agents section:

```markdown
### [N]. [language]-developer
**Purpose**: Implements features and fixes bugs in [Language] projects using [Framework1], [Framework2], or [Framework3]

**Technology Stack**: [Language] [Version]+, [Framework1], [Framework2], testing frameworks

**When to Use**:
- Implementing [Language] components
- Creating [Framework] applications
- Building [Language] backend services
- Fixing bugs in [Language] codebases
- Refactoring [Language] code for better performance
- Setting up testing infrastructure

**Key Features**:
- Modern [Language] patterns
- [Framework1] best practices
- [Framework2] expertise
- Type-safe development
- Performance optimization techniques
- Comprehensive testing strategies

**Documentation**: See [DEVELOPMENT_AGENTS.md](./DEVELOPMENT_AGENTS.md) for detailed usage guide.
```

### 6.2 Update CHANGELOG.md

```markdown
## [Date] - Added [language]-developer

### Added
- New [language]-developer agent for [Language] development
- Integrated best practices from acca/[language]-pro
- Support for [Framework1], [Framework2], [Framework3]
- Comprehensive [Language]-specific testing guidance
- Performance optimization patterns for [Language]

### Enhanced
- [Any enhancements to existing agents]
```

### 6.3 Create Agent-Specific Documentation (Optional)

If the agent has unique features, create `agents/[LANGUAGE]_DEVELOPER_GUIDE.md`

---

## Common Pitfalls to Avoid

### ❌ Don't Remove Mandatory Sections
- Never remove ⚠️ CRITICAL WORKFLOW REQUIREMENTS
- Never remove Development Workflow steps
- Never remove Problem-Solving Protocol
- Never remove User Story Integration

### ❌ Don't Break Workflow Integration
- Keep sequential_thinking requirements
- Keep context7 consultation requirements
- Keep retry mechanisms
- Keep status update requirements

### ❌ Don't Copy Generic Content from acca/
- Skip generic "when invoked" sections
- Skip basic workflow descriptions
- Skip anything that conflicts with our protocols

### ✅ Do Integrate Domain Expertise
- Language-specific features
- Framework patterns
- Performance techniques
- Testing methodologies
- Tool recommendations

---

## Quick Reference: Language-Specific Mappings

### Python
- **acca/ source**: `acca/categories/02-language-specialists/python-pro.md`
- **Frameworks**: Django, FastAPI, Flask
- **Package managers**: pip, poetry, conda
- **Testing**: pytest, unittest
- **Linting**: ruff, pylint, mypy

### Go
- **acca/ source**: `acca/categories/02-language-specialists/golang-pro.md`
- **Frameworks**: Gin, Echo, Fiber
- **Package manager**: go modules
- **Testing**: testing package, testify
- **Linting**: golangci-lint

### Rust
- **acca/ source**: `acca/categories/02-language-specialists/rust-engineer.md`
- **Frameworks**: Actix, Rocket, Axum
- **Package manager**: cargo
- **Testing**: built-in test framework
- **Linting**: clippy

### Java
- **acca/ source**: `acca/categories/02-language-specialists/java-architect.md`, `spring-boot-engineer.md`
- **Frameworks**: Spring Boot, Quarkus
- **Package managers**: Maven, Gradle
- **Testing**: JUnit, Mockito
- **Linting**: Checkstyle, SpotBugs

---

## Time Breakdown

- **Step 1** (Copy Template): 10 minutes
- **Step 2** (Review acca/): 20 minutes
- **Step 3** (Integrate): 30 minutes
- **Step 4** (Validate): 10 minutes
- **Step 5** (Test): 10 minutes
- **Step 6** (Document): 10 minutes

**Total**: ~70 minutes per agent

---

## Next Agent to Create

**Recommended**: python-developer

**Why**: 
- High demand
- Clear acca/ source (python-pro.md)
- Different enough from JavaScript to validate the process
- Similar enough to use the template effectively

**Start with**: This guide, Step 1

---

**Last Updated**: 2025-10-01
