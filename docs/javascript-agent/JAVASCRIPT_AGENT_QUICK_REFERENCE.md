# JavaScript Developer Agent - Quick Reference

**Enhanced**: 2025-10-01  
**File**: `agents/javascript-developer.md`  
**Lines**: 1,771 (was 747)

---

## 🎯 What's New - Quick Lookup

### 1. Modern JavaScript (ES2023+) - Lines 313-350

**Find**: "Modern JavaScript Features (ES2023+)"

**Key Topics**:
- Private class fields (`#field`)
- Top-level await
- Nullish coalescing (`??`)
- Optional chaining (`?.`)
- Dynamic imports
- WeakRef & FinalizationRegistry

**Use When**: Need latest JavaScript features

---

### 2. Advanced Async Patterns - Lines 352-410

**Find**: "Asynchronous Programming Mastery"

**Key Topics**:
- Promise.all, Promise.allSettled, Promise.race
- Async iterators & generators
- Event loop understanding
- Timeout patterns
- Concurrent execution

**Use When**: Complex async operations, streaming data

---

### 3. Functional Programming - Lines 412-546

**Find**: "Functional Programming Patterns"

**Key Topics**:
- Higher-order functions (compose, pipe)
- Pure functions & immutability
- Currying & partial application
- Memoization

**Use When**: Need functional patterns, performance optimization

---

### 4. Performance Optimization - Lines 548-604

**Find**: "Performance Optimization Techniques"

**Key Topics**:
- Memory management
- Debouncing & throttling
- WeakMap usage
- Garbage collection

**Use When**: Performance issues, memory leaks

---

### 5. Object-Oriented Patterns - Lines 606-815

**Find**: "Object-Oriented Patterns"

**Key Topics**:
- ES6 classes with private fields
- Mixin composition
- Design patterns (Singleton, Factory, Observer, Strategy)
- Proxy & Reflect

**Use When**: Need OOP patterns, meta-programming

---

### 6. Node.js Backend - Lines 707-876

**Find**: "Node.js Backend Expertise"

**Key Topics**:
- Stream API patterns
- Worker threads
- Cluster module
- EventEmitter patterns
- File system operations

**Use When**: Backend development, Node.js APIs

---

### 7. Browser APIs - Lines 878-977

**Find**: "Browser API Mastery"

**Key Topics**:
- Fetch with timeout & retry
- Web Workers
- IndexedDB
- Intersection Observer
- Service Workers

**Use When**: PWA, client-side storage, background processing

---

### 8. Security - Lines 979-1063

**Find**: "Security Best Practices"

**Key Topics**:
- XSS prevention
- CSRF protection
- Secure cookies
- Input validation
- Content Security Policy

**Use When**: Security concerns, production deployment

---

### 9. Build Optimization - Lines 1203-1322

**Find**: "Build Optimization and Tooling"

**Key Topics**:
- Webpack optimization
- Vite configuration
- Code splitting
- Tree shaking
- Bundle analysis

**Use When**: Bundle size issues, build optimization

---

### 10. Enhanced Testing - Lines 162-226

**Find**: "Step 5: Test Your Implementation"

**Key Topics**:
- Unit tests (Jest/Vitest)
- Component tests (RTL)
- Async testing
- Mocking strategies
- 85%+ coverage requirement

**Use When**: Writing tests, improving coverage

---

## 📋 Quality Checklist - Lines 1324-1400

**Find**: "JavaScript Development Checklist"

**Pre-Commit Checklist**:
- [ ] ESLint strict - no errors
- [ ] Prettier formatting applied
- [ ] Test coverage >85%
- [ ] JSDoc documentation complete
- [ ] Bundle size optimized
- [ ] Security vulnerabilities checked
- [ ] Cross-browser compatibility verified
- [ ] Performance benchmarks (Lighthouse >90)

---

## 🔍 Quick Search Guide

### Need Async Help?
**Search for**: "Asynchronous Programming Mastery"  
**Line**: ~352

### Need Performance Tips?
**Search for**: "Performance Optimization Techniques"  
**Line**: ~548

