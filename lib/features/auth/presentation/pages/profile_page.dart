import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/bottom_navigation_widget.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/presentation/bloc/movie_bloc.dart';
import '../../../movies/presentation/bloc/movie_event.dart';
import '../../../movies/presentation/bloc/movie_state.dart';
import '../../../movies/presentation/pages/movie_detail_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/limited_offer_bottom_sheet.dart';
import 'photo_upload_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthGetProfile());
    context.read<MovieBloc>().add(MovieLoadFavorites());
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPhotoUploaded) {
          context.read<AuthBloc>().add(AuthGetProfile());
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'Profil Detayı',
                      style: AppTextStyles.headingSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        _showLimitedOfferBottomSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.diamond,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sınırlı Teklif',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthPhotoUploaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fotoğraf başarıyla yüklendi'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    context.read<AuthBloc>().add(AuthGetProfile());
                  } else if (state is AuthPhotoUploadError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  } else if (state is AuthUnauthenticated) {
                    context.go('/login');
                  }
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthAuthenticated) {
                            return _buildNewProfileHeader(state.user);
                          }
                          return const LoadingWidget();
                        },
                      ),

                      const SizedBox(height: 32),

                      _buildFavoriteMoviesSection(),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: BottomNavigationWidget(currentIndex: 1),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildNewProfileHeader(user) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => _showProfilePhotoBottomSheet(context),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[700]!, width: 2),
                ),
                child: ClipOval(
                  child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: user.photoUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? 'Kullanıcı',
                    style: AppTextStyles.headingMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${user.id}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showPhotoUploadPage(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Fotoğraf Ekle',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFavoriteMoviesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Beğendiğim Filmler',
            style: AppTextStyles.headingMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        BlocConsumer<MovieBloc, MovieState>(
          listenWhen: (previous, current) {
            return current is MovieFavoritesLoaded ||
                   (current is MovieLoading && previous is! MovieLoading) ||
                   (current is MovieError && previous is! MovieError);
          },
          listener: (context, state) {
          },
          buildWhen: (previous, current) {
            return current is MovieLoading ||
                   current is MovieError ||
                   current is MovieFavoritesLoaded ||
                   (previous is MovieFavoritesLoaded && current is MovieFavoritesLoaded);
          },
          builder: (context, state) {
            if (state is MovieLoading) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              );
            }

            if (state is MovieError) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Favoriler yüklenemedi',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          context.read<MovieBloc>().add(MovieLoadFavorites());
                        },
                        child: const Text(
                          'Tekrar Dene',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            List<Movie> favoriteMovies = [];
            if (state is MovieFavoritesLoaded) {
              favoriteMovies = state.favoriteMovies;
            }

            if (favoriteMovies.isEmpty) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 48,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Beğendiğin film yok',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Filmler sayfasından beğendiğin filmleri ekleyebilirsin',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              key: ValueKey('favorites_grid_${favoriteMovies.length}'),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.6,
              ),
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return GestureDetector(
                  onTap: () {
                    _showMovieDetail(context, movie);
                  },
                  child: Container(
                    key: ValueKey('movie_${movie.id}'),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          key: ValueKey('image_${movie.id}'),
                          imageUrl: movie.posterUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          memCacheWidth: 300,
                          memCacheHeight: 400,
                          fadeInDuration: const Duration(milliseconds: 200),
                          fadeOutDuration: const Duration(milliseconds: 200),
                          placeholder: (context, url) => Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.error,
                              color: Colors.grey,
                            ),
                          ),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (movie.genre != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                movie.genre!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  ),
                );
              },
            );
          },
        ),
      ],
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

  void _showPhotoUploadPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PhotoUploadPage(),
      ),
    );
  }

  void _showLimitedOfferBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LimitedOfferBottomSheet(),
    );
  }

  void _showProfilePhotoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primary),
              title: Text(
                'Çıkış Yap',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


}
