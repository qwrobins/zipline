# Testing Patterns for Development Agents

## Overview

This guide provides common testing patterns and best practices used across all development agents.

## Testing Philosophy

### Test Pyramid

```
    E2E Tests (Few)
   ├─ Full user workflows
   └─ Critical paths

  Integration Tests (Some)
 ├─ Module interactions
 ├─ External dependencies
 └─ API contracts

Unit Tests (Many)
├─ Individual functions
├─ Edge cases
└─ Error conditions
```

### Coverage Goals

- **Unit tests**: >90% code coverage
- **Integration tests**: All module boundaries
- **E2E tests**: Critical user journeys
- **Focus**: Behavior over implementation

## Language-Specific Patterns

### Python (pytest)

**Basic Test Structure:**
```python
import pytest

def test_function_name():
    # Arrange
    input_data = create_test_data()
    
    # Act
    result = function_under_test(input_data)
    
    # Assert
    assert result == expected_value
```

**Parametrized Tests:**
```python
@pytest.mark.parametrize("input_data,expected", [
    ([], 0),
    ([1, 2, 3], 6),
    ([1, -1, 1], 1),
])
def test_calculate_sum(input_data, expected):
    result = calculate_sum(input_data)
    assert result == expected
```

**Async Tests:**
```python
@pytest.mark.asyncio
async def test_async_endpoint():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/users/123")
    assert response.status_code == 200
```

**Fixtures:**
```python
@pytest.fixture
def sample_user():
    return User(id="123", name="John Doe", email="john@example.com")

def test_user_validation(sample_user):
    assert sample_user.is_valid()
```

**Mocking:**
```python
from unittest.mock import AsyncMock, patch

@pytest.mark.asyncio
@patch('my_module.external_api_call')
async def test_service_with_mock(mock_api):
    mock_api.return_value = {"status": "success"}
    result = await service.process_data("test")
    assert result["status"] == "success"
```

### JavaScript/TypeScript (Jest/Vitest)

**Basic Test:**
```typescript
import { describe, it, expect } from 'vitest';

describe('calculateSum', () => {
  it('should sum array of numbers', () => {
    const result = calculateSum([1, 2, 3]);
    expect(result).toBe(6);
  });
});
```

**Async Tests:**
```typescript
it('should fetch user data', async () => {
  const user = await fetchUser('123');
  expect(user.id).toBe('123');
});
```

**Mocking:**
```typescript
import { vi } from 'vitest';

const mockFetch = vi.fn();
global.fetch = mockFetch;

it('should call API', async () => {
  mockFetch.mockResolvedValue({ json: () => ({ id: '123' }) });
  const result = await fetchUser('123');
  expect(mockFetch).toHaveBeenCalledWith('/api/users/123');
});
```

### React Testing Library

**Component Tests:**
```typescript
import { render, screen, fireEvent } from '@testing-library/react';

it('should render button and handle click', () => {
  const handleClick = vi.fn();
  render(<Button onClick={handleClick}>Click me</Button>);
  
  const button = screen.getByRole('button', { name: /click me/i });
  fireEvent.click(button);
  
  expect(handleClick).toHaveBeenCalledTimes(1);
});
```

**Async Component Tests:**
```typescript
import { waitFor } from '@testing-library/react';

it('should load and display data', async () => {
  render(<UserProfile userId="123" />);
  
  await waitFor(() => {
    expect(screen.getByText('John Doe')).toBeInTheDocument();
  });
});
```

### Go (testing package)

**Basic Test:**
```go
func TestCalculateSum(t *testing.T) {
    result := CalculateSum([]int{1, 2, 3})
    expected := 6
    
    if result != expected {
        t.Errorf("Expected %d, got %d", expected, result)
    }
}
```

**Table-Driven Tests:**
```go
func TestCalculateSum(t *testing.T) {
    tests := []struct {
        name     string
        input    []int
        expected int
    }{
        {"empty slice", []int{}, 0},
        {"positive numbers", []int{1, 2, 3}, 6},
        {"mixed numbers", []int{1, -1, 1}, 1},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := CalculateSum(tt.input)
            if result != tt.expected {
                t.Errorf("Expected %d, got %d", tt.expected, result)
            }
        })
    }
}
```

### Rust (cargo test)

**Basic Test:**
```rust
#[test]
fn test_calculate_sum() {
    let result = calculate_sum(&[1, 2, 3]);
    assert_eq!(result, 6);
}
```

