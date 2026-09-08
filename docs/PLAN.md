# Restaurant Menu Android — Full Plan (v1)

> Flutter kiosk + admin app for restaurants. Backed by Next.js + Postgres (Prisma).
> One sideloaded APK per tenant, tenant-id baked at build time, offline-first with periodic two-way sync.

Current shell: `pubspec.yaml`, `lib/main.dart` (Hello World). Nothing to migrate.

## 1. Locked decisions

- **Packaging:** one APK per tenant, `TENANT_SLUG` / `TENANT_ID` baked via `--dart-define` + `assets/tenants/<slug>/`.
- **Sync direction:** two-way (tablet edits push, web edits pull).
- **Backend API:** does not exist yet — design with Next.js side.
- **Auth:** first admin login online via better-auth, then cache session/token locally for offline admin.
- **Theme:** hybrid controlled theming only — baked fallback + pulled override stored locally (see §5). `customCss` deprecated/removed, never applied.
- **Sync rhythm:** 15-min periodic pull (silent) + push-on-save + manual "Sync now" button in admin + pull-on-boot.
- **Device:** customer-facing kiosk tablet, rotation locked (landscape-first), no dayparting in v1.
- **Language:** user-toggleable AR (default) / EN, RTL when AR. `name`/`label` = canonical AR, EN in `*_translations`/`labelEn`. Numbers always Latin digits (`NumberFormat('en')`), never Arabic-Indic.
- **Variants:** single-select pills, price updates on select, `basePrice` hidden when variants exist.
- **Tenant bake:** `TENANT_SLUG` baked (readable, stable); resolve `Tenant.id` uuid on first pull.
- **Dietary tags:** fixed enum (values TBD — proposal: `vegan, vegetarian, spicy, gluten_free, nuts`; AR labels in app).
- **Fonts:** map web `headingFont/bodyFont` → bundled `Cairo` + `Inter`; ignore `customCss/shadow` v1.
- **Layout:** web defaults confirmed — `menuLayout single` = list, `cardStyle elevated` = elevated cards, `spacing comfortable` = comfy padding.
- **Images:** host already exists (details TBD — need base URL + max size). Compress client-side before upload.
- **Price:** customer sees `basePrice`, or min-variant "from" price when variants exist.
- **Session:** web password change invalidates sessions → tablet forces online re-login on next 401.
- **Images:** in v1. `MenuItem.imageUrl` + `Tenant.logoUrl/coverUrl`.
- **"Credits":** admin username/email + password login.
- **Distribution:** manual sideload per restaurant.

## 2. Source of truth: real Prisma schema

Supersedes the old drizzle sqlite sketch.

- `User(id uuid, name, email unique, tenantId?, role default TENANT_ADMIN)` + `Session` / `Account` / `Verification` / `TwoFactor` (better-auth).
- `Tenant(id uuid, name, slug unique, domain unique, plan FREE|STARTER|PRO, isActive, ...tokens, logoUrl, coverUrl, description, address, phone, instagram, website, defaultLocale default "en", availableLocales default ["en"], categories[], items[])`.
- Design tokens on `Tenant` (controlled theming only — `customCss` deprecated, never read by app): `primaryColor #e74c3c`, `secondaryColor #2c3e50`, `accentColor #f39c12`, `backgroundColor #fdf5e6`, `surfaceColor #ffffff`, `textColor #1a1a2e`, `textMuted #64748b`, `headingFont`, `bodyFont`, `borderRadiusSm 4px`, `borderRadiusMd 8px`, `borderRadiusLg 16px`, `shadow`, `cardStyle elevated`, `menuLayout single`, `spacing comfortable`. Web will drop `customCss` entirely; app ignores it even if present.
- `Category(id uuid, tenantId, name, slug, description?, displayOrder 0, isActive true, createdAt, updatedAt)` + `@@unique([tenantId, slug])`.
- `MenuItem(id uuid, tenantId, categoryId, name, description?, basePrice Decimal(10,2)?, imageUrl?, isAvailable true, displayOrder 0, dietaryTags String[], createdAt, updatedAt)` + `@@index([tenantId, categoryId])`.
- `MenuItemVariant(id uuid, menuItemId, label AR, labelEn EN, price Decimal(10,2), sortOrder 0)`.
- `CategoryTranslation(categoryId, locale, name, description?)` + `@@unique([categoryId, locale])`.
- `MenuItemTranslation(menuItemId, locale, name, description?)` + `@@unique([menuItemId, locale])`.

