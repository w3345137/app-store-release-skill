# App store release checklist

## Shared

- Target store and distribution channel are explicit.
- Store identity, product ID, version/build, architecture/platform, minimum OS, and commercial model are recorded.
- Final package came from a clean, reproducible build and has a retained SHA-256 hash.
- Exact build inputs are frozen and checked after the build; a dirty worktree has an input hash manifest and a release receipt tying that manifest to the exported package.
- Credentials, signing keys, certificates, and secrets are absent from repository and package.
- If a direct-sale entitlement service runs as a dedicated OS user, verify that user can traverse each secret directory and read only the intended key files; root-only read checks are insufficient. Verify the service user cannot write the containing directory, and validate the actual systemd/service identity before opening checkout.
- Direct-sale payment tests cover delayed successful webhooks after claim expiry/cleanup, duplicate deliveries, receipt-based recovery, and first/middle/latest annual-purchase refunds or chargebacks. Out-of-order adjustment delivery cannot undo a newer decision; the offline-token revocation limit is documented.
- Time-limited access is rechecked at expiry in the main app and independent extensions or workers; cached grants do not survive expiry or a backward clock jump.
- Privacy declarations, permissions, capabilities/entitlements, network behavior, and reviewer notes agree with runtime behavior.
- Debug/test builds cannot share the production app's TCC identity or writable app group; built Debug and Release identities are inspected separately before testing production permission continuity.
- Screenshots show the current build and contain no personal or internal data.
- Demo credentials use an account containing only stable demonstration data.
- Any App Review request for a physical-device video or additional new-developer information is answered with evidence from the exact reviewed build and a reviewer-accessible demo path; the same durable details are saved in App Review Notes.
- Metadata survives reload and the processed package is attached to the intended version/submission.
- Before public availability, website Store/download calls to action remain non-interactive, including for keyboard and accessibility users; do not leave a placeholder `href="#"` on a hidden link. After launch, verify the real destination works.
- Release mode and markets are intentional.
- A paid mobile app's required companion desktop app is publicly installable and proven through first-run setup before mobile public release; manual release remains selected until then.
- Final submission has explicit user authorization and its resulting review/certification state is read back.

## Apple App Store

- Apple Distribution signing, provisioning, hardened runtime, sandbox, and entitlements are valid.
- `PrivacyInfo.xcprivacy`, usage descriptions, encryption declaration, SDK manifests, and App Store privacy answers agree.
- Store version equals `CFBundleShortVersionString`; build number is unique.
- Required iPhone/iPad/macOS screenshot families are present based on actual target support.
- For an iPhone/iPad app, Apple-silicon Mac and Vision Pro availability are intentional and do not contradict a separate desktop product or price.
- Price, availability, agreements, tax/banking state if paid, DSA status, export compliance, and regional compliance are complete.
- Uploaded delivery reaches terminal success and exact version/build is selectable.
- Final state is `WAITING_FOR_REVIEW` or later.

## Microsoft Store

- Partner Center identity name, publisher, package family, and four-part version match the final package.
- Dedicated Store build removes installer-download UI, native self-updater, and executable frontend/code hot-update behavior at compile time.
- Final executable/resources are scanned for forbidden updater and installer markers.
- MSIX manifest, assets, architecture, minimum Windows version, capabilities, entry point, and dependencies are verified.
- Windows App Certification Kit and a clean Windows install/launch smoke test pass or have documented, understood warnings.
- Restricted capabilities such as `runFullTrust` have a reviewer-facing justification.
- Listing, privacy URL, support contact, age rating, declarations, screenshots, certification notes, markets, and release schedule are complete.
- Uploaded package analysis succeeds and exact version/architecture is selected.
- Final state is `In certification` or later.