**Async Tests:**
```rust
#[tokio::test]
async fn test_async_function() {
    let result = async_function().await;
    assert_eq!(result, expected_value);
}
```

## Common Testing Patterns

### Arrange-Act-Assert (AAA)

```
// Arrange - Set up test data and conditions
let input = createTestData();

// Act - Execute the code under test
let result = functionUnderTest(input);

// Assert - Verify the outcome
assert(result === expected);
```

### Given-When-Then (BDD)

```
// Given - Initial context
given('a user is logged in', () => {
  setupAuthenticatedUser();
});

// When - Action occurs
when('the user clicks logout', () => {
  clickLogoutButton();
});

// Then - Expected outcome
then('the user should be redirected to login', () => {
  expect(currentPage).toBe('/login');
});
```

### Test Doubles

**Stub** - Returns predetermined values:
```typescript
const stub = () => ({ id: '123', name: 'Test User' });
```

**Mock** - Verifies interactions:
```typescript
const mock = vi.fn();
functionUnderTest(mock);
expect(mock).toHaveBeenCalledWith(expectedArgs);
```

**Spy** - Wraps real implementation:
```typescript
const spy = vi.spyOn(object, 'method');
object.method();
expect(spy).toHaveBeenCalled();
```

**Fake** - Working implementation for testing:
```typescript
class FakeDatabase {
  private data = new Map();
  async save(key, value) { this.data.set(key, value); }
  async get(key) { return this.data.get(key); }
}
```

## Testing Workflow

### Before Writing Tests

1. **Understand requirements** - Read acceptance criteria
2. **Identify test cases** - Edge cases, happy path, errors
3. **Plan test structure** - Unit, integration, or E2E
4. **Set up test environment** - Fixtures, mocks, test data

### Writing Tests

1. **Start with happy path** - Basic functionality works
2. **Add edge cases** - Boundary conditions, empty inputs
3. **Test error conditions** - Invalid inputs, exceptions
4. **Verify interactions** - Mocks and spies for dependencies
5. **Check coverage** - Ensure adequate test coverage

### Running Tests

```bash
# Python
pytest                          # All tests
pytest tests/test_module.py     # Specific file
pytest -k "test_name"           # Specific test
pytest --cov=src                # With coverage

# JavaScript/TypeScript
npm test                        # All tests
npm test -- tests/module.test.ts # Specific file
npm test -- --coverage          # With coverage

# Go
go test ./...                   # All packages
go test -v ./pkg/module         # Specific package
go test -cover ./...            # With coverage

# Rust
cargo test                      # All tests
cargo test test_name            # Specific test
cargo test --package pkg_name   # Specific package
```

### Test Maintenance

- **Keep tests simple** - One assertion per test when possible
- **Use descriptive names** - Test name explains what's being tested
- **Avoid test interdependence** - Tests should run in any order
- **Update tests with code** - Tests are first-class code
- **Remove obsolete tests** - Delete tests for removed features

## Best Practices

### DO

- ✅ Test behavior, not implementation
- ✅ Use meaningful test names
- ✅ Keep tests fast and isolated
- ✅ Mock external dependencies
- ✅ Test edge cases and errors
- ✅ Maintain high coverage
- ✅ Run tests before committing

### DON'T

- ❌ Test private methods directly
- ❌ Use production data in tests
- ❌ Write flaky tests
- ❌ Skip failing tests
- ❌ Ignore test warnings
- ❌ Commit broken tests
- ❌ Over-mock (test becomes meaningless)

## Integration with Development Workflow

### Test-Driven Development (TDD)

1. **Red** - Write failing test
2. **Green** - Write minimal code to pass
3. **Refactor** - Improve code while keeping tests green

### Continuous Integration

- Tests run automatically on commit
- Builds fail if tests fail
- Coverage reports generated
- Test results visible in PR

### Pre-Merge Checklist

- [ ] All tests pass locally
- [ ] New code has tests
- [ ] Coverage meets threshold
- [ ] No skipped tests
- [ ] Tests are meaningful
- [ ] Test names are descriptive

## Resources

**Language-Specific:**
- Python: pytest documentation
- JavaScript: Jest/Vitest documentation
- Go: testing package documentation
- Rust: Rust book testing chapter

**General Testing:**
- Test pyramid concept
- Testing best practices
- TDD methodology
- BDD frameworks

