# Workflow Configuration for TanStack Demo

This document explains how the GitHub Actions workflows are configured to work with the `tanstack-demo` branch.

## Overview

The Concert + Bob CVE remediation system uses two GitHub Actions workflows:

1. **`trigger-concert-ingestion.yml`** - Triggers Concert to scan the repository for vulnerabilities
2. **`bob-shell-v2.yml`** - Orchestrates the CVE remediation process with Bob Shell

## Workflow 1: Concert Ingestion (`trigger-concert-ingestion.yml`)

### Purpose
Triggers Concert to scan the repository and generate an SBOM (Software Bill of Materials) to detect vulnerabilities.

### Configuration for TanStack Demo

```yaml
on:
  push:
    branches:
      - main              # Python Flask demo (legacy)
      - tanstack-demo     # TanStack npm demo (primary)
  workflow_dispatch:
    inputs:
      branch:
        description: 'Branch to scan (default: current branch)'
        required: false
        type: string
```

### Key Points

1. **Automatic Triggers**: Runs automatically when code is pushed to either `main` or `tanstack-demo` branches
2. **Manual Trigger**: Can be manually triggered via workflow_dispatch for any branch
3. **Branch-Specific Scanning**: Concert scans the specific branch that triggered the workflow

### What Happens

1. Workflow triggers on push to `tanstack-demo`
2. Calls Concert API to submit an ingestion job
3. Concert scans the repository at the `tanstack-demo` branch
4. Concert analyzes `package.json` and `app/vulnerable/requirements.txt`
5. Concert detects vulnerable packages:
   - `@tanstack/react-query@5.62.1` (supply chain attack)
   - `axios@1.5.1` (CVE-2023-45857)
   - Python packages in `app/vulnerable/`
6. Concert creates GitHub issues for each CVE

## Workflow 2: CVE Remediation (`bob-shell-v2.yml`)

### Purpose
Orchestrates the complete CVE remediation process using Bob Shell.

### Configuration

```yaml
on:
  issues:
    types: [opened, labeled]
  pull_request:
    types: [closed]
  workflow_dispatch:
    inputs:
      issue_number:
        description: 'GitHub Issue number for CVE remediation'
        required: false
        type: number
```

### Key Points

1. **Branch-Agnostic**: Works on ANY branch - not limited to `main` or `tanstack-demo`
2. **Issue-Triggered**: Automatically runs when Concert creates a GitHub issue
3. **PR-Aware**: Tracks PRs created by Bob and continues workflow after approval
4. **Manual Override**: Can be manually triggered for specific issues

### How It Works with TanStack Demo

#### Step 1: DevOps Phase
```yaml
- name: Checkout repository
  uses: actions/checkout@v4
  with:
    fetch-depth: 0
```
- Checks out the repository (current branch)
- Bob reads the GitHub issue created by Concert
- Bob analyzes the code to detect false positives
- Bob creates a PR on the SAME branch where the issue was detected

#### Step 2: Ecosystem Detection
```yaml
- name: Detect Ecosystem from PR Changes
  id: detect-ecosystem
  uses: actions/github-script@v7
  with:
    script: |
      // Check which files were modified
      if (modifiedFiles.some(f => f === 'package.json')) {
        ecosystem = 'npm';
      }
      else if (modifiedFiles.some(f => f.includes('requirements.txt'))) {
        ecosystem = 'python';
      }
```
- Examines PR file changes to determine ecosystem
- If `package.json` modified → npm ecosystem
- If `requirements.txt` modified → Python ecosystem

#### Step 3: Ecosystem-Specific Testing
```yaml
- name: Install npm dependencies
  if: steps.detect-ecosystem.outputs.ecosystem == 'npm'
  run: npm ci

- name: Install Python dependencies
  if: steps.detect-ecosystem.outputs.ecosystem == 'python'
  working-directory: app/vulnerable
  run: pip install -r requirements.txt
```
- Installs dependencies based on detected ecosystem
- For npm: Runs `npm ci` (installs from package-lock.json)
- For Python: Runs `pip install -r requirements.txt`

#### Step 4: Ecosystem-Specific Tests
```yaml
- name: Run unit tests
  run: |
    if [[ "${{ steps.detect-ecosystem.outputs.ecosystem }}" == "npm" ]]; then
      npm test
    elif [[ "${{ steps.detect-ecosystem.outputs.ecosystem }}" == "python" ]]; then
      cd app/vulnerable
      python -m unittest test_main.py -v
    fi
```
- Runs appropriate test command based on ecosystem
- For npm: `npm test` (runs Vitest)
- For Python: `python -m unittest test_main.py -v`

