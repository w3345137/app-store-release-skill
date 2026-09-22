# Apple App Store release

Use this reference for macOS, iOS, App Store Connect, TestFlight, Xcode archives, `.pkg`, and `.ipa` work.

## Discover and audit

- Run `scripts/audit-macos-app.sh <repo> [scheme] [configuration]`. Pass the actual Store configuration rather than assuming `Release`.
- Read release documents, `Info.plist`, entitlements, privacy manifest, project settings, archive/export scripts, and App Store Connect state.
- Record bundle ID, marketing version, build number, minimum OS version, platform, team ID, category, App Store Connect IDs, and intended commercial model.
- For a new record, fix the name, primary locale, platform, registered Bundle ID, SKU, and access scope before creation. Read the Apple ID back after creation.
- App Store Connect may create an initial version such as `1.0` even when the binary uses another value. Make the store version and `CFBundleShortVersionString` agree before attaching a build.

## Requirements

- Verify Apple Distribution signing, App Store provisioning, hardened runtime, App Sandbox, and only justified entitlements.
- Verify `PrivacyInfo.xcprivacy`, usage descriptions, SDK manifests, privacy-policy URL, and privacy answers against actual runtime behavior.
- Derive screenshot families from resolved target device family and supported platforms. If iPad is supported, provide an accepted iPad screenshot.
- Verify pricing, availability, distribution method, agreements, tax category, DSA status, export compliance, and region-specific compliance.
- Do not automate acceptance of legal agreements. The account holder must accept contracts such as the Paid Apps Agreement.
- For China mainland, use the exact App Store Connect compliance state. Do not exclude China based only on a generic assumption about ICP requirements.

## Build and upload

- Prefer the project-owned archive/export workflow. Otherwise use `xcodebuild archive` plus an App Store export-options plist.
- Validate an exported macOS `.pkg` or iOS `.ipa` with `scripts/asc-package.sh validate <path>` and upload with `scripts/asc-package.sh upload <path>`.
- Capture the delivery ID and use `scripts/asc-package.sh status <delivery-id>` until processing finishes.
- Verify the exact marketing version/build appears in the intended app before attaching it.

## Metadata and submission

- Use App Store Connect APIs where credentials are configured; use the website for unsupported fields and account-bound declarations.
- Validate screenshots with `scripts/check-screenshot.sh`, then inspect every final image at full size.
- Read back price, countries or regions, release mode, review contact, demo credentials, export-compliance answers, and attached build after saving.
- Prefer manual release unless the user explicitly requests automatic or phased release.
- A confirmation dialog is intermediate evidence. Verify the exact version/build reaches `WAITING_FOR_REVIEW` or a later state.

## Common blockers

- Generic add-for-review failure often means missing price, availability, agreement, DSA declaration, export compliance, or a required screenshot.
- A processed build can still be blocked by encryption declarations or mismatched bundle/version metadata.
- A free app still needs an active Free Apps agreement and availability configuration.
- A paid app needs an active Paid Apps Agreement plus tax and banking setup.
- Cancelling an in-review submission to replace a build creates a new verification cycle: reload every editable field and read the new App Review state back.
