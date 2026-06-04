---
name: Test False Positive CVE
about: Test issue for false positive detection workflow
title: 'CVE-2023-32681 in requests 2.25.1'
labels: cve-remediation
assignees: ''
---

## CVE Details

- **CVE ID**: CVE-2023-32681
- **Package**: requests 2.25.1
- **Severity**: MEDIUM (CVSS 6.1)
- **Type**: Unintended leak of Proxy-Authorization header
- **CWE**: CWE-200 (Exposure of Sensitive Information)

## Description

Requests is a HTTP library. Since Requests 2.3.0, Requests has been leaking Proxy-Authorization headers to destination servers when redirected to an HTTPS endpoint. 

This is a product of how we use `rebuild_proxies` to reattach the `Proxy-Authorization` header to requests. For HTTP connections sent through the tunnel, the proxy will identify the header in the request itself and remove it prior to forwarding to the destination server. 

However when sent over HTTPS, the `Proxy-Authorization` header must be sent in the CONNECT request as the proxy has no visibility into the tunneled request. This results in Requests forwarding proxy credentials to the destination server unintentionally, allowing a malicious actor to potentially exfiltrate sensitive information.

## Vulnerability Details

- **Affected Versions**: requests < 2.31.0
- **Fixed Version**: requests 2.31.0
- **Attack Vector**: Network
- **Attack Complexity**: High
- **Privileges Required**: None
- **User Interaction**: Required

## Remediation

Upgrade to requests 2.31.0 or later.

## Application Context

- **Application**: vulnerable-flask-app
- **File**: `app/vulnerable/requirements.txt`
- **Current Version**: 2.25.1
- **Recommended Version**: 2.31.0

## References

- NVD: https://nvd.nist.gov/vuln/detail/CVE-2023-32681
- GitHub Advisory: https://github.com/advisories/GHSA-j8r2-6x86-q33q
- Package Changelog: https://github.com/psf/requests/releases/tag/v2.31.0

---

**Note**: This is a test issue for the false positive detection workflow. The `requests` package is listed in requirements.txt but is never imported or used in the application code, making this a false positive.