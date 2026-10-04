import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HiveCache {
  static const boxName = 'tava_cache';

  Box<String>? _box;

  Future<void> ensureOpen() async {
    _box ??= await Hive.openBox<String>(boxName);
  }

  Future<void> putJson(String key, Object value) async {
    await ensureOpen();
    await _box!.put(key, jsonEncode(value));
  }

  Future<T?> getJson<T>(
    String key,
    T Function(Object? decoded) decode,
  ) async {
    await ensureOpen();
    final raw = _box!.get(key);
    if (raw == null) return null;
    try {
      return decode(jsonDecode(raw));
    } on Object {
      return null;
    }
  }

  Future<void> remove(String key) async {
    await ensureOpen();
    await _box!.delete(key);
  }
}
