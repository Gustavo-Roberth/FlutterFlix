import 'package:flutter/material.dart';

import 'package:flutter_flix/controllers/movie_controller.dart';
import 'package:flutter_flix/models/movie_model.dart';
import 'package:flutter_flix/pages/movie_detail_page.dart';
import 'package:intl/intl.dart';

// Tela de Minha Lista de filmes favoritos
// Todos os filmes favoritos adicionados na lista são apresentados em cards
class MyListPage extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

// Constroe a estrutura da tela da Minha Lista de filmes favoritos
class _MyListState extends State<MyListPage> {
  final _controller = MovieController();
  int lastPage = 1;

  MovieHelper helper = MovieHelper();

  List<Movie> movies = [];

// Força a inicialização da página com os dados relevantes
// override para construção da inicialização do Scroll infinito de cards, e carregamento dos dados a serem apresentados
  @override
  void initState() {
    super.initState();
    _initialize();
  }

// Carrega os dados dos campo da tela da Minha Lista de favoritos e atributos dos ícones interativos
  _initialize() async {
    setState(() {
      _controller.loading = true;
    });

    _getAllMovies();

    setState(() {
      _controller.loading = false;
    });
  }

// Chamada da barra superior e corpo do app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _buildMovieCard(context, index);
          }),
    );
  }

// Constroe a barra superior com nome da página ou app e ícones interativos
  _buildAppBar() {
    return AppBar(
      title: Text('Minha Lista'),
      actions: [
        IconButton(
          icon: Icon(Icons.delete, color: Colors.white),
          onPressed: _deleteWishList,
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: _initialize,
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat('dd/MM/yyyy').format(time);
  }

// Constroe o corpo da página com os cards dos filmes contidos na lista de favoritos
  Widget _buildMovieCard(BuildContext context, int index) {
    final double maxWidth = MediaQuery.of(context).size.width * 0.68;
    return GestureDetector(
      child: Card(
          child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Row(children: <Widget>[
                Container(
                  width: 80.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: movies[index].posterPath != null
                            ? NetworkImage(
                                'https://image.tmdb.org/t/p/w220_and_h330_face/${movies[index].posterPath}')
                            : AssetImage("assets/images/poster.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                            '${movies[index].title}' ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 19.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(7.0, 7.0, 7.0, 6.0),
                          child: Row(
                            children: [
                              Container(
                                constraints: BoxConstraints(maxWidth: maxWidth),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 3.0),
                                      child: Icon(
                                        Icons.favorite,
                                        size: 14.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        '${movies[index].voteAverage}' ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(maxWidth: maxWidth),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 3.0),
                                      child: Icon(
                                        Icons.access_time,
                                        size: 14.0,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        '${_formatTime(movies[index].releaseDate)}' ??
                                            "",
                                        style: TextStyle(fontSize: 12.0),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          padding: EdgeInsets.only(right: 13.0),
                          child: Text(
                            '${movies[index].overview}' ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]))),
      onTap: () {
        _openDetailPage(movies[index].id);
      },
    );
  }

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
  }

// Realiza a atualização de todos os filmes na estrutura de lista de favoritos
  void _getAllMovies() {
    helper.getAllMovies().then((list) {
      setState(() {
        movies = list;
      });
    });
  }

// Realiza a deleção de todos os filmes na estrutura de lista de favoritos
  void _deleteWishList() {
    if (movies != null) {
      for (Movie movie in movies) {
        helper.deleteMovie(movie.id);
      }
      _getAllMovies();
    }
  }
}
