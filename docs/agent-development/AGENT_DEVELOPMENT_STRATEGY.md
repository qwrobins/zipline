# Agent Development Strategy

**Approved Strategy**: Continue developing workflow-integrated agents in `agents/` directory, integrating best features from corresponding `acca/` agents.

**Date**: 2025-10-01

---

## Core Principle

**Maintain the `agents/` workflow-integrated structure** while **enhancing with domain expertise from `acca/`**.

### The Pattern

For each new agent:

1. ✅ **Start with `agents/` template** - Copy structure from existing workflow agent (e.g., javascript-developer)
2. ✅ **Customize for the language/domain** - Adapt language-specific sections
3. ✅ **Integrate `acca/` expertise** - Merge best features from corresponding acca/ agent
4. ✅ **Keep mandatory protocols** - Preserve sequential_thinking, context7, retry mechanisms
5. ✅ **Test and refine** - Validate with real tasks

---

## Template Structure (Proven Pattern)

Every workflow-integrated agent follows this structure:

```markdown
---
name: [language]-developer
description: [Detailed description with examples]
model: sonnet
---

## Core Expertise
[Language-specific expertise - FROM ACCA/]

## Core Responsibilities
[Standard responsibilities - FROM TEMPLATE]

## ⚠️ CRITICAL WORKFLOW REQUIREMENTS ⚠️
[Mandatory protocols - FROM TEMPLATE - NEVER CHANGE]
- ALWAYS use sequential_thinking before coding
- ALWAYS consult documentation when uncertain
- ALWAYS follow problem-solving protocol
- ALWAYS update user story status

## Development Workflow
[Standard workflow - FROM TEMPLATE - MINOR CUSTOMIZATION]

## [Language]-Specific Best Practices
[Deep domain expertise - FROM ACCA/]

## Testing & Quality
[Standard testing - FROM TEMPLATE - LANGUAGE-SPECIFIC TOOLS]

## Common Patterns & Examples
[Language-specific patterns - FROM ACCA/]
```

---

## Integration Process

### Step 1: Create Base Agent from Template

**Copy from**: `agents/javascript-developer.md`

**Keep unchanged**:
- ⚠️ CRITICAL WORKFLOW REQUIREMENTS section (100 lines)
- Development Workflow section (150 lines)
- User Story Integration section (50 lines)
- Problem-Solving Protocol section (50 lines)

**Customize**:
- Agent name and description
- Language/framework references
- Tool names
- Examples

### Step 2: Extract Best Features from acca/

**Review corresponding acca/ agent** (e.g., `acca/categories/02-language-specialists/python-pro.md`)

**Extract**:
- ✅ Language-specific expertise (frameworks, libraries, patterns)
- ✅ Performance optimization techniques
- ✅ Testing methodologies
- ✅ Common patterns and best practices
- ✅ Checklists and quality standards
- ✅ MCP tool listings

**Ignore**:
- ❌ Generic workflow sections (we have better ones)
- ❌ Basic descriptions (we have embedded templates)
- ❌ Anything that conflicts with mandatory protocols

### Step 3: Merge and Enhance

**Integration points**:

1. **Core Expertise** section:
   - Add acca/ language mastery details
   - Add acca/ framework expertise
   - Add acca/ ecosystem knowledge

2. **Best Practices** section:
   - Add acca/ performance optimization
   - Add acca/ design patterns
   - Add acca/ common pitfalls

3. **Testing** section:
   - Add acca/ testing frameworks
   - Add acca/ testing patterns
   - Keep our comprehensive testing requirements

4. **Tools** section:
   - Add acca/ MCP tool listings
   - Add acca/ domain-specific tools

### Step 4: Validate and Test

- [ ] All mandatory protocols present
- [ ] Workflow integration intact
- [ ] Language-specific expertise comprehensive
- [ ] Examples relevant and accurate
- [ ] Tools properly listed
- [ ] Test with sample user story

---

## Example: Creating python-developer

### Phase 1: Copy Template (10 minutes)

```bash
cp agents/javascript-developer.md agents/python-developer.md
```

