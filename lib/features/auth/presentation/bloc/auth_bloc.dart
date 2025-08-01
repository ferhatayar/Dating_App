import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetProfileUseCase getProfileUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getProfileUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthGetProfile>(_onGetProfile);
    on<AuthUploadPhoto>(_onUploadPhoto);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await registerUseCase(RegisterParams(
      name: event.name,
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await authRepository.isLoggedIn();
    
    if (isLoggedIn) {
      add(AuthGetProfile());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onGetProfile(
    AuthGetProfile event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getProfileUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onUploadPhoto(
    AuthUploadPhoto event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthPhotoUploading());

    final result = await authRepository.uploadPhoto(event.imagePath);

    result.fold(
      (failure) => emit(AuthPhotoUploadError(message: failure.message)),
      (photoUrl) async {
        emit(AuthPhotoUploaded(photoUrl: photoUrl));
        // Refresh profile to get updated user data
        final profileResult = await authRepository.getProfile();
        profileResult.fold(
          (failure) => {}, // Ignore profile refresh error
          (user) => emit(AuthAuthenticated(user: user)),
        );
      },
    );
  }
}
