import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../constants/api_constants.dart';
import '../constants/storage_constants.dart';

class DioClient {
  late Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final Logger _logger;

  DioClient({
    required FlutterSecureStorage secureStorage,
    required Logger logger,
  })  : _secureStorage = secureStorage,
        _logger = logger {
    _dio = Dio();
    _initializeDio();
  }

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': ApiConstants.contentType,
      },
    );

    // Add interceptors
    _dio.interceptors.add(_getAuthInterceptor());
    _dio.interceptors.add(_getLoggingInterceptor());
  }

  InterceptorsWrapper _getAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: StorageConstants.accessToken);
        if (token != null) {
          options.headers[ApiConstants.authorization] = '${ApiConstants.bearer} $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, clear storage
          await _secureStorage.deleteAll();
          _logger.w('Token expired, cleared storage');
        }
        handler.next(error);
      },
    );
  }

  InterceptorsWrapper _getLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.d('REQUEST: ${options.method} ${options.path}');
        _logger.d('Headers: ${options.headers}');
        if (options.data != null) {
          _logger.d('Body: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.d('RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
        _logger.d('Data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        _logger.e('ERROR: ${error.message}');
        if (error.response != null) {
          _logger.e('Response: ${error.response?.data}');
        }
        handler.next(error);
      },
    );
  }

  Dio get dio => _dio;
}
