# Development Server Management Directive

## 🚨 CRITICAL: Port Conflict Prevention for Parallel Execution

**This directive is MANDATORY for all developer agents when starting development servers.**

### The Problem

When multiple developer agents run in parallel (e.g., in separate git worktrees), they often need to start development servers for testing. If agents attempt to kill processes on occupied ports, it causes:

1. **Cross-Agent Interference**: Agent A kills Agent B's development server
2. **Terminal Session Termination**: Kill commands can terminate the entire Claude Code terminal session
3. **Workflow Failures**: Both agents fail because their servers keep getting killed

### The Solution

**NEVER kill processes. ALWAYS find an available port instead.**

---

## 🚫 ABSOLUTE PROHIBITIONS

### NEVER Do These:

1. ❌ **NEVER run kill commands**:
   - `kill`, `pkill`, `killall` (Unix/Linux/macOS)
   - `taskkill` (Windows)
   - `fuser -k` (Linux)
   - Any command that terminates processes

2. ❌ **NEVER assume you should kill a process** because a port is in use

3. ❌ **NEVER use hardcoded default ports** without checking availability first

4. ❌ **NEVER fail** if the default port is occupied - find an alternative

---

## ✅ REQUIRED WORKFLOW

### Step 1: Detect Port Availability

**Before starting any development server, check if the default port is available.**

#### Unix/Linux/macOS:
```bash
# Check if port 3000 is in use
if lsof -i :3000 >/dev/null 2>&1; then
  echo "Port 3000 is in use"
else
  echo "Port 3000 is available"
fi
```

#### Cross-Platform (Node.js):
```javascript
// check-port.js
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

// Usage
findAvailablePort(3000, 3010).then(port => {
  if (port) {
    console.log(port);
  } else {
    console.error('No available ports in range 3000-3010');
    process.exit(1);
  }
});
```

#### Cross-Platform (Python):
```python
# check_port.py
import socket

def is_port_available(port):
    """Check if a port is available."""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.bind(('localhost', port))
            return True
    except OSError:
        return False

def find_available_port(start_port, end_port):
    """Find an available port in the given range."""
    for port in range(start_port, end_port + 1):
        if is_port_available(port):
            return port
    return None

# Usage
port = find_available_port(8000, 8010)
if port:
    print(port)
else:
    print('No available ports in range 8000-8010', file=sys.stderr)
    sys.exit(1)
```

### Step 2: Select Available Port

**Use a port range specific to your framework and find the first available port.**

#### Port Range Recommendations:

| Framework | Default Port | Recommended Range | Command Example |
|-----------|--------------|-------------------|-----------------|
| NestJS | 3000 | 3000-3010 | `npm run start:dev -- --port $PORT` |
| Express | 3000 | 3000-3010 | `PORT=$PORT npm start` |
| Next.js | 3000 | 3000-3010 | `next dev -p $PORT` |
| React (Vite) | 5173 | 5173-5183 | `vite --port $PORT` |
| React (CRA) | 3000 | 3000-3010 | `PORT=$PORT npm start` |
| Vue (Vite) | 5173 | 5173-5183 | `vite --port $PORT` |
| Flask | 5000 | 5000-5010 | `flask run --port $PORT` |
| FastAPI | 8000 | 8000-8010 | `uvicorn main:app --port $PORT` |
| Django | 8000 | 8000-8010 | `python manage.py runserver $PORT` |
| Actix (Rust) | 8080 | 8080-8090 | Set in code: `.bind(("127.0.0.1", port))` |
| Axum (Rust) | 3000 | 3000-3010 | Set in code: `.bind(("127.0.0.1", port))` |

### Step 3: Start Server with Selected Port

**Examples for common frameworks:**

#### NestJS:
```bash
# Find available port
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

# Start server on available port
npm run start:dev -- --port $AVAILABLE_PORT &
SERVER_PID=$!
echo "NestJS server started on port $AVAILABLE_PORT (PID: $SERVER_PID)"
```

#### Next.js:
```bash
# Find available port (same as above)
AVAILABLE_PORT=$(node check-port.js)

# Start server
next dev -p $AVAILABLE_PORT &
SERVER_PID=$!
echo "Next.js server started on port $AVAILABLE_PORT (PID: $SERVER_PID)"
```

#### React (Vite):
```bash
# Find available port
AVAILABLE_PORT=$(node -e "/* same port finding logic */")

# Start server
vite --port $AVAILABLE_PORT &
SERVER_PID=$!
echo "Vite dev server started on port $AVAILABLE_PORT (PID: $SERVER_PID)"
```

#### Python (FastAPI):
```bash
# Find available port
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

# Start server
uvicorn main:app --port $AVAILABLE_PORT &
SERVER_PID=$!
echo "FastAPI server started on port $AVAILABLE_PORT (PID: $SERVER_PID)"
```

#### Python (Flask):
```bash
# Find available port (same as above)
AVAILABLE_PORT=$(python3 check_port.py)

# Start server
flask run --port $AVAILABLE_PORT &
SERVER_PID=$!
echo "Flask server started on port $AVAILABLE_PORT (PID: $SERVER_PID)"
```

