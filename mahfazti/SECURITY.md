# Security Policy

## Supported Versions

Security issues should be reported against the latest development version or latest stable release.

| Version            | Supported    |
| ------------------ | ------------ |
| Latest release     | ✅            |
| Development branch | ✅            |
| Older versions     | Case by case |

## Reporting a Vulnerability

Please do **not** report security vulnerabilities through public GitHub issues.

Report security issues privately to the project maintainer using the contact information available on the repository profile.

Include:

* Description of the vulnerability
* Affected component
* Steps to reproduce
* Potential impact
* Suggested mitigation, if known

Do not include:

* Real passwords
* JWT secrets
* Database credentials
* API keys
* Private financial information

## Security Principles

Mahfazti uses:

* Spring Security
* JWT authentication
* BCrypt password hashing
* Stateless sessions
* Request validation
* Resource ownership validation
* Global exception handling

## Secret Management

Never commit:

```text
.env
application-local.yml
application-prod.yml
database passwords
JWT secrets
API keys
private certificates
production credentials
```

Use environment variables or a secure secret manager for production deployments.

## Production Recommendations

Before production deployment:

* Use HTTPS.
* Use strong JWT secrets.
* Store secrets outside Git.
* Restrict CORS origins.
* Use production database credentials.
* Disable unnecessary debug logging.
* Review database permissions.
* Keep dependencies updated.
