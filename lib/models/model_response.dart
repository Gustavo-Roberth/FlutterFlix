import 'dart:convert';

import 'movie_model.dart';

MovieResponse movieResponseFromJson(String str) =>
    MovieResponse.fromJson(json.decode(str));

class MovieResponse {
  MovieResponse({
    this.page,
    this.movies,
    this.totalResults,
    this.totalPages,
  });

  int page;
  List<Movie> movies;
  int totalResults;
  int totalPages;

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
        page: json["page"],
        movies: List<Movie>.from(json["results"].map((x) => Movie.fromJson(
            x))), // 'results' pois na API a estrutura é 'results' não 'movies'
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
      );
}
