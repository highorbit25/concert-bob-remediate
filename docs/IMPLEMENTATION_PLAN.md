# Implementation Plan: TanStack Demo on Dev Branch

## Overview

This document tracks the implementation of the TanStack supply chain attack demonstration on the `tanstack-demo` branch. The goal is to replace the Python Flask app with a Node.js/React application while maintaining the ability to continue using the main branch during development.

## Branch Strategy

```
main (Python Flask app - stable)
  └── tanstack-demo (Node.js/React app - development)
```

**Benefits**:
- Main branch remains stable with Python demo
- Can continue using repo during development
- Easy to test and compare implementations
- Can merge when ready or keep separate

## Implementation Status

### ✅ Phase 1: Research & Documentation (COMPLETED)
- [x] TanStack attack analysis document
- [x] False positive detection methodology
- [x] Implementation plan document

### 🔄 Phase 2: Node.js Project Setup (IN PROGRESS)
- [ ] Create package.json with safe versions
- [ ] Set up Vite + React
- [ ] Configure testing with Vitest
- [ ] Add .gitignore for Node.js

### ⏳ Phase 3: React Application (PENDING)
- [ ] Create App.jsx with TanStack Query
- [ ] Implement UserList component
- [ ] Implement Weather component (axios)
- [ ] Create API layer files
- [ ] Add basic styling

### ⏳ Phase 4: Unit Tests (PENDING)
- [ ] Set up Vitest configuration
- [ ] Write UserList tests
- [ ] Write Weather tests
- [ ] Write API function tests

### ⏳ Phase 5: GitHub Integration (PENDING)
- [ ] Create TanStack issue template
- [ ] Create axios false positive template
- [ ] Update workflow for npm
- [ ] Update Bob custom modes

### ⏳ Phase 6: Documentation (PENDING)
- [ ] Update README
- [ ] Create workflow diagrams
- [ ] Document testing procedures

### ⏳ Phase 7: Testing (PENDING)
- [ ] Test TRUE POSITIVE workflow
- [ ] Test FALSE POSITIVE workflow
- [ ] Verify npm install timing
- [ ] End-to-end validation

## File Structure

```
concert-bob-remediate/ (tanstack-demo branch)
├── package.json              # NEW
├── package-lock.json         # NEW
├── vite.config.js           # NEW
├── vitest.config.js         # NEW
├── index.html               # NEW
├── .gitignore               # UPDATED
├── src/                     # NEW
│   ├── main.jsx
│   ├── App.jsx
│   ├── App.css
│   ├── components/
│   │   ├── UserList.jsx
│   │   ├── UserList.test.jsx
│   │   ├── Weather.jsx
│   │   └── Weather.test.jsx
│   └── api/
│       ├── users.js
│       ├── users.test.js
│       ├── weather.js
│       └── weather.test.js
├── docs/                    # UPDATED
│   ├── tanstack-attack-analysis.md
│   ├── false-positive-methodology.md
│   └── IMPLEMENTATION_PLAN.md
├── .github/
│   ├── workflows/
│   │   └── bob-shell-v2.yml # UPDATED
│   └── ISSUE_TEMPLATE/
│       ├── tanstack-supply-chain.md  # NEW
│       └── axios-false-positive.md   # NEW
├── .bob/
│   └── custom_modes.yaml    # UPDATED
└── README.md                # UPDATED
```

## Key Decisions

### 1. Package Versions

**Decision**: Use safe versions in package.json
```json
{
  "@tanstack/react-query": "5.62.3",  // Safe version
  "axios": "1.5.1"                    // Has CVE but used safely
}
```

**Rationale**:
- Can safely run `npm install` during development
- Can run tests to verify functionality
- Concert will be configured to simulate detecting 5.62.1
- Issue templates will reference vulnerable versions

### 2. npm install Timing

**Decision**: Only run `npm install` AFTER Bob creates PR with safe versions

**Workflow**:
1. Initial state: package.json has safe versions
2. Issue created: Simulates detecting vulnerable version
3. Bob analyzes: Updates package.json (or detects false positive)
4. PR created: Contains safe versions
5. npm install: NOW safe to install and test

### 3. False Positive Example

**Decision**: Use axios CVE-2023-45857 with safe usage pattern

**Why**:
- Package IS used (not just unused)
- Demonstrates intelligent code analysis
- Realistic scenario
- Clear safe vs unsafe patterns

### 4. Testing Strategy

**Decision**: Use Vitest + React Testing Library

**Why**:
- Fast and modern
- Great Vite integration
- Similar to Jest (familiar)
- Good React support

## Development Workflow

### For This Implementation

1. **Create files on tanstack-demo branch**
2. **Test locally** (can run npm install safely)
3. **Commit incrementally**
4. **Keep main branch untouched**
5. **Merge when ready** (or keep separate)

### For Demo Usage

1. **User creates issue** (TanStack or axios)
2. **Workflow triggers** Bob Shell
3. **Bob analyzes** code and CVE
4. **Bob determines** TRUE/FALSE positive
5. **Bob takes action** (PR or comment)
6. **DevOps reviews** and approves
7. **Tests run** (npm install safe versions)
8. **Code fixes** if needed
9. **PR merged** to production

## Safety Measures

### During Development
- ✅ Using safe package versions
- ✅ Can run npm install anytime
- ✅ Can test functionality
- ✅ No risk of malicious code

### During Demo
- ✅ Issue templates reference vulnerable versions
- ✅ Bob analyzes simulated scenario
- ✅ npm install only after PR with safe versions
- ✅ Multiple safety checks in workflow

## Next Steps

1. Create package.json with dependencies
2. Set up Vite + React project structure
3. Implement components
4. Write tests
5. Update workflow and templates
6. Test end-to-end
7. Update documentation

## Timeline

- **Week 1**: Project setup + React app (Days 1-5)
- **Week 2**: Tests + GitHub integration (Days 6-10)
- **Week 3**: Documentation + testing (Days 11-15)

## Success Criteria

- [ ] React app runs successfully
- [ ] TanStack Query demonstrates usage
- [ ] axios shows safe usage pattern
- [ ] All tests pass
- [ ] Bob detects TRUE POSITIVE correctly
- [ ] Bob detects FALSE POSITIVE correctly
- [ ] npm install only runs after PR
- [ ] Complete documentation
- [ ] End-to-end workflow tested

## Notes

- Main branch remains stable with Python app
- Can switch between branches easily
- Can demo both implementations if needed
- Easy to merge or keep separate

---

*Last Updated: 2026-06-04*  
*Branch: tanstack-demo*  
*Status: In Progress*