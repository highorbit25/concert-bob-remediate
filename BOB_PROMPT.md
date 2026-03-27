# Bob Prompt: Intelligent Security Vulnerability Auto-Remediation

## 🎯 Task for Bob

Automatically research, analyze, and remediate security vulnerabilities described in GitHub issues by independently investigating CVEs, understanding vulnerability types, and implementing comprehensive fixes across all categories: dependency updates, code vulnerabilities, configuration issues, and infrastructure problems.

**Issue URL**: [ISSUE_URL]

## 🔐 Vulnerability Categories Supported

This prompt handles ALL types of security vulnerabilities:

### 1. **Dependency Vulnerabilities** (Package/Library Issues)
- Outdated packages with known CVEs
- Transitive dependency vulnerabilities
- Version conflicts and compatibility issues
- **Examples**: CVE-2025-55182 (Next.js), Log4Shell, Spring4Shell

### 2. **Code Vulnerabilities** (Application Logic Issues)
- SQL Injection (SQLi)
- Cross-Site Scripting (XSS)
- Remote Code Execution (RCE)
- Server-Side Request Forgery (SSRF)
- Path Traversal
- Insecure Deserialization
- Command Injection
- XML External Entity (XXE)
- **Examples**: Unsanitized user input, unsafe eval(), dynamic SQL queries

### 3. **Configuration Vulnerabilities** (Settings & Secrets)
- Hardcoded credentials and API keys
- Exposed secrets in code/config files
- Insecure CORS policies
- Weak cryptographic settings
- Missing security headers
- Permissive file permissions
- **Examples**: API keys in .env committed to git, weak JWT secrets

### 4. **Infrastructure Vulnerabilities** (Deployment & Container Issues)
- Vulnerable Docker base images
- Insecure Kubernetes configurations
- Exposed ports and services
- Missing security policies
- Insecure CI/CD pipelines
- **Examples**: Running containers as root, exposed management interfaces

## 📋 Instructions for Bob

### Step 1: Fetch Issue Details from GitHub

Use GitHub MCP to retrieve the complete issue information.

**Extract key data:**
- CVE identifier (e.g., CVE-2025-55182)
- Severity level (CRITICAL/HIGH/MEDIUM/LOW)
- Priority and risk score
- Affected package/component/code section
- Environment details
- Version information
- Vulnerability type/category

**Example MCP call:**
```json
{
  "tool": "get_issue",
  "arguments": {
    "owner": "{owner}",
    "repo": "{repo}",
    "issue_number": {N}
  }
}
```

### Step 2: Research the CVE from Authoritative Sources (CRITICAL FIRST STEP)

**🔍 PRIMARY RESEARCH SOURCES (Check in this order):**

**A. Official CVE Databases and Advisories**

1. **National Vulnerability Database (NVD)**
   - URL: https://nvd.nist.gov/vuln/detail/{CVE-ID}
   - Look for: CVSS score, affected versions, patched versions, CWE classification

2. **Official Security Advisories**
   - Package maintainer's security page (e.g., GitHub Security Advisories)
   - Vendor security bulletins (e.g., React, Next.js, Django official blogs)
   - CERT advisories and security notices

3. **Package-Specific Resources**
   - Official changelogs and release notes
   - Security-focused release announcements
   - Migration guides for security patches

4. **Security Research Databases**
   - Snyk Vulnerability Database
   - GitHub Advisory Database
   - CVE Details
   - MITRE CVE database
   - OWASP (for code vulnerabilities)

**B. Analyze CVE Information from Official Sources**

**REQUIRED INFORMATION TO EXTRACT:**
- ✅ **CVE ID and Description**: What is the vulnerability?
- ✅ **Vulnerability Type**: RCE, XSS, SQL Injection, SSRF, etc.
- ✅ **Attack Vector**: How can it be exploited?
- ✅ **CVSS Score**: Severity rating (0-10)
- ✅ **CWE Classification**: Common Weakness Enumeration
- ✅ **Affected Versions**: Exact version ranges affected
- ✅ **Patched Versions**: Which versions contain the fix
- ✅ **Workarounds**: Any temporary mitigations available
- ✅ **Root Cause**: What causes the vulnerability
- ✅ **Proof of Concept**: Is there a known exploit?

