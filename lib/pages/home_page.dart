import 'package:flutter/material.dart';
import 'package:flutter_flix/controllers/movie_controller.dart';
import 'package:flutter_flix/core/constant.dart';
import 'package:flutter_flix/pages/movie_detail_page.dart';
import 'package:flutter_flix/widgets/movie_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = MovieController();
  final _scrollController = ScrollController();
  int lastPage = 1;

  @override
  void initState() {
    super.initState();
    _initScrollListener();
    _initialize();
  }

// Controe o Scroll Infinito e carrega as páginas de cards
  _initScrollListener() {
    _scrollController.addListener(() async {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        if (_controller.currentPage == lastPage) {
          lastPage++;
          await _controller.fetchAllMovies(page: lastPage);
          setState(() {});
        }
      }
    });
  }

// Carrega os dados dos cards da primeira página e atributos dos ícones interativos
  _initialize() async {
    setState(() {
      _controller.loading = true;
    });

    await _controller.fetchAllMovies(page: lastPage);

    setState(() {
      _controller.loading = false;
    });
  }

// Chamada da barra superior e corpo do app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildMovieGrid(),
    );
  }

// Constroe a barra superior com nome da página ou app e ícones interativos
  _buildAppBar() {
    return AppBar(
      title: Text(kAppName),
      actions: [
        IconButton(
          icon: Icon(Icons.favorite, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: _initialize,
        ),
      ],
    );
  }

// Constroe o corpo do app com uma Grid de cards de itens
  _buildMovieGrid() {
    return GridView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      padding: const EdgeInsets.all(2.0),
      itemCount: _controller.moviesCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 0.65,
      ),
      itemBuilder: _buildMovieCard,
    );
  }

  Widget _buildMovieCard(BuildContext context, int index) {
    final movie = _controller.movies[index];
    return MovieCard(
      posterPath: movie.posterPath,
      onTap: () => _openDetailPage(movie.id),
    );
  }

  _openDetailPage(int movieId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movieId),
      ),
    );
  }
}
