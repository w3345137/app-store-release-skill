#!/bin/bash
set -euo pipefail

platform="auto"
if [[ "${1:-}" == "--platform" ]]; then
  [[ $# -ge 3 ]] || {
    echo "usage: check-screenshot.sh [--platform auto|ios|iphone|ipad|macos|tvos|visionos|watchos] <image> [image ...]" >&2
    exit 2
  }
  platform="$2"
  shift 2
fi

case "$platform" in
  auto|ios|iphone|ipad|macos|tvos|visionos|watchos) ;;
  *) echo "unsupported platform: $platform" >&2; exit 2 ;;
esac

[[ $# -ge 1 ]] || {
  echo "usage: check-screenshot.sh [--platform auto|ios|iphone|ipad|macos|tvos|visionos|watchos] <image> [image ...]" >&2
  exit 2
}

python3 - "$platform" "$@" <<'PY'
import struct
import sys
from pathlib import Path

platform = sys.argv[1]
paths = [Path(value) for value in sys.argv[2:]]

def png_info(data: bytes):
    if not data.startswith(b"\x89PNG\r\n\x1a\n") or len(data) < 33:
        raise ValueError("invalid PNG")
    width, height, _, color_type, _, _, _ = struct.unpack(">IIBBBBB", data[16:29])
    has_alpha = color_type in (4, 6) or b"tRNS" in data
    return width, height, has_alpha

def jpeg_info(data: bytes):
    if not data.startswith(b"\xff\xd8"):
        raise ValueError("invalid JPEG")
    offset = 2
    sof = {0xC0, 0xC1, 0xC2, 0xC3, 0xC5, 0xC6, 0xC7, 0xC9, 0xCA, 0xCB, 0xCD, 0xCE, 0xCF}
    while offset + 4 <= len(data):
        while offset < len(data) and data[offset] != 0xFF:
            offset += 1
        while offset < len(data) and data[offset] == 0xFF:
            offset += 1
        if offset >= len(data):
            break
        marker = data[offset]
        offset += 1
        if marker in (0xD8, 0xD9) or 0xD0 <= marker <= 0xD7:
            continue
        if offset + 2 > len(data):
            break
        length = struct.unpack(">H", data[offset:offset + 2])[0]
        if length < 2 or offset + length > len(data):
            break
        if marker in sof:
            if length < 7:
                break
            height, width = struct.unpack(">HH", data[offset + 3:offset + 7])
            return width, height, False
        offset += length
    raise ValueError("JPEG dimensions not found")

def image_info(path: Path):
    suffix = path.suffix.lower()
    if suffix not in {".png", ".jpg", ".jpeg"}:
        raise ValueError("format must be PNG or JPEG")
    data = path.read_bytes()
    return png_info(data) if suffix == ".png" else jpeg_info(data)

def orientations(values):
    result = set(values)
    result.update((height, width) for width, height in values)
    return result

# Apple App Store Connect screenshot specifications, checked 2026-09-23.
sizes = {
    "iphone": orientations({
        (1260, 2736), (1290, 2796), (1320, 2868),
        (1284, 2778), (1242, 2688),
        (1179, 2556), (1206, 2622),
        (1170, 2532), (1125, 2436), (1080, 2340),
        (1242, 2208), (750, 1334),
        (640, 1096), (640, 1136), (640, 920), (640, 960),
    }),
    "ipad": orientations({
        (2064, 2752), (2048, 2732),
        (1488, 2266), (1668, 2420), (1668, 2388), (1640, 2360),
        (1668, 2224),
        (1536, 2008), (1536, 2048), (768, 1004), (768, 1024),
    }),
    "macos": {(1280, 800), (1440, 900), (2560, 1600), (2880, 1800)},
    "tvos": {(1920, 1080), (3840, 2160)},
    "visionos": {(3840, 2160)},
    "watchos": {
        (422, 514), (410, 502), (416, 496),
        (396, 484), (368, 448), (312, 390),
    },
}

requested = {"iphone", "ipad"} if platform == "ios" else ({platform} if platform != "auto" else set(sizes))

failed = False
for path in paths:
    if not path.is_file():
        print(f"missing image: {path}", file=sys.stderr)
        failed = True
        continue
    try:
        width, height, has_alpha = image_info(path)
    except ValueError as error:
        print(f"invalid screenshot: {error}: {path}", file=sys.stderr)
        failed = True
        continue
    if has_alpha:
        print(f"invalid screenshot: alpha/transparency is not allowed: {width}x{height} {path}", file=sys.stderr)
        failed = True
        continue
    matches = [name for name in sorted(requested) if (width, height) in sizes[name]]
    if not matches:
        print(f"unsupported {platform} App Store screenshot size: {width}x{height} {path}", file=sys.stderr)
        failed = True
        continue
    print(f"valid App Store screenshot ({'/'.join(matches)}): {width}x{height} {path}")

sys.exit(1 if failed else 0)
PY