**C. Determine Vulnerability Category and Fix Strategy**

**Category 1: Dependency Vulnerability**
- **Indicators**: CVE mentions package name and version
- **Research Focus**: Official package security advisory, NVD entry
- **Fix Strategy**: Upgrade to patched version specified in advisory
- **Example**: CVE-2025-55182 in Next.js 16.0.6 → Upgrade to 16.0.7

**Category 2: Code Pattern Vulnerability**
- **Indicators**: CVE describes coding practice (SQLi, XSS, etc.)
- **Research Focus**: OWASP guidelines, CWE documentation, secure coding patterns
- **Fix Strategy**: Refactor code to use secure alternatives
- **Examples**:
  - **SQL Injection**: Use parameterized queries/ORMs
  - **XSS**: Sanitize output, use Content Security Policy
  - **Command Injection**: Avoid shell execution, use safe APIs
  - **Path Traversal**: Validate and sanitize file paths
  - **Insecure Deserialization**: Use safe serialization formats

**Category 3: Configuration Vulnerability**
- **Indicators**: CVE mentions configuration, secrets, or settings
- **Research Focus**: Security best practices, framework documentation
- **Fix Strategy**: Update configuration with secure defaults
- **Examples**:
  - **Hardcoded Secrets**: Move to environment variables, use secret managers
  - **Weak Crypto**: Use strong algorithms (AES-256, SHA-256)
  - **Permissive CORS**: Restrict origins to trusted domains
  - **Missing Headers**: Add security headers (CSP, HSTS, X-Frame-Options)

**Category 4: Infrastructure Vulnerability**
- **Indicators**: CVE mentions Docker, Kubernetes, deployment
- **Research Focus**: Container security guidelines, official image advisories
- **Fix Strategy**: Update infrastructure configuration
- **Examples**:
  - **Vulnerable Base Image**: Update to patched image version
  - **Root Container**: Run as non-root user
  - **Exposed Ports**: Restrict network access
  - **Missing Security Context**: Add security policies

**D. Cross-Reference Multiple Sources**

**⚠️ CRITICAL: Always verify information across multiple sources:**
1. Check official vendor advisory (most authoritative)
2. Verify with NVD/MITRE CVE database
3. Review security research (Snyk, GitHub Security)
4. Check OWASP guidelines (for code vulnerabilities)
5. Look for official patches and their release notes

**E. Document Your Research**

**Create a research summary:**
```markdown
## CVE Research: {CVE-ID}

### Official Sources Consulted:
- NVD: https://nvd.nist.gov/vuln/detail/{CVE-ID}
- Vendor Advisory: {URL}
- Security Database: {URL}
- OWASP Reference: {URL if applicable}

### Findings:
- **Type**: {RCE/XSS/SQLi/Config/etc.}
- **Category**: {Dependency/Code/Configuration/Infrastructure}
- **Affected**: {version range or code pattern}
- **Patched**: {fixed versions or secure pattern}
- **Attack Vector**: {description}
- **Severity**: {CRITICAL/HIGH/MEDIUM/LOW}
- **CVSS**: {score}
- **CWE**: {CWE-XXX}

### Recommended Fix:
{Based on official advisories and security best practices}
```

### Step 3: Analyze Repository Context and Validate Fix Compatibility

**⚠️ IMPORTANT: Repository context is used to VALIDATE the fix from Step 2, not to determine it.**

**A. Read Relevant Files to Understand Current State**

Use GitHub MCP to gather context:

```json
{
  "tool": "get_file_contents",
  "arguments": {
    "owner": "{owner}",
    "repo": "{repo}",
    "path": "package.json",  // or relevant file
    "branch": "main"
  }
}
```

**FILES TO CHECK (based on vulnerability type):**

