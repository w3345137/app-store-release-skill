# App store release checklist

## Shared

- Target store and distribution channel are explicit.
- Store identity, product ID, version/build, architecture/platform, minimum OS, and commercial model are recorded.
- Final package came from a clean, reproducible build and has a retained SHA-256 hash.
- Credentials, signing keys, certificates, and secrets are absent from repository and package.
- Privacy declarations, permissions, capabilities/entitlements, network behavior, and reviewer notes agree with runtime behavior.
- Screenshots show the current build and contain no personal or internal data.
- Demo credentials use an account containing only stable demonstration data.
- Metadata survives reload and the processed package is attached to the intended version/submission.
- Release mode and markets are intentional.
- Final submission has explicit user authorization and its resulting review/certification state is read back.

## Apple App Store

- Apple Distribution signing, provisioning, hardened runtime, sandbox, and entitlements are valid.
- `PrivacyInfo.xcprivacy`, usage descriptions, encryption declaration, SDK manifests, and App Store privacy answers agree.
- Store version equals `CFBundleShortVersionString`; build number is unique.
- Required iPhone/iPad/macOS screenshot families are present based on actual target support.
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