### Need Security Guidance?
**Search for**: "Security Best Practices"  
**Line**: ~979

### Need Node.js Patterns?
**Search for**: "Node.js Backend Expertise"  
**Line**: ~707

### Need Browser API Help?
**Search for**: "Browser API Mastery"  
**Line**: ~878

### Need Build Optimization?
**Search for**: "Build Optimization and Tooling"  
**Line**: ~1203

### Need OOP Patterns?
**Search for**: "Object-Oriented Patterns"  
**Line**: ~606

### Need Functional Programming?
**Search for**: "Functional Programming Patterns"  
**Line**: ~412

---

## 🎓 Code Example Locations

### Promise Patterns
**Line**: ~360-395

### Async Iterators
**Line**: ~397-410

### Function Composition
**Line**: ~420-435

### Memoization
**Line**: ~530-546

### Debouncing/Throttling
**Line**: ~573-604

### ES6 Classes
**Line**: ~610-650

### Design Patterns
**Line**: ~680-760

### Proxy & Reflect
**Line**: ~762-815

### Node.js Streams
**Line**: ~730-750

### Worker Threads
**Line**: ~752-775

### Web Workers
**Line**: ~900-925

### Service Workers
**Line**: ~950-977

### Security Examples
**Line**: ~985-1050

### Webpack Config
**Line**: ~1210-1235

### Vite Config
**Line**: ~1237-1260

---

## 🚨 Mandatory Sections (NEVER CHANGE)

### Critical Workflow Requirements
**Line**: 39-74  
**Status**: ✅ PRESERVED - Unchanged

### Development Workflow
**Line**: 76-201  
**Status**: ✅ PRESERVED - Enhanced testing section only

### Problem-Solving Protocol
**Line**: 203-309  
**Status**: ✅ PRESERVED - Unchanged

### User Story Integration
**Line**: 168-201  
**Status**: ✅ PRESERVED - Unchanged

---

## 📊 Coverage by Topic

| Topic | Lines | Coverage |
|-------|-------|----------|
| Workflow Requirements | 35 | 100% |
| Modern JavaScript | 240 | 90% |
| Async Programming | 60 | 95% |
| Functional Programming | 135 | 85% |
| OOP Patterns | 210 | 90% |
| Node.js Backend | 170 | 90% |
| Browser APIs | 100 | 85% |
| Security | 85 | 80% |
| Performance | 60 | 90% |
| Build Tools | 120 | 80% |
| Testing | 65 | 90% |
| React/Next.js | 200 | 100% |

---

## 🎯 When to Use What

### Frontend Component Development
→ React Best Practices (Line ~820)  
→ Next.js Patterns (Line ~880)  
→ TypeScript Types (Line ~660)

### Backend API Development
→ Node.js Expertise (Line ~707)  
→ Stream Patterns (Line ~730)  
→ EventEmitter (Line ~777)

### Performance Issues
→ Performance Optimization (Line ~548)  
→ Debouncing/Throttling (Line ~573)  
→ Memory Management (Line ~550)

### Security Concerns
→ Security Best Practices (Line ~979)  
→ XSS Prevention (Line ~985)  
→ Input Validation (Line ~1020)

### Build Problems
→ Build Optimization (Line ~1203)  
→ Code Splitting (Line ~1262)  
→ Bundle Analysis (Line ~1285)

### Testing
→ Enhanced Testing (Line ~162)  
→ Unit Tests (Line ~175)  
→ Component Tests (Line ~195)

---

## 💡 Pro Tips

1. **Always start with sequential_thinking** (Line 120-145)
2. **Consult context7 when uncertain** (Line 95-119)
3. **Follow Problem-Solving Protocol** (Line 203-309)
4. **Use the quality checklist** (Line 1324-1400)
5. **Check code examples** for patterns you need

---

## 🔗 Related Files

- **Strategy**: `AGENT_DEVELOPMENT_STRATEGY.md`
- **Summary**: `JAVASCRIPT_AGENT_ENHANCEMENT_SUMMARY.md`
- **Creation Guide**: `QUICK_AGENT_CREATION_GUIDE.md`

---

**Last Updated**: 2025-10-01
