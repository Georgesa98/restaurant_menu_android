import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dish photos live in the HTTP disk cache (LRU); logo/cover are pinned
/// files that must never be evicted (docs/PLAN.md §11).
class ImagePrefetch {
  ImagePrefetch(this._dio, this._prefs);

  final Dio _dio;
  final SharedPreferences _prefs;

  static const _logoKey = 'pinned_logo_url';
  static const _coverKey = 'pinned_cover_url';

  Future<Directory> get _dir async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'pinned'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File?> pinnedFile(String name) async {
    final f = File(p.join((await _dir).path, name));
    return await f.exists() ? f : null;
  }

  /// First existing pinned brand file (`logo`/`cover`, any extension).
  Future<File?> pinnedBrand(String base) async {
    for (final e in ['png', 'jpg', 'jpeg', 'webp']) {
      final f = File(p.join((await _dir).path, '$base.$e'));
      if (await f.exists()) return f;
    }
    return null;
  }

  /// Downloads all dish [urls] into the cache (best-effort, capped).
  Future<int> prefetchDishes(Iterable<String> urls, {int cap = 300}) async {
    var done = 0;
    for (final url in urls.take(cap)) {
      if (url.isEmpty) continue;
      try {
        await DefaultCacheManager().downloadFile(url);
        done++;
      } catch (_) {
        // Offline or dead URL: kiosk keeps serving cache/placeholder.
      }
    }
    return done;
  }

  /// Re-pins logo/cover only when their URLs changed since last pin.
  Future<void> pinBrand({String? logoUrl, String? coverUrl}) async {
    await _pinIfChanged(_logoKey, 'logo', logoUrl);
    await _pinIfChanged(_coverKey, 'cover', coverUrl);
  }

  Future<void> _pinIfChanged(String prefKey, String fileBase, String? url) async {
    if (url == null || url.isEmpty) return;
    if (_prefs.getString(prefKey) == url) return;
    try {
      final res = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = res.data;
      if (bytes == null || bytes.isEmpty) return;
      final ext = url.split('?').first.split('.').last.toLowerCase();
      final safeExt = ['png', 'jpg', 'jpeg', 'webp'].contains(ext) ? ext : 'png';
      final file = File(p.join((await _dir).path, '$fileBase.$safeExt'));
      // Remove stale sibling extensions so only the current pin exists.
      for (final e in ['png', 'jpg', 'jpeg', 'webp']) {
        final sibling = File(p.join((await _dir).path, '$fileBase.$e'));
        if (sibling.path != file.path && await sibling.exists()) {
          await sibling.delete();
        }
      }
      await file.writeAsBytes(bytes, flush: true);
      await _prefs.setString(prefKey, url);
    } catch (_) {
      // Keep the previous pin; retry next cycle.
    }
  }
}
