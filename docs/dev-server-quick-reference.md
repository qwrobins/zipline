# Development Server Management - Quick Reference

## 🚨 CRITICAL RULES

### ❌ NEVER Do These:
1. ❌ Kill processes on occupied ports (`kill`, `pkill`, `killall`, `taskkill`)
2. ❌ Use hardcoded default ports without checking availability
3. ❌ Fail if the default port is occupied
4. ❌ Assume you're the only agent running

### ✅ ALWAYS Do These:
1. ✅ Check port availability before starting server
2. ✅ Find available port in framework-specific range
3. ✅ Document which port was actually used
4. ✅ Configure tests to use actual port (not hardcoded)
5. ✅ Kill ONLY your own server process (using saved PID)

---

## Port Ranges by Framework

| Framework | Default | Range | Command |
|-----------|---------|-------|---------|
| **NestJS** | 3000 | 3000-3010 | `npm run start:dev -- --port $PORT` |
| **Express** | 3000 | 3000-3010 | `PORT=$PORT npm start` |
| **Next.js** | 3000 | 3000-3010 | `next dev -p $PORT` |
| **React (Vite)** | 5173 | 5173-5183 | `vite --port $PORT` |
| **React (CRA)** | 3000 | 3000-3010 | `PORT=$PORT npm start` |
| **Flask** | 5000 | 5000-5010 | `flask run --port $PORT` |
| **FastAPI** | 8000 | 8000-8010 | `uvicorn main:app --port $PORT` |
| **Django** | 8000 | 8000-8010 | `python manage.py runserver $PORT` |
| **Actix** | 8080 | 8080-8090 | `.bind(("127.0.0.1", port))` |
| **Axum** | 3000 | 3000-3010 | `.bind(("127.0.0.1", port))` |

---

## Quick Start: NestJS Example

```bash
# 1. Find available port
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

# 2. Start server
npm run start:dev -- --port $AVAILABLE_PORT &
SERVER_PID=$!

# 3. Run tests
export TEST_SERVER_PORT=$AVAILABLE_PORT
npm test

# 4. Cleanup
kill $SERVER_PID 2>/dev/null || true

# 5. Document
echo "Server port: $AVAILABLE_PORT"
```

---

## Quick Start: Python (FastAPI) Example

```bash
# 1. Find available port
AVAILABLE_PORT=$(python3 -c "
import socket
for port in range(8000, 8011):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.bind(('localhost', port))
            print(port)
            break
    except OSError:
        continue
")

# 2. Start server
uvicorn main:app --port $AVAILABLE_PORT &
SERVER_PID=$!

# 3. Run tests
export TEST_SERVER_PORT=$AVAILABLE_PORT
pytest

# 4. Cleanup
kill $SERVER_PID 2>/dev/null || true

# 5. Document
echo "Server port: $AVAILABLE_PORT"
```

---

## Port Detection Code Snippets

### Node.js
```javascript
const net = require('net');

async function findAvailablePort(start, end) {
  for (let port = start; port <= end; port++) {
    const available = await new Promise(resolve => {
      const server = net.createServer();
      server.once('error', () => resolve(false));
      server.once('listening', () => {
        server.close();
        resolve(true);
      });
      server.listen(port);
    });
    if (available) return port;
  }
  return null;
}

// Usage
const port = await findAvailablePort(3000, 3010);
if (!port) {
  console.error('No available ports');
  process.exit(1);
}
```

### Python
```python
import socket

def find_available_port(start, end):
    for port in range(start, end + 1):
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.bind(('localhost', port))
                return port
        except OSError:
            continue
    return None

# Usage
port = find_available_port(8000, 8010)
if not port:
    print('No available ports', file=sys.stderr)
    sys.exit(1)
```

### Rust
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

// Usage
let port = find_available_port(8080, 8090)
    .expect("No available ports in range");
```

---

## Test Configuration

### Jest (Node.js)
```javascript
// ❌ WRONG: Hardcoded port
const BASE_URL = 'http://localhost:3000';

// ✅ CORRECT: Use environment variable
const PORT = process.env.TEST_SERVER_PORT || 3000;
const BASE_URL = `http://localhost:${PORT}`;
```

### Pytest (Python)
```python
# ❌ WRONG: Hardcoded port
BASE_URL = "http://localhost:8000"

# ✅ CORRECT: Use environment variable
import os
PORT = os.environ.get('TEST_SERVER_PORT', '8000')
BASE_URL = f"http://localhost:{PORT}"
```

---

## Error Handling

### If All Ports Are Occupied

```bash
if [ -z "$AVAILABLE_PORT" ]; then
  echo "❌ ERROR: No available ports in range 3000-3010"
  echo ""
  echo "Possible solutions:"
  echo "1. Wait for other agents to complete their tests"
  echo "2. Expand the port range in the directive"
  echo "3. Check for orphaned server processes"
  echo ""
  echo "To check for orphaned processes:"
  echo "  lsof -i :3000-3010"
  exit 1
fi
```

---

## Documentation Template

### Dev Agent Record

```markdown
## Dev Agent Record

### Implementation Details
- Development server started on port: **3002** (default 3000 was in use)
- Server PID: 12345
- Tests configured to use port 3002

### Testing
All tests passed using development server on port 3002:
- Unit tests: ✅ Passed
- Integration tests: ✅ Passed (connected to http://localhost:3002)
- E2E tests: ✅ Passed

### Cleanup
- Server process (PID 12345) terminated successfully
- No orphaned processes
```

---

## Common Scenarios

### Scenario 1: Default Port Available ✅
```
Check port 3000 → Available
Start server on 3000
Document: "Server on port 3000"
```

### Scenario 2: Default Port Occupied ✅
```
Check port 3000 → In use
Check port 3001 → Available
Start server on 3001
Document: "Server on port 3001 (default 3000 was in use)"
```

### Scenario 3: Multiple Ports Occupied ✅
```
Check port 3000 → In use
Check port 3001 → In use
Check port 3002 → Available
Start server on 3002
Document: "Server on port 3002 (ports 3000-3001 were in use)"
```

### Scenario 4: All Ports Occupied ❌
```
Check ports 3000-3010 → All in use
Report error with clear message
Suggest solutions
Exit with error code
```

---

## Troubleshooting

### Check Which Ports Are In Use

**Unix/Linux/macOS:**
```bash
# Check specific port
lsof -i :3000

# Check port range
lsof -i :3000-3010

# Check all Node.js processes
lsof -i -P | grep node
```

**Windows:**
```cmd
# Check specific port
netstat -ano | findstr :3000

# Check all ports
netstat -ano
```

### Kill Orphaned Processes (Manual Only)

**⚠️ WARNING: Only do this manually, NEVER in agent code!**

```bash
# Find process on port 3000
lsof -ti :3000

# Kill specific PID (if you're sure it's orphaned)
kill <PID>
```

---

## Summary

**Remember:**
- 🚫 NEVER kill processes on occupied ports
- ✅ ALWAYS find an available port instead
- 📝 ALWAYS document which port was used
- 🧪 ALWAYS configure tests to use actual port
- 🧹 ALWAYS cleanup only your own server (using saved PID)

**In parallel execution, multiple agents may be running simultaneously. Your development server is just one of many. Be a good citizen and find your own port!**

---

**Full Documentation:** `agents/directives/development-server-management.md`
