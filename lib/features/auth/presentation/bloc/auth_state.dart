import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthPhotoUploading extends AuthState {}

class AuthPhotoUploaded extends AuthState {
  final String photoUrl;

  const AuthPhotoUploaded({required this.photoUrl});

  @override
  List<Object> get props => [photoUrl];
}

class AuthPhotoUploadError extends AuthState {
  final String message;

  const AuthPhotoUploadError({required this.message});

  @override
  List<Object> get props => [message];
}
