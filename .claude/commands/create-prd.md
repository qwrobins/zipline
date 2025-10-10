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

## 13. Implementation Phasing

**🚨 CRITICAL: Feature Phasing Rules 🚨**

### Pre-Launch (Initial Development Phase)

**ALL user-facing features and functionality MUST be implemented before launch:**

✅ **User Interface & Experience:**
- Theme switching (light/dark mode)
- All UI components and interactions
- Responsive design for all breakpoints (mobile, tablet, desktop)
- Loading states and skeleton screens
- Error boundaries and user-facing error handling
- Form validation and inline error messages
- Animations and transitions
- Empty states and placeholder content

✅ **Accessibility & Usability:**
- WCAG 2.1 AA compliance
- Keyboard navigation
- Screen reader support
- Focus management
- Color contrast requirements
- Alternative text for images

✅ **Core Functionality:**
- All features described in functional requirements
- Data fetching and state management
- User authentication and authorization
- Search and filtering
- Sorting and pagination
- CRUD operations
- Real-time updates (if applicable)

✅ **Design System:**
- All design tokens (colors, typography, spacing)
- Component library implementation
- Theme configuration
- Icon system
- Layout system

✅ **Performance & Security:**
- Performance optimizations (code splitting, lazy loading)
- Application-level security (input validation, XSS prevention)
- Error handling and recovery
- Data validation
- API error handling

**Rule:** If a user can see it, interact with it, or it affects the user experience, it MUST be implemented before launch.

### Post-Launch (After User Acceptance Testing)

**ONLY deployment and operational infrastructure:**

✅ **Deployment Infrastructure:**
- CI/CD pipeline setup and automation
- Production deployment configurations
- Environment-specific configurations
- Blue-green deployment setup
- Rollback procedures

✅ **Monitoring & Operations:**
- Application monitoring and alerting
- Log aggregation and analysis
- Performance monitoring dashboards
- Error tracking and reporting
- Uptime monitoring

✅ **Production Infrastructure:**
- CDN configuration and optimization
- Database scaling and replication
- Backup and disaster recovery
- Infrastructure as Code (IaC) setup
- Production security hardening (beyond application-level)
- Load balancing configuration

**Rule:** Only items related to deploying, monitoring, and operating the application in production should be post-launch.

### ❌ NEVER Post-Launch

- Any feature visible to end users
- Any functionality described in functional requirements
- Design system implementation
- Accessibility features
- Responsive design
- Theme/styling systems
- Component libraries
- User-facing error handling
- Form validation
- Loading states
- Any UI component or interaction

### Feature Categorization Decision Tree

```
Is this feature/item visible to or interacts with end users?
├─ YES → Pre-Launch (Initial Development)
└─ NO → Is it deployment/operations infrastructure?
    ├─ YES → Post-Launch (After UAT)
    └─ NO → Pre-Launch (Initial Development)
```

### Example Categorization

**Pre-Launch:**
- ✅ Dark mode toggle button
- ✅ User profile page
- ✅ Search functionality
- ✅ Form validation
- ✅ Loading spinners
- ✅ Error messages
- ✅ Responsive navigation menu
- ✅ Accessibility features

**Post-Launch:**
- ✅ CI/CD pipeline
- ✅ Production monitoring dashboards
- ✅ Log aggregation setup
- ✅ CDN configuration
- ✅ Database backup automation

## 14. Timeline (Optional)

| Phase | Duration | Deliverables |
|-------|----------|--------------|
| Phase 1: Initial Development | [X weeks] | All user-facing features, accessibility, responsive design |
| Phase 2: Post-Launch Operations | [X weeks] | CI/CD, monitoring, production infrastructure |

## 15. Next Steps

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

**🚨 CRITICAL: Feature Phasing Validation 🚨**

Before finalizing the PRD, verify:
- ✅ **All user-facing features are in Pre-Launch phase**
  - Theme switching (light/dark mode) is NOT post-launch
  - All UI components are NOT post-launch
  - Accessibility features are NOT post-launch
  - Responsive design is NOT post-launch
  - Form validation is NOT post-launch
  - Loading states are NOT post-launch
  - Error handling is NOT post-launch

- ✅ **Only deployment/operations infrastructure is Post-Launch**
  - CI/CD pipeline is post-launch
  - Monitoring dashboards are post-launch
  - Log aggregation is post-launch
  - Production infrastructure is post-launch

- ✅ **No functionality gaps that would require rework**
  - All features users interact with are complete before launch
  - No "we'll add this later" for user-facing features
  - Design system is fully implemented before launch

**Common Mistakes to Avoid:**
- ❌ Marking dark mode as "post-launch enhancement"
- ❌ Marking accessibility as "nice to have for later"
- ❌ Marking responsive design as "phase 2"
- ❌ Marking any UI component as "post-launch"
- ❌ Marking form validation as "can add later"

**Validation Questions:**
1. Can a user see or interact with this feature? → Pre-Launch
2. Is this purely deployment/operations infrastructure? → Post-Launch
3. When in doubt? → Pre-Launch
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

