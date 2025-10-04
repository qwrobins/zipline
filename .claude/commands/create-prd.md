---
description: Transform a product brief into a comprehensive Product Requirements Document (PRD)
---

You are transforming a product brief into a comprehensive Product Requirements Document (PRD).

# Instructions

## Step 1: Read the Product Brief

Read the product brief file provided by the user (or ask for the path if not provided).

## Step 2: Analyze Requirements (REQUIRED - Use sequential_thinking)

**CRITICAL**: You MUST use the `sequential_thinking` tool to analyze the product brief before creating the PRD.

Use sequential_thinking to think through:
- Product vision and goals
- Target users and their needs
- Key features and functionality
- Technical constraints
- Success criteria
- Epic structure and user stories
- Non-functional requirements
- Risks and dependencies

**Example sequential_thinking usage**:
```
sequential_thinking:
  thought: "Analyzing the product brief for [Product Name]. The core problem is [X], and the solution involves [Y]. Key users are [Z]..."
  thoughtNumber: 1
  totalThoughts: 8
  nextThoughtNeeded: true
```

Continue thinking through all aspects until you have a complete understanding (typically 6-10 thoughts).

## Step 3: Research Best Practices (REQUIRED - Use context7)

**CRITICAL**: You MUST use `context7` tools to research PRD best practices and domain-specific requirements.

**Required research**:

1. **PRD Structure and Best Practices**:
```
resolve-library-id: "product requirements document best practices"
get-library-docs: [Use the library ID from resolve-library-id]
```

2. **Domain-Specific Requirements** (based on product type):
```
resolve-library-id: "[product domain] requirements"
# Examples: "e-commerce requirements", "SaaS application requirements",
#           "mobile app requirements", "dashboard requirements"
get-library-docs: [Use the library ID from resolve-library-id]
```

3. **Technology Stack Best Practices** (if mentioned in brief):
```
resolve-library-id: "[framework/technology] best practices"
# Examples: "Next.js best practices", "React best practices"
get-library-docs: [Use the library ID from resolve-library-id]
```

**Use the research to inform**:
- Functional requirements structure
- Non-functional requirements (performance, security, accessibility)
- Common patterns for this type of product
- Industry standards and best practices

## Step 4: Create Comprehensive PRD

**IMPORTANT**: Base your PRD on:
- ✅ Insights from sequential_thinking analysis (Step 2)
- ✅ Best practices from context7 research (Step 3)
- ✅ Requirements from the product brief

Create a PRD at `docs/prd.md` with the following structure:

