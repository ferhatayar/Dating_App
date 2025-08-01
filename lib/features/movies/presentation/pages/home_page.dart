import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/movie_card.dart';
import '../../../../shared/widgets/bottom_navigation_widget.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import 'movie_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial movies after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieBloc>().add(const MovieLoadRequested(page: 1, isRefresh: true));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MovieBloc>().add(MovieLoadMore());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Keşfet',
          style: AppTextStyles.headingMedium,
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state is MovieInitial || state is MovieLoading) {
                return const LoadingWidget(message: 'Filmler yükleniyor...');
              }

              if (state is MovieError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bir hata oluştu',
                        style: AppTextStyles.headingSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MovieBloc>().add(MovieRefresh());
                        },
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                );
              }

              if (state is MovieLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<MovieBloc>().add(MovieRefresh());
                  },
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: state.hasReachedMax 
                        ? state.movies.length 
                        : state.movies.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.movies.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }

                      final movie = state.movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          // Navigate to movie detail
                          _showMovieDetail(context, movie);
                        },
                        onFavoritePressed: () {
                          context.read<MovieBloc>().add(
                            MovieToggleFavorite(movieId: movie.id),
                          );
                        },
                      );
                    },
                  ),
                );
              }

              // For any other state (like MovieFavoritesLoaded), show loading and reload movies
              // But only if we're not in a state that's related to favorites
              if (state is! MovieFavoritesLoaded && state is! MovieLoading) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<MovieBloc>().add(const MovieLoadRequested(page: 1, isRefresh: true));
                });
              }

              return const LoadingWidget(message: 'Filmler yükleniyor...');
            },
          ),
          // Bottom Navigation Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: BottomNavigationWidget(currentIndex: 0), // 0 means home is active
            ),
          ),
        ],
      ),
    );
  }

  void _showMovieDetail(BuildContext context, movie) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MovieDetailPage(
          movie: movie,
        ),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