Implications:

- No `settings` KV or `admin_password` table — config lives on `Tenant`, auth lives in better-auth.
- Price rule: if `variants > 0`, `basePrice` ignored/null; else `basePrice` required.
- Display order: `displayOrder` / `sortOrder`, not `order`.
- Visibility: `Category.isActive` + `MenuItem.isAvailable` (kiosk filters both).
- Slugs are per-tenant unique — tablet must generate collision-safe slugs offline.

## 3. Stack (add to `pubspec.yaml`)

```yaml
drift + sqlite3_flutter_libs  # type-safe local DB, closest to Prisma
flutter_riverpod              # state
go_router                     # / , /admin/login, /admin/*
dio                           # API + X-Tenant-Id interceptor
cached_network_image          # dish/logo/cover + disk cache for offline kiosk
flutter_secure_storage        # session token cache
shared_preferences            # lastPullAt, locale, polling interval
intl + flutter_localizations  # ar/en
connectivity_plus + workmanager
wakelock_plus (+ window_manager if needed)  # kiosk no-sleep, immersive
uuid                          # v4 ids offline
```

Fonts to bundle: `Cairo` or `IBM Plex Sans Arabic` (AR) + `Inter` (EN). Web `headingFont/bodyFont` strings map to these (see §5).

## 4. Local SQLite (drift) — cache of Postgres

Mirror server + add sync columns. `updatedAt` from server is conflict basis. `dirty`/`isDeleted` only needed where tablet edits.

```text
tenants(
  id TEXT PK, name, slug, plan, isActive INTEGER,
  primaryColor, secondaryColor, accentColor, backgroundColor,
  surfaceColor, textColor, textMuted,
  headingFont, bodyFont,
  borderRadiusSm, borderRadiusMd, borderRadiusLg,
  shadow, cardStyle, menuLayout, spacing,   -- no customCss: deprecated, never stored
  logoUrl?, coverUrl?, description?, address?, phone?,
  instagram?, website?,
  defaultLocale, availableLocalesCsv,   -- "ar,en"
  lastSyncAt TEXT?
)
-- single row per APK (our tenant), see §5

categories(
  id TEXT PK, tenantId, name, slug, description?,
  displayOrder INTEGER, isActive INTEGER,
  updatedAt TEXT, isDeleted INTEGER DEFAULT 0, dirty INTEGER DEFAULT 0
)

category_translations(
  categoryId, locale, name, description?,
  PK(categoryId, locale), dirty INTEGER DEFAULT 0
)

menu_items(
  id TEXT PK, tenantId, categoryId, name, description?,
  basePrice REAL?, imageUrl?,
  isAvailable INTEGER, displayOrder INTEGER,
  dietaryTagsCsv TEXT,                   -- join("|")
  updatedAt TEXT, isDeleted INTEGER DEFAULT 0, dirty INTEGER DEFAULT 0
)

menu_item_translations(
  menuItemId, locale, name, description?,
  PK(menuItemId, locale), dirty INTEGER DEFAULT 0
)

menu_item_variants(
  id TEXT PK, menuItemId, label, labelEn, price REAL, sortOrder INTEGER,
  isDeleted INTEGER DEFAULT 0, dirty INTEGER DEFAULT 0
)

device_auth(
  id INTEGER PK CHECK (id = 1),
  userId?, tenantId, email?,
  sessionToken?, tokenExpiresAt TEXT?,
  createdAt TEXT
)

sync_state(
  id INTEGER PK CHECK (id = 1),
  lastPullAt TEXT?, lastPushAt TEXT?, pendingCount INTEGER DEFAULT 0
)
```

Notes:

- UUIDs (`uuid()` on server, v4 on client) — safe to create offline.
- `Category.slug`: `slugify(name)-shortid` client-side; server enforces `@@unique([tenantId, slug])`, tablet must handle 409 → regenerate.
- Kiosk query: `WHERE isActive=1 AND isDeleted=0 ORDER BY displayOrder, name`; items `WHERE isAvailable=1 AND isDeleted=0 ORDER BY displayOrder, name`.
- Admin sees all + toggles.
- `dietaryTags`: store CSV locally; allowed values defined by backend (e.g. `vegan,vegetarian,spicy,gluten_free`) — AR labels in app.

## 5. Tenant baking + theme storage (yes, we store it)

> Q: "if theme is pulled from db we need to store them, correctly right?"
> A: Yes. Otherwise kiosk blanks offline and every color change needs a rebuild.

### 5.1 Bake (fallback, compiled in)

- Build: `tool/build_tenant.sh <slug>` → `--dart-define=TENANT_SLUG=<slug> --dart-define=TENANT_ID=<uuid> --dart-define=TENANT_NAME=...`.
- Per-tenant assets: `assets/tenants/<slug>/theme.json + logo.png + cover.png` → also sets `applicationId` (`com.yourco.menu.<slug>`), app name, icon.
- `lib/core/config/tenant_config.dart` loads defines + fallback `theme.json`. If API unreachable on first boot, app still brands correctly.
- Keep `assets/tenants/demo/` for dev.

### 5.2 Pull + store (override)

- Every sync `GET /sync/pull` returns `tenant` object → upsert into local `tenants` single row + `lastSyncAt=serverTime`.
- `logoUrl/coverUrl` downloaded + disk-cached (prefetch on pull). Kiosk never depends on network for paint.
- App watches `tenants` row (Riverpod Stream) → rebuilds `ThemeData`.

### 5.3 Token → Flutter mapping

| Web token | Flutter |
|---|---|
| `primaryColor/secondaryColor/accentColor/backgroundColor/surfaceColor/textColor/textMuted` (`#rrggbb`) | `ColorScheme` + `ScaffoldBackgroundColor`; parse hex, fallback to baked on parse fail |
| `borderRadiusSm/Md/Lg` (`"4px"`) | `double` via `parsePx()` → `RoundedRectangleBorder` / `CardTheme` |
| `headingFont/bodyFont` (`"Georgia, serif"`) | name-match → bundled `Cairo` / `Inter`; unknown → default |
| `cardStyle` (`elevated`) | `elevated` / `outlined` / `filled` presets |
| `menuLayout` (`single`) | `single` (list) / `grid` presets |
| `spacing` (`comfortable`) | `compact` / `comfortable` density + padding scale |
| `shadow` | v1: map to 1 preset elevation; no free-form shadows |
| `customCss` | **Removed by policy.** App never reads/parses/applies it. Web to drop column. Pull parser allowlists only controlled tokens above and drops anything else. |
| `logoUrl/coverUrl` | header + splash; cached; placeholder if null |

> Policy (2026-09-07): controlled theming only. No WebView, no CSS injection, no free-form style strings from server. If web still sends `customCss`, app ignores it and logs `dropped_custom_css` in sync report.

No APK rebuild when owner rebrands on web — next poll applies it. Baked theme is only the offline-first-run safety net.

## 6. Next.js API to build

Auth reuses better-auth. Do not reintroduce hash-sync.

```text
POST /api/v1/device/login
  body: { slug|tenantId, email, password }
  → { user{id,email,tenantId,role}, session{token, expiresAt}, tenant }
  → tablet stores session in device_auth (secure storage)

GET /api/v1/sync/pull?since=ISO8601
  headers: X-Tenant-Id, (admin routes: Authorization: Bearer <session>)
  public kiosk read by slug allowed; full dump if no `since`
  → { serverTime, tenant, categories[], categoryTranslations[],
       items[], itemTranslations[], variants[], deletedIds[] }

POST /api/v1/sync/push
  headers: X-Tenant-Id + Bearer
  body: { baseSince, upserts:{categories[], categoryTranslations[],
          items[], itemTranslations[], variants[]},
          deletes:{categoryIds[], itemIds[], variantIds[]} }
  → { serverTime, accepted[], conflicts[] }  // conflicts = server newer

GET /api/v1/media/upload-url?contentType=image/jpeg
  → { uploadUrl, publicUrl }  // tablet PUTs bytes, then pushes publicUrl as imageUrl
```

