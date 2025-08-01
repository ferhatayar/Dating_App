import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class MovieLoadRequested extends MovieEvent {
  final int page;
  final bool isRefresh;

  const MovieLoadRequested({
    required this.page,
    this.isRefresh = false,
  });

  @override
  List<Object> get props => [page, isRefresh];
}

class MovieLoadMore extends MovieEvent {}

class MovieRefresh extends MovieEvent {}

class MovieToggleFavorite extends MovieEvent {
  final String movieId;

  const MovieToggleFavorite({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class MovieLoadFavorites extends MovieEvent {}
