---
name: mac-app-store-release
description: "Prepare, validate, upload, and submit macOS and companion iOS apps to App Store Connect. Use for App Store readiness audits, Xcode archives, signing and entitlement checks, screenshots and metadata, privacy declarations, export compliance, pricing and availability, TestFlight/App Store build selection, or review submission. Prefer CLI and App Store Connect API operations; use the website only for unsupported declarations and the final confirmation when needed."
---

# Apple App Store Release

Ship macOS and companion iOS apps with reproducible evidence. Treat app-record creation, archive upload, processing, version preparation, review submission, approval, and public release as separate states.

## Operating rules

- Inspect the repository, signing configuration, App Store Connect state, and existing release scripts before changing anything.
- Keep API keys, Apple IDs, app-specific passwords, certificates, and `.p8` files outside the repository. Never print their contents.
- Prefer `xcodebuild`, `codesign`, `security`, `plutil`, `xcrun altool`, and the App Store Connect API. Reuse an existing authenticated App Store Connect session only where API or CLI coverage is absent.
- Do not infer legal declarations. DSA trader status, content rights, export-control answers, and privacy answers must follow verified product facts or an explicit user choice.
- Prepare and inspect legal agreements, but leave acceptance of contracts such as the Paid Apps Agreement to the account holder. A visible unchecked agreement is a blocker, not authorization to accept it.
- Treat the commercial model as a release invariant. A free companion, a separately paid app, and an app with in-app purchases require different code, metadata, agreements, and review notes; do not silently carry a desktop trial or license into a separately purchased mobile app.
- Uploading a build is not authorization to submit it for review. Obtain explicit authorization before the final submission action. Approval is not authorization for an automatic public release unless the user asked for it.
- Do not use screenshots containing personal bookmarks, history, accounts, internal URLs, email, names, or company-only data. Use real app UI; crop or redact private chrome before upload.
- Verify every mutation by reading the resulting state back. A successful click, HTTP response, or CLI exit code alone is not completion.

## Workflow

1. Discover the app target and current release state.
   - Run `scripts/audit-macos-app.sh <repo> [scheme] [configuration]`. Pass the actual store configuration rather than assuming `Release`.
   - Read any release documents and `Info.plist`, entitlements, privacy manifest, project settings, and archive/export scripts.
   - Record bundle ID, marketing version, build number, minimum OS version, platform, team ID, category, and App Store Connect IDs.
   - For a new App Store Connect record, fix the intended name, primary locale, platform, registered Bundle ID, SKU, and access scope before opening the creation form. Read the created Apple ID back from App Store Connect; a successful click is not evidence.
   - App Store Connect may create an initial store version such as `1.0` even when the binary uses `0.1.0`. Treat the store version and `CFBundleShortVersionString` as separate values and make them agree before attaching a build for App Review.
2. Audit App Store requirements.
   - Signing: Apple Distribution identity, App Store provisioning, hardened runtime, sandbox, and only justified entitlements.
   - Privacy: `PrivacyInfo.xcprivacy`, usage descriptions, SDK manifests, privacy-policy URL, and App Store privacy answers agree with runtime behavior.
   - Product page: localized name, subtitle, description, keywords, support URL, marketing URL, copyright, category, age rating, screenshots, and review notes.
   - Derive required screenshot families from the resolved target device family and supported platforms. If an iOS target includes iPad, provide and inspect an accepted iPad screenshot instead of assuming iPhone assets are sufficient.
   - Commerce: free/paid price, availability, distribution method, active agreements, tax category, DSA status for EU distribution, and export compliance.
   - Before changing an app from free to paid, verify that the Paid Apps Agreement is active and that required tax and banking information can be completed. A one-time paid download is sold by the App Store and does not require StoreKit purchase UI inside the app.
   - For a separately distributed Mac app sold on the website, verify the complete payment lifecycle: signed webhook fulfillment, idempotency, entitlement recovery after closing or clearing the browser, renewal behavior, and refund or chargeback handling. Treat self-service recovery as a release requirement when no public support channel exists. Keep bearer claims out of URLs and access logs.
   - For China mainland, inspect the app's actual compliance section and status. Apple says additional documentation, including an ICP filing number, is required for some apps; do not exclude China preemptively unless the product category or App Store Connect state shows a real requirement that cannot yet be met.
3. Build and upload.
   - Prefer a project-owned archive/export script. Otherwise archive with `xcodebuild archive` and export with an App Store export-options plist.
   - Validate an exported macOS `.pkg` or iOS `.ipa` with `scripts/asc-package.sh validate <path>` and upload with `scripts/asc-package.sh upload <path>`. The script infers the platform from the file extension unless an explicit platform is provided.
   - Capture the delivery ID returned by upload. Use `scripts/asc-package.sh status <delivery-id>` to wait for import processing, then verify the exact marketing version/build appears and is selectable in the intended app.
4. Complete metadata and attach the processed build.
   - Use App Store Connect API endpoints when credentials are configured; use the website only for fields without stable API support or legal confirmations.
   - Validate screenshots with `scripts/check-screenshot.sh` before upload.
   - Inspect each final screenshot at full size. Check the tab strip, bookmarks bar, address bar, page content, menu bar, Dock, notifications, and window background for private or irrelevant state.
   - Save, reload, and read back all fields. Browser-side text changes may appear locally before App Store Connect has persisted them.
   - Read back the storefront price, not only the base price selection, and verify that the intended countries or regions remain selected after saving.
5. Submit only after explicit authorization.
   - Resolve every blocking warning.
   - Choose manual release unless the user explicitly requests automatic release.
   - A submission confirmation dialog is intermediate evidence. Open App Review and verify the exact version/build changed to the localized equivalent of `WAITING_FOR_REVIEW` or a later review state.
   - If a version is already in review and needs a new build or commercial model, finish the replacement build and commerce preflight before removing the existing submission. Then recheck every editable field and submit the replacement as a new review submission.
6. Record the release.
   - Update the project release notes or project memory with App ID, version/build, submission time, release mode, URLs, and remaining reviewer risks. Never record credentials.

## Common blockers

- Generic “try again later” after adding for review often means missing price, availability, agreement, DSA declaration, export compliance, or a required screenshot—not necessarily a transient outage.
- A processed build may still be blocked by an unanswered encryption declaration or mismatched bundle/version metadata.
- A free app still needs an active Free Apps agreement and availability. EU availability also requires a DSA trader/non-trader declaration.
- A paid app needs an active Paid Apps Agreement plus the required tax and banking setup. Upload success does not prove that pricing can be activated.
- China mainland availability is not automatically incompatible with a paid app. Use the exact App Store Connect compliance status; `ICP Filing Number Missing` is a concrete blocker, while a generic assumption is not.
- App Store screenshots must use accepted pixel dimensions. Validate the final file, not the source capture.
- “Ready to Submit” is not “submitted”; verify the state after the final action.
- If a submission is cancelled to revise metadata, treat the replacement as a new submission: reload the version page, recheck the screenshot and description, submit again, then read back App Review status.

Read [checklist.md](references/checklist.md) when performing a full release audit.
