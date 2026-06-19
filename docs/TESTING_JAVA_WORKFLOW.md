# Testing the Java App CVE Remediation Workflow

This guide explains how to test the new CVE-2017-5638 Java application remediation workflow on the `vuln-java-app` branch without affecting your production Python app workflow on `main`.

## Overview

The repository now supports two demo scenarios:
- **`main` branch**: Python Flask vulnerable app (production)
- **`vuln-java-app` branch**: Java Struts vulnerable app (testing)

## Testing Strategy

Since both workflows use the same GitHub Actions workflow file (`.github/workflows/bob-shell-v2.yml`), we need to ensure they don't interfere with each other during testing.

## Option 1: Use Workflow Dispatch with Branch Context (Recommended)

The workflow automatically detects the application type based on files present in the checked-out branch. Here's how to test:

### Step 1: Create a Test CVE Issue for Java App

1. Go to your repository's Issues page
2. Create a new issue with this format:

```markdown
Title: CVE-2017-5638 in Apache Struts 2.3.31

Body:
Package: org.apache.struts:struts2-core
Current Version: 2.3.31
Vulnerable to: CVE-2017-5638
Severity: Critical (CVSS 10.0)
Recommended Fix: Upgrade to 2.3.32 or later

This is a test issue for the Java credit-app on vuln-java-app branch.
```

