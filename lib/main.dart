import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection_container.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/movies/presentation/bloc/movie_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await InjectionContainer.init();

  runApp(const DatingApp());
}

class DatingApp extends StatelessWidget {
  const DatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => InjectionContainer.authBloc..add(AuthCheckStatus()),
        ),
        BlocProvider<MovieBloc>(
          create: (context) => InjectionContainer.movieBloc,
        ),
      ],
      child: MaterialApp.router(
        title: 'Dating App',
        debugShowCheckedModeBanner: false,

        theme: AppTheme.darkTheme,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr', 'TR'),
          Locale('en', 'US'),
        ],
        locale: const Locale('tr', 'TR'),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
