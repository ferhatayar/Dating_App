import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure({
    required String message,
    this.statusCode,
  }) : super(message);
  
  @override
  List<Object> get props => [message, statusCode ?? 0];
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  final Map<String, String>? errors;
  
  const ValidationFailure({
    required String message,
    this.errors,
  }) : super(message);
  
  @override
  List<Object> get props => [message, errors ?? {}];
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