**For Dependency Vulnerabilities:**
- package.json, package-lock.json (Node.js)
- requirements.txt, Pipfile, poetry.lock (Python)
- pom.xml, build.gradle (Java)
- go.mod, go.sum (Go)
- Gemfile, Gemfile.lock (Ruby)
- composer.json (PHP)

**For Code Vulnerabilities:**
- Source code files mentioned in CVE or issue
- Related files that may have similar vulnerable patterns
- Database query files (for SQLi)
- Template files (for XSS)
- File handling code (for path traversal)
- API endpoints (for injection attacks)

**For Configuration Vulnerabilities:**
- .env files (check for exposed secrets)
- config files (YAML, JSON, TOML)
- Security configuration files
- CORS settings
- Authentication/authorization configs

**For Infrastructure Vulnerabilities:**
- Dockerfile, docker-compose.yml
- Kubernetes manifests (*.yaml)
- Terraform/CloudFormation templates
- CI/CD pipeline configurations (.github/workflows, .gitlab-ci.yml)
- Nginx/Apache configuration files

**B. Validate Fix Compatibility with Current Environment**

**CRITICAL VALIDATION STEPS:**

1. **Check Current Versions/State**
   - What version of the vulnerable component is currently used?
   - What are ALL the dependency versions?
   - Are there version constraints in lock files?
   - What is the current code pattern?

2. **Verify Fix Compatibility**
   - Will the patched version work with existing dependencies?
   - Will the code fix break existing functionality?
   - Are there breaking changes in the fix?
   - Check semantic versioning implications

3. **Identify Potential Conflicts**
   - Are there peer dependency requirements?
   - Will the fix break other dependencies?
   - Are there known incompatibilities?
   - Will tests need updating?

4. **Check for Application-Specific Constraints**
   - Does README.md specify version requirements?
   - Are there comments in code about version dependencies?
   - Is there a CHANGELOG documenting version history?
   - Are there framework-specific considerations?

**C. Assess Implementation Impact**

1. **For Dependency Updates:**
   - Is this an upgrade or downgrade?
   - What is the version jump? (patch/minor/major)
   - Are there breaking changes in the changelog?
   - Will lock files need updating?
   - Do transitive dependencies need updating?

2. **For Code Changes:**
   - Which files need modification?
   - How extensive are the changes?
   - Are there similar patterns elsewhere that also need fixing?
   - Will tests need updating?
   - Are there performance implications?

3. **For Configuration Changes:**
   - Which config files need updating?
   - Are there environment-specific configs (dev/staging/prod)?
   - Will deployment process change?
   - Are secrets properly managed (not committed)?
   - Do environment variables need updating?

4. **For Infrastructure Changes:**
   - Which infrastructure files need updating?
   - Are there multiple environments?
   - Will deployment pipeline change?
   - Are there rollback procedures?
   - Do security policies need updating?

**D. Decision Matrix: Fix Selection**

**Use this matrix to validate your fix from Step 2:**

| Scenario | Action | Validation |
|----------|--------|------------|
| Official advisory specifies exact version | Use that version | Verify compatibility with current deps |
| Multiple patched versions available | Use minimal version bump | Check changelog for breaking changes |
| Fix requires major version upgrade | Evaluate breaking changes | Check migration guide, assess impact |
| Fix incompatible with current deps | Update dependencies together | Test compatibility matrix |
| No official patch available | Implement workaround from advisory | Document temporary nature |
| Code pattern fix available | Refactor to secure pattern | Ensure no functionality loss |
| Configuration fix needed | Apply secure defaults | Test in all environments |

**E. Red Flags - Additional Research Required**

🚨 **STOP and seek clarification if:**
- Official advisory conflicts with repository documentation
- Patched version incompatible with current dependencies
- Multiple conflicting fix recommendations
- No clear patched version specified in advisories
- Fix requires extensive code refactoring without clear guidance
- Downgrade seems necessary (very rare, usually wrong)
- Security fix introduces new vulnerabilities

### Step 4: Determine Remediation Strategy

**Decision Tree:**

