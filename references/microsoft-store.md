# Microsoft Store release

Use this reference for Windows, Microsoft Partner Center, MSIX-family packaging, package flights, WACK, and Microsoft certification.

## Discover and audit

- Record Partner Center product ID, Store identity name, publisher subject, package family name, version, architecture, minimum Windows version, capabilities, application entry point, and intended markets.
- Inspect the dedicated Store build configuration rather than assuming the direct-download Windows build is compliant.
- Verify package identity values against Partner Center before building. Identity name and publisher must match exactly; package versions use four numeric components.
- Inspect login, first launch, offline behavior, WebView2/runtime dependencies, protocol handlers, file associations, notifications, background tasks, elevated capabilities, and `runFullTrust` justification.
- Treat login-required apps as reviewer-access tasks. Provide a demo-only account with stable sample data and verify the credentials immediately before submission.

## Store distribution boundary

- Microsoft Store builds must not expose links or UI that download installers, executables, scripts, packages, or other code for the same or other apps.
- Disable native self-updaters and executable frontend/code hot-update channels at compile time. Microsoft Store must be the package update authority.
- A remote web service may deliver ordinary user data and server-rendered content. If downloaded resources can replace executable app logic, treat them as code update and remove them from the Store channel.
- Keep website/direct-download features in a separate distribution channel. Hiding them only with runtime CSS, remote flags, or reviewer-only conditions is insufficient.
- Inspect the final packaged executable/resources for updater endpoints, installer URLs, download labels, and direct-download configuration. Source review alone is not evidence.

## Package validation

- Build from a clean checkout or reproducible CI workflow and retain commit, version, build log, artifact hash, and toolchain versions.
- Run the Windows App Certification Kit on the exact package when available. Record warnings separately from failures and verify runtime launch on a clean supported Windows environment.
- Run `scripts/audit-windows-store-app.ps1 -Repo <path> -Package <msix>` for source and package inspection.
- Run `scripts/verify-msix.ps1 -Package <msix> -ExpectedName <identity> -ExpectedPublisher <publisher>` on Windows. Add `-ForbiddenString` values for product-specific updater URLs or markers.
- Verify manifest identity, publisher, four-part version, architecture, minimum OS, capabilities, visual assets, execution alias or protocol declarations, and package contents.
- For restricted capabilities such as `runFullTrust`, document why the app requires them and ensure listing/reviewer notes agree with runtime behavior.
- Sign local install/smoke artifacts only with controlled test certificates. Do not confuse a local test signature with Store ingestion or Store signing.

## Partner Center listing

- Complete description, short description, search terms, categories, system requirements, privacy-policy URL, support contact, age ratings, market availability, pricing, screenshots, and release notes.
- Use screenshots from the current Store build and inspect them for private data, direct-download buttons, obsolete versions, or unsupported claims.
- Review product declarations, permissions/capabilities, data handling, cryptography, third-party content, accessibility claims, and commerce behavior against the shipped package.
- In certification notes, give deterministic steps to reach important features, explain unusual capabilities, and state that the Store channel has no in-app installer downloads or self-updater when relevant.

## Upload, certification, and rollout

- Upload the exact verified package and wait for package analysis to finish. Read back identity, version, architecture, and validation results.
- Recheck package selection, listing, declarations, reviewer credentials, certification notes, markets, visibility, and release schedule before submission.
- For a rejection, map each policy citation to a concrete source/package/runtime change. Build a new version when package behavior changed; metadata-only resubmission is insufficient for binary issues.
- Submit only after explicit authorization. Verify the exact submission shows `In certification` or its current localized equivalent.
- After approval, verify public listing and install from Microsoft Store. Test first launch, login, data persistence, Store-managed update, and uninstall/reinstall behavior.
- For gradual exposure, use Partner Center rollout controls or package flights when supported. Do not reintroduce an in-app updater to simulate phased rollout.

## Common blockers

- Package identity or publisher differs from the Partner Center reservation.
- Version is not a valid increasing four-part package version.
- Final package contains self-update endpoints, installer downloads, or executable hot-update code that the source-level UI appears to hide.
- Required visual assets are missing or invalid.
- Restricted capabilities lack a clear functional justification.
- Reviewer cannot sign in, reaches production-only/private data, or cannot reproduce the described feature path.
- Package analysis succeeded but certification was never submitted. Upload, package acceptance, certification, approval, and public availability remain distinct states.