```markdown
# [Product Name] - Product Requirements Document

## 1. Executive Summary
- **Product Overview**: [2-3 sentence description]
- **Key Features**: [3-5 main features]
- **Target Users**: [Primary user types]
- **Business Value**: [Why we're building this]

## 2. Problem Statement
**Current Challenge**: [What problem exists today?]

**Proposed Solution**: [How does this product solve it?]

**Success Criteria**: [How will we know we succeeded?]

## 3. Goals & Objectives

| Objective | Target | Measurement |
|-----------|--------|-------------|
| [Goal 1] | [Specific target] | [How to measure] |
| [Goal 2] | [Specific target] | [How to measure] |
| [Goal 3] | [Specific target] | [How to measure] |

## 4. Target Users

### Primary User Persona
- **Name**: [Persona name]
- **Role**: [Job title/role]
- **Goals**: [What they want to achieve]
- **Pain Points**: [Current challenges]
- **Usage Scenario**: [How they'll use the product]

## 5. Scope

### In Scope
- [Feature 1]
- [Feature 2]
- [Feature 3]

### Out of Scope
- [What we're NOT building]
- [Future considerations]

## 6. Functional Requirements

### FR1: [Feature Area 1]
**Description**: [What this feature does]

**Requirements**:
- FR1.1: [Specific requirement]
- FR1.2: [Specific requirement]
- FR1.3: [Specific requirement]

### FR2: [Feature Area 2]
[Repeat for each major feature area]

## 7. Non-Functional Requirements

### Performance
- NFR1: Page load time < [X] seconds
- NFR2: API response time < [X] ms
- NFR3: Support [X] concurrent users

### Accessibility
- NFR4: WCAG 2.1 Level AA compliance
- NFR5: Keyboard navigation support
- NFR6: Screen reader compatibility

### Security
- NFR7: [Security requirement]
- NFR8: [Data protection requirement]

### Scalability
- NFR9: [Scalability requirement]

## 8. User Stories & Epics

### Epic 1: [Epic Name]
**Goal**: [What value does this epic deliver?]

#### Story 1.1: [Story Title]
**As a** [user type],
**I want** [goal],
**so that** [benefit].

**Acceptance Criteria**:
1. [Specific, testable criterion]
2. [Specific, testable criterion]
3. [Specific, testable criterion]
4. [Specific, testable criterion]
5. [Specific, testable criterion]

**Technical Requirements**:
- Technology: [Framework/library]
- Components: [UI components needed]
- APIs: [Backend endpoints needed]

**Story Points**: [1, 2, 3, 5, 8, 13]

[Repeat for each story in the epic]

### Epic 2: [Epic Name]
[Repeat epic structure]

## 9. Technical Assumptions
- [Assumption 1]
- [Assumption 2]
- [Assumption 3]

## 10. Dependencies
- [Dependency 1]
- [Dependency 2]

## 11. Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| [Risk 1] | High/Med/Low | High/Med/Low | [How to mitigate] |
| [Risk 2] | High/Med/Low | High/Med/Low | [How to mitigate] |

## 12. Success Metrics

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| User Satisfaction | > 85% | Post-launch survey |
| Performance | < 2s load time | Lighthouse score |
| Adoption | [X] users in [Y] days | Analytics |

## 13. Timeline (Optional)

| Phase | Duration | Deliverables |
|-------|----------|--------------|
| Phase 1 | [X weeks] | [Deliverables] |
| Phase 2 | [X weeks] | [Deliverables] |

## 14. Next Steps

### For Design Team
"Review this PRD and create design specifications for [key features]. Focus on [design priorities]."

### For Architecture Team
"Review this PRD at docs/prd.md and create technical architecture document at docs/architecture.md covering: system design, data models, API specifications, and technology stack."

### For Development Team
"Review this PRD and create user stories in docs/stories/ directory. Break down epics into implementable stories with clear acceptance criteria."
```

## Step 4: Save the PRD

Use the `save-file` tool to create `docs/prd.md` with the complete PRD content.

**Important**: 
- Save to `docs/prd.md` (NOT project root)
- save-file automatically creates the docs/ directory
- Do NOT use bash or mkdir commands

## Quality Checklist

**CRITICAL - Verify you completed all required steps**:
- ✅ **Used sequential_thinking** to analyze requirements (Step 2)
- ✅ **Used context7** to research best practices (Step 3)
- ✅ **Incorporated research** into the PRD (Step 4)

**Ensure your PRD**:
- ✅ Has specific, quantified requirements (e.g., "< 2s load time" not "fast")
- ✅ Includes 5+ acceptance criteria per user story
- ✅ Defines measurable success metrics
- ✅ Clearly states what's in-scope and out-of-scope
- ✅ Includes technical assumptions and constraints
- ✅ Identifies risks and mitigation strategies
- ✅ Reflects best practices from context7 research
- ✅ Addresses insights from sequential_thinking analysis

## Output

After creating the PRD, provide a brief summary:
- Path where PRD was saved
- Number of epics created
- Number of user stories created
- Key features identified
- Any assumptions made

# Example Usage

User: `/create-prd docs/product-brief.md`

You:
1. **Read** the product brief using `view` tool
2. **Analyze** requirements using `sequential_thinking` tool (REQUIRED)
3. **Research** best practices using `context7` tools (REQUIRED)
4. **Create** comprehensive PRD at docs/prd.md using `save-file` tool
5. **Confirm** completion with summary

# Critical Requirements

**YOU MUST**:
- ✅ Use `sequential_thinking` in Step 2 (not optional)
- ✅ Use `context7` in Step 3 (not optional)
- ✅ Base PRD on research and analysis (not just template)

**DO NOT**:
- ❌ Skip sequential_thinking
- ❌ Skip context7 research
- ❌ Just fill in template without research
- ❌ Use bash/mkdir commands

