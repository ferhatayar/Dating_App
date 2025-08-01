import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final int currentPage;
  final bool isRefreshing;

  const MovieLoaded({
    required this.movies,
    required this.hasReachedMax,
    required this.currentPage,
    this.isRefreshing = false,
  });

  MovieLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
    int? currentPage,
    bool? isRefreshing,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object> get props => [movies, hasReachedMax, currentPage, isRefreshing];
}

class MovieError extends MovieState {
  final String message;

  const MovieError({required this.message});

  @override
  List<Object> get props => [message];
}

class MovieFavoriteToggling extends MovieState {
  final String movieId;

  const MovieFavoriteToggling({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class MovieFavoriteToggled extends MovieState {
  final String movieId;
  final bool isFavorite;

  const MovieFavoriteToggled({
    required this.movieId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [movieId, isFavorite];
}

class MovieFavoritesLoaded extends MovieState {
  final List<Movie> favoriteMovies;

  const MovieFavoritesLoaded({required this.favoriteMovies});

  @override
  List<Object> get props => [favoriteMovies];
}