3. Note the issue number (e.g., #123)

### Step 2: Manually Trigger Workflow on vuln-java-app Branch

**Important**: The workflow will checkout the branch where it's defined. To test the Java app:

1. **First, merge the workflow changes to `vuln-java-app`** (already done)
2. Go to Actions → "Bob Shell V2 - CVE Remediation with Approvals"
3. Click "Run workflow"
4. **Select branch**: `vuln-java-app` (CRITICAL!)
5. Enter the issue number from Step 1
6. Click "Run workflow"

### Step 3: Workflow Behavior

The workflow will:
1. ✅ Checkout the `vuln-java-app` branch
2. ✅ Detect Java application (finds `app/credit-app/pom.xml`)
3. ✅ Analyze CVE-2017-5638 in Apache Struts
4. ✅ Create remediation branch from `vuln-java-app` (e.g., `fix/cve-2017-5638-struts2-core`)
5. ✅ Update `pom.xml` with fixed version
6. ✅ Create PR targeting `vuln-java-app` branch
7. ✅ Run Java unit tests (`mvn test`)
8. ✅ Fix any failing tests if needed

### Step 4: Verify PR Target Branch

When Bob creates the PR, verify:
- **Base branch**: `vuln-java-app` (not `main`)
- **Head branch**: `fix/cve-2017-5638-struts2-core`
- **Files changed**: `app/credit-app/pom.xml`
- **Tests**: Java/Maven tests run successfully

## Option 2: Label-Based Workflow Separation

To completely isolate testing, you can modify the workflow trigger:

### For Production (main branch):
- Use label: `cve-remediation`
- Workflow checks out `main` by default

### For Testing (vuln-java-app branch):
- Use label: `java-app-test`
- Workflow explicitly checks out `vuln-java-app`

### Implementation:

1. Update `.github/workflows/bob-shell-v2.yml` on `vuln-java-app` branch:

```yaml
on:
  issues:
    types: [opened, labeled]
  # ... rest of triggers

jobs:
  devops-cve-research:
    # Add branch detection based on label
    steps:
      - name: Determine Branch
        id: determine-branch
        run: |
          if [[ "${{ github.event.label.name }}" == "java-app-test" ]]; then
            echo "branch=vuln-java-app" >> $GITHUB_OUTPUT
          else
            echo "branch=main" >> $GITHUB_OUTPUT
          fi
      
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          ref: ${{ steps.determine-branch.outputs.branch }}
          fetch-depth: 0
```

2. Update Bob's prompt to use the correct base branch:

```yaml
- name: Run Bob Shell - DevOps Concert Mode V2
  with:
    prompt: |
      # ... existing prompt ...
      
      IMPORTANT: 
      - Base branch for PR: ${{ steps.determine-branch.outputs.branch }}
      - Create remediation branch from: ${{ steps.determine-branch.outputs.branch }}
      - PR should target: ${{ steps.determine-branch.outputs.branch }}
```

## Option 3: Separate Workflow File (Complete Isolation)

Create `.github/workflows/bob-shell-v2-java.yml` on `vuln-java-app` branch:

```yaml
name: Bob Shell V2 - Java App Testing

on:
  issues:
    types: [labeled]
  workflow_dispatch:
    inputs:
      issue_number:
        description: 'GitHub Issue number'
        required: true
        type: number

# Only triggers on 'java-app-test' label
# Completely separate from main workflow

jobs:
  # Copy all jobs from bob-shell-v2.yml
  # But hardcode ref: vuln-java-app in all checkout steps
```

## Testing Checklist

### Before Testing:
- [ ] Ensure `vuln-java-app` branch has latest workflow changes
- [ ] Verify Java app builds: `cd app/credit-app && mvn clean test`
- [ ] Verify Concert API credentials are configured
- [ ] Verify `devops-approval` environment is set up

### During Testing:
- [ ] Create test CVE issue for Apache Struts
- [ ] Trigger workflow on `vuln-java-app` branch
- [ ] Verify Bob analyzes Java app (not Python app)
- [ ] Verify PR targets `vuln-java-app` branch
- [ ] Verify Maven tests run (not Python unittest)
- [ ] Approve DevOps environment
- [ ] Verify unit tests pass/fail correctly
- [ ] Verify Bob fixes failing tests if needed

### After Testing:
- [ ] Review PR changes
- [ ] Verify Concert API updates (if false positive)
- [ ] Merge PR to `vuln-java-app` (not `main`)
- [ ] Close test issue

## Key Differences: Java vs Python Workflow

| Aspect | Python (main) | Java (vuln-java-app) |
|--------|---------------|----------------------|
| **App Location** | `app/vulnerable/` | `app/credit-app/` |
| **Package File** | `requirements.txt` | `pom.xml` |
| **Build Tool** | pip | Maven |
| **Test Command** | `python -m unittest` | `mvn test` |
| **Java Version** | N/A | Java 8 |
| **Vulnerability** | Various CVEs | CVE-2017-5638 |
| **Package** | Python packages | Apache Struts |

## Troubleshooting

### Issue: Workflow analyzes wrong app
**Solution**: Ensure workflow is triggered from `vuln-java-app` branch, not `main`

### Issue: PR targets main branch
**Solution**: Bob needs to be instructed to use `vuln-java-app` as base branch

### Issue: Python tests run instead of Java tests
**Solution**: Application detection failed. Check if `app/credit-app/pom.xml` exists

### Issue: Maven build fails
**Solution**: Ensure Java 8 is set up in workflow (already configured)

## Recommended Testing Approach

**For initial testing, use Option 1 (Workflow Dispatch)**:

1. Keep `main` branch unchanged (production Python workflow)
2. Test Java workflow by manually triggering on `vuln-java-app` branch
3. Use workflow dispatch to control which branch is tested
4. PRs will automatically target the branch they're created from

**For production deployment**:

1. After successful testing, merge `vuln-java-app` to `main`
2. Update README.md to reflect Java app as primary demo
3. Archive Python app or keep both as examples
4. Update Concert ingestion to scan Java app

## Example Test Scenario

### Scenario: Test CVE-2017-5638 Remediation

1. **Create Issue**:
   ```
   Title: CVE-2017-5638 - Apache Struts RCE
   Label: java-app-test (or cve-remediation)
   ```

2. **Trigger Workflow**:
   - Branch: `vuln-java-app`
   - Issue: #123

3. **Expected Behavior**:
   - Bob analyzes `app/credit-app/pom.xml`
   - Finds `struts2-core:2.3.31`
   - Queries NVD for CVE-2017-5638
   - Recommends upgrade to 2.3.32+
   - Creates PR with `pom.xml` changes
   - Runs `mvn test` (24 tests)
   - All tests pass ✅

4. **Verify**:
   - PR targets `vuln-java-app` branch
   - Changes only in `app/credit-app/pom.xml`
   - Maven build successful
   - No Python files modified

## Next Steps

After successful testing:

1. Document any issues found
2. Update workflow if needed
3. Create final PR to merge `vuln-java-app` → `main`
4. Update production Concert configuration
5. Archive or remove old Python app

## Support

If you encounter issues during testing:

1. Check workflow logs in GitHub Actions
2. Verify branch context in checkout steps
3. Confirm application detection logic
4. Review Bob's analysis comments
5. Check PR target branch

---

**Note**: This testing approach ensures your production Python workflow on `main` remains untouched while you validate the new Java workflow on `vuln-java-app`.