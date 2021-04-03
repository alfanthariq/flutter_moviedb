import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: 'Flutter Demo',
        home: BlocProvider(
          create: (context) => MovieCubit(ApiRepository()),
          child: MoviePage(),
        ));
  }
}
