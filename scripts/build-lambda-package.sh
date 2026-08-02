#!/usr/bin/env bash
# Invoked by Terraform's `external` data source (see data.external.lambda_build
# in main.tf) to build one Lambda's dependency-bundled zip and report its hash,
# automatically as part of `terraform plan`/`apply` — no separate build step.
#
# Only re-runs pip install/zip when the source tree actually changed (cached via
# a hash file), since external data sources are re-invoked on every plan/apply.
set -euo pipefail

# The `external` data source protocol pipes a JSON query object on stdin; we
# don't use it, but must still consume it.
cat >/dev/null || true

MODULE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAME="$1" # orchestrator | worker | notifier

SRC_DIR="$MODULE_ROOT/src/$NAME"
BUILD_DIR="$MODULE_ROOT/.build/$NAME"
ZIP_PATH="$MODULE_ROOT/.build/$NAME.zip"
SRC_HASH_CACHE="$MODULE_ROOT/.build/$NAME.srchash"

mkdir -p "$MODULE_ROOT/.build"

# Content hash over every source file's path+bytes (excluding local dev caches,
# which are gitignored and would otherwise cause spurious rebuilds).
SRC_HASH=$(
  find "$SRC_DIR" -type f ! -path '*/__pycache__/*' ! -name '*.pyc' -print0 |
    sort -z |
    xargs -0 shasum -a 256 |
    shasum -a 256 |
    awk '{print $1}'
)

if [[ ! -f "$ZIP_PATH" || ! -f "$SRC_HASH_CACHE" || "$(cat "$SRC_HASH_CACHE")" != "$SRC_HASH" ]]; then
  rm -rf "$BUILD_DIR"
  pip3 install --quiet \
    --platform manylinux2014_x86_64 \
    --python-version 3.13 \
    --implementation cp \
    --only-binary=:all: \
    --target "$BUILD_DIR" "$SRC_DIR" >&2
  rm -f "$ZIP_PATH"
  (cd "$BUILD_DIR" && zip -qr "$ZIP_PATH" .)
  echo "$SRC_HASH" >"$SRC_HASH_CACHE"
fi

ZIP_HASH=$(openssl dgst -sha256 -binary "$ZIP_PATH" | base64)
printf '{"hash":"%s"}\n' "$ZIP_HASH"