Server rules:

- Scope every write by `tenantId` from session, ignore client `tenantId`.
- Validate `@@unique([tenantId, slug])`, `@@unique([categoryId, locale])`, `@@unique([menuItemId, locale])` → 409 with field error → tablet surfaces + regenerates slug if needed.
- `updatedAt` server-stamped on accept; echo back for tablet to clear `dirty`.
- `dietaryTags`, `plan`, `isActive` transitions validated server-side.

Needed from web repo to finalize: better-auth session expiry, `settings`-equivalent keys already on `Tenant`, current image host, slugify function to mirror.

## 7. Sync engine

Offline-first, periodic polling (default 5 min, per-tenant configurable) + push-on-save + manual refresh + pull-on-boot.

```text
pull():
  since = sync_state.lastPullAt
  res = GET /sync/pull?since
  db.transaction:
    upsert tenant
    upsert categories/items/variants/translations where res.updatedAt > local.updatedAt
    apply deletedIds as tombstones
    sync_state.lastPullAt = res.serverTime
  prefetch images (logo/cover/item thumbnails)

push():
  if offline → keep dirty=1, sync_state.pendingCount++
  else POST /sync/push { baseSince=lastPushAt, dirty rows }
  on accepted → clear dirty, update updatedAt=serverTime
  on conflicts[] → keep server copy, toast in admin "web changed X, kept newest"
  sync_state.lastPushAt = serverTime
```

- All writes via repository layer — UI never touches drift directly, so `dirty` can't be missed.
- Conflict v1: last-write-wins by `updatedAt`, server wins ties. No field-merge.
- UI: kiosk silent refresh (no flicker); admin screen shows `lastPullAt/lastPushAt`, pending count, Retry, offline banner.

## 8. Auth on device

- Same `User.email/password` (`role=TENANT_ADMIN`, `tenantId` must match baked tenant).
- First login requires internet → better-auth session → store `sessionToken + expiresAt` in `flutter_secure_storage` (`device_auth` row).
- Offline admin: allow if token cached and not expired (or grace period, e.g. 7 days); kiosk menu always works offline regardless.
- Password change on web invalidates sessions → tablet forces online re-login on next 401.
- Hidden admin entry (5-tap logo / long-press corner) → `/admin/login` → `/admin/*` guarded by Riverpod auth state. Logout clears token, keeps menu cache.

## 9. App structure

```text
lib/
  main.dart                     # TenantConfig → Drift DB → Dio → Riverpod → GoRouter
  core/
    config/tenant_config.dart   # defines + assets/tenants/<slug>/theme.json
    theme/theme_mapper.dart     # Tenant row → ThemeData (+ parsePx, parseHex)
    db/app_db.dart (drift)      # schema §4 + DAOs
    api/api_client.dart         # dio, X-Tenant-Id, auth interceptor, retry
    sync/sync_engine.dart       # pull/push, WorkManager timer
    kiosk/kiosk_lock.dart       # immersive, wakelock
  features/
    menu/                       # kiosk: cover/logo/name/address/phone, category rail, item cards
    admin/                      # login, dashboard, category/item/variant editors, reorder, toggles, image picker
    settings/                   # locale AR/EN toggle, polling interval, about, logout
  l10n/ ar.arb  en.arb
assets/tenants/<slug>/theme.json  logo.png  cover.png
tool/build_tenant.sh
```

Routes: `/` kiosk, `/admin/login`, `/admin/categories`, `/admin/items/:id`. Back button in kiosk requires PIN/exit guard.

Kiosk card: image (cached, placeholder), `name[locale]`, `desc[locale]`, price — `basePrice` or `"from {min(variants.price)}"` if variants, variant pills (single-select), `dietaryTags` chips. Filter unavailable. Search (AR/EN aware).

