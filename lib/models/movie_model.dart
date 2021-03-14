import 'dart:convert';

import 'package:flutter_flix/models/movie_detail_model.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String movieTable = 'movieTable';
final String idColumn = 'idColumn';
final String adultColumn = 'adultColumn';
final String backdropPathColumn = 'backdropPathColumn';
final String originalLanguageColumn = 'originalLanguageColumn';
final String originalTitleColumn = 'originalTitleColumn';
final String overviewColumn = 'overviewColum';
final String popularityColumn = 'popularityColumn';
final String posterPathColumn = "posterPathColumn";
final String releaseDateColumn = 'releaseDateColumn';
final String titleColumn = 'titleColumn';
final String voteAverageColumn = 'voteAverageColumn';
final String voteCountColumn = 'voteCountColumn';
final String videoColumn = 'videoColumn';

class MovieHelper {
  static final MovieHelper _instance = MovieHelper.internal();

  factory MovieHelper() => _instance;
  MovieHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'movies.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute('CREATE TABLE $movieTable($idColumn INTEGER PRIMARY KEY,'
          '$adultColumn INTEGER,'
          '$backdropPathColumn TEXT,'
          '$overviewColumn TEXT,'
          '$originalLanguageColumn TEXT,'
          '$originalTitleColumn TEXT,'
          '$popularityColumn REAL,'
          '$posterPathColumn TEXT,'
          '$releaseDateColumn TEXT,'
          '$titleColumn TEXT,'
          '$voteAverageColumn REAL,'
          '$voteCountColumn INTEGER,'
          '$videoColumn INTEGER)');
    });
  }

  Future<void> saveMovie(MovieDetail movie) async {
    Database dbMovie = await db;
    await dbMovie.insert(movieTable, {
      '$idColumn': movie.id,
      '$adultColumn': castBooltoInt(movie.adult),
      '$backdropPathColumn': movie.backdropPath,
      '$overviewColumn': movie.overview,
      '$originalLanguageColumn': movie.originalLanguage,
      '$originalTitleColumn': movie.originalTitle,
      '$popularityColumn': movie.popularity,
      '$posterPathColumn': movie.posterPath,
      '$releaseDateColumn':
          DateFormat('dd-MM-yyyy - hh:mm').format(movie.releaseDate),
      '$titleColumn': movie.title,
      '$voteCountColumn': movie.voteCount,
      '$videoColumn': castBooltoInt(movie.video),
      '$voteAverageColumn': movie.voteAverage,
    });
  }

  int castBooltoInt(dynamic boolean) {
    if (boolean == null && boolean == false) {
      return 0;
    } else {
      return 1;
    }
  }

  Future<Movie> getMovie(int id) async {
    Database dbMovie = await db;
    List<Map> maps = await dbMovie.query(movieTable,
        columns: [
          idColumn,
          adultColumn,
          backdropPathColumn,
          originalLanguageColumn,
          originalTitleColumn,
          popularityColumn,
          posterPathColumn,
          overviewColumn,
          releaseDateColumn,
          titleColumn,
          videoColumn,
          voteAverageColumn,
          voteCountColumn,
        ],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Movie.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteMovie(int id) async {
    Database dbMovie = await db;
    return await dbMovie
        .delete(movieTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> updateMovie(MovieDetail movie) async {
    Database dbMovie = await db;
    return await dbMovie.update(movieTable, {'id': movie.id},
        where: '$idColumn = ?', whereArgs: [movie.id]);
  }

  Future<List> getAllMovies() async {
    Database dbMovie = await db;
    List listMap = await dbMovie.rawQuery('SELECT * FROM $movieTable');
    List<Movie> listMovie = [];
    for (Map m in listMap) {
      print(m);
      listMovie.add(Movie.fromMap(m));
    }
    return listMovie;
  }

  Future getNumber() async {
    Database dbMovie = await db;
    return Sqflite.firstIntValue(
        await dbMovie.rawQuery('SELECT COUNT(*) FROM $movieTable'));
  }

  Future close() async {
    Database dbMovie = await db;
    dbMovie.close();
  }
}

Movie movieFromJson(String str) => Movie.fromJson(json.decode(str));

class Movie {
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  dynamic posterPath;
  DateTime releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Movie({
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"],
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "adult": adult,
        "backdrop_path": backdropPath,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  Map<String, dynamic> toColumnMap() => {
        "id": id,
        "adult": adult,
        "backdrop_path": backdropPath,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  Movie.fromMap(Map map) {
    id = map[idColumn];
    adult = castInttoBool(map[adultColumn]);
    backdropPath = map[backdropPathColumn];
    originalLanguage = map[originalLanguageColumn];
    originalTitle = map[originalTitleColumn];
    overview = map[overviewColumn];
    popularity = map[popularityColumn] as double;
    posterPath = map[posterPathColumn];
    releaseDate =
        DateFormat("dd-MM-yyyy - hh:mm").parse(map[releaseDateColumn]);
    title = map[titleColumn];
    video = castInttoBool(map[videoColumn]);
    voteAverage = map[voteAverageColumn] as double;
    voteCount = map[voteCountColumn] as int;
  }

  bool castInttoBool(dynamic integer) {
    if (integer == 0) {
      return false;
    } else {
      return true;
    }
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      adultColumn: adult,
      backdropPathColumn: backdropPath,
      originalLanguageColumn: originalLanguage,
      originalTitleColumn: originalTitle,
      overviewColumn: overview,
      popularityColumn: popularity,
      posterPathColumn: posterPath,
      releaseDateColumn: releaseDate,
      titleColumn: title,
      videoColumn: video,
      voteAverageColumn: voteAverage,
      voteCountColumn: voteCount,
    };
    return map;
  }
}
