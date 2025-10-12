# Scrum Master Agent - Foundation Stories Directive

This directive provides detailed guidance for generating foundation stories (Story 0.0 and Story 0.1).

## When to Use This Directive

Use this directive when:
- Creating user stories from a PRD
- Converting planning documents into actionable stories
- Setting up a new project or feature

## Foundation Story Generation Workflow

### Step 1: Project State Detection

**ALWAYS perform this check FIRST, before analyzing any planning documents.**

1. **Check for existing codebase:**
   ```
   view: package.json
   view: node_modules
   view: next.config.ts OR next.config.js
   view: app OR pages
   view: .git
   ```

2. **Evaluate results:**
   - If package.json NOT found OR no app/pages directory → `needsStory0_0 = true`
   - If package.json found AND app/pages exists → `needsStory0_0 = false`

3. **Document decision:**
   - Log which files were found/missing
   - Explain reasoning for decision
   - Include in stories README.md

### Step 2: Generate Story 0.0 (Conditional)

**IF `needsStory0_0 = true`:**

1. Generate Story 0.0 using the template from agent definition
2. Mark as Priority: Must Have (Blocker)
3. Set status to "Draft"
4. Save to `docs/stories/0.0.project-initialization.md`

**IF `needsStory0_0 = false`:**

1. Skip Story 0.0 generation
2. Document in README.md why it was skipped
3. Proceed to Story 0.1

### Step 3: Generate Story 0.1 (Always)

**ALWAYS generate Story 0.1, regardless of project state.**

1. **Read design system documentation:**
   ```
   view: docs/design/design-system.md
   ```

2. **Extract ALL design tokens:**
   - Primary color with exact HSL value
   - Semantic colors (success, warning, destructive, info) with HSL values
   - Typography scales (if specified)
   - Spacing tokens (if specified)

3. **Generate Story 0.1:**
   - Use template from agent definition
   - Replace ALL placeholders with extracted values
   - Include exact HSL values in acceptance criteria
   - Set dependencies:
     - If Story 0.0 generated: Depends on Story 0.0
     - If Story 0.0 not generated: No dependencies

4. **Save to:** `docs/stories/0.1.design-system-foundation-setup.md`

### Step 4: Update Feature Story Dependencies

**For ALL feature stories (1.1+):**

1. **Add foundation story dependencies:**
   ```markdown
   ## Dependencies
   [IF Story 0.0 was generated]:
   - Story 0.0 (Project Initialization and Setup) - Must be in "Done" status
   - Story 0.1 (Design System Foundation Setup) - Must be in "Done" status
   
   [IF Story 0.0 was NOT generated]:
   - Story 0.1 (Design System Foundation Setup) - Must be in "Done" status
   ```

2. **Add design compliance to DoD:**
   ```markdown
   ### Design System Compliance
   - [ ] All colors use design tokens (no hardcoded values)
   - [ ] Component works in both light and dark themes
   - [ ] Semantic colors used appropriately
   ```

## Quality Checklist

Before completing story generation, verify:

- [ ] Project state detection performed
- [ ] Decision documented (Story 0.0 needed or not)
- [ ] Story 0.0 generated if needed (with all AC)
- [ ] Story 0.1 always generated (with extracted tokens)
- [ ] All HSL values extracted from design-system.md
- [ ] All feature stories depend on foundation stories
- [ ] All feature stories have design compliance in DoD
- [ ] No generic color descriptions (all use tokens)
- [ ] README.md documents project state detection

## Common Mistakes to Avoid

❌ **DON'T:**
- Skip project state detection
- Assume project exists without checking
- Generate Story 0.0 when project already exists
- Skip Story 0.1 generation
- Use generic color descriptions ("red text")
- Forget to add foundation story dependencies

✅ **DO:**
- Always check project state first
- Document the decision clearly
- Generate Story 0.1 every time
- Extract exact HSL values from design docs
- Use specific token names in AC
- Add design compliance to every story

## Example: Project State Detection Output

```markdown
## Project State Detection

**Detection Date:** 2025-10-10 14:30:00

**Files Checked:**
- package.json: NOT FOUND
- node_modules/: NOT FOUND
- next.config.ts/js: NOT FOUND
- app/ or pages/: NOT FOUND
- .git/: NOT FOUND

**Decision:** NO_PROJECT

**Story 0.0 Generated:** YES

**Reasoning:** No package.json or Next.js directories found. This appears to be a new project that needs initialization. Story 0.0 (Project Initialization and Setup) will be generated as the first story, blocking all other stories until the project is properly set up.
```

## Example: Design Token Extraction

**From design-system.md:**
```css
--primary: 221.2 83.2% 53.3%;        /* Blue */
--success: 142 76% 36%;              /* Green */
--warning: 38 92% 50%;               /* Amber */
--destructive: 0 84.2% 60.2%;        /* Red */
```

**In Story 0.1 Acceptance Criteria:**
```markdown
1. **Primary Color Configuration**
   - [ ] Primary color is Blue (HSL: 221.2 83.2% 53.3%)
   - [ ] CSS variable `--primary` defined in `:root` block

2. **Semantic Colors - Light Theme**
   - [ ] Success color (HSL: 142 76% 36%) defined in `:root`
   - [ ] Warning color (HSL: 38 92% 50%) defined in `:root`
   - [ ] Destructive color (HSL: 0 84.2% 60.2%) defined in `:root`
```

## Example: Feature Story with Design Tokens

**WRONG:**
```markdown
## Acceptance Criteria
- Validation errors displayed inline with red text
- Delete button has destructive styling
```

**CORRECT:**
```markdown
## Dependencies
- Story 0.1 (Design System Foundation Setup) - Must be in "Done" status

## Acceptance Criteria
- [ ] Validation errors use `text-destructive` token (HSL: 0 84.2% 60.2%)
- [ ] Error field borders use `border-destructive` token
- [ ] Delete button uses `variant="destructive"` from design system
- [ ] Delete icon uses `text-destructive-foreground` color

## Definition of Done

### Design System Compliance
- [ ] All colors use design tokens (no hardcoded values)
- [ ] Component works in both light and dark themes
- [ ] Semantic colors used appropriately
```

## Testing the Workflow

### Test Case 1: New Project
**Input:** Empty directory + design-system.md + PRD
**Expected:**
- ✅ Story 0.0 generated
- ✅ Story 0.1 generated (depends on 0.0)
- ✅ All feature stories depend on 0.0 and 0.1
- ✅ All HSL values extracted

### Test Case 2: Existing Project
**Input:** Directory with package.json, app/ + design-system.md + PRD
**Expected:**
- ✅ Story 0.0 NOT generated
- ✅ Story 0.1 generated (no dependencies)
- ✅ All feature stories depend on 0.1 only
- ✅ All HSL values extracted

### Test Case 3: Design Token Extraction
**Input:** design-system.md with specific HSL values
**Expected:**
- ✅ Exact HSL values in Story 0.1 AC
- ✅ No generic placeholders
- ✅ All semantic colors included

## Success Metrics

- ✅ 100% project state detection before story generation
- ✅ Story 0.0 generated when needed, skipped when not
- ✅ Story 0.1 always generated with extracted tokens
- ✅ All feature stories have foundation dependencies
- ✅ All feature stories have design compliance in DoD
- ✅ Zero generic color descriptions
- ✅ All acceptance criteria testable

## Related Documents

- Agent Definition: `agents/definitions/scrum-master.md`
- Analysis: `analysis/CRITICAL-FINDINGS.md`
- Implementation Guide: `analysis/IMPLEMENTATION-GUIDE.md`
