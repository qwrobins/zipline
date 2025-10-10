# PRD Feature Phasing Directive

This directive provides strict rules for categorizing features into Pre-Launch vs. Post-Launch phases when generating Product Requirements Documents (PRDs).

## Critical Problem

**Issue:** PRDs incorrectly categorize essential user-facing features (like dark mode, accessibility, responsive design) as "post-launch" items, leading to:
- Incomplete initial implementations
- Design-code drift
- Rework and technical debt
- Poor user experience at launch
- Additional development cycles

**Solution:** Follow strict phasing rules that ensure ALL user-facing features are implemented before launch.

---

## Feature Phasing Rules

### ✅ Pre-Launch (Initial Development Phase)

**ALL user-facing features and functionality MUST be implemented before launch.**

#### User Interface & Experience
- ✅ Theme switching (light/dark mode)
- ✅ All UI components and interactions
- ✅ Responsive design for all breakpoints (mobile, tablet, desktop)
- ✅ Loading states and skeleton screens
- ✅ Error boundaries and user-facing error handling
- ✅ Form validation and inline error messages
- ✅ Animations and transitions
- ✅ Empty states and placeholder content
- ✅ Tooltips and help text
- ✅ Modals and dialogs
- ✅ Navigation menus and breadcrumbs

#### Accessibility & Usability
- ✅ WCAG 2.1 AA compliance
- ✅ Keyboard navigation
- ✅ Screen reader support
- ✅ Focus management
- ✅ Color contrast requirements
- ✅ Alternative text for images
- ✅ ARIA labels and roles
- ✅ Skip links and landmarks

#### Core Functionality
- ✅ All features described in functional requirements
- ✅ Data fetching and state management
- ✅ User authentication and authorization
- ✅ Search and filtering
- ✅ Sorting and pagination
- ✅ CRUD operations
- ✅ Real-time updates (if applicable)
- ✅ File uploads and downloads
- ✅ Export functionality
- ✅ Print styles

#### Design System
- ✅ All design tokens (colors, typography, spacing)
- ✅ Component library implementation
- ✅ Theme configuration (light/dark)
- ✅ Icon system
- ✅ Layout system
- ✅ Grid system
- ✅ Breakpoint system

#### Performance & Security
- ✅ Performance optimizations (code splitting, lazy loading)
- ✅ Application-level security (input validation, XSS prevention)
- ✅ Error handling and recovery
- ✅ Data validation
- ✅ API error handling
- ✅ Rate limiting (application-level)
- ✅ CSRF protection
- ✅ Content Security Policy

**Golden Rule:** If a user can see it, interact with it, or it affects the user experience, it MUST be implemented before launch.

---

### ✅ Post-Launch (After User Acceptance Testing)

**ONLY deployment and operational infrastructure.**

#### Deployment Infrastructure
- ✅ CI/CD pipeline setup and automation
- ✅ Production deployment configurations
- ✅ Environment-specific configurations
- ✅ Blue-green deployment setup
- ✅ Rollback procedures
- ✅ Deployment scripts and automation
- ✅ Container orchestration (Kubernetes, etc.)

#### Monitoring & Operations
- ✅ Application monitoring and alerting
- ✅ Log aggregation and analysis
- ✅ Performance monitoring dashboards
- ✅ Error tracking and reporting
- ✅ Uptime monitoring
- ✅ APM (Application Performance Monitoring)
- ✅ Distributed tracing

#### Production Infrastructure
- ✅ CDN configuration and optimization
- ✅ Database scaling and replication
- ✅ Backup and disaster recovery
- ✅ Infrastructure as Code (IaC) setup
- ✅ Production security hardening (beyond application-level)
- ✅ Load balancing configuration
- ✅ Auto-scaling policies
- ✅ Network security groups
- ✅ WAF (Web Application Firewall) configuration

**Golden Rule:** Only items related to deploying, monitoring, and operating the application in production should be post-launch.

---

### ❌ NEVER Post-Launch

These items should NEVER be marked as post-launch:
- ❌ Any feature visible to end users
- ❌ Any functionality described in functional requirements
- ❌ Design system implementation
- ❌ Accessibility features
- ❌ Responsive design
- ❌ Theme/styling systems (light/dark mode)
- ❌ Component libraries
- ❌ User-facing error handling
- ❌ Form validation
- ❌ Loading states
- ❌ Any UI component or interaction
- ❌ Search functionality
- ❌ Filtering or sorting
- ❌ User authentication UI
- ❌ Navigation menus
- ❌ Breadcrumbs
- ❌ Tooltips or help text

---

## Decision Tree

Use this decision tree for EVERY feature when creating a PRD:

```
Is this feature/item visible to or interacts with end users?
├─ YES → Pre-Launch (Initial Development)
│   └─ Add to initial development phase
│       Mark as "Must Have" priority
│       Include in MVP scope
│
└─ NO → Is it deployment/operations infrastructure?
    ├─ YES → Post-Launch (After UAT)
    │   └─ Add to post-launch phase
    │       Mark as "Operational"
    │       Schedule after UAT completion
    │
    └─ NO → Pre-Launch (Initial Development)
        └─ Default to pre-launch when in doubt
            Add to initial development phase
```

---

## Examples

### ✅ Correct Categorization

