---
name: mac-app-store-release
description: "Prepare, validate, upload, and submit a macOS app to App Store Connect. Use for Mac App Store readiness audits, Xcode archives, signing and entitlement checks, screenshots and metadata, privacy declarations, export compliance, pricing and availability, TestFlight/App Store build selection, or review submission. Prefer CLI and App Store Connect API operations; use the website only for unsupported declarations and the final confirmation when needed."
---

# Mac App Store Release

Ship a macOS app with reproducible evidence. Treat archive upload, version preparation, review submission, approval, and public release as separate states.

## Operating rules

- Inspect the repository, signing configuration, App Store Connect state, and existing release scripts before changing anything.
- Keep API keys, Apple IDs, app-specific passwords, certificates, and `.p8` files outside the repository. Never print their contents.
- Prefer `xcodebuild`, `codesign`, `security`, `plutil`, `xcrun altool`, and the App Store Connect API. Reuse an existing authenticated App Store Connect session only where API or CLI coverage is absent.
- Do not infer legal declarations. DSA trader status, content rights, export-control answers, and privacy answers must follow verified product facts or an explicit user choice.
- Uploading a build is not authorization to submit it for review. Obtain explicit authorization before the final submission action. Approval is not authorization for an automatic public release unless the user asked for it.
- Do not use screenshots containing personal bookmarks, history, accounts, internal URLs, email, names, or company-only data. Use real app UI; crop or redact private chrome before upload.
- Verify every mutation by reading the resulting state back. A successful click, HTTP response, or CLI exit code alone is not completion.

## Workflow

1. Discover the app target and current release state.
   - Run `scripts/audit-macos-app.sh <repo> [scheme] [configuration]`. Pass the actual store configuration rather than assuming `Release`.
   - Read any release documents and `Info.plist`, entitlements, privacy manifest, project settings, and archive/export scripts.
   - Record bundle ID, marketing version, build number, minimum macOS version, team ID, category, and App Store Connect IDs.
2. Audit App Store requirements.
   - Signing: Apple Distribution identity, App Store provisioning, hardened runtime, sandbox, and only justified entitlements.
   - Privacy: `PrivacyInfo.xcprivacy`, usage descriptions, SDK manifests, privacy-policy URL, and App Store privacy answers agree with runtime behavior.
   - Product page: localized name, subtitle, description, keywords, support URL, marketing URL, copyright, category, age rating, screenshots, and review notes.
   - Commerce: free/paid price, availability, distribution method, active agreements, tax category, DSA status for EU distribution, and export compliance.
3. Build and upload.
   - Prefer a project-owned archive/export script. Otherwise archive with `xcodebuild archive` and export with an App Store export-options plist.
   - Validate the exported `.pkg` with `scripts/asc-package.sh validate <pkg>` and upload with `scripts/asc-package.sh upload <pkg>`.
   - Wait for App Store Connect processing and verify the exact bundle version/build appears and is selectable.
4. Complete metadata and attach the processed build.
   - Use App Store Connect API endpoints when credentials are configured; use the website only for fields without stable API support or legal confirmations.
   - Validate screenshots with `scripts/check-screenshot.sh` before upload.
   - Inspect each final screenshot at full size. Check the tab strip, bookmarks bar, address bar, page content, menu bar, Dock, notifications, and window background for private or irrelevant state.
   - Save, reload, and read back all fields. Browser-side text changes may appear locally before App Store Connect has persisted them.
5. Submit only after explicit authorization.
   - Resolve every blocking warning.
   - Choose manual release unless the user explicitly requests automatic release.
   - A submission confirmation dialog is intermediate evidence. Open App Review and verify the exact version/build changed to the localized equivalent of `WAITING_FOR_REVIEW` or a later review state.
6. Record the release.
   - Update the project release notes or project memory with App ID, version/build, submission time, release mode, URLs, and remaining reviewer risks. Never record credentials.

## Common blockers

- Generic “try again later” after adding for review often means missing price, availability, agreement, DSA declaration, export compliance, or a required screenshot—not necessarily a transient outage.
- A processed build may still be blocked by an unanswered encryption declaration or mismatched bundle/version metadata.
- A free app still needs an active Free Apps agreement and availability. EU availability also requires a DSA trader/non-trader declaration.
- App Store screenshots must use accepted pixel dimensions. Validate the final file, not the source capture.
- “Ready to Submit” is not “submitted”; verify the state after the final action.
- If a submission is cancelled to revise metadata, treat the replacement as a new submission: reload the version page, recheck the screenshot and description, submit again, then read back App Review status.

Read [checklist.md](references/checklist.md) when performing a full release audit.
