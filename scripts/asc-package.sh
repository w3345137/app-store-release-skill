#!/bin/bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: asc-package.sh <validate|upload> <pkg>" >&2
  exit 2
fi

action=$1
package_path=$2
[[ -f "$package_path" ]] || { echo "missing package: $package_path" >&2; exit 3; }
: "${ASC_KEY_ID:?set ASC_KEY_ID without committing it}"
: "${ASC_ISSUER_ID:?set ASC_ISSUER_ID without committing it}"

case "$action" in
  validate) verb=--validate-app ;;
  upload) verb=--upload-app ;;
  *) echo "unsupported action: $action" >&2; exit 2 ;;
esac

xcrun altool "$verb" \
  --file "$package_path" \
  --type macos \
  --apiKey "$ASC_KEY_ID" \
  --apiIssuer "$ASC_ISSUER_ID"