#### Rust (Actix):
```rust
// In your main.rs or server setup
use actix_web::{App, HttpServer};
use std::net::TcpListener;

fn find_available_port(start: u16, end: u16) -> Option<u16> {
    for port in start..=end {
        if TcpListener::bind(("127.0.0.1", port)).is_ok() {
            return Some(port);
        }
    }
    None
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let port = find_available_port(8080, 8090)
        .expect("No available ports in range 8080-8090");
    
    println!("Starting server on port {}", port);
    
    HttpServer::new(|| App::new())
        .bind(("127.0.0.1", port))?
        .run()
        .await
}
```

### Step 4: Document Port Usage

**ALWAYS document which port was actually used in your Dev Agent Record.**

```markdown
## Dev Agent Record

### Implementation Details
- Development server started on port: **3002** (default 3000 was in use)
- Server PID: 12345
- Tests configured to use port 3002

### Testing
All tests passed using development server on port 3002:
- API endpoint tests: http://localhost:3002/api
- Integration tests: Connected to port 3002
```

### Step 5: Update Tests to Use Actual Port

**DO NOT hardcode default ports in tests. Use the actual port.**

#### Example (Jest/Supertest):
```javascript
// ❌ WRONG: Hardcoded port
const request = require('supertest');
const app = 'http://localhost:3000';

// ✅ CORRECT: Use environment variable or detected port
const PORT = process.env.TEST_SERVER_PORT || 3000;
const app = `http://localhost:${PORT}`;

describe('API Tests', () => {
  it('should respond to health check', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
  });
});
```

#### Example (Python pytest):
```python
# ❌ WRONG: Hardcoded port
BASE_URL = "http://localhost:8000"

# ✅ CORRECT: Use environment variable or detected port
import os
PORT = os.environ.get('TEST_SERVER_PORT', '8000')
BASE_URL = f"http://localhost:{PORT}"

def test_health_check():
    response = requests.get(f"{BASE_URL}/health")
    assert response.status_code == 200
```

---

## 🔧 Error Handling

### If All Ports in Range Are Occupied

**DO NOT fail silently. Report to orchestrator.**

```bash
AVAILABLE_PORT=$(node check-port.js)

if [ -z "$AVAILABLE_PORT" ]; then
  echo "❌ ERROR: No available ports in range 3000-3010"
  echo "This likely means multiple development servers are already running."
  echo "Possible solutions:"
  echo "1. Wait for other agents to complete their tests"
  echo "2. Expand the port range in the directive"
  echo "3. Check for orphaned server processes"
  exit 1
fi
```

### Cleanup After Testing

**ONLY kill your own server process, using the PID you saved.**

```bash
# Start server and save PID
npm run start:dev -- --port $AVAILABLE_PORT &
SERVER_PID=$!

# Run tests
npm test

# Cleanup: Kill ONLY your server (using saved PID)
kill $SERVER_PID 2>/dev/null || true
```

---

## 📋 Complete Example Workflow

### NestJS Development Server for Testing

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
  console.error('No available ports');
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
echo "Starting NestJS development server on port $AVAILABLE_PORT..."
npm run start:dev -- --port $AVAILABLE_PORT &
SERVER_PID=$!

# Wait for server to be ready
echo "Waiting for server to start..."
sleep 5

# Verify server is running
if ! curl -s http://localhost:$AVAILABLE_PORT/health > /dev/null; then
  echo "❌ ERROR: Server failed to start"
  kill $SERVER_PID 2>/dev/null || true
  exit 1
fi

echo "✅ Server is running on port $AVAILABLE_PORT (PID: $SERVER_PID)"

# Step 3: Run tests with correct port
export TEST_SERVER_PORT=$AVAILABLE_PORT
npm test

# Save test exit code
TEST_EXIT_CODE=$?

# Step 4: Cleanup (kill ONLY our server)
echo "Cleaning up server (PID: $SERVER_PID)..."
kill $SERVER_PID 2>/dev/null || true

# Step 5: Document port usage
echo ""
echo "=== Dev Agent Record ==="
echo "Development server port: $AVAILABLE_PORT"
echo "Server PID: $SERVER_PID"
echo "Tests exit code: $TEST_EXIT_CODE"
echo "======================="

exit $TEST_EXIT_CODE
```

---

## 🎯 Summary

### ALWAYS:
- ✅ Check port availability before starting server
- ✅ Find an available port in the recommended range
- ✅ Document which port was actually used
- ✅ Update tests to use the actual port
- ✅ Kill ONLY your own server process (using saved PID)

### NEVER:
- ❌ Kill processes on occupied ports
- ❌ Use hardcoded default ports without checking
- ❌ Fail silently if no ports are available
- ❌ Assume you're the only agent running

### Remember:
**In parallel execution, multiple agents may be running simultaneously. Your development server is just one of many. Be a good citizen and find your own port!**