## Branch Strategy

### Main Branch
- **Purpose**: Python Flask demo (legacy)
- **Packages**: Python packages in `app/vulnerable/requirements.txt`
- **Concert Scanning**: Enabled
- **Workflow**: Full CVE remediation workflow

### TanStack Demo Branch
- **Purpose**: TanStack npm demo (primary)
- **Packages**: 
  - npm packages in `package.json` (root)
  - Python packages in `app/vulnerable/requirements.txt` (legacy)
- **Concert Scanning**: Enabled
- **Workflow**: Full CVE remediation workflow with multi-ecosystem support

## Testing the Workflow

### Option 1: Automatic (Recommended)

1. Push code to `tanstack-demo` branch
2. Concert ingestion workflow triggers automatically
3. Concert scans the branch and creates issues
4. CVE remediation workflow triggers automatically
5. Bob processes each issue

### Option 2: Manual Trigger

1. Go to Actions → "Trigger Concert Ingestion Job"
2. Click "Run workflow"
3. Select branch: `tanstack-demo`
4. Wait for Concert to create issues
5. CVE remediation workflow triggers automatically

### Option 3: Direct Issue Processing

1. Manually create a GitHub issue with CVE details
2. Add label: `cve-remediation`
3. CVE remediation workflow triggers automatically
4. Bob processes the issue

## Expected Workflow Execution

### For TanStack Supply Chain Attack (TRUE POSITIVE)

```
1. Concert creates issue for @tanstack/react-query@5.62.1
2. bob-shell-v2.yml triggers (Step 1: DevOps Phase)
3. Bob analyzes code → finds UserList.jsx uses TanStack Query
4. Bob determines TRUE POSITIVE
5. Bob creates PR to upgrade to 5.62.3
6. Workflow pauses for DevOps approval (Step 2)
7. DevOps approves
8. Workflow detects ecosystem = npm (Step 3)
9. Workflow runs: npm ci && npm test
10. Tests pass (or Bob fixes if they fail)
11. Software Lead reviews and merges
```

### For axios CVE-2023-45857 (FALSE POSITIVE)

```
1. Concert creates issue for axios@1.5.1
2. bob-shell-v2.yml triggers (Step 1: DevOps Phase)
3. Bob analyzes code → finds weather.js uses axios safely
4. Bob determines FALSE POSITIVE
5. Bob comments on issue with analysis
6. Bob tags DevOps engineer for review
7. NO PR created
8. DevOps engineer reviews and closes issue
```

## Troubleshooting

### Issue: Concert doesn't scan tanstack-demo branch

**Solution**: Ensure `trigger-concert-ingestion.yml` includes `tanstack-demo` in the branches list:
```yaml
on:
  push:
    branches:
      - main
      - tanstack-demo  # Must be present
```

### Issue: Workflow runs on wrong branch

**Solution**: The workflow is branch-agnostic by design. It processes issues regardless of which branch they're associated with. Bob creates PRs on the same branch where the vulnerability was detected.

### Issue: npm install fails with "package not found"

**Expected Behavior**: This is correct! The vulnerable TanStack versions (5.62.1) are withdrawn from npm. Installation only happens AFTER Bob creates a PR with safe versions (5.62.3+).

### Issue: Tests don't run for npm packages

**Check**:
1. Verify PR modifies `package.json`
2. Check workflow logs for ecosystem detection
3. Ensure `npm ci` step runs successfully
4. Verify `npm test` command is executed

## Configuration Checklist

Before running the workflow on `tanstack-demo` branch:

- [ ] `trigger-concert-ingestion.yml` includes `tanstack-demo` in branches
- [ ] Concert API credentials configured in GitHub Secrets
- [ ] Bob Shell API key configured in GitHub Secrets
- [ ] GitHub MCP configured in Bob Shell
- [ ] DevOps approval environment configured
- [ ] Reviewers configured in GitHub Variables
- [ ] `package.json` has vulnerable versions (5.62.1, 1.5.1)
- [ ] Unit tests are present in `src/test/`

## Summary

The workflows are now properly configured to work with the `tanstack-demo` branch:

1. ✅ **Concert Ingestion**: Triggers on pushes to `tanstack-demo`
2. ✅ **CVE Remediation**: Branch-agnostic, works on any branch
3. ✅ **Multi-Ecosystem**: Automatically detects npm vs Python
4. ✅ **Issue-Specific**: Processes each CVE independently
5. ✅ **False Positive Detection**: Analyzes code before creating PRs

The system is ready for end-to-end testing on the `tanstack-demo` branch!
