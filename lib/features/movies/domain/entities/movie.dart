import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String? genre;
  final bool isFavorite;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    this.genre,
    this.isFavorite = false,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    String? genre,
    bool? isFavorite,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      genre: genre ?? this.genre,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, title, description, posterUrl, genre, isFavorite];
}
