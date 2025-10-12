# Development Server Management Fix

## Critical Issue Fixed: Port Conflicts in Parallel Execution

### Problem

When multiple developer agents run in parallel (e.g., in separate git worktrees), they often need to start development servers for testing. The previous behavior caused critical issues:

1. **Cross-Agent Interference**: Agent A kills Agent B's development server
2. **Terminal Session Termination**: Kill commands terminate the entire Claude Code terminal session
3. **Workflow Failures**: Both agents fail because their servers keep getting killed

**Example Scenario:**
```
Agent 1 (Story 1.2): Starts NestJS server on port 3000 for testing
Agent 2 (Story 1.3): Tries to start NestJS server on port 3000
Agent 2 finds port in use → kills all Node processes
Result: Agent 1's server killed + Claude terminal session terminated
Both agents fail
```

### Solution

Created a comprehensive development server management directive that:
1. **Prevents process killing** - Agents NEVER kill processes on occupied ports
2. **Automatic port selection** - Agents find available ports in framework-specific ranges
3. **Port documentation** - Agents document which port was actually used
4. **Test configuration** - Tests use actual port (not hardcoded defaults)

---

## Files Created

### 1. `agents/directives/development-server-management.md`

**Comprehensive directive covering:**

#### Absolute Prohibitions
- ❌ NEVER run kill commands (`kill`, `pkill`, `killall`, `taskkill`)
- ❌ NEVER assume you should kill a process because a port is in use
- ❌ NEVER use hardcoded default ports without checking availability
- ❌ NEVER fail if the default port is occupied

#### Required Workflow
1. **Detect Port Availability** - Check if default port is available
2. **Select Available Port** - Find first available port in framework-specific range
3. **Start Server** - Start server on selected port
4. **Document Port** - Record which port was used in Dev Agent Record
5. **Update Tests** - Configure tests to use actual port (not hardcoded)

#### Port Range Recommendations

| Framework | Default Port | Recommended Range | Command Example |
|-----------|--------------|-------------------|-----------------|
| NestJS | 3000 | 3000-3010 | `npm run start:dev -- --port $PORT` |
| Express | 3000 | 3000-3010 | `PORT=$PORT npm start` |
| Next.js | 3000 | 3000-3010 | `next dev -p $PORT` |
| React (Vite) | 5173 | 5173-5183 | `vite --port $PORT` |
| React (CRA) | 3000 | 3000-3010 | `PORT=$PORT npm start` |
| Flask | 5000 | 5000-5010 | `flask run --port $PORT` |
| FastAPI | 8000 | 8000-8010 | `uvicorn main:app --port $PORT` |
| Django | 8000 | 8000-8010 | `python manage.py runserver $PORT` |
| Actix (Rust) | 8080 | 8080-8090 | `.bind(("127.0.0.1", port))` |
| Axum (Rust) | 3000 | 3000-3010 | `.bind(("127.0.0.1", port))` |

#### Code Examples

**Port Detection (Node.js):**
```javascript
const net = require('net');

function isPortAvailable(port) {
  return new Promise((resolve) => {
    const server = net.createServer();
    server.once('error', () => resolve(false));
    server.once('listening', () => {
      server.close();
      resolve(true);
    });
    server.listen(port);
  });
}

async function findAvailablePort(startPort, endPort) {
  for (let port = startPort; port <= endPort; port++) {
    if (await isPortAvailable(port)) {
      return port;
    }
  }
  return null;
}
```

**Port Detection (Python):**
```python
import socket

def is_port_available(port):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.bind(('localhost', port))
            return True
    except OSError:
        return False

def find_available_port(start_port, end_port):
    for port in range(start_port, end_port + 1):
        if is_port_available(port):
            return port
    return None
```

**Port Detection (Rust):**
```rust
use std::net::TcpListener;

fn find_available_port(start: u16, end: u16) -> Option<u16> {
    for port in start..=end {
        if TcpListener::bind(("127.0.0.1", port)).is_ok() {
            return Some(port);
        }
    }
    None
}
```

#### Complete Example Workflow (NestJS)

```bash
#!/bin/bash

# Step 1: Find available port
echo "Finding available port in range 3000-3010..."
AVAILABLE_PORT=$(node -e "
const net = require('net');
async function findPort() {
  for (let port = 3000; port <= 3010; port++) {
    const available = await new Promise(resolve => {
      const server = net.createServer();
      server.once('error', () => resolve(false));
      server.once('listening', () => { server.close(); resolve(true); });
      server.listen(port);
    });
    if (available) { console.log(port); return; }
  }
  process.exit(1);
}
findPort();
")

if [ -z "$AVAILABLE_PORT" ]; then
  echo "❌ ERROR: No available ports in range 3000-3010"
  exit 1
fi

echo "✅ Found available port: $AVAILABLE_PORT"

# Step 2: Start development server
npm run start:dev -- --port $AVAILABLE_PORT &
SERVER_PID=$!

# Step 3: Wait for server to be ready
sleep 5

# Step 4: Run tests with correct port
export TEST_SERVER_PORT=$AVAILABLE_PORT
npm test
TEST_EXIT_CODE=$?

# Step 5: Cleanup (kill ONLY our server)
kill $SERVER_PID 2>/dev/null || true

# Step 6: Document port usage
echo "Development server port: $AVAILABLE_PORT"
echo "Server PID: $SERVER_PID"
echo "Tests exit code: $TEST_EXIT_CODE"

exit $TEST_EXIT_CODE
```

