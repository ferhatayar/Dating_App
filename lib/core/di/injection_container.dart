import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../network/api_client.dart';
import '../network/dio_client.dart';

// Services
import '../../shared/services/storage_service.dart';

// Auth
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_profile_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Movies
import '../../features/movies/data/datasources/movie_remote_data_source.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/usecases/get_favorite_movies_usecase.dart';
import '../../features/movies/domain/usecases/get_movies_usecase.dart';
import '../../features/movies/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/movies/presentation/bloc/movie_bloc.dart';

class InjectionContainer {
  static late SharedPreferences _sharedPreferences;
  static late FlutterSecureStorage _secureStorage;
  static late Logger _logger;
  static late DioClient _dioClient;
  static late ApiClient _apiClient;
  static late StorageService _storageService;

  // Auth
  static late AuthRemoteDataSource _authRemoteDataSource;
  static late AuthLocalDataSource _authLocalDataSource;
  static late AuthRepository _authRepository;
  static late LoginUseCase _loginUseCase;
  static late RegisterUseCase _registerUseCase;
  static late LogoutUseCase _logoutUseCase;
  static late GetProfileUseCase _getProfileUseCase;
  static late AuthBloc _authBloc;

  // Movies
  static late MovieRemoteDataSource _movieRemoteDataSource;
  static late MovieRepository _movieRepository;
  static late GetMoviesUseCase _getMoviesUseCase;
  static late GetFavoriteMoviesUseCase _getFavoriteMoviesUseCase;
  static late ToggleFavoriteUseCase _toggleFavoriteUseCase;
  static late MovieBloc _movieBloc;

  static Future<void> init() async {
    // External dependencies
    _sharedPreferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
    _logger = Logger();

    // Core
    _dioClient = DioClient(
      secureStorage: _secureStorage,
      logger: _logger,
    );
    _apiClient = ApiClient(_dioClient.dio);
    _storageService = StorageService(
      secureStorage: _secureStorage,
      prefs: _sharedPreferences,
    );

    // Auth
    _authRemoteDataSource = AuthRemoteDataSourceImpl(apiClient: _apiClient);
    _authLocalDataSource = AuthLocalDataSourceImpl(storageService: _storageService);
    _authRepository = AuthRepositoryImpl(
      remoteDataSource: _authRemoteDataSource,
      localDataSource: _authLocalDataSource,
    );

    _loginUseCase = LoginUseCase(_authRepository);
    _registerUseCase = RegisterUseCase(_authRepository);
    _logoutUseCase = LogoutUseCase(_authRepository);
    _getProfileUseCase = GetProfileUseCase(_authRepository);

    _authBloc = AuthBloc(
      loginUseCase: _loginUseCase,
      registerUseCase: _registerUseCase,
      logoutUseCase: _logoutUseCase,
      getProfileUseCase: _getProfileUseCase,
      authRepository: _authRepository,
    );

    // Movies
    _movieRemoteDataSource = MovieRemoteDataSourceImpl(apiClient: _apiClient);
    _movieRepository = MovieRepositoryImpl(remoteDataSource: _movieRemoteDataSource);

    _getMoviesUseCase = GetMoviesUseCase(_movieRepository);
    _getFavoriteMoviesUseCase = GetFavoriteMoviesUseCase(_movieRepository);
    _toggleFavoriteUseCase = ToggleFavoriteUseCase(_movieRepository);

    _movieBloc = MovieBloc(
      getMoviesUseCase: _getMoviesUseCase,
      getFavoriteMoviesUseCase: _getFavoriteMoviesUseCase,
      toggleFavoriteUseCase: _toggleFavoriteUseCase,
    );
  }

  // Getters
  static AuthBloc get authBloc => _authBloc;
  static MovieBloc get movieBloc => _movieBloc;
  static StorageService get storageService => _storageService;
  static AuthRepository get authRepository => _authRepository;
}