**Find and replace**:
- `javascript-developer` → `python-developer`
- `JavaScript/TypeScript` → `Python`
- `React, Next.js` → `Django, FastAPI, Flask`
- `npm, yarn` → `pip, poetry, conda`
- `Jest, Vitest` → `pytest, unittest`

### Phase 2: Review acca/python-pro (20 minutes)

**Open**: `acca/categories/02-language-specialists/python-pro.md`

**Extract these sections**:
```markdown
Python mastery:
- Python 3.12+ features
- Type hints and mypy
- Async/await patterns
- Context managers
- Decorators
- Metaclasses
- Descriptors
- Generators

Framework expertise:
- Django 5+ patterns
- FastAPI best practices
- Flask microservices
- SQLAlchemy ORM
- Pydantic validation
- Celery task queues
- Django REST framework
- GraphQL with Strawberry

Performance optimization:
- Profiling with cProfile
- Memory optimization
- Async performance
- Database query optimization
- Caching strategies
- Multiprocessing patterns
- GIL considerations
- C extensions

Testing methodology:
- pytest fixtures
- Mock and patch
- Parametrized tests
- Coverage analysis
- Integration testing
- API testing
- Performance testing
- Security testing
```

### Phase 3: Integrate (30 minutes)

**Add to python-developer.md**:

1. **After "Core Expertise" section**, add:
```markdown
### Languages & Runtimes
- **Python 3.12+**: Modern syntax, type hints, async/await, pattern matching
- **Type System**: mypy, Pydantic, dataclasses, Protocol, TypedDict
- **Async**: asyncio, aiohttp, async context managers, async generators

### Frameworks & Libraries
- **Django 5+**: ORM, migrations, admin, REST framework, channels, Celery
- **FastAPI**: Async routes, dependency injection, Pydantic models, OpenAPI
- **Flask**: Blueprints, extensions, SQLAlchemy, Flask-RESTful
- **Testing**: pytest, unittest, hypothesis, factory_boy, faker
```

2. **Add new section** "Python-Specific Best Practices":
```markdown
## Python-Specific Best Practices

### Modern Python Features
- Type hints with mypy strict mode
- Pattern matching (Python 3.10+)
- Structural pattern matching
- Union types with | operator
- Dataclasses and frozen dataclasses
- Context managers for resource management
- Async context managers
- Generators and async generators

### Performance Optimization
[Copy from acca/python-pro]

### Django Best Practices
[Copy from acca/python-pro]

### FastAPI Patterns
[Copy from acca/python-pro]
```

3. **Update Testing section**:
```markdown
### Testing
- **pytest**: Fixtures, parametrization, markers, plugins
- **Coverage**: pytest-cov with >85% target
- **Mocking**: unittest.mock, pytest-mock, responses
- **API Testing**: httpx, TestClient (FastAPI), Django test client
- **Integration**: Database fixtures, test containers
- **Performance**: pytest-benchmark, locust
```

### Phase 4: Validate (10 minutes)

**Checklist**:
- [ ] ⚠️ CRITICAL WORKFLOW REQUIREMENTS section unchanged
- [ ] Development Workflow section intact
- [ ] Python-specific expertise comprehensive
- [ ] Django/FastAPI/Flask coverage complete
- [ ] Testing frameworks updated
- [ ] Examples use Python syntax
- [ ] Tools list includes pip, poetry, pytest, mypy
- [ ] User story integration preserved

**Total time**: ~70 minutes per agent

---

## Priority Queue

### Immediate (Next 2 Weeks)

1. **python-developer** (Week 1)
   - Base: javascript-developer
   - Enhance with: acca/python-pro
   - Frameworks: Django, FastAPI, Flask

2. **qa-engineer** (Week 2)
   - Base: javascript-developer (testing sections)
   - Enhance with: acca/qa-expert, acca/test-automator
   - Focus: Test automation, quality assurance

### Short-term (Weeks 3-6)

3. **go-developer** (Week 3)
   - Base: javascript-developer
   - Enhance with: acca/golang-pro
   - Frameworks: Gin, Echo, gRPC

