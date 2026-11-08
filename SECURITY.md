# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| `main` branch | ✅ Yes       |
| Tagged releases | ✅ Yes (latest) |
| Any other version | ❌ No        |

## Reporting a Vulnerability

**Do not open a public issue for security vulnerabilities.**

Report via [GitHub Private Vulnerability Reporting](https://github.com/Salar-prog/my-opencode-configs/security/advisories/new) (preferred) — it creates a private advisory that the maintainer can triage and fix before public disclosure.

Include in your report:
- Steps to reproduce
- Affected files/paths (e.g. `opencode/opencode.jsonc`, a skill directory)
- Potential impact (e.g. "committed token in config", "unsafe MCP server command")

## What Is NOT a Vulnerability Here

This is a configuration bundle. The following are expected and **not** vulnerabilities:

- **OAuth flows** for GitHub MCP (expected interactive sign-in on each machine).
- **`service.json` being absent from the repo** — it's generated per machine by design.
- **Secrets via `{env:VAR}`** — by design; if you see a hardcoded token in a skill file, that's an upstream issue (file upstream, not here).
- **Executable scripts inside skill directories** — created by upstream skill packs for their own use cases; treat as you would any upstream code.

## Scope

In scope:
- All files in this repo (`opencode/`, `agents/`, `scripts/`, docs).

Out of scope:
- Upstream tools this config references (OpenCode, superpowers, ponytail, gamedev-skills, MCP servers). Report issues affecting those to their respective projects.

## Disclosure Policy

The maintainer will:
1. Acknowledge receipt within **48 hours**.
2. Investigate and prepare a fix.
3. Coordinate a disclosure timeline with the reporter.
4. Publish a security advisory and release notes after the fix is deployed.

Thank you for helping keep this project (and its users) safe.
