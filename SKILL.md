---
name: app-store-release
description: "Prepare, audit, package, upload, and submit apps to Apple App Store Connect or Microsoft Partner Center. Use for macOS/iOS App Store and Windows Microsoft Store readiness, signing, package validation, listings, privacy and policy declarations, test credentials, certification submission, staged release, or rejection remediation."
---

# App Store Release

Ship Apple and Microsoft Store apps with reproducible evidence. Treat code readiness, package creation, upload, processing, certification submission, approval, rollout, and public availability as separate states.

## Route the task

- For macOS, iOS, App Store Connect, TestFlight, `.pkg`, `.ipa`, Xcode signing, or Apple review, read [apple-app-store.md](references/apple-app-store.md).
- For Windows, Microsoft Store, Partner Center, `.msix`, `.msixbundle`, `.appx`, WACK, package flights, or Microsoft certification, read [microsoft-store.md](references/microsoft-store.md).
- For a full readiness or submission audit, also read [checklist.md](references/checklist.md).
- If a product ships in both stores, audit each channel independently. A build that is compliant in one store is not evidence for the other.

## Shared operating rules

- Inspect the repository, target-specific release configuration, store record, existing scripts, and current certification state before changing anything.
- Keep API keys, Apple IDs, Microsoft accounts, app-specific passwords, certificates, signing keys, and test-account passwords outside the repository. Never print their contents.
- Prefer deterministic CLI or API checks. Use store websites only where APIs are unavailable, for account-bound declarations, or for final submission.
- Do not infer legal or policy declarations. Privacy, export-control, content rights, age rating, trader status, commerce, and data-safety answers must follow verified product behavior or an explicit user choice.
- Treat distribution channels as compile-time trust boundaries. Store builds must not accidentally inherit direct-download, self-update, executable hot-update, licensing, or telemetry behavior intended for website builds.
- Use real app UI for screenshots and reviewer evidence, but remove personal bookmarks, history, accounts, internal URLs, email addresses, names, company-only data, and production secrets.
- Uploading a package is not authorization to submit it for certification. Obtain explicit authorization immediately before the final submission action. Approval is not authorization for automatic public release unless the user requested it.
- Verify every mutation by reading the resulting store state back. A successful click, HTTP response, upload command, or CI exit code alone is not completion.

## Shared workflow

1. Discover the target store, product identity, current release state, commercial model, and intended release mode.
2. Audit code and runtime behavior for that store channel, including permissions, privacy, updater behavior, authentication, review access, and package identity.
3. Build the exact store artifact from a clean checkout or reproducible CI job. Record the commit, version, build, artifact hash, and build log.
4. Validate the final artifact, not only source configuration. Inspect package metadata, signature expectations, capabilities or entitlements, embedded resources, and forbidden production markers.
5. Complete listing metadata and reviewer access. Use a demo-only account when login is required; verify it immediately before submission without disclosing the password.
6. Upload and wait for package processing. Read back the exact version/build and attach the processed package to the intended submission.
7. Resolve blocking warnings and present the final package, listing, declarations, release mode, and known risks to the user.
8. Submit only after explicit authorization. Then read back the exact certification state and record the submission evidence without credentials.
9. After approval, verify the public listing, install path, first launch, login, update behavior, and rollback or halt controls appropriate to that store.

## Evidence standard

A release report should distinguish:

- **Verified:** observed in source, package, CI, store API, or store UI in the current run.
- **Prepared:** ready locally but not yet uploaded or submitted.
- **Submitted:** the store shows the exact version/build in review.
- **Approved:** certification passed but rollout may not have started.
- **Public:** the public listing installs the intended build.
- **Blocked:** a concrete missing agreement, declaration, package requirement, permission, or reviewer action.

Record version/build, package hash, store product ID, submission time, release mode, certification state, URLs, and remaining reviewer risks in the project release notes or project memory. Never record credentials.
