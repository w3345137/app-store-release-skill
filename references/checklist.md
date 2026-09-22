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

- Name, subtitle, description, keywords, category, age rating, support URL, marketing URL, and privacy URL are complete.
- Screenshots use accepted dimensions and show real, current UI without private data. Inspect tab titles, pinned tabs, bookmarks, address text, page content, menus, notifications, menu bar, Dock, and background windows.
- Review contact and notes are current; demo credentials are provided only when required.
- Content-rights declaration matches embedded or catalogued third-party content.

## Commerce and legal

- Free or paid price is configured.
- Countries/regions and distribution method are configured.
- Required agreements are active; tax and banking are complete if paid.
- DSA trader status is explicitly confirmed for EU distribution.
- Export compliance is answered from the shipped binary, not by guesswork.
- Privacy answers match code, dependencies, and network behavior.

## Submission evidence

- Uploaded build is processed and attached to the intended version.
- Metadata save succeeds and survives reload.
- Release mode is intentional: manual, automatic, or phased as supported.
- Submission confirmation is followed by an App Review page readback for the exact version/build.
- Final state is `WAITING_FOR_REVIEW` or later, captured by API or UI readback.
