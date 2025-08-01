import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_constants.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_favorite_movies_usecase.dart';
import '../../domain/usecases/get_movies_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMoviesUseCase getMoviesUseCase;
  final GetFavoriteMoviesUseCase getFavoriteMoviesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  MovieBloc({
    required this.getMoviesUseCase,
    required this.getFavoriteMoviesUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(MovieInitial()) {
    on<MovieLoadRequested>(_onMovieLoadRequested);
    on<MovieLoadMore>(_onMovieLoadMore);
    on<MovieRefresh>(_onMovieRefresh);
    on<MovieToggleFavorite>(_onMovieToggleFavorite);
    on<MovieLoadFavorites>(_onMovieLoadFavorites);
  }

  Future<void> _onMovieLoadRequested(
    MovieLoadRequested event,
    Emitter<MovieState> emit,
  ) async {
    if (event.isRefresh) {
      emit(MovieLoading());
    }

    final result = await getMoviesUseCase(GetMoviesParams(page: event.page));

    result.fold(
      (failure) => emit(MovieError(message: failure.message)),
      (movieResponse) {
        final hasReachedMax = event.page >= ApiConstants.maxPages || 
                             event.page >= movieResponse.totalPages;
        
        emit(MovieLoaded(
          movies: movieResponse.movies,
          hasReachedMax: hasReachedMax,
          currentPage: event.page,
        ));
      },
    );
  }

  Future<void> _onMovieLoadMore(
    MovieLoadMore event,
    Emitter<MovieState> emit,
  ) async {
    final currentState = state;
    if (currentState is MovieLoaded && !currentState.hasReachedMax) {
      final nextPage = currentState.currentPage + 1;
      
      final result = await getMoviesUseCase(GetMoviesParams(page: nextPage));

      result.fold(
        (failure) => emit(MovieError(message: failure.message)),
        (movieResponse) {
          final hasReachedMax = nextPage >= ApiConstants.maxPages || 
                               nextPage >= movieResponse.totalPages;
          
          emit(currentState.copyWith(
            movies: [...currentState.movies, ...movieResponse.movies],
            hasReachedMax: hasReachedMax,
            currentPage: nextPage,
          ));
        },
      );
    }
  }

  Future<void> _onMovieRefresh(
    MovieRefresh event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    add(const MovieLoadRequested(page: 1, isRefresh: true));
  }

  Future<void> _onMovieToggleFavorite(
    MovieToggleFavorite event,
    Emitter<MovieState> emit,
  ) async {
    // Store the current state before toggling
    final currentState = state;

    // Optimistically update the UI for both MovieLoaded and MovieFavoritesLoaded states
    if (currentState is MovieLoaded) {
      final updatedMovies = currentState.movies.map((movie) {
        if (movie.id == event.movieId) {
          return movie.copyWith(isFavorite: !movie.isFavorite);
        }
        return movie;
      }).toList();

      emit(currentState.copyWith(movies: updatedMovies));
    } else if (currentState is MovieFavoritesLoaded) {
      // Find the movie being toggled
      final movieToToggle = currentState.favoriteMovies.firstWhere(
        (movie) => movie.id == event.movieId,
        orElse: () => throw Exception('Movie not found in favorites'),
      );

      List<Movie> updatedFavorites;
      if (movieToToggle.isFavorite) {
        // Remove from favorites
        updatedFavorites = currentState.favoriteMovies
            .where((movie) => movie.id != event.movieId)
            .toList();
      } else {
        // Add to favorites (this case shouldn't happen in favorites list, but handle it)
        updatedFavorites = currentState.favoriteMovies.map((movie) {
          if (movie.id == event.movieId) {
            return movie.copyWith(isFavorite: true);
          }
          return movie;
        }).toList();
      }

      emit(MovieFavoritesLoaded(favoriteMovies: updatedFavorites));
    }

    final result = await toggleFavoriteUseCase(
      ToggleFavoriteParams(movieId: event.movieId),
    );

    result.fold(
      (failure) {
        // Revert the optimistic update on failure
        if (currentState is MovieLoaded) {
          emit(currentState);
        } else if (currentState is MovieFavoritesLoaded) {
          emit(currentState);
        }
        emit(MovieError(message: failure.message));
      },
      (_) {
        // Success - the optimistic update was correct, no need to change anything
      },
    );
  }

  Future<void> _onMovieLoadFavorites(
    MovieLoadFavorites event,
    Emitter<MovieState> emit,
  ) async {
    print('🎬 MovieLoadFavorites event triggered');
    print('🎬 Current state: ${state.runtimeType}');
    
    // Eğer zaten favori filmler yüklenmişse, tekrar yükleme
    final currentState = state;
    if (currentState is MovieFavoritesLoaded && currentState.favoriteMovies.isNotEmpty) {
      print('🎬 Favorites already loaded with ${currentState.favoriteMovies.length} movies, skipping...');
      return;
    }
    
    print('🎬 Emitting MovieLoading state');
    emit(MovieLoading());

    try {
      print('🎬 Fetching favorite movies from API...');
      final result = await getFavoriteMoviesUseCase(const GetFavoriteMoviesParams(page: 1));

      result.fold(
        (failure) {
          print('🎬 Error loading favorites: ${failure.message}');
          print('🎬 Emitting MovieError state');
          emit(MovieError(message: failure.message));
        },
        (favoriteMovies) {
          print('🎬 Successfully loaded ${favoriteMovies.length} favorite movies');
          print('🎬 Emitting MovieFavoritesLoaded state');
          emit(MovieFavoritesLoaded(favoriteMovies: favoriteMovies));
        },
      );
    } catch (e) {
      print('🎬 Exception in _onMovieLoadFavorites: $e');
      print('🎬 Emitting MovieError state due to exception');
      emit(MovieError(message: 'Favori filmler yüklenirken hata oluştu: $e'));
    }
  }
}
