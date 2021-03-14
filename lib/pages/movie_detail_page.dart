import 'package:flutter/material.dart';
import 'package:flutter_flix/controllers/movie_detail_controller.dart';
import 'package:flutter_flix/models/movie_model.dart';
import 'package:flutter_flix/widgets/centered_message.dart';
import 'package:flutter_flix/widgets/centered_progress.dart';
import 'package:flutter_flix/widgets/chip_date.dart';
import 'package:flutter_flix/widgets/rate.dart';

// Tela de detalhes de um filme
// Todos os filmes são apresentados detalhadamente e individualmente aqui
class MovieDetailPage extends StatefulWidget {
  final int movieId;

  MovieDetailPage(this.movieId);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

// Constroe a estrutura da tela de detalhes de um filme
class _MovieDetailPageState extends State<MovieDetailPage> {
  final _controller = MovieDetailController();

  MovieHelper helper = MovieHelper();
  List<int> idWishList = [];
  List<Movie> wishList = [];

  Icon _iconList = Icon(Icons.bookmark_border, color: Colors.white);

// Força a inicialização da página com os dados relevantes
// override para construção da inicialização do carregamento dos dados a serem apresentados
  @override
  void initState() {
    super.initState();
    _initialize();
  }

// Carrega os dados dos campo da tela de detalhes e atributos dos ícones interativos
  _initialize() async {
    setState(() {
      _controller.loading = true;
    });

    await _controller.fetchMovieById(widget.movieId);

    if (_controller.movieError == null) {
      Movie movie = await helper.getMovie(_controller.movieDetail.id);

      if (movie == null) {
        setState(() {
          _iconList = Icon(Icons.bookmark_border, color: Colors.white);
        });
      } else {
        print(movie.id);
        setState(() {
          _iconList = Icon(Icons.bookmark, color: Colors.amber);
        });
      }
    }

    setState(() {
      _controller.loading = false;
    });
  }

// Chamada da barra superior e corpo do app
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
      actions: [
        IconButton(
          icon: _iconList,
          onPressed: _onList,
        ),
      ],
    );
  }

// Constroe o corpo da página com uma imagem do filme e informações relevantes
  _buildMovieDetail() {
    if (_controller.loading) {
      return CenteredProgress();
    }

    if (_controller.movieError != null) {
      return CenteredMessage(message: _controller.movieError.message);
    }

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

// Realiza a construção da Minha Lista de filmes favoritos contidos no Grid da Tela Principal
// Construção e controle da lista e ícone interativo
// Ícone interativo de inserção de filmes na localizado na barra superior
  Future<void> _onList() async {
    Movie movie = await helper.getMovie(_controller.movieDetail.id);

    if (movie == null) {
      await helper.saveMovie(_controller.movieDetail);
      Movie movie2 = await helper.getMovie(_controller.movieDetail.id);
      if (movie2 != null) {
        setState(() {
          _iconList = Icon(Icons.bookmark, color: Colors.amber);
        });
      }
    } else {
      await helper.deleteMovie(_controller.movieDetail.id);
      Movie movie2 = await helper.getMovie(_controller.movieDetail.id);
      if (movie2 == null) {
        setState(() {
          _iconList = Icon(Icons.bookmark_border, color: Colors.white);
        });
      }
    }
  }
}
