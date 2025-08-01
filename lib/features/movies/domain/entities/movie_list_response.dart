import 'package:equatable/equatable.dart';
import 'movie.dart';

class MovieListResponse extends Equatable {
  final List<Movie> movies;
  final int totalPages;
  final int currentPage;
  final bool hasNextPage;

  const MovieListResponse({
    required this.movies,
    required this.totalPages,
    required this.currentPage,
  }) : hasNextPage = currentPage < totalPages;

  MovieListResponse copyWith({
    List<Movie>? movies,
    int? totalPages,
    int? currentPage,
  }) {
    return MovieListResponse(
      movies: movies ?? this.movies,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [movies, totalPages, currentPage, hasNextPage];
}
