import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/download_item_model.dart';

class StorageService {
  static const _downloadsKey = 'downloads';
  static const _folderKey = 'download_folder';

  Future<List<DownloadItemModel>> loadDownloads() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_downloadsKey) ?? const [];
    return raw.map((entry) => DownloadItemModel.fromJson(jsonDecode(entry) as Map<String, Object?>)).toList();
  }

  Future<void> saveDownloads(List<DownloadItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_downloadsKey, items.map((item) => jsonEncode(item.toJson())).toList());
  }

  Future<String?> loadFolder() async => (await SharedPreferences.getInstance()).getString(_folderKey);
  Future<void> saveFolder(String folder) async => (await SharedPreferences.getInstance()).setString(_folderKey, folder);
}
