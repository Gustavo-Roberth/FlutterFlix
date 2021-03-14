import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_flix/core/api.dart';
import 'package:flutter_flix/errors/movie_error.dart';
import 'package:flutter_flix/models/model_response.dart';
import 'package:flutter_flix/models/movie_detail_model.dart';

class MovieRepository {
  final Dio _dio = Dio(kDioOptions);

  Future<Either<MovieError, MovieResponse>> fetchAllMovies(int page) async {
    try {
      final response = await _dio.get('/movie/popular?page=$page',
          queryParameters: {'language': kLanguage});
      final model = MovieResponse.fromJson(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(
            MovieRepositoryError(error.response.data['status_message']));
      } else {
        return Left(MovieRepositoryError(kServerError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }

  Future<Either<MovieError, MovieDetail>> fetchMovieById(int id) async {
    try {
      final response = await _dio
          .get('/movie/$id', queryParameters: {'language': kLanguage});
      final model = MovieDetail.fromJson(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(
            MovieRepositoryError(error.response.data['status_message']));
      } else {
        return Left(MovieRepositoryError(kServerError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }
}
