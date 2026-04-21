# Concert + Bob Vulnerability Remediation
This repo contains a sample vulnerable python application

We will showcase a workflow for vulnerability remediation using Concert + Bob

![Workflow Diagram](./workflow_diagram.png)

## Workflow Overview
This automated [workflow](./.github/workflows/bob-shell-v2.yml) orchestrates CVE remediation through four key stages:

1. **DevOps Phase** - Bob Shell researches the CVE using Concert API and external sources (NVD, GitHub Advisory), then creates a PR with package upgrades
2. **DevOps Approval** - DevOps engineer reviews and approves the package changes on GitHub UI
3. **Unit Testing** - Automated tests run against the upgraded dependencies to verify compatibility
4. **Code Remediation** - If tests fail, Bob Shell automatically fixes application code to work with the new package versions
5. **Merge & Deploy** - Software Lead assigned to perform code review before changes are merged and deployed to production

The workflow uses Bob Shell in two specialized modes: `devops-concert-shell` for CVE research and implement package upgrades, while using `advanced` mode for code fixes. Each stage includes automated PR comments, reviewer assignments, and label management to track progress.

### Initial Setup:
#### Configure the following Github Action Secrets
`https://github.com/highorbit25/concert-bob-remediate/settings/secrets/actions`

```
BOBSHELL_API_KEY="XXX"

BOBSHELL_MCP_CONFIG="{sample in .bob/mcp.json}"

CONCERT_API_KEY="C_API_KEY XXX"
```


#### Configure the following Github Action Variables
`https://github.com/highorbit25/concert-bob-remediate/settings/variables/actions`

```
CONCERT_HOSTNAME="https://162.133.134.XXX:12443"

CONCERT_INSTANCE_ID="0000-0000-0000-0000"

# To disable telemetry
BOBSHELL_SETTINGS={ "security": { "ibmTelemetry": { "enabled": false } } }

DEVOPS_REVIEWERS=['devops-user']

INGESTION_JOB_ID=92073c05-xxxx-xxxx-8408-89ed1341a592

LEAD_REVIEWERS=['swe-lead-user']

SWE_REVIEWERS=['swe-user']
```

#### Configure `devops-approval` Environments for DevOps Approval

`https://github.com/highorbit25/concert-bob-remediate/settings/environments`

1. Create `devops-approval` environment
2. Add `Deployment protection rules` > `Required reviewers` > Select `devops-user`


#### Use this `requirements.txt` in ./app/vulnerable with vulnerable packages
```
click==8.1.8
Flask==1.1.2
itsdangerous==1.1.0
Jinja2==3.1.6
MarkupSafe==3.0.2
Werkzeug==0.16.1
```