4. **devops-specialist** (Week 4)
   - Base: javascript-developer (workflow sections)
   - Enhance with: acca/devops-engineer
   - Focus: CI/CD, deployment, infrastructure

5. **rust-developer** (Week 5)
   - Base: javascript-developer
   - Enhance with: acca/rust-engineer
   - Frameworks: Actix, Rocket, Tokio

6. **database-specialist** (Week 6)
   - Base: javascript-developer (workflow sections)
   - Enhance with: acca/database-administrator, acca/postgres-pro
   - Focus: Schema design, optimization, migrations

### Medium-term (Weeks 7-12)

7. **java-developer**
   - Enhance with: acca/java-architect, acca/spring-boot-engineer

8. **mobile-developer**
   - Enhance with: acca/mobile-developer, acca/flutter-expert

9. **security-specialist**
   - Enhance with: acca/security-auditor, acca/penetration-tester

10. **performance-specialist**
    - Enhance with: acca/performance-engineer

---

## Maintenance Strategy

### When acca/ Updates

If acca/ agents are updated:

1. **Review changes** in corresponding acca/ agent
2. **Extract new best practices** or patterns
3. **Integrate into our agent** without breaking workflow
4. **Test** to ensure no regression
5. **Document** what was added

### When Our Workflow Evolves

If we improve our workflow pattern:

1. **Update template** (e.g., javascript-developer)
2. **Propagate changes** to all other agents
3. **Test** each agent
4. **Document** the improvement

---

## Quality Standards

Every workflow-integrated agent must have:

### Mandatory Sections (Never Remove)
- ✅ ⚠️ CRITICAL WORKFLOW REQUIREMENTS
- ✅ Development Workflow (Step 1-8)
- ✅ User Story Integration
- ✅ Problem-Solving Protocol
- ✅ Testing & Quality Requirements
- ✅ Status Management

### Language-Specific Sections (Customize)
- ✅ Core Expertise (from acca/)
- ✅ Frameworks & Libraries (from acca/)
- ✅ Best Practices (from acca/)
- ✅ Performance Optimization (from acca/)
- ✅ Common Patterns (from acca/)
- ✅ Testing Methodology (from acca/)

### Quality Metrics
- ✅ 600-900 lines (comprehensive but not overwhelming)
- ✅ Embedded examples for the language
- ✅ Complete tool listings
- ✅ Clear, actionable guidance
- ✅ No conflicts with mandatory protocols

---

## Benefits of This Approach

### 1. **Best of Both Worlds**
- ✅ Workflow integration from agents/
- ✅ Domain expertise from acca/
- ✅ Mandatory quality protocols
- ✅ Comprehensive language coverage

### 2. **Consistency**
- ✅ All agents follow same structure
- ✅ Same mandatory protocols
- ✅ Same workflow integration
- ✅ Predictable behavior

### 3. **Efficiency**
- ✅ Template-based creation (~70 min per agent)
- ✅ No need to design from scratch
- ✅ Proven pattern
- ✅ Reusable sections

### 4. **Quality**
- ✅ Enforced best practices
- ✅ Mandatory research and thinking
- ✅ Built-in retry mechanisms
- ✅ Status tracking

### 5. **Maintainability**
- ✅ Easy to update all agents
- ✅ Clear structure
- ✅ Documented process
- ✅ Can adopt acca/ improvements

---

## Next Steps

1. **Create python-developer** following this process
2. **Document any refinements** to the process
3. **Create qa-engineer** to validate process works for non-language agents
4. **Continue with priority queue**

---

## Success Criteria

An agent is complete when:

- [ ] All mandatory workflow sections present
- [ ] Language/domain expertise comprehensive (from acca/)
- [ ] Testing requirements complete
- [ ] Examples use correct syntax
- [ ] Tools properly listed
- [ ] Tested with real user story
- [ ] Documentation updated
- [ ] Added to README

---

**This strategy approved**: 2025-10-01  
**Next agent to create**: python-developer  
**Estimated completion**: Week 1
