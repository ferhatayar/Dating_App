import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movie.dart';
import '../entities/movie_list_response.dart';

abstract class MovieRepository {
  Future<Either<Failure, MovieListResponse>> getMovies(int page);
  Future<Either<Failure, List<Movie>>> getFavoriteMovies(int page);
  Future<Either<Failure, void>> toggleFavorite(String movieId);
}
