# Concert + Bob CVE Remediation Workflow Diagrams

This document contains visual representations of the automated CVE remediation workflow.

## Table of Contents
1. [Complete Workflow Overview](#complete-workflow-overview)
2. [False Positive Detection Flow](#false-positive-detection-flow)
3. [True Positive Remediation Flow](#true-positive-remediation-flow)
4. [Multi-Ecosystem Support](#multi-ecosystem-support)

---

## Complete Workflow Overview

This diagram shows the entire CVE remediation workflow from Concert detection to production deployment.

```mermaid
flowchart TD
    Start([Concert Detects CVE]) --> Issue[Concert Creates GitHub Issue]
    Issue --> Trigger[GitHub Actions Workflow Triggered]
    
    Trigger --> DevOps[DevOps Phase: Bob Shell]
    DevOps --> Research[Research CVE in Concert API]
    Research --> External[Cross-check NVD/GitHub Advisory]
    External --> FPDetect{False Positive<br/>Detection}
    
    FPDetect -->|Analyze Code| Search[Search Codebase for Package Usage]
    Search --> Analyze[Analyze Function Calls & Data Flow]
    Analyze --> Determine{Is CVE<br/>Exploitable?}
    
    Determine -->|FALSE POSITIVE| Comment[Comment on Issue with Analysis]
    Comment --> TagEngineer[Tag DevOps Engineer for Review]
    TagEngineer --> EngineerReview{Engineer<br/>Agrees?}
    EngineerReview -->|Yes| CloseIssue[Close Issue - No Action Needed]
    EngineerReview -->|No| ManualFix[Manual Remediation]
    
    Determine -->|TRUE POSITIVE| CreateBranch[Create Remediation Branch]
    CreateBranch --> UpdateManifest[Update Package Manifest]
    UpdateManifest --> CommitPush[Commit & Push Changes]
    CommitPush --> CreatePR[Create Pull Request]
    
    CreatePR --> Approval[DevOps Approval Gate]
    Approval --> DevOpsReview{DevOps Engineer<br/>Approves?}
    DevOpsReview -->|Reject| RejectPR[Close PR]
    DevOpsReview -->|Approve| RunTests[Run Unit Tests]
    
    RunTests --> TestResult{Tests<br/>Pass?}
    TestResult -->|Pass| LeadReview[Software Lead Review]
    TestResult -->|Fail| CodeFix[Code Remediation: Bob Shell]
    
    CodeFix --> FixCode[Fix Application Code for New Package]
    FixCode --> RerunTests[Re-run Unit Tests]
    RerunTests --> TestResult2{Tests<br/>Pass?}
    TestResult2 -->|Fail| FixCode
    TestResult2 -->|Pass| LeadReview
    
    LeadReview --> LeadApprove{Lead<br/>Approves?}
    LeadApprove -->|Reject| RequestChanges[Request Changes]
    LeadApprove -->|Approve| Merge[Merge to Main]
    Merge --> Deploy[Deploy to Production]
    Deploy --> End([CVE Remediated])
    
    CloseIssue --> End
    RejectPR --> End
    ManualFix --> End

    style Start fill:#e1f5ff
    style End fill:#c8e6c9
    style FPDetect fill:#fff9c4
    style Determine fill:#fff9c4
    style Comment fill:#ffccbc
    style CreateBranch fill:#c5e1a5
    style TestResult fill:#fff9c4
    style TestResult2 fill:#fff9c4
```

---

## False Positive Detection Flow

Detailed view of the intelligent false positive detection process.

```mermaid
flowchart TD
    Start([CVE Detected]) --> Extract[Extract CVE Context]
    Extract --> Details[Parse CVE Details:<br/>- Package name & version<br/>- Vulnerable functions<br/>- Attack vector<br/>- CVSS score]
    
    Details --> Search[Search Codebase]
    Search --> ImportSearch[Find Package Imports:<br/>npm: import/require<br/>Python: import/from]
    ImportSearch --> FunctionSearch[Search for Vulnerable Functions]
    
    FunctionSearch --> ReadFiles[Read Source Files]
    ReadFiles --> Analyze[Analyze Usage Patterns]
    
    Analyze --> Check1{Package<br/>Directly Used?}
    Check1 -->|No - Transitive| FP1[FALSE POSITIVE:<br/>Transitive Dependency]
    Check1 -->|Yes| Check2{Vulnerable<br/>Functions Called?}
    
    Check2 -->|No| FP2[FALSE POSITIVE:<br/>Unused Feature]
    Check2 -->|Yes| Check3{Code Path<br/>Reachable?}
    
    Check3 -->|No| FP3[FALSE POSITIVE:<br/>Unreachable Code]
    Check3 -->|Yes| Check4{User Input<br/>Reaches Vuln?}
    
    Check4 -->|No| FP4[FALSE POSITIVE:<br/>Safe Usage Pattern]
    Check4 -->|Yes| Check5{Security<br/>Controls?}
    
    Check5 -->|Yes - WAF/Validation| FP5[FALSE POSITIVE:<br/>Mitigated]
    Check5 -->|No| TP[TRUE POSITIVE:<br/>Requires Remediation]
    
    FP1 --> Document[Document Analysis]
    FP2 --> Document
    FP3 --> Document
    FP4 --> Document
    FP5 --> Document
    
    Document --> Comment[Create GitHub Comment:<br/>- Evidence<br/>- File paths<br/>- Code snippets<br/>- Reasoning]
    Comment --> Tag[Tag DevOps Engineer]
    Tag --> End([Await Engineer Review])
    
    TP --> Remediate[Proceed with Remediation]
    Remediate --> End2([Create PR])

    style Start fill:#e1f5ff
    style End fill:#ffccbc
    style End2 fill:#c8e6c9
    style FP1 fill:#ffccbc
    style FP2 fill:#ffccbc
    style FP3 fill:#ffccbc
    style FP4 fill:#ffccbc
    style FP5 fill:#ffccbc
    style TP fill:#c8e6c9
```

---

## True Positive Remediation Flow

Detailed view of the package upgrade and code remediation process.

```mermaid
flowchart TD
    Start([TRUE POSITIVE Confirmed]) --> Branch[Create Branch:<br/>fix/cve-{ID}-{package}]
    Branch --> Manifest[Update Package Manifest]
    
    Manifest --> EcoCheck{Ecosystem?}
    EcoCheck -->|npm| NPM[Update package.json:<br/>- Change version<br/>- Add comment]
    EcoCheck -->|Python| PY[Update requirements.txt:<br/>- Change version<br/>- Add comment]
    EcoCheck -->|Java| JAVA[Update pom.xml:<br/>- Change version<br/>- Add comment]
    
    NPM --> Commit
    PY --> Commit
    JAVA --> Commit
    
    Commit[Commit Changes:<br/>fix: upgrade {pkg} to {ver} for CVE-{ID}]
    Commit --> Push[Push to Remote]
    Push --> PR[Create Pull Request:<br/>- CVE details<br/>- Concert recommendations<br/>- Link to issue]
    
    PR --> Label[Add Labels:<br/>- security<br/>- dependencies]
    Label --> Assign[Assign DevOps Reviewers]
    Assign --> Approval[DevOps Approval Gate]
    
    Approval --> Review{Approved?}
    Review -->|No| Close[Close PR]
    Review -->|Yes| Install[Install Dependencies]
    
    Install --> EcoTest{Ecosystem?}
    EcoTest -->|npm| NPMTest[npm ci && npm test]
    EcoTest -->|Python| PyTest[pip install && python -m unittest]
    EcoTest -->|Java| JavaTest[mvn test]
    
    NPMTest --> TestResult
    PyTest --> TestResult
    JavaTest --> TestResult
    
    TestResult{Tests Pass?}
    TestResult -->|Yes| Success[Add Success Comment]
    Success --> LeadReview[Assign Software Lead]
    
    TestResult -->|No| Failure[Add Failure Comment]
    Failure --> BobFix[Bob Shell: Advanced Mode]
    BobFix --> AnalyzeFail[Analyze Test Failures]
    AnalyzeFail --> FixCode[Fix Application Code:<br/>- Update deprecated APIs<br/>- Fix import paths<br/>- Update method calls]
    FixCode --> ReTest[Re-run Tests]
    ReTest --> TestResult2{Tests Pass?}
    TestResult2 -->|No| FixCode
    TestResult2 -->|Yes| Success
    
    LeadReview --> FinalReview{Lead Approves?}
    FinalReview -->|No| RequestChanges[Request Changes]
    FinalReview -->|Yes| Merge[Merge to Main]
    Merge --> Deploy[Deploy to Production]
    Deploy --> CloseIssue[Close GitHub Issue]
    CloseIssue --> End([CVE Remediated])
    
    Close --> End
    RequestChanges --> End

    style Start fill:#c8e6c9
    style End fill:#c8e6c9
    style TestResult fill:#fff9c4
    style TestResult2 fill:#fff9c4
    style Failure fill:#ffccbc
    style Success fill:#c8e6c9
```

---

## Multi-Ecosystem Support

How the workflow handles different package ecosystems (npm, Python, Java).

```mermaid
flowchart TD
    Start([PR Created]) --> Detect[Workflow Detects Ecosystem]
    Detect --> Check[Check Modified Files in PR]
    
    Check --> Files{Which Files<br/>Modified?}
    
    Files -->|package.json| NPM[Ecosystem: npm]
    Files -->|requirements.txt| Python[Ecosystem: Python]
    Files -->|pom.xml| Java[Ecosystem: Java]
    
    NPM --> NPMSetup[Setup Node.js Environment]
    NPMSetup --> NPMInstall[npm ci<br/>Install exact versions from lock]
    NPMInstall --> NPMTest[npm test<br/>Run Jest/Vitest tests]
    
    Python --> PySetup[Setup Python Environment]
    PySetup --> PyInstall[pip install -r requirements.txt<br/>Install dependencies]
    PyInstall --> PyTest[python -m unittest<br/>Run unit tests]
    
    Java --> JavaSetup[Setup Java Environment]
    JavaSetup --> JavaInstall[mvn install<br/>Install dependencies]
    JavaInstall --> JavaTest[mvn test<br/>Run JUnit tests]
    
    NPMTest --> Result
    PyTest --> Result
    JavaTest --> Result
    
    Result{Tests Pass?}
    Result -->|Pass| Success[Continue Workflow]
    Result -->|Fail| Fix[Bob Shell Code Remediation]
    
    Fix --> EcoFix{Ecosystem?}
    EcoFix -->|npm| NPMFix[Fix JavaScript/TypeScript:<br/>- Update import statements<br/>- Fix deprecated APIs<br/>- Update React patterns]
    EcoFix -->|Python| PyFix[Fix Python Code:<br/>- Update imports<br/>- Fix deprecated methods<br/>- Update Flask patterns]
    EcoFix -->|Java| JavaFix[Fix Java Code:<br/>- Update imports<br/>- Fix deprecated methods<br/>- Update Spring patterns]
    
    NPMFix --> Retest[Re-run Tests]
    PyFix --> Retest
    JavaFix --> Retest
    
    Retest --> Result
    Success --> End([Workflow Continues])

    style Start fill:#e1f5ff
    style End fill:#c8e6c9
    style Result fill:#fff9c4
    style NPM fill:#68a063
    style Python fill:#3776ab
    style Java fill:#f89820
```

---

## TanStack Demo Scenario Flow

Specific flow for the TanStack supply chain attack demonstration.

```mermaid
flowchart TD
    Start([Concert Scans SBOM]) --> Detect[Detects 2 CVEs in npm packages]
    Detect --> Issue1[Issue #1: TanStack Query 5.62.1<br/>Supply Chain Attack]
    Detect --> Issue2[Issue #2: axios 1.5.1<br/>CVE-2023-45857 SSRF]
    
    Issue1 --> Workflow1[Trigger Workflow for Issue #1]
    Issue2 --> Workflow2[Trigger Workflow for Issue #2]
    
    Workflow1 --> Research1[Bob: Research TanStack Attack]
    Research1 --> Search1[Search: import.*@tanstack/react-query]
    Search1 --> Found1[Found: UserList.jsx uses useQuery]
    Found1 --> Analyze1[Analyze: Package actively used]
    Analyze1 --> TP1[TRUE POSITIVE:<br/>Supply chain attack affects app]
    TP1 --> PR1[Create PR: Upgrade to 5.62.3]
    
    Workflow2 --> Research2[Bob: Research axios CVE]
    Research2 --> Search2[Search: import.*axios]
    Search2 --> Found2[Found: weather.js uses axios]
    Found2 --> Analyze2[Analyze Usage Pattern]
    Analyze2 --> Check2[Check: axios.get with hardcoded URL]
    Check2 --> Safe2[User input only in query params]
    Safe2 --> FP2[FALSE POSITIVE:<br/>Safe usage pattern]
    FP2 --> Comment2[Comment on Issue #2:<br/>Detailed analysis]
    
    PR1 --> Approve1[DevOps Approves PR #1]
    Approve1 --> Test1[Run npm test]
    Test1 --> Pass1{Tests Pass?}
    Pass1 -->|Yes| Merge1[Merge PR #1]
    Pass1 -->|No| Fix1[Bob: Fix code for new TanStack API]
    Fix1 --> Test1
    
    Comment2 --> Engineer2[DevOps Engineer Reviews]
    Engineer2 --> Agree2{Agrees with<br/>Analysis?}
    Agree2 -->|Yes| Close2[Close Issue #2]
    Agree2 -->|No| Manual2[Manual Investigation]
    
    Merge1 --> Deploy[Deploy to Production]
    Close2 --> End([Demo Complete])
    Deploy --> End
    Manual2 --> End

    style Start fill:#e1f5ff
    style End fill:#c8e6c9
    style TP1 fill:#c8e6c9
    style FP2 fill:#ffccbc
    style Issue1 fill:#ffebee
    style Issue2 fill:#ffebee
```

---

## Workflow State Transitions

State diagram showing the lifecycle of a CVE issue.

```mermaid
stateDiagram-v2
    [*] --> Detected: Concert detects CVE
    Detected --> Analyzing: Bob Shell triggered
    
    Analyzing --> FalsePositive: Code analysis shows safe
    Analyzing --> TruePositive: Vulnerability confirmed
    
    FalsePositive --> AwaitingReview: Comment posted
    AwaitingReview --> Closed: Engineer agrees
    AwaitingReview --> TruePositive: Engineer disagrees
    
    TruePositive --> PRCreated: Package upgrade PR
    PRCreated --> AwaitingApproval: DevOps review
    
    AwaitingApproval --> Rejected: DevOps rejects
    AwaitingApproval --> Testing: DevOps approves
    
    Testing --> TestsPassed: All tests pass
    Testing --> TestsFailed: Tests fail
    
    TestsFailed --> CodeFixing: Bob fixes code
    CodeFixing --> Testing: Re-run tests
    
    TestsPassed --> CodeReview: Lead review
    CodeReview --> ChangesRequested: Lead requests changes
    CodeReview --> Merged: Lead approves
    
    ChangesRequested --> CodeFixing: Apply changes
    
    Merged --> Deployed: Deploy to production
    Deployed --> [*]: CVE remediated
    
    Rejected --> [*]: Manual intervention
    Closed --> [*]: No action needed
```

---

## Actor Interactions

Sequence diagram showing interactions between different actors in the workflow.

```mermaid
sequenceDiagram
    participant C as Concert
    participant GH as GitHub
    participant W as Workflow
    participant B as Bob Shell
    participant D as DevOps Engineer
    participant L as Software Lead
    
    C->>GH: Create CVE Issue
    GH->>W: Trigger Workflow
    W->>B: Start DevOps Phase
    
    B->>C: Query CVE Details
    C-->>B: CVE Information
    B->>B: Analyze Codebase
    
    alt False Positive
        B->>GH: Comment on Issue
        GH->>D: Notify Engineer
        D->>GH: Review & Close
    else True Positive
        B->>GH: Create PR
        GH->>D: Request Approval
        D->>GH: Approve PR
        
        W->>W: Run Tests
        
        alt Tests Pass
            W->>GH: Add Success Comment
            GH->>L: Request Review
            L->>GH: Approve & Merge
        else Tests Fail
            W->>B: Start Code Fix Phase
            B->>B: Fix Application Code
            B->>GH: Push Fixes
            W->>W: Re-run Tests
            W->>GH: Add Success Comment
            GH->>L: Request Review
            L->>GH: Approve & Merge
        end
        
        W->>W: Deploy to Production
        W->>GH: Close Issue
    end
```

---

## Key Workflow Features

### 1. Intelligent False Positive Detection
- Analyzes actual code usage patterns
- Prevents unnecessary package upgrades
- Reduces breaking changes
- Saves engineering time

### 2. Multi-Ecosystem Support
- Automatically detects npm, Python, or Java
- Runs appropriate test commands
- Handles ecosystem-specific patterns

### 3. Automated Code Remediation
- Fixes application code when tests fail
- Updates deprecated APIs
- Maintains functionality with new packages

### 4. Human-in-the-Loop Approval
- DevOps approval for package changes
- Software Lead approval for code changes
- Engineer review for false positives

### 5. Complete Traceability
- Links PRs to original CVE issues
- Documents Concert recommendations
- Tracks all changes and approvals

---

## Workflow Triggers

The workflow can be triggered in multiple ways:

1. **Automatic**: Concert detects CVE and creates GitHub issue
2. **Manual**: Engineer creates issue with CVE details
3. **Scheduled**: Periodic scans for new vulnerabilities
4. **On-Demand**: Manual workflow dispatch

## Success Metrics

- **Time to Remediation**: From CVE detection to production deployment
- **False Positive Rate**: Percentage of CVEs correctly identified as false positives
- **Test Success Rate**: Percentage of PRs that pass tests on first try
- **Manual Intervention Rate**: Percentage of CVEs requiring manual fixes
