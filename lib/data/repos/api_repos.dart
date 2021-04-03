import 'package:dio/dio.dart';
import 'package:moviedb/data/model/genres.dart';
import 'package:moviedb/data/model/movies.dart';

const baseUrl = "https://api.themoviedb.org/3/";
const apiKey = "6d360c412baa6922132b1253eefef87c";

class ApiRepository {
  Future<Movies> fetchMovies(String genres, int page) async {
    var queryParameters;
    if (genres.isEmpty) {
      queryParameters = {
        'api_key': apiKey,
        'page': page,
      };
    } else {
      queryParameters = {
        'api_key': apiKey,
        'page': page,
        'with_genres': genres
      };
    }

    var response = await Dio()
        .get(baseUrl + "discover/movie", queryParameters: queryParameters);

    var movie = Movies.fromJson(response.data);
    return movie;
  }

  Future<GenresList> fetchGenres() async {
    var queryParameters = {'api_key': apiKey};

    var response = await Dio()
        .get(baseUrl + "genre/movie/list", queryParameters: queryParameters);

    var genre = GenresList.fromJson(response.data);
    return genre;
  }
}
