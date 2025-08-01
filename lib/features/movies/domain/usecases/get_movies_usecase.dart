import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_list_response.dart';
import '../repositories/movie_repository.dart';

class GetMoviesUseCase implements UseCase<MovieListResponse, GetMoviesParams> {
  final MovieRepository repository;

  GetMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, MovieListResponse>> call(GetMoviesParams params) async {
    return await repository.getMovies(params.page);
  }
}

class GetMoviesParams extends Equatable {
  final int page;

  const GetMoviesParams({required this.page});

  @override
  List<Object> get props => [page];
}
