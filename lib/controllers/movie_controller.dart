import 'package:dartz/dartz.dart';
import 'package:flutter_flix/errors/movie_error.dart';
import 'package:flutter_flix/models/model_response.dart';
import 'package:flutter_flix/models/movie_model.dart';
import 'package:flutter_flix/repositories/movie_repository.dart';

class MovieController {
  final _repository = MovieRepository();

  MovieResponse movieResponse;
  MovieError movieError;

  bool loading = true;

  List<Movie> get movies => movieResponse?.movies ?? <Movie>[];

  int get moviesCount => movies.length;
  bool get hasMovies => moviesCount != 0;
  int get totalPages => movieResponse?.totalPages ?? 1;
  int get currentPage => movieResponse?.page ?? 1;

  Future<Either<MovieError, MovieResponse>> fetchAllMovies(
      {int page = 1}) async {
    movieError = null;

    final result = await _repository.fetchAllMovies(page);
    result.fold((error) => movieError = error, (movie) {
      if (movieResponse == null) {
        movieResponse = movie;
      } else {
        movieResponse.page = movie.page;
        movieResponse.movies.addAll(movie.movies);
      }
    });

    return result;
  }

  Future<Either<MovieError, MovieResponse>> searchMovies(String search,
      {int page = 1}) async {
    movieError = null;

    final result = await _repository.searchMovies(search, page);
    result.fold((error) => movieError = error, (movie) {
      if (movieResponse == null) {
        movieResponse = movie;
      } else {
        movieResponse.page = movie.page;
        movieResponse.movies.addAll(movie.movies);
      }
    });

    return result;
  }
}
