#!/bin/bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "usage: asc-package.sh <validate|upload> <pkg-or-ipa> [macos|ios|appletvos|visionos]" >&2
  echo "       asc-package.sh status <delivery-id>" >&2
  exit 2
fi

action=$1
subject=$2
: "${ASC_KEY_ID:?set ASC_KEY_ID without committing it}"
: "${ASC_ISSUER_ID:?set ASC_ISSUER_ID without committing it}"

case "$action" in
  validate) verb=--validate-app ;;
  upload) verb=--upload-app ;;
  status)
    [[ $# -eq 2 ]] || { echo "status does not accept a platform" >&2; exit 2; }
    exec xcrun altool --build-status \
      --delivery-id "$subject" \
      --wait \
      --output-format json \
      --apiKey "$ASC_KEY_ID" \
      --apiIssuer "$ASC_ISSUER_ID"
    ;;
  *) echo "unsupported action: $action" >&2; exit 2 ;;
esac

package_path=$subject
[[ -f "$package_path" ]] || { echo "missing package: $package_path" >&2; exit 3; }
if [[ $# -eq 3 ]]; then
  platform=$3
else
  case "${package_path##*.}" in
    ipa) platform=ios ;;
    pkg) platform=macos ;;
    *) echo "cannot infer platform from package extension; pass it explicitly" >&2; exit 2 ;;
  esac
fi
case "$platform" in
  macos|ios|appletvos|visionos) ;;
  *) echo "unsupported platform: $platform" >&2; exit 2 ;;
esac

xcrun altool "$verb" \
  --file "$package_path" \
  --type "$platform" \
  --apiKey "$ASC_KEY_ID" \
  --apiIssuer "$ASC_ISSUER_ID"
