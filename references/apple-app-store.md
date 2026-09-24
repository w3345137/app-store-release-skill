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
- When the product promises landscape use on iPad or large/foldable iPhone layouts, inspect supported orientations in the exported app and exercise the actual landscape UI on representative simulator/device sizes. A portrait screenshot or orientation plist entry alone does not verify the layout.
- Verify pricing, availability, distribution method, agreements, tax category, DSA status, export compliance, and region-specific compliance.
- Keep website-direct macOS sales separate from App Store payments: the Paid Apps Agreement and StoreKit In-App Purchase do not process purchases for a Developer ID app distributed outside the Mac App Store. Apple Pay on a website is a wallet checkout method and still needs a merchant/payment provider plus order fulfillment; verify that provider's account, domain, device, and currency requirements before promising Apple Pay in release copy.
- For a website-direct paid app, check that the public site links to real terms, privacy, refund, and a working contact path. For a contact form, verify an actual test message reaches the intended inbox and can be answered; an HTTP success response or a running SMTP process alone is insufficient. Match the refund promise and displayed price to checkout policy, and keep payment disabled until a test order, fulfillment, recovery, refund, and chargeback path have all been exercised.
- When a private and public app share a source tree, gate the private feature's model types, actions, service, and UI at compile time. Disabling only the command parser or network request can still leave private names and code in the exported public binary. Scan the exact export and the app inside the distribution image for private markers before publication.
- Test trial and purchased-entitlement transitions while the app remains open. Verify the UI and every background worker stop at expiry and resume after activation; a unit test of the date comparison alone does not catch a stale hourly UI timer. Bound the normal refresh interval so the check does not poll continuously after expiry. For workers or extensions with their own authorization cache, reject cached access at the exact expiry and after a backward clock jump; a separate-process cache can outlive the main app's timer.
- For a Developer ID Mac app that uses Full Disk Access or another TCC permission, compare the installed and update candidate's bundle ID, Team ID, and `codesign -dr -` designated requirements for both app and extensions. Preserve a signed-app and data backup, install without exposing a partially copied app bundle, and read the actual macOS permission switch after an update. Matching signatures reduce identity drift but do not prove permission continuity without an update test.
- Stop or freeze the old app and its extensions before exchanging the bundle at the installed path, and do not resume old code while that path points to the new binary. A live old process using the new path can trigger a TCC code-requirement mismatch even when both builds have matching designated requirements. Check the System Settings switch and TCC result after the upgrade. Do not infer the app's Full Disk Access from a short CLI process launched by a terminal or agent with its own access; macOS may attribute that probe to the launcher.
- For a website-direct Mac feature that calls private or undocumented system APIs, verify the exact C ABI (argument count, pointer/object type, ownership and release function) and wire format against a primary implementation before packaging. A successful compile or notarization does not prove the operation works; exercise real hardware, and avoid sending commands when a display or device cannot be identified unambiguously.
- Apply the same notarization gate to a separately signed owner-only or test variant before installing it as a long-lived local app. A valid Developer ID signature can still be rejected as `Unnotarized Developer ID`; staple and validate the exact App and DMG, then check both with Gatekeeper. Keep those artifacts out of the public update feed.
- For iPhone/iPad apps, inspect the separate Apple-silicon Mac and Vision Pro availability switches. They may be enabled even if those platforms were not part of the product plan; test their experience and pricing implications before leaving them on.
- Do not automate acceptance of legal agreements. The account holder must accept contracts such as the Paid Apps Agreement.
- For China mainland, use the exact App Store Connect compliance state. Do not exclude China based only on a generic assumption about ICP requirements.

## Build and upload

- Prefer the project-owned archive/export workflow. Otherwise use `xcodebuild archive` plus an App Store export-options plist.
- For a direct-download package, freeze a hash manifest of build inputs before archiving, verify it after archive/export and before publishing, then record the final package hash and notarization ID in a local release receipt. This is especially important when the worktree has uncommitted changes: a Git commit alone cannot identify the exact source of that binary. Keep the receipt beside the artifact, not inside a public installer if it lists private paths.
- Validate an exported macOS `.pkg` or iOS `.ipa` with `scripts/asc-package.sh validate <path>` and upload with `scripts/asc-package.sh upload <path>`.
- Capture the delivery ID and use `scripts/asc-package.sh status <delivery-id>` until processing finishes.
- Verify the exact marketing version/build appears in the intended app before attaching it.

## Metadata and submission

- Use App Store Connect APIs where credentials are configured; use the website for unsupported fields and account-bound declarations.
- Validate screenshots with `scripts/check-screenshot.sh --platform <iphone|ipad|macos|tvos|visionos|watchos>`, then inspect every final image at full size. The helper rejects alpha/transparency as required by App Store Connect.
- App Store Connect can display newly selected screenshots before their upload has finished persisting. When replacing store media, upload the new images, refresh the media manager, and confirm their filenames and count survived the reload **before** deleting the old images. Refresh again after deletion and verify the final set and first-three display order on the version page; a transient thumbnail or file-picker success is not proof of a saved listing.
- Read back price, countries or regions, release mode, review contact, demo credentials, export-compliance answers, and attached build after saving.
- If the user specifies an exact price in a local currency, inspect the App Store Connect base country/region before choosing a global price tier. A USD base tier can convert to a different local amount; use an appropriate base region or a custom regional price, then read back the actual storefront amount.
- Prefer manual release unless the user explicitly requests automatic or phased release.
- A confirmation dialog is intermediate evidence. Verify the exact version/build reaches `WAITING_FOR_REVIEW` or a later state.

## Common blockers

- A first app from a developer account with limited review history may be rejected under Guideline 2.1 for more information even when the binary processes successfully. Read the exact Resolution Center message. Apple may require a screen recording from a physical device on the latest OS, beginning at app launch and showing the typical flow, plus the app purpose/audience, setup and access steps, external services, regional differences, and rights to regulated or third-party material. Prepare an accurate reply and repeat the durable facts in App Review Notes. A simulator recording, a static preview, or a processed TestFlight build does not prove this gate is satisfied.
- If reviewers cannot access account-based or private-server features, give them a stable demo-only route or sample environment. Do not expose a personal production account or claim that a read-only mockup demonstrates live network functionality. Check the exact submitted build on each supported physical device platform before replying.
- Generic add-for-review failure often means missing price, availability, agreement, DSA declaration, export compliance, or a required screenshot.
- A processed build can still be blocked by encryption declarations or mismatched bundle/version metadata.
- A free app still needs an active Free Apps agreement and availability configuration.
- A paid app needs an active Paid Apps Agreement plus completed tax and banking setup. Read all three states separately: an agreement marked “Waiting for User Info” does not mean ready, a bank account can remain “Processing,” and individual tax forms may still show missing information after another form becomes active. Do not treat the agreement date or a valid regional compliance row as proof that paid distribution is enabled.
- Cancelling an in-review submission to replace a build creates a new verification cycle: reload every editable field and read the new App Review state back.
