import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetFavoriteMoviesUseCase implements UseCase<List<Movie>, GetFavoriteMoviesParams> {
  final MovieRepository repository;

  GetFavoriteMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GetFavoriteMoviesParams params) async {
    return await repository.getFavoriteMovies(params.page);
  }
}

class GetFavoriteMoviesParams extends Equatable {
  final int page;

  const GetFavoriteMoviesParams({required this.page});

  @override
  List<Object> get props => [page];
}
