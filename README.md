# App Store Release Skill

A reusable Codex skill for preparing, validating, uploading, and submitting apps to Apple App Store Connect and Microsoft Partner Center.

It covers macOS/iOS App Store and Windows Microsoft Store release work: signing, package identity, entitlements or capabilities, privacy and policy declarations, screenshots and metadata, reviewer access, certification submission, staged release, rejection remediation, and final state verification.

## Install

```bash
git clone https://github.com/w3345137/app-store-release-skill.git \
  "${CODEX_HOME:-$HOME/.codex}/skills/app-store-release"
```

Restart Codex after installation. The skill is discovered automatically for Apple and Microsoft Store release work.

## Included helpers

- `scripts/audit-macos-app.sh`: inspect resolved Xcode build settings and locate privacy and entitlement files.
- `scripts/check-screenshot.sh`: validate current iPhone, iPad, macOS, Apple TV, Apple Vision Pro, and Apple Watch screenshot dimensions and reject alpha/transparency. Use `--platform` to require a specific family.
- `scripts/asc-package.sh`: validate or upload Apple `.pkg` and `.ipa` packages and inspect processing status.
- `scripts/audit-windows-store-app.ps1`: inspect Windows Store source configuration and optionally verify a final MSIX-family package.
- `scripts/verify-msix.ps1`: unpack and verify MSIX identity, version, architecture, capabilities, hash, and forbidden embedded strings.

The skill never stores credentials. Legal declarations and final certification submission remain explicit user decisions.

## License

MIT
