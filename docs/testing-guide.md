# Testing Guide for Concert + Bob CVE Remediation

This guide explains how to test the CVE remediation workflow in different environments.

## Table of Contents
1. [Testing Philosophy](#testing-philosophy)
2. [Local Development Testing](#local-development-testing)
3. [GitHub Actions Testing](#github-actions-testing)
4. [End-to-End Workflow Testing](#end-to-end-workflow-testing)
5. [Troubleshooting](#troubleshooting)

---

## Testing Philosophy

### Why Packages Are Not Installed Locally

The repository intentionally uses **vulnerable package versions** that cannot be installed:

**npm packages**:
- `@tanstack/react-query@5.62.1` - Withdrawn from npm registry (supply chain attack)
- `axios@1.5.1` - Has known CVE but installable

**Python packages**:
- Various vulnerable Flask versions in `app/vulnerable/requirements.txt`

### Safety-First Approach

1. **Vulnerable versions are referenced but not installed** - This allows us to demonstrate the workflow without exposing systems to actual vulnerabilities
2. **Installation only happens AFTER remediation** - Bob creates a PR with safe versions, then GitHub Actions installs and tests
3. **Tests run in isolated CI environment** - GitHub Actions provides clean, isolated runners

---

## Local Development Testing

### What CAN Be Tested Locally

#### 1. Code Structure and Syntax
```bash
# Check JavaScript/TypeScript syntax
npx eslint src/ --ext .js,.jsx

# Check Python syntax
cd app/vulnerable
python -m py_compile main.py test_main.py
```

#### 2. Documentation and Configuration
```bash
# Verify package.json structure
cat package.json | jq .

# Verify requirements.txt format
cat app/vulnerable/requirements.txt

# Check workflow syntax
yamllint .github/workflows/bob-shell-v2.yml
```

#### 3. Bob Custom Modes
```bash
# Validate custom modes YAML
yamllint .bob/custom_modes.yaml

# Check mode definitions
cat .bob/custom_modes.yaml | grep -A 5 "slug:"
```

### What CANNOT Be Tested Locally

❌ **npm install** - Vulnerable TanStack versions are withdrawn
❌ **npm test** - Requires installed packages
❌ **Running the React app** - Requires installed packages
❌ **Python pip install** - Would install vulnerable packages
❌ **Running Flask app** - Requires vulnerable packages

### Safe Local Verification

You can verify the code structure without installing packages:

```bash
# Verify React component structure
cat src/components/UserList.jsx | grep -E "(import|export|function)"

# Verify test structure
cat src/test/UserList.test.jsx | grep -E "(describe|it|test)"

# Verify API layer
cat src/api/users.js | grep -E "(export|async|fetch)"
```

---

## GitHub Actions Testing

### Workflow Execution Environment

The GitHub Actions workflow provides a **clean, isolated environment** where:

1. ✅ Bob Shell is installed fresh
2. ✅ GitHub MCP is configured
3. ✅ Concert API credentials are available
4. ✅ Package installation happens AFTER Bob creates PR with safe versions

### Testing the DevOps Phase

**Trigger**: Concert creates a GitHub issue for a CVE

**What Bob Does**:
1. Reads the GitHub issue
2. Researches CVE in Concert API
3. Performs false positive detection
4. Either:
   - **FALSE POSITIVE**: Comments on issue, no PR
   - **TRUE POSITIVE**: Creates PR with package upgrade

**Test Command** (in GitHub Actions):
```bash
# Bob Shell processes the issue
bob-shell --mode devops-concert-shell-v2 \
  --prompt "Process GitHub issue #${ISSUE_NUMBER} and create a remediation PR"
```

### Testing the Unit Test Phase

**Trigger**: DevOps engineer approves the PR

**What Happens**:
1. Workflow detects ecosystem from PR changes
2. Installs dependencies (now with SAFE versions from PR)
3. Runs appropriate tests

**Test Commands** (in GitHub Actions):
```bash
# For npm ecosystem
if [[ "$ECOSYSTEM" == "npm" ]]; then
  npm ci  # Install from package-lock.json with safe versions
  npm test
fi

# For Python ecosystem
if [[ "$ECOSYSTEM" == "python" ]]; then
  pip install -r app/vulnerable/requirements.txt
  cd app/vulnerable && python -m unittest test_main.py
fi
```

### Testing the Code Remediation Phase

**Trigger**: Unit tests fail after package upgrade

**What Bob Does**:
1. Analyzes test failures
2. Fixes application code to work with new package versions
3. Re-runs tests until they pass

**Test Command** (in GitHub Actions):
```bash
# Bob Shell fixes the code
bob-shell --mode advanced \
  --prompt "Fix the failing unit tests in PR #${PR_NUMBER}"
```

---

## End-to-End Workflow Testing

### Scenario 1: TanStack Supply Chain Attack (TRUE POSITIVE)

**Setup**:
1. Concert detects `@tanstack/react-query@5.62.1` vulnerability
2. Concert creates GitHub issue #X

**Expected Flow**:
```
Issue Created
  ↓
Bob: Research CVE
  ↓
Bob: Search codebase for "import.*@tanstack/react-query"
  ↓
Bob: Find UserList.jsx uses useQuery()
  ↓
Bob: Determine TRUE POSITIVE (package actively used)
  ↓
Bob: Create PR to upgrade to 5.62.3
  ↓
DevOps: Approve PR
  ↓
Workflow: npm ci && npm test
  ↓
Tests: PASS (or Bob fixes if FAIL)
  ↓
Lead: Review & Merge
  ↓
Deploy to Production
```

**Verification Points**:
- ✅ Bob creates PR with correct version (5.62.3+)
- ✅ PR description includes CVE details
- ✅ PR links to original issue
- ✅ Tests pass after package upgrade
- ✅ No breaking changes in application code

### Scenario 2: axios CVE-2023-45857 (FALSE POSITIVE)

**Setup**:
1. Concert detects `axios@1.5.1` CVE-2023-45857 (SSRF)
2. Concert creates GitHub issue #Y

**Expected Flow**:
```
Issue Created
  ↓
Bob: Research CVE (SSRF vulnerability)
  ↓
Bob: Search codebase for "import.*axios"
  ↓
Bob: Find weather.js uses axios.get()
  ↓
Bob: Analyze usage pattern
  ↓
Bob: Detect hardcoded URL + user input only in query params
  ↓
Bob: Determine FALSE POSITIVE (safe usage pattern)
  ↓
Bob: Comment on issue with detailed analysis
  ↓
Bob: Tag DevOps engineer for review
  ↓
Engineer: Review analysis
  ↓
Engineer: Agree and close issue (or disagree and trigger manual fix)
```

**Verification Points**:
- ✅ Bob does NOT create a PR
- ✅ Bob comments on issue with analysis
- ✅ Comment includes file paths and code snippets
- ✅ Comment explains why it's a false positive
- ✅ DevOps engineer is tagged for review

### Scenario 3: Package Upgrade Breaks Tests

**Setup**:
1. Bob creates PR to upgrade package
2. DevOps approves PR
3. Tests fail after package upgrade

**Expected Flow**:
```
Tests Fail
  ↓
Workflow: Trigger Bob Shell in advanced mode
  ↓
Bob: Analyze test failures
  ↓
Bob: Identify root cause (e.g., deprecated API)
  ↓
Bob: Fix application code
  ↓
Bob: Push fixes to PR
  ↓
Workflow: Re-run tests
  ↓
Tests: PASS
  ↓
Lead: Review & Merge
```

**Verification Points**:
- ✅ Bob identifies correct root cause
- ✅ Bob makes minimal, targeted fixes
- ✅ Tests pass after fixes
- ✅ No regressions introduced

---

## Troubleshooting

### Issue: "vitest: command not found"

**Cause**: npm packages not installed (expected behavior)

**Solution**: This is correct! Packages install only after Bob creates PR with safe versions.

**Verification**:
```bash
# Check package.json has vulnerable versions
cat package.json | grep -A 2 "@tanstack/react-query"
# Should show: "5.62.1" (withdrawn version)

# This is the CORRECT state for demonstration
```

### Issue: "ModuleNotFoundError: No module named 'flask'"

**Cause**: Python packages not installed (expected behavior)

**Solution**: This is correct! Packages install in GitHub Actions after PR creation.

**Verification**:
```bash
# Check requirements.txt has vulnerable versions
cat app/vulnerable/requirements.txt | grep Flask
# Should show: "Flask==1.1.2" (vulnerable version)

# This is the CORRECT state for demonstration
```

### Issue: Bob Shell Cannot Access GitHub Issue

**Cause**: GitHub MCP not configured or issue doesn't exist

**Solution**:
1. Verify GitHub MCP configuration in `.bob/mcp.json`
2. Ensure `GITHUB_TOKEN` is set in environment
3. Verify issue number exists and is accessible

**Debug**:
```bash
# Test GitHub API access
gh issue view 123 --repo owner/repo

# Check MCP configuration
cat .bob/mcp.json | jq .
```

### Issue: Concert API Returns 401 Unauthorized

**Cause**: Concert API credentials not configured

**Solution**:
1. Verify `.env` file exists with correct credentials
2. Check `CONCERT_API_KEY`, `CONCERT_HOSTNAME`, `CONCERT_INSTANCE_ID`
3. Ensure credentials are not expired

**Debug**:
```bash
# Test Concert API access (redact output)
source .env && curl -kX GET \
  -H "Authorization: ${CONCERT_API_KEY}" \
  -H "InstanceId: ${CONCERT_INSTANCE_ID}" \
  "${CONCERT_HOSTNAME}/concert/core/api/v1/applications" | jq .
```

### Issue: Workflow Detects Wrong Ecosystem

**Cause**: PR modifies files from multiple ecosystems

**Solution**: Workflow prioritizes based on file changes:
1. If `package.json` modified → npm
2. If `requirements.txt` modified → Python
3. If `pom.xml` modified → Java

**Debug**:
```bash
# Check which files are modified in PR
gh pr view 123 --json files --jq '.files[].path'
```

---

## Testing Checklist

### Before Committing Changes

- [ ] Code syntax is valid (no syntax errors)
- [ ] Documentation is updated
- [ ] Workflow YAML is valid
- [ ] Bob custom modes are valid YAML
- [ ] `.gitignore` excludes sensitive files
- [ ] No hardcoded credentials in code

### Before Triggering Workflow

- [ ] Concert API credentials configured
- [ ] GitHub MCP configured
- [ ] Bob Shell API key configured
- [ ] DevOps approval environment configured
- [ ] Reviewers configured in workflow variables

### After Workflow Execution

- [ ] Bob successfully reads GitHub issue
- [ ] Bob queries Concert API successfully
- [ ] False positive detection works correctly
- [ ] PR is created with correct package versions
- [ ] Tests run in correct ecosystem
- [ ] Code remediation fixes failing tests
- [ ] All approvals work correctly

---

## Manual Testing Commands

### Test Bob Custom Modes Locally

```bash
# Test mode validation
yamllint .bob/custom_modes.yaml

# Check mode definitions
cat .bob/custom_modes.yaml | grep -E "slug:|name:|description:"
```

### Test Workflow Syntax

```bash
# Validate workflow YAML
yamllint .github/workflows/bob-shell-v2.yml

# Check workflow triggers
cat .github/workflows/bob-shell-v2.yml | grep -A 5 "on:"
```

### Test Documentation

```bash
# Check all markdown files
find . -name "*.md" -exec echo "Checking {}" \; -exec cat {} \; > /dev/null

# Verify links in README
cat README.md | grep -E "\[.*\]\(.*\)"
```

---

## Success Criteria

A successful test run should demonstrate:

1. ✅ **False Positive Detection**: Bob correctly identifies safe usage patterns
2. ✅ **True Positive Remediation**: Bob creates PR with correct package versions
3. ✅ **Multi-Ecosystem Support**: Workflow handles both npm and Python
4. ✅ **Automated Code Fixes**: Bob fixes code when tests fail
5. ✅ **Human Approvals**: DevOps and Lead approvals work correctly
6. ✅ **Complete Traceability**: All changes linked to original CVE issue

---

## Next Steps

After successful testing:

1. Document any issues found
2. Update workflow based on learnings
3. Create demo video showing complete flow
4. Prepare presentation materials
5. Schedule demo with stakeholders
