import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/storage_constants.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  StorageService({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences prefs,
  })  : _secureStorage = secureStorage,
        _prefs = prefs;

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: StorageConstants.accessToken, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: StorageConstants.accessToken);
  }

  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: StorageConstants.userId, value: userId);
  }

  Future<String?> getUserId() async {
    return await _secureStorage.read(key: StorageConstants.userId);
  }

  Future<void> clearSecureData() async {
    await _secureStorage.deleteAll();
  }

  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    await _prefs.setString(StorageConstants.userProfile, jsonEncode(profile));
  }

  Map<String, dynamic>? getUserProfile() {
    final profileString = _prefs.getString(StorageConstants.userProfile);
    if (profileString != null) {
      return jsonDecode(profileString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> setFirstLaunch(bool isFirst) async {
    await _prefs.setBool(StorageConstants.isFirstLaunch, isFirst);
  }

  bool isFirstLaunch() {
    return _prefs.getBool(StorageConstants.isFirstLaunch) ?? true;
  }

  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(StorageConstants.selectedLanguage, languageCode);
  }

  String getLanguage() {
    return _prefs.getString(StorageConstants.selectedLanguage) ?? 'tr';
  }

  Future<void> cacheMovieList(List<Map<String, dynamic>> movies) async {
    final cacheData = {
      'movies': movies,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _prefs.setString(StorageConstants.movieListCache, jsonEncode(cacheData));
  }

  List<Map<String, dynamic>>? getCachedMovieList() {
    final cacheString = _prefs.getString(StorageConstants.movieListCache);
    if (cacheString != null) {
      final cacheData = jsonDecode(cacheString) as Map<String, dynamic>;
      final timestamp = cacheData['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      if (now - timestamp < StorageConstants.cacheValidityHours * 60 * 60 * 1000) {
        return List<Map<String, dynamic>>.from(cacheData['movies']);
      }
    }
    return null;
  }

  Future<void> clearCache() async {
    await _prefs.remove(StorageConstants.movieListCache);
    await _prefs.remove(StorageConstants.favoritesCache);
  }

  Future<void> clearAll() async {
    await clearSecureData();
    await _prefs.clear();
  }
}
