import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviedb/cubit/movie_cubit.dart';
import 'package:moviedb/data/repos/api_repos.dart';
import 'package:moviedb/pages/movie_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Movie DB',
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: BlocProvider(
          create: (context) => MovieCubit(ApiRepository()),
          child: MoviePage(),
        ));
  }
}