```
What type of vulnerability is it?
│
├─ DEPENDENCY VULNERABILITY
│  ├─ Direct dependency → Update in package.json/requirements.txt
│  ├─ Transitive dependency → Update parent package or use overrides
│  └─ Verify no breaking changes → Test compatibility
│
├─ CODE VULNERABILITY
│  ├─ SQL Injection → Use parameterized queries/ORM
│  ├─ XSS → Sanitize output, escape HTML, use CSP
│  ├─ Command Injection → Avoid shell, use safe APIs
│  ├─ Path Traversal → Validate paths, use path.join()
│  ├─ Insecure Deserialization → Use safe formats (JSON), validate input
│  ├─ SSRF → Validate URLs, use allowlists
│  └─ Add input validation and security tests
│
├─ CONFIGURATION VULNERABILITY
│  ├─ Hardcoded Secrets → Move to env vars, use secret manager
│  ├─ Weak Crypto → Use strong algorithms (AES-256, bcrypt)
│  ├─ Permissive CORS → Restrict to trusted origins
│  ├─ Missing Headers → Add CSP, HSTS, X-Frame-Options
│  └─ Update security policies
│
└─ INFRASTRUCTURE VULNERABILITY
   ├─ Vulnerable Image → Update base image version
   ├─ Root Container → Add USER directive, run as non-root
   ├─ Exposed Ports → Restrict network access
   ├─ Missing Security Context → Add securityContext in K8s
   └─ Update deployment configs
```

**Example Workflows:**

**Example 1: Dependency Vulnerability (CVE-2025-55182)**

**Step 2: Research from Official Sources**
1. **Check NVD**: https://nvd.nist.gov/vuln/detail/CVE-2025-55182
   - Type: Remote Code Execution (RCE)
   - Affected: React Server Components 19.0.0-19.2.0
   - Also affects: Next.js 15.x, 16.0.0-16.0.6

2. **Check Next.js Security Advisory**: https://nextjs.org/blog/CVE-2025-66478
   - Patched in: Next.js 16.0.7
   - Recommendation: Upgrade to 16.0.7 or later

3. **Check React Advisory**: https://react.dev/blog/2025/12/03/...
   - Root cause: Unsafe deserialization in RSC Flight protocol
   - Patched in: React 19.2.1 (but Next.js fix is sufficient)

**Step 3: Validate Against Repository**
1. **Read package.json**:
   ```json
   {
     "dependencies": {
       "next": "16.0.6",  // ← Vulnerable
       "react": "19.2.0",  // ← Check compatibility
       "react-dom": "19.2.0"
     }
   }
   ```

2. **Validate Fix Compatibility**:
   - Official fix: Next.js 16.0.7
   - Current React: 19.2.0
   - Check: Is Next.js 16.0.7 compatible with React 19.2.0? ✅ YES
   - Version jump: 16.0.6 → 16.0.7 (patch bump, no breaking changes)

**Decision**: Upgrade next from 16.0.6 to 16.0.7

**Example 2: Code Vulnerability (SQL Injection)**

**Step 2: Research from Official Sources**
1. **Check OWASP**: https://owasp.org/www-community/attacks/SQL_Injection
   - Type: SQL Injection (CWE-89)
   - Attack Vector: Unsanitized user input in SQL queries
   - Impact: Data breach, unauthorized access

2. **Check Framework Documentation**:
   - Secure pattern: Use parameterized queries or ORM
   - Example: `db.query('SELECT * FROM users WHERE id = ?', [userId])`

**Step 3: Validate Against Repository**
1. **Read vulnerable code**:
   ```javascript
   // Vulnerable code
   const userId = req.params.id;
   const query = `SELECT * FROM users WHERE id = ${userId}`;
   db.query(query);
   ```

2. **Identify fix**:
   ```javascript
   // Secure code
   const userId = req.params.id;
   const query = 'SELECT * FROM users WHERE id = ?';
   db.query(query, [userId]);
   ```

**Decision**: Refactor to use parameterized queries

**Example 3: Configuration Vulnerability (Hardcoded API Key)**

