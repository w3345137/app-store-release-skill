#!/bin/bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: check-screenshot.sh <image> [image ...]" >&2
  exit 2
fi

for image_path in "$@"; do
  [[ -f "$image_path" ]] || { echo "missing image: $image_path" >&2; exit 3; }

  width=$(sips -g pixelWidth "$image_path" 2>/dev/null | awk '/pixelWidth/ {print $2}')
  height=$(sips -g pixelHeight "$image_path" 2>/dev/null | awk '/pixelHeight/ {print $2}')

  case "${width}x${height}" in
    1280x800|1440x900|2560x1600|2880x1800) ;;
    *)
      echo "unsupported Mac App Store screenshot size: ${width}x${height} $image_path" >&2
      exit 4
      ;;
  esac

  echo "valid Mac App Store screenshot: ${width}x${height} $image_path"
done
