# JavaScript Developer Agent - Critical Workflow Updates

## Summary of Changes

The `agents/javascript-developer.md` agent definition has been updated with critical workflow requirements that are now **MANDATORY** and **NON-NEGOTIABLE**. These changes emphasize proper planning, documentation consultation, problem-solving, and user story management.

## What Was Added

### 1. Critical Workflow Requirements Section (NEW)

Added a prominent **⚠️ CRITICAL WORKFLOW REQUIREMENTS ⚠️** section immediately after "Your Core Responsibilities" that highlights four mandatory requirements:

1. **ALWAYS Use Sequential Thinking Before Coding**
   - Must use `sequential_thinking` tool to plan BEFORE writing any code
   - Not optional - required for every implementation
   - Break down tasks, identify challenges, plan structure

2. **ALWAYS Consult Documentation When Uncertain**
   - Must use `context7` tools to consult official documentation
   - Required whenever there is ANY uncertainty
   - Default behavior, not an exception

3. **ALWAYS Follow the Problem-Solving Protocol**
   - Mandatory iterative cycle when encountering difficulties
   - Research → Analyze → Implement → Verify → Iterate
   - Must complete 2-3 cycles before asking for help

4. **ALWAYS Update User Story Status**
   - Required when implementing from `docs/stories/`
   - Update status to "Ready for Review"
   - Document work in "Dev Agent Record" section

### 2. Enhanced Development Workflow

Updated the **Development Workflow** section with:

#### Step 1: Understand the Codebase (Enhanced)
- Added requirement to read entire user story file if implementing from `docs/stories/`

#### Step 2: Consult Official Documentation (MANDATORY - NEW)
- **Completely rewritten** to emphasize this is NOT optional
- Made it clear this is the DEFAULT behavior when facing any implementation question
- Added specific scenarios requiring documentation consultation
- Provided detailed examples of context7 usage

#### Step 3: Plan with Sequential Thinking (MANDATORY - Enhanced)
- **Made this a REQUIRED first step**, not optional
- Added detailed list of what to plan
- Provided example sequential_thinking usage
- Emphasized this must happen BEFORE writing code

#### Step 4: Implement with Best Practices (Enhanced)
- Added instruction to STOP and consult documentation if uncertain during implementation

#### Step 6: Update User Story Status (NEW)
- **Completely new step** for user story management
- Detailed instructions on updating story status
- Specific format for "Dev Agent Record" section
- Requirements for documenting:
  - What was implemented
  - Files created/modified
  - Deviations from acceptance criteria
  - Follow-up tasks
  - Known issues

### 3. Problem-Solving Protocol Section (NEW)

Added a comprehensive **Problem-Solving Protocol** section that includes:

#### When to Use This Protocol
- Clear list of scenarios requiring the protocol
- Errors, test failures, uncertainty, being stuck

#### The Problem-Solving Cycle (MANDATORY)
Detailed 5-step iterative cycle:

1. **RESEARCH** - Consult official documentation with context7
   - Be specific about what you're looking for
   - Look for examples and common pitfalls
   - Provided detailed examples

2. **ANALYZE** - Use sequential_thinking
   - Review error messages carefully
   - Identify expected vs. actual behavior
   - Consider alternative approaches
   - Provided detailed examples

3. **IMPLEMENT** - Try the new approach
   - Apply what you learned from documentation
   - Use insights from sequential thinking
   - Make targeted changes

4. **VERIFY** - Test the solution
   - Run tests to verify the fix
   - Check original problem is resolved
   - Ensure no new problems introduced

5. **ITERATE** - Repeat if necessary
   - Go back to Step 1 if problem persists
   - Try different approaches
   - DO NOT give up until 2-3 cycles completed

#### Example Problem-Solving Scenario
- Provided concrete example showing two cycles
- Demonstrates how to iterate and improve

#### When to Ask for Help
- Only after completing the cycle 2-3 times
- Must document what was tried and learned
- Must provide specific information

### 4. Enhanced Tool Usage Guidelines

Updated **Tool Usage Guidelines** section with:

#### sequential_thinking (MANDATORY)
- Added "MANDATORY - Use BEFORE coding" label
- Emphasized it must be used for ALL implementations
- Provided detailed example of planning a feature

#### context7 (MANDATORY)
- Added "MANDATORY - Use when uncertain" label
- Emphasized use whenever there is ANY uncertainty
- Provided multiple detailed examples:
  - Researching Next.js
  - Researching React
  - Specific topics and library IDs

#### str-replace-editor (Enhanced)
- Added specific use case for updating user story status
- Added use case for adding Dev Agent Record

### 5. Enhanced "Remember" Section

Completely restructured the **Remember** section with:

#### MANDATORY Steps (Non-Negotiable) - NEW
- Four critical requirements listed prominently
- Clear statement that these are non-negotiable

#### Code Quality Standards
- Preserved existing quality standards

#### When Uncertain - NEW
- Step-by-step process for handling uncertainty
- Emphasis on documentation first

#### When Stuck - NEW
- Clear DO and DO NOT instructions
- Emphasis on iteration and persistence

#### Communication - NEW
- Requirements for explaining approach
- Documenting decisions
- Updating story status

#### Updated Closing Statement
- Reinforced mandatory use of sequential_thinking and context7
- Emphasized problem-solving protocol
- Added statement about never giving up after first attempt

## Key Behavioral Changes

### Before These Updates
- Sequential thinking was suggested for "complex tasks"
- Context7 was mentioned as "when needed"
- No formal problem-solving protocol
- No user story status management
- Agent might give up after first failure

### After These Updates
- Sequential thinking is MANDATORY before ANY code
- Context7 is MANDATORY when ANY uncertainty exists
- Formal problem-solving protocol with 5 steps
- Required user story status updates with specific format
- Agent must iterate 2-3 times before asking for help
- Clear emphasis on persistence and iteration

## Impact on Agent Behavior

These changes will result in:

1. **Better Planning**: Agent will always plan before implementing
2. **More Accurate Implementations**: Agent will consult documentation instead of guessing
3. **Better Problem-Solving**: Agent will iterate and research instead of giving up
4. **Better Documentation**: User stories will be properly updated with implementation details
5. **More Persistence**: Agent will try multiple approaches before asking for help
6. **Higher Quality**: Less guessing, more research-based implementations

## Usage Example

**Before:**
```
User: "Create a Next.js API route for user authentication"
Agent: [Immediately starts writing code, might guess at API]
```

**After:**
```
User: "Create a Next.js API route for user authentication"
Agent: 
1. Uses sequential_thinking to plan the implementation
2. Uses context7 to consult Next.js documentation on API routes
3. Uses context7 to research authentication best practices
4. Implements based on documentation and plan
5. If errors occur, follows problem-solving protocol
6. Updates user story status if implementing from docs/stories/
```

## File Location

The updated agent definition is located at:
```
agents/javascript-developer.md
```

## Related Documentation

These updates align with and reference:
- `agents/DEVELOPMENT_AGENTS.md` - Development agents overview
- `agents/JAVASCRIPT_DEVELOPER_GUIDE.md` - User guide
- `docs/stories/` - User story files that need status updates

## Version

- **Previous Version**: 1.0
- **Updated Version**: 2.0
- **Update Date**: 2025-10-01
- **Changes**: Added mandatory workflow requirements, problem-solving protocol, and user story management

---

**Maintained By**: AI Agent Development Team

