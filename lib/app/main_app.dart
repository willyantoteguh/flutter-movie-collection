import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/movie/crew_bloc/crew_bloc.dart';
import '../presentation/movie/genre_bloc/genre_bloc.dart';
import '../presentation/movie/movie_bloc/movie_bloc.dart';
import '../presentation/movie/screens/movie_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (context) => MovieBloc(),
        ),
        BlocProvider<CrewBloc>(
          create: (context) => CrewBloc(),
        ),
        BlocProvider<GenreBloc>(
          create: (context) => GenreBloc(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MovieScreen(),
      ),
    );
  }
}
