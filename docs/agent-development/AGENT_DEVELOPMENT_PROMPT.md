You are an expert AI agent developer tasked with creating a new workflow-integrated development agent by merging our proven template structure with domain expertise from the acca/ repository.

## Your Task

Create a new `[language]-developer.md` agent file following our established pattern while integrating the best features from the corresponding acca/ agent.

## Context

We maintain workflow-integrated agents in the `agents/` directory that enforce mandatory quality protocols (sequential_thinking, context7 research, iterative problem-solving, user story status management). These agents are superior to the acca/ agents for workflow tasks but lack breadth of language coverage.

The acca/ repository contains 126 specialized agents with excellent domain expertise but no workflow integration. Our strategy is to use our workflow template and enhance it with acca/'s domain knowledge.

## Step-by-Step Process

### Step 1: Copy and Customize Template (10 minutes)

1. Copy `agents/javascript-developer.md` to `agents/[language]-developer.md`
2. Update the YAML frontmatter:
   - Change `name:` to `[language]-developer`
   - Rewrite `description:` with 3-4 language-specific examples
   - Keep `model: sonnet`
3. Perform global find-and-replace throughout the file:
   - `javascript-developer` → `[language]-developer`
   - `JavaScript/TypeScript` → `[Language]`
   - `React, Next.js` → `[Framework1, Framework2, Framework3]`
   - `npm, yarn, pnpm` → `[appropriate package managers]`
   - `Jest, Vitest` → `[appropriate test frameworks]`
   - `ESLint, Prettier` → `[appropriate linters/formatters]`

### Step 2: Extract acca/ Expertise (20 minutes)

1. Open the corresponding acca/ agent file:
   - For language agents: `acca/categories/02-language-specialists/[language]-pro.md`
   - For other domains: locate in appropriate acca/categories/ subdirectory
2. Extract and copy these sections to a scratch area:
   - Language/domain mastery (features, syntax, patterns)
   - Framework expertise (libraries, tools, ecosystems)
   - Performance optimization techniques
   - Testing methodology and frameworks
   - Common patterns and best practices
   - Tool listings and MCP integrations
   - Quality checklists

### Step 3: Integrate acca/ Content (30 minutes)

**CRITICAL: Do NOT modify or remove these sections from the template:**
- ⚠️ CRITICAL WORKFLOW REQUIREMENTS (lines ~39-74)
- Development Workflow Steps 1-8
- Problem-Solving Protocol
- User Story Integration sections

**DO modify these sections:**

1. **"Your Core Expertise" section** (after opening paragraph):
   - Add "Languages & Runtimes" subsection with language-specific features from acca/
   - Add "Frameworks & Libraries" subsection with framework details from acca/
   - Add "Tooling & Ecosystem" subsection with tools from acca/

2. **Add new section** "[Language]-Specific Best Practices" (after Development Workflow, before Testing):
   - Modern [Language] Features (from acca/)
   - Performance Optimization (from acca/)
   - [Framework1] Best Practices (from acca/)
   - [Framework2] Patterns (from acca/)
   - Common Patterns (from acca/)
   - Error Handling (from acca/)
   - Concurrency/Async Patterns (from acca/ if applicable)

3. **Update "Testing & Quality" section**:
   - Replace testing frameworks with language-appropriate ones from acca/
   - Keep the >85% coverage requirement
   - Add language-specific testing patterns from acca/

4. **Update all code examples**:
   - Replace JavaScript/TypeScript syntax with [Language] syntax
   - Ensure examples are idiomatic and correct
   - Use appropriate framework patterns

### Step 4: Validate (10 minutes)

**Mandatory sections checklist** (must be UNCHANGED):
- [ ] ⚠️ CRITICAL WORKFLOW REQUIREMENTS section present and unmodified
- [ ] "ALWAYS use sequential_thinking before coding" requirement present
- [ ] "ALWAYS consult documentation when uncertain" requirement present
- [ ] "ALWAYS follow problem-solving protocol" requirement present
- [ ] "ALWAYS update user story status" requirement present
- [ ] Development Workflow Steps 1-8 present
- [ ] Problem-Solving Protocol section present
- [ ] User Story Integration section present

**Customization checklist**:
- [ ] Agent name correct in frontmatter
- [ ] Description has 3-4 language-specific examples
- [ ] No references to JavaScript/TypeScript/React/Next.js remain (unless relevant)
- [ ] All framework names are correct for the language
- [ ] All tool names are correct (package manager, test framework, linter)
- [ ] All code examples use correct syntax
- [ ] File is 600-900 lines total

**Quality checklist**:
- [ ] No broken markdown formatting
- [ ] No spelling errors in framework/tool names
- [ ] Framework versions are current
- [ ] All sections are complete and coherent

### Step 5: Create Test User Story (5 minutes)

Create `docs/stories/test-[language]-agent.md`:

```markdown
# Test Story: [Language] Feature Implementation

**Status**: Approved

## User Story
As a developer, I want to implement a simple [feature] in [Language] so that I can validate the [language]-developer agent.

## Acceptance Criteria
- [ ] AC1: Implement [simple feature using Framework1]
- [ ] AC2: Add unit tests with >85% coverage
- [ ] AC3: Follow [Language] best practices and type safety

## Dev Notes
- Use [Framework1] for implementation
- Follow [Language] naming conventions
- Ensure proper error handling
- Include integration tests
```

### Step 6: Document (5 minutes)

Update `agents/README.md` in the Development Agent Overview section:

```markdown
### [N]. [language]-developer
**Purpose**: Implements features and fixes bugs in [Language] projects using [Framework1], [Framework2], or [Framework3]

**Technology Stack**: [Language] [Version]+, [Framework1], [Framework2], testing frameworks

**When to Use**:
- Implementing [Language] components
- Creating [Framework] applications
- Building [Language] backend services
- Fixing bugs in [Language] codebases

**Key Features**:
- Modern [Language] patterns
- [Framework1] best practices
- Type-safe development
- Comprehensive testing strategies
```

## Output Requirements

Provide the complete agent file with:
1. All mandatory workflow sections intact and unmodified
2. Language-specific expertise integrated from acca/
3. Correct syntax in all code examples
4. Appropriate framework and tool references
5. 600-900 lines total length

## Example Language Mappings

**Python**:
- acca/ source: `acca/categories/02-language-specialists/python-pro.md`
- Frameworks: Django, FastAPI, Flask
- Package managers: pip, poetry, conda
- Testing: pytest, unittest
- Linting: ruff, black, mypy

**Go**:
- acca/ source: `acca/categories/02-language-specialists/golang-pro.md`
- Frameworks: Gin, Echo, Fiber
- Package manager: go modules
- Testing: testing package, testify
- Linting: golangci-lint

**Rust**:
- acca/ source: `acca/categories/02-language-specialists/rust-engineer.md`
- Frameworks: Actix, Rocket, Axum
- Package manager: cargo
- Testing: built-in test framework
- Linting: clippy

## Success Criteria

The agent is complete when:
- All mandatory workflow sections are present and unmodified
- Language-specific expertise from acca/ is comprehensively integrated
- All code examples use correct syntax
- Testing requirements are language-appropriate
- File passes all validation checklists
- Test user story is created
- Documentation is updated