import 'package:flutter/material.dart';
import 'package:flutter_flix/controllers/movie_detail_controller.dart';
import 'package:flutter_flix/widgets/chip_date.dart';
import 'package:flutter_flix/widgets/rate.dart';

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
      appBar: _buildAppBar(),
      body: _buildMovieDetail(),
    );
  }

// Constroe a barra superior com nome da página ou app e ícones interativos
  _buildAppBar() {
    return AppBar(
      title: Text(_controller.movieDetail?.title ?? ''),
      actions: [],
    );
  }

// Constroe o corpo da página com uma imagem do filme e informações relevantes
  _buildMovieDetail() {
    return ListView(
      children: [
        _buildCover(),
        _buildStatus(),
        _buildOverview(),
      ],
    );
  }

// Constroe a imagem do filme no fundo da tela
  _buildCover() {
    return Image.network(
        'https://image.tmdb.org/t/p/w500${_controller.movieDetail.backdropPath}');
  }

// Constroe ícones com informações do filme
  _buildStatus() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Rate(_controller.movieDetail.voteAverage),
          ChipDate(date: _controller.movieDetail.releaseDate),
        ],
      ),
    );
  }

// Constroe as demais informações do filmes em texto
  _buildOverview() {
    return Column(children: [
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
              textAlign: TextAlign.left, style: TextStyle(fontSize: 17.0))),
    ]);
  }
}
