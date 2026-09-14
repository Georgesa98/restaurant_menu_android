#!/usr/bin/env bash
# Build one sideloadable APK per tenant with the tenant id baked in.
# Usage: tool/build_tenant.sh <slug> [TENANT_ID] [TENANT_NAME] [MENU_API_URL]
#   slug        : tenants/<slug>/ asset folder
#   TENANT_ID   : web Tenant.id uuid (may be empty; resolved by slug on first pull)
#   TENANT_NAME : display name fallback
#   MENU_API_URL: server base url (defaults to production)
# NOTE: explicit --dart-define values win over any bundled dev `.env`
# (see TenantConfig), so release builds are unaffected by local .env files.
# KNOWN LIMIT (docs/PLAN.md §22): single applicationId for all tenants
# (no flavors yet) — one tenant per device. Don't add per-slug suffixes
# here without adding productFlavors in android/app/build.gradle.kts.
set -euo pipefail

SLUG="${1:?usage: tool/build_tenant.sh <slug> [TENANT_ID] [TENANT_NAME] [MENU_API_URL]}"
TENANT_ID="${2:-}"
TENANT_NAME="${3:-$SLUG}"
MENU_API_URL="${4:-https://menu.georgesalebe.me}"

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
  --dart-define="MENU_API_URL=$MENU_API_URL" \
  --target-platform android-arm64

cp build/app/outputs/flutter-apk/app-release.apk "$OUT"
echo "wrote $OUT"
