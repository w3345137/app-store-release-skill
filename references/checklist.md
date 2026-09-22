# Mac App Store submission checklist

## Binary

- Release scheme archives without warnings that affect signing or runtime.
- Bundle ID matches the App Store Connect record.
- Marketing version and build are unique and intentional.
- `LSApplicationCategoryType`, minimum macOS version, app icon, copyright, and executable name are correct.
- App Sandbox and hardened runtime are enabled; entitlements are minimal and justified.
- `ITSAppUsesNonExemptEncryption` matches actual cryptography use.
- Privacy manifest and every protected-resource usage description match runtime behavior.
- Archive signature, nested code, and provisioning are valid.

## Product page

- For a newly created app, name, platform, primary locale, Bundle ID, SKU, access scope, and Apple ID are read back after creation.
- The App Store version string matches the uploaded build's `CFBundleShortVersionString`; do not assume the default `1.0` matches a prerelease build.
- Name, subtitle, description, keywords, category, age rating, support URL, marketing URL, and privacy URL are complete.
- Screenshots use accepted dimensions and show real, current UI without private data. Inspect tab titles, pinned tabs, bookmarks, address text, page content, menus, notifications, menu bar, Dock, and background windows.
- Screenshot families cover every advertised device class. Resolve `TARGETED_DEVICE_FAMILY` and platform support first; an iPhone+iPad app needs accepted assets for both device classes unless App Store Connect explicitly says otherwise.
- Review contact and notes are current; demo credentials are provided only when required.
- Content-rights declaration matches embedded or catalogued third-party content.

## Commerce and legal

- Free or paid price is configured.
- The commercial model in code, product-page copy, review notes, and website agrees: free companion, separately paid download, or StoreKit purchase.
- For a separately paid download, the Paid Apps Agreement is active and required tax and banking information is complete. The app does not add a redundant StoreKit paywall.
- Countries/regions and distribution method are configured.
- China mainland is included or excluded from actual compliance evidence. If App Store Connect reports a missing ICP filing number or another permit, record that exact blocker; do not exclude the storefront merely because the app is paid.
- Required agreements are active; tax and banking are complete if paid.
- The account holder personally accepted any new legal agreement; automation only verified its resulting active state.
- DSA trader status is explicitly confirmed for EU distribution.
- Export compliance is answered from the shipped binary, not by guesswork.
- Privacy answers match code, dependencies, and network behavior.
- For website-sold Mac licenses, payment completion, duplicate webhook delivery, early renewal, browser-close recovery, cross-device recovery, refund/chargeback state, and application activation are tested end to end. Recovery credentials are not placed in URL paths or server access logs, and any stored buyer identifier is minimized and disclosed.

## Submission evidence

- Upload output and delivery ID are retained without storing credentials.
- Delivery processing reaches a terminal success state before the build is treated as available in App Store Connect.
- Uploaded build is processed and attached to the intended version.
- If replacing a submission already in review, the replacement build and commerce setup were ready before the previous submission was removed.
- Metadata save succeeds and survives reload.
- Release mode is intentional: manual, automatic, or phased as supported.
- Submission confirmation is followed by an App Review page readback for the exact version/build.
- Final state is `WAITING_FOR_REVIEW` or later, captured by API or UI readback.