**Pre-Launch:**
- Dark mode toggle button and theme switching
- User profile page with all fields
- Search functionality with filters
- Form validation with inline errors
- Loading spinners and skeleton screens
- Error messages and error boundaries
- Responsive navigation menu
- Accessibility features (keyboard nav, screen reader)
- All CRUD operations
- Pagination and sorting
- File upload with progress indicators
- Export to CSV/PDF functionality

**Post-Launch:**
- CI/CD pipeline with GitHub Actions
- Production monitoring with Datadog
- Log aggregation with ELK stack
- CDN configuration with Cloudflare
- Database backup automation
- Auto-scaling policies
- Blue-green deployment setup

### ❌ Incorrect Categorization

**WRONG - These should be Pre-Launch, not Post-Launch:**
- ❌ "Dark mode - Post-launch enhancement"
- ❌ "Accessibility - Phase 2"
- ❌ "Mobile responsive - Nice to have"
- ❌ "Form validation - Can add later"
- ❌ "Loading states - Post-MVP"
- ❌ "Error handling - Future improvement"
- ❌ "Search filters - Phase 2"

---

## Validation Checklist

Before finalizing a PRD, verify:

### User-Facing Features
- [ ] Theme switching (light/dark mode) is Pre-Launch
- [ ] All UI components are Pre-Launch
- [ ] Accessibility features (WCAG AA) are Pre-Launch
- [ ] Responsive design (all breakpoints) is Pre-Launch
- [ ] Form validation is Pre-Launch
- [ ] Loading states are Pre-Launch
- [ ] Error handling (user-facing) is Pre-Launch
- [ ] All functional requirements are Pre-Launch

### Infrastructure
- [ ] CI/CD pipeline is Post-Launch
- [ ] Monitoring dashboards are Post-Launch
- [ ] Log aggregation is Post-Launch
- [ ] Production infrastructure is Post-Launch
- [ ] Deployment automation is Post-Launch

### No Gaps
- [ ] No user-facing features marked as "post-launch"
- [ ] No "we'll add this later" for UI/UX features
- [ ] Design system fully implemented before launch
- [ ] No functionality gaps requiring rework

---

## Common Mistakes to Avoid

### ❌ Mistake 1: "Dark Mode as Enhancement"
**Wrong:** "Dark mode will be added as a post-launch enhancement"
**Right:** "Dark mode is part of the design system and must be implemented before launch"

### ❌ Mistake 2: "Accessibility as Phase 2"
**Wrong:** "WCAG compliance will be addressed in Phase 2"
**Right:** "WCAG 2.1 AA compliance is required for all features before launch"

### ❌ Mistake 3: "Responsive as Nice-to-Have"
**Wrong:** "Mobile responsive design is a nice-to-have for later"
**Right:** "Responsive design for mobile, tablet, and desktop is required before launch"

### ❌ Mistake 4: "Validation Can Wait"
**Wrong:** "Form validation can be added after launch"
**Right:** "Form validation with inline errors is required before launch"

### ❌ Mistake 5: "Loading States Later"
**Wrong:** "Loading states and skeleton screens can be added post-launch"
**Right:** "Loading states and skeleton screens are required for all async operations before launch"

---

## Rationale

### Why This Matters

**Implementing user-facing features post-launch causes:**
1. **Incomplete Initial Implementations**
   - Users experience a half-finished product
   - Missing essential features like dark mode
   - Poor first impressions

2. **Design-Code Drift**
   - Design specs exist but aren't implemented
   - Developers use defaults instead of custom designs
   - Inconsistent user experience

3. **Rework and Technical Debt**
   - Features need to be retrofitted later
   - More expensive to add after launch
   - Disrupts ongoing development

4. **Poor User Experience at Launch**
   - Missing accessibility features
   - No responsive design
   - Broken user flows
   - Unprofessional appearance

5. **Additional Development Cycles**
   - 7-11 days of rework per project
   - Delayed feature releases
   - Increased costs

### Why Infrastructure Can Be Post-Launch

**Deployment/operations infrastructure can be post-launch because:**
1. It doesn't affect user experience
2. It can only be properly configured after the application is feature-complete
3. It requires production data to tune correctly
4. It doesn't block user acceptance testing
5. It can be set up while users are testing

---

## Implementation in PRD

When writing the PRD, include this section:

```markdown
## Implementation Phasing

### Pre-Launch (Initial Development Phase)
All user-facing features and functionality:
- [List all user-facing features]
- [Include theme switching, accessibility, responsive design]
- [Include all UI components and interactions]

### Post-Launch (After User Acceptance Testing)
Only deployment and operational infrastructure:
- [List only CI/CD, monitoring, production infrastructure]
- [NO user-facing features here]
```

---

## Success Criteria

A well-phased PRD achieves:
- ✅ All user-facing features in Pre-Launch phase
- ✅ Only infrastructure in Post-Launch phase
- ✅ No functionality gaps at launch
- ✅ Complete user experience before UAT
- ✅ Zero rework for missing features
- ✅ Professional product at launch

---

## Related Documents

- Command: `.claude/commands/create-prd.md`
- Analysis: `analysis/CRITICAL-FINDINGS.md`
- Scrum Master: `agents/definitions/scrum-master.md`

