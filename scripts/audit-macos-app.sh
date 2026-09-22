#!/bin/bash
set -euo pipefail

repo_path=${1:-.}
scheme=${2:-}
configuration=${3:-Release}
cd "$repo_path"

project=$(find . -maxdepth 3 -name '*.xcodeproj' -print -quit)
workspace=$(find . -maxdepth 2 -name '*.xcworkspace' -not -path '*.xcodeproj/*' -print -quit)
if [[ -z "$project" && -z "$workspace" ]]; then
  echo "no Xcode project or workspace found" >&2
  exit 3
fi

echo "repository: $(pwd)"
[[ -n "$project" ]] && echo "project: $project"
[[ -n "$workspace" ]] && echo "workspace: $workspace"
echo "configuration: $configuration"

if [[ -z "$scheme" ]]; then
  if [[ -n "$workspace" ]]; then
    xcodebuild -list -workspace "$workspace"
  else
    xcodebuild -list -project "$project"
  fi
  echo "rerun with a scheme to inspect resolved Release settings"
  exit 0
fi

args=(-scheme "$scheme" -configuration "$configuration" -showBuildSettings)
[[ -n "$workspace" ]] && args=(-workspace "$workspace" "${args[@]}") || args=(-project "$project" "${args[@]}")

xcodebuild "${args[@]}" | awk -F' = ' '
  /PRODUCT_BUNDLE_IDENTIFIER|MARKETING_VERSION|CURRENT_PROJECT_VERSION|MACOSX_DEPLOYMENT_TARGET|DEVELOPMENT_TEAM|CODE_SIGN_STYLE|CODE_SIGN_IDENTITY|PRODUCT_NAME|INFOPLIST_FILE|CODE_SIGN_ENTITLEMENTS/ {print}
'

echo "privacy manifests:"
find . -name PrivacyInfo.xcprivacy -not -path '*/.build/*' -not -path '*/DerivedData/*' -print
echo "entitlement files:"
find . -name '*.entitlements' -not -path '*/.build/*' -not -path '*/DerivedData/*' -print