**Step 2: Research from Official Sources**
1. **Check Security Best Practices**:
   - Type: Exposed Secrets (CWE-798)
   - Impact: Unauthorized API access, data breach
   - Fix: Use environment variables, secret managers

**Step 3: Validate Against Repository**
1. **Read vulnerable config**:
   ```javascript
   // config.js - Vulnerable
   const API_KEY = "sk-1234567890abcdef";
   ```

2. **Identify fix**:
   ```javascript
   // config.js - Secure
   const API_KEY = process.env.API_KEY;
   
   // .env (not committed)
   API_KEY=sk-1234567890abcdef
   
   // .gitignore
   .env
   ```

**Decision**: Move secrets to environment variables

### Step 5: Implement the Fix

**A. Create Feature Branch**
```json
{
  "tool": "create_branch",
  "arguments": {
    "owner": "{owner}",
    "repo": "{repo}",
    "branch": "fix/issue-{N}-{cve-id}",
    "from_branch": "main"
  }
}
```

**B. Apply the Fix Based on Vulnerability Type**

**For Dependency Updates:**
```json
{
  "tool": "create_or_update_file",
  "arguments": {
    "owner": "{owner}",
    "repo": "{repo}",
    "path": "package.json",
    "content": "{updated_content}",
    "message": "security: fix {CVE} by upgrading {package} from {old} to {new}\n\nResolves: #{issue}\n\nVulnerability Details:\n- CVE: {CVE}\n- Severity: {severity}\n- Package: {package}\n- Vulnerable Version: {old_version}\n- Fixed Version: {new_version}\n\nRemediation:\nUpdated the {package} package to version {new_version} which contains\nthe security fix for this {severity} vulnerability.\n\nAutomated fix generated by IBM Bob based on CVE research.",
    "branch": "fix/issue-{N}-{cve-id}",
    "sha": "{current_file_sha}"
  }
}
```

**For Code Vulnerabilities:**

1. **Read the vulnerable file**
2. **Identify the vulnerable code section**
3. **Implement secure alternative based on vulnerability type:**
   - **SQL Injection**: Replace string concatenation with parameterized queries
   - **XSS**: Add output encoding/escaping
   - **Command Injection**: Replace shell execution with safe APIs
   - **Path Traversal**: Add path validation and sanitization
   - **Insecure Deserialization**: Use safe serialization formats
4. **Add security comments explaining the fix**
5. **Update the file with the fix**

**For Configuration Vulnerabilities:**

1. **Read current configuration**
2. **Identify insecure settings**
3. **Apply secure defaults:**
   - Move secrets to environment variables
   - Update crypto settings to use strong algorithms
   - Add security headers
   - Restrict CORS policies
4. **Create .env.example with placeholder values**
5. **Update .gitignore to exclude secrets**
6. **Document the changes in comments**

**For Infrastructure Vulnerabilities:**

1. **Read infrastructure files**
2. **Identify insecure configurations**
3. **Apply security best practices:**
   - Update base images to patched versions
   - Add USER directive to run as non-root
   - Restrict network access
   - Add security contexts
   - Update resource limits
4. **Document the changes**

### Step 6: Create Comprehensive Pull Request

**Title Format:**
```
🔒 Security Fix: Remediate {CVE} - {Vulnerability Type}
```