## 10. i18n / RTL

- `defaultLocale` should become `"ar"`, `availableLocales ["ar","en"]` (current default `["en"]` is wrong for this market — migrate seed).
- Canonical `Category.name / MenuItem.name / Variant.label` = Arabic; EN in `*_translations` / `labelEn`. Fallback to canonical if translation missing.
- `Directionality.rtl` when AR; layout mirrors, but numbers/prices always Latin digits via `NumberFormat('en')` (no Arabic-Indic digits per owner).
- Language toggle prominent in kiosk (AR/EN pill) + persists in `shared_preferences`.

## 11. Images (ratios locked 2026-09-07)

Demand this from restaurants — app center-crops anything else:

- **Dishes (`MenuItem.imageUrl`): 4:3 landscape — 1200×900 min, 1600×1200 max, ≤500KB, JPEG/WebP sRGB.** Why 4:3: best food framing in kiosk grid (2–3 cols landscape), no excessive vertical waste like 1:1, no aggressive crop like 16:9. Upload tolerance ±5%; outside that → reject with "must be 4:3" or auto center-crop.
- **Logo (`Tenant.logoUrl`): 1:1 square — 512×512 min, PNG transparent preferred, ≤300KB.** Used in header/splash/admin; circle/rounded mask applied by app.
- **Cover (`Tenant.coverUrl`): 16:9 wide — 1920×1080 max, ≤1MB, JPEG/WebP.** Kiosk header banner; safe-area: keep text/logos centered (edges crop on small tablets).

- Single `imageUrl` per item + `logoUrl/coverUrl` per tenant in v1 (no gallery).
- Upload: tablet picker (gallery/camera) → `GET upload-url` → PUT bytes → push `publicUrl`. Client compresses to above caps + strips EXIF. Server validates ratio + size + contentType.
- Cache: `cached_network_image` + prefetch after pull; branded placeholder + error widget. Offline kiosk serves disk cache only.

## 12. Kiosk hardening + sideload