---

## Files Modified

### Agent Definitions Updated

All developer agent definitions now reference the new directive:

1. **`agents/definitions/nestjs-developer.md`**
   - Added reference in CRITICAL REQUIREMENTS section
   - Added reference in Testing section
   - Port range: 3000-3010

2. **`agents/definitions/react-developer.md`**
   - Added reference in CRITICAL REQUIREMENTS section
   - Port range: 5173-5183 (Vite) or 3000-3010 (CRA)

3. **`agents/definitions/nextjs-developer.md`**
   - Added reference in CRITICAL REQUIREMENTS section
   - Port range: 3000-3010

4. **`agents/definitions/vanilla-javascript-developer.md`**
   - Added reference in CRITICAL REQUIREMENTS section
   - Port range: 3000-3010 (Express/Node.js)

5. **`agents/definitions/typescript-developer.md`**
   - Added reference in CRITICAL REQUIREMENTS section
   - Port range: Framework-specific

6. **`agents/definitions/python-developer.md`**
   - Added reference in CRITICAL WORKFLOW REQUIREMENTS section
   - Port range: 8000-8010 (FastAPI) or 5000-5010 (Flask)

7. **`agents/definitions/rust-developer.md`**
   - Added reference in CRITICAL WORKFLOW REQUIREMENTS section
   - Port range: 8080-8090 (Actix) or 3000-3010 (Axum)

### Reference Added to Each Agent

```markdown
### 🚨 CRITICAL: Development Server Management (Parallel Execution)
**See `agents/directives/development-server-management.md` for:**
- **NEVER kill processes** on occupied ports
- **ALWAYS find available port** in range [framework-specific]
- Port detection and selection strategies
- Framework-specific port configuration
- Test configuration for dynamic ports
- **This is MANDATORY for parallel agent execution**
```

---

## Expected Behavior

### Before Fix ❌

```
Agent 1: Start server on port 3000
Agent 2: Try to start server on port 3000
Agent 2: Port in use → kill all Node processes
Result: Agent 1's server killed, Claude terminal terminated, both agents fail
```

### After Fix ✅

```
Agent 1: Find available port → 3000 available → Start on 3000
Agent 2: Find available port → 3000 in use → Try 3001 → Start on 3001
Result: Both servers running, both agents succeed
```

---

## Benefits

### Stability
- ✅ No cross-agent interference
- ✅ Claude Code terminal sessions remain stable
- ✅ Both agents can run development servers simultaneously

### Reliability
- ✅ Automatic port selection prevents conflicts
- ✅ Clear error messages if all ports are occupied
- ✅ Proper cleanup (only kill own server process)

### Documentation
- ✅ Port usage documented in Dev Agent Record
- ✅ Tests configured to use actual port
- ✅ Clear troubleshooting guidance

### Best Practices
- ✅ Never kill processes on occupied ports
- ✅ Framework-specific port ranges
- ✅ Cross-platform port detection
- ✅ Proper error handling

---

## Verification Checklist

- [ ] Multiple agents can start development servers simultaneously
- [ ] Each agent automatically selects an available port
- [ ] No agent kills another agent's processes
- [ ] Claude Code terminal sessions remain stable
- [ ] All agents document which port they used
- [ ] Tests connect to the correct port (not hardcoded defaults)
- [ ] Error messages are clear when all ports are occupied
- [ ] Cleanup only kills the agent's own server process

---

## Testing Scenarios

### Scenario 1: Two Agents, Same Framework

```
Agent 1 (NestJS, Story 1.2):
  - Find port: 3000 available
  - Start server on 3000
  - Run tests on 3000
  - Document: "Server on port 3000"

Agent 2 (NestJS, Story 1.3):
  - Find port: 3000 in use, 3001 available
  - Start server on 3001
  - Run tests on 3001
  - Document: "Server on port 3001"

Result: ✅ Both succeed
```

### Scenario 2: Three Agents, Different Frameworks

```
Agent 1 (NestJS): Port 3000
Agent 2 (Next.js): Port 3001 (3000 in use)
Agent 3 (React Vite): Port 5173 (different range)

Result: ✅ All succeed
```

### Scenario 3: All Ports Occupied

```
Agent 1: Tries ports 3000-3010, all occupied
Agent 1: Reports error with clear message
Agent 1: Suggests solutions (wait, expand range, check orphaned processes)

Result: ✅ Clear error, no silent failure
```

---

## Summary

**Issue:** Port conflicts causing cross-agent interference and terminal termination

**Solution:** Comprehensive development server management directive

**Impact:**
- ✅ Parallel execution stability
- ✅ No process killing
- ✅ Automatic port selection
- ✅ Clear documentation
- ✅ Proper error handling

**Status:** ✅ COMPLETE

All developer agents now follow the directive and will never kill processes on occupied ports.
