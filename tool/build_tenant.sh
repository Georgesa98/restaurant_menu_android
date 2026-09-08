#!/usr/bin/env bash
# Build one sideloadable APK per tenant with the tenant id baked in.
# Usage: tool/build_tenant.sh <slug> [TENANT_ID] [TENANT_NAME]
#   slug        : tenants/<slug>/ asset folder + applicationId suffix
#   TENANT_ID   : web Tenant.id uuid (may be empty; resolved by slug on first pull)
#   TENANT_NAME : display name fallback
set -euo pipefail

SLUG="${1:?usage: tool/build_tenant.sh <slug> [TENANT_ID] [TENANT_NAME]}"
TENANT_ID="${2:-}"
TENANT_NAME="${3:-$SLUG}"

if [ ! -f "assets/tenants/$SLUG/theme.json" ]; then
  echo "missing assets/tenants/$SLUG/theme.json" >&2
  exit 1
fi

OUT="build/$SLUG/app-release.apk"
mkdir -p "build/$SLUG"

flutter build apk --release \
  --dart-define="TENANT_SLUG=$SLUG" \
  --dart-define="TENANT_ID=$TENANT_ID" \
  --dart-define="TENANT_NAME=$TENANT_NAME" \
  --target-platform android-arm64

cp build/app/outputs/flutter-apk/app-release.apk "$OUT"
echo "wrote $OUT"
