import '../../../../core/errors/exceptions.dart';
import '../../../../shared/services/storage_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthData(String token, UserModel user);
  Future<UserModel?> getCachedUser();
  Future<String?> getToken();
  Future<void> clearAuthData();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService storageService;

  AuthLocalDataSourceImpl({required this.storageService});

  @override
  Future<void> saveAuthData(String token, UserModel user) async {
    try {
      await storageService.saveToken(token);
      await storageService.saveUserId(user.id);
      await storageService.saveUserProfile(user.toJson());
    } catch (e) {
      throw CacheException('Failed to save auth data: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userProfile = storageService.getUserProfile();
      if (userProfile != null) {
        return UserModel.fromJson(userProfile);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user: ${e.toString()}');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await storageService.getToken();
    } catch (e) {
      throw CacheException('Failed to get token: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await storageService.clearSecureData();
    } catch (e) {
      throw CacheException('Failed to clear auth data: ${e.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
