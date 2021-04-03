part of 'movie_cubit.dart';

@immutable
abstract class MovieState {
  const MovieState();
}

class MovieInitial extends MovieState {
  const MovieInitial();
}

class MovieNoData extends MovieState {
  const MovieNoData();
}

class MovieLoading extends MovieState {
  const MovieLoading();
}

class MovieLoaded extends MovieState {
  final Movies movies;
  final GenresList genre;
  const MovieLoaded(this.movies, this.genre);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieLoaded &&
        other.movies == movies &&
        other.genre == genre;
  }

  @override
  int get hashCode => movies.hashCode ^ genre.hashCode;
}

class MovieError extends MovieState {
  final String errMsg;
  const MovieError(this.errMsg);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieError && other.errMsg == errMsg;
  }

  @override
  int get hashCode => errMsg.hashCode;
}