**Description Template:**
```markdown
## 🔒 Security Vulnerability Remediation

### 🔍 Vulnerability Analysis

**CVE**: {CVE-ID}
**Type**: {RCE/XSS/SQL Injection/Configuration/etc.}
**Category**: {Dependency/Code/Configuration/Infrastructure}
**Severity**: {CRITICAL/HIGH/MEDIUM/LOW}
**CVSS Score**: {score if available}
**CWE**: {CWE-XXX if available}

**Description**:
{Brief explanation of what the vulnerability is and how it can be exploited}

**Attack Vector**:
{How an attacker could exploit this vulnerability}

**Impact**:
{What could happen if this vulnerability is exploited - data breach, RCE, etc.}

### 🔧 Changes Made

**[For Dependency Vulnerabilities]**
- **Package**: `{package}`
- **From**: `{old_version}` (vulnerable)
- **To**: `{new_version}` (patched)
- **File**: `{file_path}`
- **Breaking Changes**: {YES/NO - explain if yes}

**[For Code Vulnerabilities]**
- **File**: `{file_path}`
- **Function/Component**: `{name}`
- **Vulnerability Type**: {SQL Injection/XSS/etc.}
- **Change**: {Description of code change}
- **Security Pattern Applied**: {e.g., parameterized queries, output encoding}
- **Lines Modified**: {line numbers}

**[For Configuration Vulnerabilities]**
- **File**: `{config_file}`
- **Setting**: `{setting_name}`
- **Change**: {Description of configuration change}
- **Security Improvement**: {e.g., secrets moved to env vars}

**[For Infrastructure Vulnerabilities]**
- **File**: `{infrastructure_file}`
- **Component**: `{Docker/Kubernetes/etc.}`
- **Change**: {Description of infrastructure change}
- **Security Improvement**: {e.g., running as non-root user}

### 📋 Remediation Strategy

**Research Sources:**
- {Official vendor advisory URL}
- {NVD database URL}
- {Security research database URL}
- {OWASP reference URL if applicable}

**Fix Rationale:**
- {Reason 1 - why this specific fix}
- {Reason 2 - compatibility considerations}
- {Reason 3 - minimal change principle}
- {Reason 4 - security best practices followed}

**Alternative Approaches Considered:**
- {Alternative 1 and why not chosen}
- {Alternative 2 and why not chosen}

### 📊 Impact Assessment

**Security Impact**: {HIGH/MEDIUM/LOW}
- Remediates {severity} vulnerability
- Eliminates {attack_vector} attack vector
- Reduces attack surface by {description}

**Functional Impact**: {NONE/LOW/MEDIUM/HIGH}
- Breaking changes: {YES/NO}
- Migration required: {YES/NO}
- Tests updated: {YES/NO}
- Documentation updated: {YES/NO}

**Compatibility**: {MAINTAINED/BREAKING}
- {Explanation of compatibility with existing dependencies/code}
- {Any version constraints or requirements}

### ✅ Testing Performed

- [ ] Verified fix addresses the vulnerability
- [ ] Checked for breaking changes
- [ ] Tested with existing test suite
- [ ] Added new security tests (if applicable)
- [ ] Verified no new vulnerabilities introduced
- [ ] Tested in development environment

### 📚 References

- **CVE Details**: https://nvd.nist.gov/vuln/detail/{CVE}
- **Security Advisory**: {official_advisory_url}
- **Package Changelog**: {changelog_url if available}
- **OWASP Reference**: {owasp_url if applicable}
- **CWE Details**: https://cwe.mitre.org/data/definitions/{CWE-XXX}.html
- **Concert Issue**: #{issue_number}

### 🚀 Deployment Notes

{Any special considerations for deploying this fix}
- {Note 1}
- {Note 2}

### 📝 Additional Notes

{Any other relevant information}

---

**Automated Security Remediation** | Powered by IBM Concert + IBM Bob + GitHub MCP

Closes #{issue_number}
```

### Step 7: Document the Research and Remediation

Create `bob_task_<CVE>_<datetime>.md` with:

**CVE Research Section:**
```markdown
## CVE Research: {CVE}

### Initial Analysis
- **CVE ID**: {CVE}
- **Discovered**: {date}
- **Severity**: {severity}
- **CVSS Score**: {score if available}
- **CWE**: {CWE-XXX}
- **Category**: {Dependency/Code/Configuration/Infrastructure}

### Vulnerability Details
- **Type**: {vulnerability type}
- **Attack Vector**: {how it can be exploited}
- **Affected Versions/Code**: {version range or code pattern}
- **Patched Versions/Fix**: {fixed versions or secure pattern}
- **Root Cause**: {technical explanation}

### Research Sources
1. **NVD Database**: {URL and findings}
2. **Official Advisory**: {URL and findings}
3. **Security Research**: {URL and findings}
4. **OWASP/CWE**: {URL and findings if applicable}
5. **Package Documentation**: {URL and findings}

### Decision Process
1. **Identified vulnerability type**: {type and category}
2. **Analyzed repository context**: {findings from code review}
3. **Evaluated fix options**: {options considered}
4. **Selected approach**: {chosen approach}
5. **Rationale**: {detailed reasoning with security considerations}

### Implementation Details
- **Files modified**: {list with line numbers}
- **Changes made**: {detailed summary}
- **Security patterns applied**: {list}
- **Testing performed**: {tests run}
- **Verification**: {how verified the fix works}

### Compatibility Analysis
- **Dependencies checked**: {list}
- **Breaking changes**: {YES/NO with details}
- **Migration required**: {YES/NO with steps}
- **Rollback plan**: {if needed}
```

## 🎯 Success Criteria

### Research Phase
✅ CVE details thoroughly researched from official sources
✅ Vulnerability type and category correctly identified
✅ Attack vector understood and documented
✅ Affected versions/code patterns determined
✅ Patched versions/secure patterns identified
✅ Fix strategy selected with clear rationale
✅ Multiple authoritative sources cross-referenced

### Implementation Phase
✅ Repository context analyzed comprehensively
✅ Current state assessed accurately
✅ Appropriate fix implemented for vulnerability type
✅ Code quality maintained or improved
✅ Security best practices followed
✅ No breaking changes introduced (or documented if unavoidable)
✅ Similar vulnerable patterns also fixed

### Documentation Phase
✅ Comprehensive PR description created
✅ Research process documented with sources
✅ Testing steps provided
✅ Deployment notes included
✅ References linked
✅ bob_task.md updated with full analysis

### Quality Checks
✅ Fix addresses root cause, not just symptoms
✅ No new vulnerabilities introduced
✅ Compatible with existing code/dependencies
✅ Follows project conventions
✅ Properly tested and verified
✅ Security tests added (if applicable)

## 🚨 Important Notes

### Research Quality
- **Start with Official Sources**: Always begin with NVD, vendor advisories, and official security bulletins
- **Cross-Reference**: Verify information across multiple authoritative sources
- **Document Sources**: Keep track of where information came from with URLs
- **Understand Root Cause**: Don't just apply patches, understand why they work
- **Think Critically**: Evaluate if the fix makes sense for the specific vulnerability type
- **Consider Context**: Understand how the vulnerability fits into the broader security landscape

### Research Priority Order
1. **Official Vendor Security Advisory** (highest authority)
2. **National Vulnerability Database (NVD)**
3. **Package Maintainer's Changelog/Release Notes**
4. **Security Research Databases** (Snyk, GitHub Security)
5. **OWASP Guidelines** (for code vulnerabilities)
6. **Repository Documentation** (for validation, not determination)
7. **Community Discussions** (lowest authority, verify claims)

### Security First
- **Accuracy Over Speed**: Take time to research thoroughly from official sources
- **Defense in Depth**: Consider multiple security layers
- **Fail Securely**: Ensure errors don't expose vulnerabilities
- **Document Everything**: Create complete audit trail with source citations
- **Test Thoroughly**: Verify the fix works and doesn't break functionality
- **Think Like an Attacker**: Consider how the vulnerability could be exploited

### Critical Validation Checklist
Before implementing ANY fix:
- ✅ Researched CVE from official sources (NVD, vendor advisory)
- ✅ Identified exact vulnerability type and category
- ✅ Found official patched version or secure coding pattern
- ✅ Cross-referenced information across multiple sources
- ✅ Validated fix compatibility with current repository state
- ✅ Checked for breaking changes and migration requirements
- ✅ Considered similar vulnerable patterns elsewhere
- ✅ Documented all research sources and decision rationale

