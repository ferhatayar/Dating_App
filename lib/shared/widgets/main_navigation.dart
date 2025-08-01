import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/movies/presentation/pages/home_page.dart';
import '../../features/movies/presentation/bloc/movie_bloc.dart';
import '../../features/movies/presentation/bloc/movie_event.dart';
import 'bottom_navigation_widget.dart';

final GlobalKey<MainNavigationState> mainNavigationKey = GlobalKey<MainNavigationState>();

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  MainNavigation({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key ?? mainNavigationKey);

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentIndex == 0) {
        context.read<MovieBloc>().add(const MovieLoadRequested(page: 1, isRefresh: true));
      } else if (_currentIndex == 1) {
        context.read<MovieBloc>().add(MovieLoadFavorites());
      }
    });
  }

  void switchToHome() {
    setState(() {
      _currentIndex = 0;
    });
    context.read<MovieBloc>().add(const MovieLoadRequested(page: 1, isRefresh: true));
  }

  void switchToProfile() {
    setState(() {
      _currentIndex = 1;
    });
    context.read<MovieBloc>().add(MovieLoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: BottomNavigationWidget(
                currentIndex: _currentIndex,
                onProfileTap: switchToProfile,
                onHomeTap: switchToHome,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