- Immersive sticky, `wakelock`, landscape-first responsive (7–12" tablets), no-sleep while charging.
- Crash auto-restart (WorkManager + `FlutterError` guard), offline banner hidden in kiosk (subtle dot), full status in admin.
- Versioning: `versionName` = `1.x.y+<tenantSlug>.<build>`; keep `CHANGELOG` per tenant build.
- `tool/build_tenant.sh <slug>` outputs `build/<slug>/app-release.apk`; manual install; document reinstall (data preserved via `autoBackup` unless tenant changes).
- Later (not v1): in-app self-updater polling `GET /device/latest?slug=` → download APK.

## 13. Build order (P0 → P4)

- **P0 Foundations:** deps, lint, folders, `TenantConfig` + `build_tenant.sh`, drift schema §4, `ar/en` + RTL shell, demo seed.
- **P1 Read-only kiosk:** menu UI (variants/translations/tags), theme mapper + baked theme, offline seed works, sideload demo APK.
- **P2 Pull sync:** Next.js `pull` + Dio + polling + pull-on-boot + image prefetch + tenant override (§5.2).
- **P3 Admin + push:** login (better-auth, cached session), CRUD + reorder + toggles + image upload, push queue + conflicts UI.
- **P4 Harden:** kiosk lock, wakelock, error/empty/offline states, real-tablet QA, per-tenant release notes.

## 14. Resolved (2026-09-07 Q&A) + remaining

Resolved:

1. ~~Polling interval?~~ → 15 min silent + manual Sync button in admin + pull-on-boot.
2. ~~Canonical language?~~ → AR canonical, EN in translations; user-toggleable, default AR; Latin digits always.
3. ~~Variants UX?~~ → single-select pills; hide `basePrice` when variants exist.
4. `dietaryTags` → fixed enum; values TBD (proposal: vegan, vegetarian, spicy, gluten_free, nuts + AR labels).
5. ~~Fonts?~~ → Cairo/Inter mapping. `customCss` killed by policy (2026-09-07): web to drop column, app never reads it.
6. ~~Layout meaning?~~ → confirmed: single = list, elevated = elevated cards, comfortable = comfy padding.
7. ~~Bake slug vs id?~~ → bake `slug`, resolve uuid on first pull.
8. ~~Images/host?~~ → Minio on Coolify compose, direct public S3 URLs (see §16–§17). Price → show `basePrice` / min-variant "from".
9. ~~Session?~~ → force online re-login on password change / 401. Session TTL follows better-auth (confirm value in web repo).
10. Tablet → rotation locked, no dayparting v1. Screensaver: see §15.

Still needed from web repo:

- better-auth session TTL + 401 shape.
- `dietaryTags` final values.
- Currency code/symbol per tenant (add to `Tenant`? or infer from locale?).
- Slugify function to mirror on tablet.

## 15. Screensaver options (owner asked)

No rotation, no dayparting — but idle screen is cheap and useful for a kiosk:

- **V1 (recommend):** after N min idle (default 3, configurable in admin), full-screen attract loop: `coverUrl` + logo + top dishes (first 6 available items w/ images) + QR to web menu. Any touch exits. Uses already-cached data, no new backend.
- **V1-alt:** clock + logo + "touch to browse" only. Zero content risk, same timer.
- **Later:** promo slides from web (`Tenant.promos[]` — new table/endpoint), video loop, dayparting.

Proposal: ship V1 attract loop with idle timer + admin toggle + touch-to-exit. Zero extra API. Confirm idle minutes + whether QR-to-web-menu wanted.

## 16. Media pipeline — direct public S3 (locked 2026-09-08)

Web findings (`~/projects/restaurant-menu`): Next is `output: 'export'` (static, no Next server);
Hono `api-server` serves API + `out/` static on `:3001`; storage keys already tenant-scoped
`uploads/<tenantId>/`; upload already crops 4:3 (400×300 + 800×600 WebP). Decisions:

- **Serving:** direct public S3 URLs. Hono `/uploads/*` proxy **removed completely**
  (`api-server/index.ts`, `lib/storage.ts::streamFromBucket` deleted; `upload.ts` returns absolute URL).
- **Keys:** keep `uploads/<tenantId-uuid>/` (rename-safe; slug only in docs/URLs, never as key prefix).
- **Bucket:** single `menu-media`, public-read-only (write denied except via app creds).
  Ensure-on-boot: create bucket if missing + set public-read policy.
- **New env:** `STORAGE_PUBLIC_BASE_URL=https://s3-menu.georgesalebe.me/menu-media`
  (alongside existing `STORAGE_ENDPOINT=http://minio:9000`, `STORAGE_REGION`,
  `STORAGE_BUCKET=menu-media`, `STORAGE_ACCESS_KEY_ID/SECRET`).
- **Upload response:** `{ url: "<PUBLIC_BASE>/uploads/<tenantId>/<uuid>_card.webp" }`
  stored in `MenuItem.imageUrl` / `logoUrl` / `coverUrl`. Android treats them as opaque
  absolute URLs (cached + prefetched, §11 ratios unchanged: dishes 4:3, logo 1:1, cover 16:9).
- **Backfill (one-time SQL, old rows have relative `/uploads/...` URLs):**
  ```sql
  UPDATE menu_items
     SET "imageUrl" = 'https://s3-menu.georgesalebe.me/menu-media' || "imageUrl",
         "updatedAt" = NOW()
   WHERE "imageUrl" LIKE '/uploads/%';
  -- repeat for tenants.logoUrl / tenants.coverUrl (table/columns per schema)
  ```
  New uploads need no migration. Deleted-item orphans: sweep later, not v1.

## 17. Deployment — Coolify compose (locked 2026-09-08)

Mimics reservation compose, stripped to 2 services (no booking/bot/runner, no desktop bucket).
Web DB stays external (nixpacks DB untouched); Minio added because Coolify has no managed S3.

- **Domains:** `menu.georgesalebe.me` + `*.menu.georgesalebe.me` → api:3001 (API + static);
  `s3-menu.georgesalebe.me` → minio:9000; `minio-menu.georgesalebe.me` → minio:9001.
  Tenant custom domains attach as extra Coolify domains on the api service
  (path-based `/en/<slug>/menu` needs no per-tenant router, only DNS).
- **Services:** `api` (Hono, multi-stage `Dockerfile`: deps → build `out/` → runtime `tsx api-server/index.ts`)
  + `minio` (pinned `RELEASE.2025-04-22T22-12-26Z`, own creds/volume). Networks: `default` + external `coolify`.
  Files (web repo root, written 2026-09-08): `Dockerfile`, `.dockerignore`, `docker-compose.yml`.
- **Env:** carry `DATABASE_URL/DIRECT_URL`, `BETTER_AUTH_SECRET`, `TENANT_DEFAULT_SLUG`;
  set `BETTER_AUTH_URL` + `NEXT_PUBLIC_APP_URL` → `https://menu.georgesalebe.me`,
  `STORAGE_PUBLIC_BASE_URL` → `https://s3-menu.georgesalebe.me/menu-media`,
  optional `TRUSTED_ORIGINS` (extra tenant domains) + `COOLIFY_BUILD_HOOK` (static rebuild trigger).
  Build args: `DATABASE_URL/DIRECT_URL/NEXT_PUBLIC_APP_URL` (migrate + prerender need DB at build time —
  same pattern as today's nixpacks build, which already hits the DB).
- **Health:** `GET /healthz → {ok:true}` (added 2026-09-08) used by compose healthcheck; minio uses
  `/minio/health/live` (same as reservation setup).
- **Env:** carry `DATABASE_URL/DIRECT_URL`, `BETTER_AUTH_SECRET`, `TENANT_DEFAULT_SLUG`;
  set `BETTER_AUTH_URL=https://menu.georgesalebe.me`, `NEXT_PUBLIC_APP_URL` same;
  new Minio/S3 secrets (never reuse reservation's); `PORT=3001`.
- **Must-fix before first compose deploy (done 2026-09-08, web repo):**
  1. ~~`package.json build` force-reset~~ → `prisma generate && prisma migrate deploy && next build`;
     `api:start` is plain `tsx` (migrate runs at image build via `api:migrate`, never at container
     start — a failing migrate must not crash-loop the service). Seeds manual-only (`db:seed`, `api:seed` untouched).
  2. ~~open CORS + localhost-only origins~~ → new `lib/origins.ts` allowlist (localhost, menu + `*.menu` domains,
     `BETTER_AUTH_URL`/`NEXT_PUBLIC_APP_URL`, extra via `TRUSTED_ORIGINS`); wired into
     better-auth `trustedOrigins` + Hono CORS (non-listed origins get no ACAO header).
  3. ~~Bucket policy~~ → `ensureBucket()` on boot (create if missing + public-GetObject-only policy);
     `STORAGE_PUBLIC_BASE_URL` emitted by `upload.ts` (see §16).
- **Migration:** branch → Dockerfile + compose → Coolify compose resource + env/DNS → verify
  (menu, login, upload→public URL, Android pull) → retire nixpacks. Rollback = redeploy nixpacks tag.
- **Done 2026-09-08 (web repo):** removed `/uploads/*` route + import (`api-server/index.ts`),
  removed `streamFromBucket` + unused `GetObjectCommand`/`Readable` (`lib/storage.ts`),
  `upload.ts` emits `${STORAGE_PUBLIC_BASE_URL}/${key}` with 500 if unconfigured.
  Verified: zero remaining references to `streamFromBucket`, `GetObjectCommand`, `/uploads/` proxy.

## 18. Delta sync — full once, changed-only after (locked 2026-09-08)

- **First fetch:** `GET /sync/pull` with no `since` → full dump (tenant + all categories/items/
  translations/variants). Tablet stores + saves `lastPullAt = serverTime` from the response
  (server clock, never client clock — no skew bugs).
- **Steady state (15-min poll):** `GET /sync/pull?since=<lastPullAt>` → only rows with
  `updatedAt > since` + tombstones. Tablet upserts in one drift transaction,
  `lastPullAt = newServerTime`. A price edit ships ~1KB (one item + variants), never the menu.
- **Images follow for free:** new photo = new uuid filename = new URL inside the changed item row
  → tablet downloads only that file (dishes via CacheManager, logo/cover re-pin on URL change).
- **Delete tracking (chosen: soft-delete flag):** add `isDeleted Boolean @default(false)` to
  `Category`, `MenuItem`, `MenuItemVariant`. Deletes set the flag; pull ships flagged rows as
  tombstones; kiosk queries add `WHERE isDeleted=0`. Super-admin purge job hard-deletes rows +
  S3 keys after N days.
- **Parent-touch rule (translations/variants have no own `updatedAt`):** any child write
  (translation/variant upsert, flag change) bumps the parent's `MenuItem.updatedAt` /
  `Category.updatedAt` in the same transaction. Pull compares only parent timestamps and always
  ships the parent's full child set — no missed-translation bug, no per-child clocks.
- **Tenant row:** already has `updatedAt` — ship when changed so rebrands arrive in deltas.
- **Pull shape:** `{ serverTime, tenant?, categories[], items[] (+ inline translations/variants) }`,
  children scoped to changed parents.
- **Safety nets:** `since` older than tombstone retention (~30d) → `410 Gone` → one full re-pull
  (no silent resurrection). Weekly/admin-triggered verify via per-table counts+hash → full re-pull
  on mismatch. Push path unchanged (dirty rows, server stamps `updatedAt` on accept).
- **Shipped 2026-09-08 (web repo):** `isDeleted` on Category/MenuItem/Variant
  (migration `20260908120000_soft_delete`); list GETs filter deleted; DELETEs tombstone
  (category cascades flag to items); variant replace tombstones old set; translation
  upsert/delete touch parent `updatedAt` in-txn; `GET /api/sync/pull` (public, slug/tenantId,
  `410 stale_cursor`); `POST /api/sync/push` (auth, tenant-scoped, LWW conflicts returned);
  one-off `prisma/oneoff/backfill_image_urls.sql` for proxy-era relative URLs.

## 19. P1 — read-only kiosk UI on local data (shipped 2026-09-08)

Customer menu renders from drift (demo seed; sync data drops in with P2 untouched).

- **P1-1 DB provider:** `lib/core/db/db_provider.dart` — `Provider<AppDb>` (create, seed demo
  when `TENANT_SLUG=demo` and tables empty, dispose on scope end).
- **P1-2 Repository:** `lib/features/menu/data/menu_repository.dart` — drift streams:
  `watchVisibleCategories(tenantId)`, `watchVisibleItems(categoryId)` (existing DAO methods),
  plus translations/variants lookup per item, locale-aware name/desc resolution
  (`translation?.name ?? fallback`), search filter across both locales.
- **P1-3 State:** `selectedCategoryIdProvider` (auto-select first), `searchQueryProvider`,
  `selectedVariantIdProvider.family(itemId)`; reuse `localeControllerProvider` for AR/EN.
- **P1-4 UI (`menu_page.dart` rewrite + widgets):**
  - Header: tenant name (+ logo file when pinned in P2, baked asset fallback), AR/EN toggle pill.
  - Category rail: horizontal scroll pills (portrait) / side rail (landscape ≥900dp via LayoutBuilder).
  - Cards grid: 1 col phone portrait, 2–3 cols tablet landscape; photo 4:3
    (`CachedNetworkImage`, branded placeholder + error widget — seed has no URLs, so
    placeholder path is exercised), name[locale], desc[locale], `dietaryTags` chips,
    single-select variant pills (price updates, `basePrice` hidden when variants exist),
    price via `NumberFormat('en')` Latin digits (currency symbol TBD per tenant).
  - Search field (both locales), empty states (no categories / no results / item unavailable),
    5-tap title → `/admin/login` (kept).
- **P1-5 Tests:** unit-test `priceLabel` + locale-resolution helpers; widget test for
  variant-pill price switching. `flutter analyze` clean.
- **Acceptance:** demo APK, airplane mode, AR default RTL correct, EN toggle re-renders,
  variant tap changes price, search filters, rotation locked landscape per §1
  (portrait still lays out sanely).