### When to Ask for Help
- **Ambiguous CVE**: If official sources provide conflicting information
- **No Official Fix**: If no patched version is documented in advisories
- **Multiple Approaches**: If official guidance suggests multiple valid fixes
- **Breaking Changes**: If fix requires significant architectural changes
- **Complex Vulnerability**: If root cause spans multiple components
- **Compatibility Issues**: If official fix incompatible with current environment
- **Unclear Impact**: If unsure about the scope of changes needed

---

## 📝 Example Usage

### Simple Prompt
```
Research and fix the security vulnerability in:
https://github.com/{owner}/{repo}/issues/{N}

Independently analyze the CVE, determine the best fix strategy,
implement the solution, and create a comprehensive pull request.
```

### Detailed Prompt
```
Analyze and remediate the security vulnerability in:
https://github.com/{owner}/{repo}/issues/{N}

Requirements:
1. Research the CVE independently from official sources
2. Identify the vulnerability category (dependency/code/config/infrastructure)
3. Analyze repository context to understand current implementation
4. Evaluate multiple fix approaches and select the best one
5. Implement the fix with security best practices
6. Create comprehensive PR with research documentation
7. Document the entire process in bob_task.md

Focus on thorough research, security best practices, and optimal outcomes.
```

### Category-Specific Prompt
```
Fix the {SQL Injection/XSS/Configuration/etc.} vulnerability in:
https://github.com/{owner}/{repo}/issues/{N}

This is a {code/configuration/infrastructure} vulnerability.
Research the secure coding patterns, implement the fix,
and ensure no similar vulnerable patterns exist elsewhere.
```

---

## 🎓 Research Methodology

### Correct Research Flow

```
1. CVE ID from Issue
   ↓
2. Research Official Sources
   ├─ NVD Database
   ├─ Vendor Security Advisory
   ├─ Package Changelog
   ├─ OWASP (for code vulns)
   └─ Security Research DBs
   ↓
3. Extract Key Information
   ├─ Vulnerability Type & Category
   ├─ Affected Versions/Patterns
   ├─ Patched Versions/Secure Patterns
   ├─ Attack Vector
   ├─ Root Cause
   └─ CWE Classification
   ↓
4. Validate Against Repository
   ├─ Check Current Versions/Code
   ├─ Verify Compatibility
   ├─ Assess Impact
   ├─ Check for Similar Patterns
   └─ Confirm Feasibility
   ↓
5. Implement Fix
   └─ Based on official guidance + validated compatibility
   ↓
6. Test & Verify
   └─ Ensure fix works and doesn't break functionality
```

### Common Mistakes to Avoid

**❌ Mistake 1: Relying Only on Repository Documentation**
- Repository docs may be outdated or incorrect
- Always verify with official CVE databases first

**❌ Mistake 2: Assuming Generic Fix Patterns**
- Not all dependency CVEs are fixed by upgrading
- Some require code changes or configuration updates
- Always check official advisory for specific guidance

**❌ Mistake 3: Ignoring Compatibility**
- Official fix may not work with current environment
- Must validate compatibility before implementing
- Check semantic versioning and breaking changes

**❌ Mistake 4: Fixing Only One Instance**
- Code vulnerabilities often appear in multiple places
- Search for similar patterns throughout the codebase
- Fix all instances to prevent incomplete remediation

**❌ Mistake 5: Not Understanding the Vulnerability**
- Applying fixes without understanding why
- May miss edge cases or introduce new issues
- Always research the root cause

**✅ Correct Approach:**
1. Research from official sources FIRST (NVD, vendor advisories, OWASP)
2. Understand the vulnerability type, category, and root cause
3. Identify the appropriate fix based on category
4. Validate compatibility with current environment
5. Search for similar vulnerable patterns
6. Implement fix based on official guidance and best practices
7. Test thoroughly and verify the fix works
8. Document all sources and reasoning

---

**Remember**: You are the security expert. **Always start with authoritative CVE sources** (NVD, vendor advisories, official security bulletins, OWASP) to determine the correct fix, then validate compatibility with the repository context. Research thoroughly, understand the vulnerability category, cite your sources, and implement the most secure solution based on official security guidance and industry best practices.