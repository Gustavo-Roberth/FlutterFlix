import 'package:flutter/material.dart';
import 'package:flutter_flix/controllers/movie_detail_controller.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  MovieDetailPage(this.movieId);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final _controller = MovieDetailController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  _initialize() async {
    setState(() {
      _controller.loading = true;
    });

    await _controller.fetchMovieById(widget.movieId);

    setState(() {
      _controller.loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_controller.movieDetail?.title ?? ''),
          actions: [],
        ),
        body: ListView(
          children: [
            Image.network(
                'https://image.tmdb.org/t/p/w500${_controller.movieDetail.backdropPath}'),
            Column(children: [
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                      'Título original: ${_controller.movieDetail.originalTitle}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17.0))),
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                      'Idioma Original: ${_controller.movieDetail.originalLanguage}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17.0))),
              Padding(
                  padding: EdgeInsets.fromLTRB(6.0, 20.0, 10.0, 10.0),
                  child: Text(_controller.movieDetail.overview,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 17.0))),
            ]),
          ],
        ));
  }
}
