import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:moviedb/data/model/genres.dart';
import 'package:moviedb/data/model/movies.dart';
import 'package:moviedb/data/repos/api_repos.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final ApiRepository apiRepository;
  MovieCubit(this.apiRepository) : super(MovieInitial());

  Future<void> getMovies(String genres, int page) async {
    try {
      if (page == 1) {
        emit(MovieLoading());
      }
      final genresList = await apiRepository.fetchGenres();
      final movies = await apiRepository.fetchMovies(genres, page);
      emit(MovieLoaded(movies, genresList));
    } on SocketException {
      emit(MovieError('No Internet connection'));
    } on HttpException {
      emit(MovieError("Couldn't find the requested data"));
    } on FormatException {
      emit(MovieError("Bad response format"));
    } on NoSuchMethodError {
      emit(MovieError("No Such Method Error"));
    }
  }
}
