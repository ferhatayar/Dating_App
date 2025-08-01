import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String name, String email, String password);
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, String>> uploadPhoto(String imagePath);
  Future<Either<Failure, void>> logout();
  Future<bool> isLoggedIn();
  Future<String?> getToken();
}
