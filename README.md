# Apple App Store Release Skill

A reusable Codex skill for preparing, validating, uploading, and submitting macOS and companion iOS apps to App Store Connect.

It focuses on the parts that commonly fail late in the process: signing and entitlements, privacy manifests, export compliance, screenshots, metadata persistence, commerce and DSA requirements, build selection, and review-state verification.

## Install

Copy this repository to your Codex skills directory:

```bash
git clone https://github.com/w3345137/mac-app-store-release-skill.git \
  "${CODEX_HOME:-$HOME/.codex}/skills/mac-app-store-release"
```

Restart Codex after installation. The skill is discovered automatically for Mac App Store release work.

## Included helpers

- `scripts/audit-macos-app.sh`: inspect resolved Xcode build settings and locate privacy and entitlement files.
- `scripts/check-screenshot.sh`: validate one or more common macOS App Store screenshot dimensions.
- `scripts/asc-package.sh`: validate or upload a macOS `.pkg` or iOS `.ipa`, and wait for a delivery ID to finish processing, using App Store Connect API credentials supplied through environment variables.

The skill never stores credentials. Legal declarations and the final review submission remain explicit user decisions.

## License

MIT
