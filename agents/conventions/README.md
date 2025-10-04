# Agent Conventions

This directory contains standards, conventions, and best practices for the agent ecosystem.

## Available Conventions

### [DOCS_DIRECTORY_CONVENTION.md](./DOCS_DIRECTORY_CONVENTION.md)
**Standard directory structure for planning documentation**

Defines the mandatory `docs/` directory convention used by all planning agents. Covers:
- Directory structure and organization
- Agent output locations
- File naming conventions
- Workflow integration
- Migration from other conventions

**Purpose**: Ensures all planning agents save documentation to consistent, predictable locations.

**Key Convention**:
```
docs/
├── prd.md                    # Product Requirements Document
├── prd/                      # Segmented PRD (optional)
├── architecture.md           # Architecture Document
├── architecture/             # Segmented architecture (optional)
└── stories/                  # User stories
```

## Why Conventions Matter

Conventions ensure:
- **Consistency** - All agents follow the same patterns
- **Predictability** - Developers know where to find files
- **Automation** - Tools can rely on standard locations
- **Collaboration** - Teams work with shared understanding
- **Maintainability** - Projects remain organized over time

## Convention Categories

### Directory Structure
- [DOCS_DIRECTORY_CONVENTION.md](./DOCS_DIRECTORY_CONVENTION.md) - Planning documentation structure

### Future Conventions

As the agent ecosystem grows, additional conventions may be added:
- Code organization conventions
- Testing conventions
- Naming conventions
- Git workflow conventions
- Documentation standards

## Related Documentation

- [../definitions/](../definitions/) - Agent definition files that follow these conventions
- [../guides/](../guides/) - Guides that reference these conventions
- [../README.md](../README.md) - Main agents overview
- [../../docs/](../../docs/) - Project documentation

## Contributing

When proposing new conventions:

1. Create a clear, descriptive document
2. Explain the rationale and benefits
3. Provide examples and migration paths
4. Update affected agent definitions
5. Document in this README
6. Get team consensus before enforcing

## Convention Enforcement

Conventions are enforced through:
- **Agent prompts** - Built into agent system prompts
- **Documentation** - Clear guidelines and examples
- **Code reviews** - Team verification
- **Automation** - Linting and validation tools (future)

## Updating Conventions

When updating existing conventions:

1. Document the change and rationale
2. Update all affected agent definitions
3. Update related guides and documentation
4. Provide migration instructions
5. Communicate changes to the team
6. Update the convention's changelog section

