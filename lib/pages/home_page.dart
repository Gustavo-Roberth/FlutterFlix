import 'package:flutter/material.dart';
import 'package:flutter_flix/controllers/movie_controller.dart';
import 'package:flutter_flix/core/constant.dart';
import 'package:flutter_flix/models/movie_model.dart';
import 'package:flutter_flix/pages/movie_detail_page.dart';
import 'package:flutter_flix/pages/mylist_page.dart';
import 'package:flutter_flix/widgets/movie_card.dart';

// Tela principal
// Todos os filmes populares são apresentados aqui
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// Constroe a estrutura da tela principal
class _HomePageState extends State<HomePage> {
  final _controller = MovieController();
  final _scrollController = ScrollController();
  int lastPage = 1;

  MovieHelper helper = MovieHelper();
  List<Movie> movies = [];

  Icon _iconMylist = Icon(Icons.favorite_border, color: Colors.white);

// Força a inicialização da página com os dados relevantes
// override para construção da inicialização do Scroll infinito de cards, e carregamento dos dados a serem apresentados
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

    _getAllMovies();
    _iconMyListColor();

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
          icon: _iconMylist,
          onPressed: () {
            _openMyListPage();
          },
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

  // Constroe o card de filme do Grid da Tela principal
  Widget _buildMovieCard(BuildContext context, int index) {
    final movie = _controller.movies[index];
    return MovieCard(
      posterPath: movie.posterPath,
      onTap: () => _openDetailPage(movie.id),
    );
  }

// Navegador para a Tela de detalhes do filme contido no GRID
// A Navegação acontece com ação de pressionamento no Card do Grid
  _openDetailPage(int movieId) async {
    final bool deleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movieId),
      ),
    );
    if (deleted == true) {
      movies.removeAt(movieId);
    }
    _getAllMovies();
    _iconMyListColor();
  }

// Navegador para a Tela de Minha Lista de filmes favoritos contidos no Grid da Tela Principal
// A Navegação acontece com ação de clique no ícone da Barra Superior
  void _openMyListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyListPage(),
      ),
    );
    _getAllMovies();
    _iconMyListColor();
  }

// Configura so atributos do ícone da Lista de filmes favoritos da Tela Principal
  void _iconMyListColor() {
    if (movies.length > 0) {
      setState(() {
        _iconMylist = Icon(Icons.favorite, color: Colors.amber);
      });
    } else {
      setState(() {
        _iconMylist = Icon(Icons.favorite_border, color: Colors.white);
      });
    }
  }

// Realiza a atualização de todos os filmes na estrutura de lista de favoritos
  void _getAllMovies() {
    helper.getAllMovies().then((list) {
      setState(() {
        movies = list;
      });
    });
  }
}
