import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register(String name, String email, String password);
  Future<UserModel> getProfile();
  Future<String> uploadPhoto(String imagePath);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await apiClient.login({
        'email': email,
        'password': password,
      });
      return response;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['response']?['message'] ?? 'Login failed';
      throw ServerException(
        message: _getErrorMessage(errorMessage),
        statusCode: e.response?.statusCode,
      );
    } on FormatException catch (e) {
      throw ServerException(
        message: 'Invalid response format: ${e.message}',
        statusCode: null,
      );
    } catch (e) {
      throw NetworkException('Network error occurred during login: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponseModel> register(String name, String email, String password) async {
    try {
      final response = await apiClient.register({
        'name': name,
        'email': email,
        'password': password,
      });
      return response;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['response']?['message'] ?? 'Registration failed';
      throw ServerException(
        message: _getErrorMessage(errorMessage),
        statusCode: e.response?.statusCode,
      );
    } on FormatException catch (e) {
      throw ServerException(
        message: 'Invalid response format: ${e.message}',
        statusCode: null,
      );
    } catch (e) {
      throw NetworkException('Network error occurred during registration: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await apiClient.getProfile();
      return response.user;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Failed to get profile',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException('Network error occurred while getting profile');
    }
  }

  @override
  Future<String> uploadPhoto(String imagePath) async {
    try {
      final file = await MultipartFile.fromFile(imagePath);
      final formData = FormData.fromMap({'file': file});
      final response = await apiClient.uploadPhoto(formData);
      return response.photoUrl;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Photo upload failed',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw NetworkException('Network error occurred during photo upload');
    }
  }

  String _getErrorMessage(String? apiMessage) {
    switch (apiMessage) {
      case 'USER_EXISTS':
        return 'Bu email adresi ile zaten kayıt olunmuş. Farklı bir email deneyin.';
      case 'INVALID_EMAIL':
        return 'Geçersiz email adresi.';
      case 'WEAK_PASSWORD':
        return 'Şifre çok zayıf. Daha güçlü bir şifre seçin.';
      case 'INVALID_CREDENTIALS':
        return 'Email veya şifre hatalı.';
      default:
        return apiMessage ?? 'Bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }
}
