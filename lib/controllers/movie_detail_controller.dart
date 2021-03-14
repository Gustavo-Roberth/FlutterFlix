import 'package:dartz/dartz.dart';
import 'package:flutter_flix/errors/movie_error.dart';
import 'package:flutter_flix/models/movie_detail_model.dart';
import 'package:flutter_flix/repositories/movie_repository.dart';

class MovieDetailController {
  final _repository = MovieRepository();

  MovieDetail movieDetail;
  MovieError movieError;

  bool loading = true;

  Future<Either<MovieError, MovieDetail>> fetchMovieById(int id) async {
    movieError = null;
    final result = await _repository.fetchMovieById(id);
    result.fold(
      (error) => movieError = error,
      (detail) => movieDetail = detail,
    );
    return result;
  }
}
