import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../api/api_client.dart';
import '../config/tenant_config.dart';
import '../db/app_db.dart';
import '../i18n/locale_controller.dart';

/// Slashed const: the server runs `trailingSlash: true` and 308-redirects
/// slashless POSTs, which dart:io won't auto-follow (same as login, §21).
const heartbeatPath = '/api/devices/heartbeat/';

const _deviceIdKey = 'tablet_device_id';

const _uuid = Uuid();

/// Stable per-tablet id, minted once into SharedPreferences.
Future<String> tabletDeviceId(SharedPreferences prefs) async {
  final existing = prefs.getString(_deviceIdKey);
  if (existing != null && existing.isNotEmpty) return existing;
  final id = _uuid.v4();
  await prefs.setString(_deviceIdKey, id);
  return id;
}

class HeartbeatResult {
  const HeartbeatResult({required this.revision, required this.syncRequired});

  factory HeartbeatResult.fromJson(Map<String, dynamic> j) => HeartbeatResult(
        revision: (j['revision'] as num?)?.toInt() ?? 0,
        syncRequired: (j['syncRequired'] as bool?) ?? false,
      );

  final int revision;
  final bool syncRequired;
}

/// Local menu revision for [slug] (0 when the tenant row hasn't pulled yet).
Future<int> localRevision(AppDb db, String slug) async {
  final row = await (db.select(db.tenants)..where((t) => t.slug.equals(slug)))
      .getSingleOrNull();
  return row?.revision ?? 0;
}

/// POST a heartbeat. Best-effort: any failure (offline, 4xx/5xx) returns
/// null and never fails the sync cycle. Sends [knownRevision] so the server
/// can auto-clear the poll flag when this fleet is current.
Future<HeartbeatResult?> sendHeartbeat(
  Ref ref, {
  int? knownRevision,
}) async {
  try {
    final api = ref.read(apiClientProvider);
    final prefs = ref.read(sharedPreferencesProvider);
    final locale = ref.read(localeControllerProvider).languageCode;
    final res = await api.post(heartbeatPath, body: {
      'slug': TenantConfig.current.slug,
      'deviceId': await tabletDeviceId(prefs),
      'locale': locale,
      if (knownRevision case final known) 'knownRevision': known,
    });
    return HeartbeatResult.fromJson(res.data as Map<String, dynamic>);
  } catch (_) {
    return null;
  }
}
