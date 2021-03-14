import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flix/controllers/movie_controller.dart';
import 'package:flutter_flix/errors/movie_error.dart';
import 'package:flutter_flix/models/model_response.dart';
import 'package:flutter_flix/models/movie_model.dart';
import 'package:flutter_flix/pages/movie_detail_page.dart';
import 'package:intl/intl.dart';

// Tela de busca por filmes
// Todos os filmes relacionados a busca são apresentados em cards resumidos
// Constroe a estrutura da tela dde busca
class SearchPage extends SearchDelegate<Movie> {
  @override
  String get searchFieldLabel => 'Pesquise aqui...';

// Constroe a ação do botão de apagar todo o texto do campo de pesquisa
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

// Constroe a ação do botão de voltar para a página anterior
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }

// Constroe o corpo da tela com os resultados da pesquisa obtida com o texto do campo de pesquisa
  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().length == 0) {
      return Padding(
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
        child: Text('Não há nada para pesquisar...',
            style: TextStyle(color: Colors.grey)),
      );
    }

    MovieController countryService = new MovieController();
    return FutureBuilder<Either<MovieError, MovieResponse>>(
      future: countryService.searchMovies(query),
      // ignore: missing_return
      builder: (_, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError || snapshot.error != null) {
          return ListTile(
              title: Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
                  child: Text('Sem resultados...',
                      style: TextStyle(color: Colors.grey))));
        }

        if (snapshot.hasData) {
          final movies = countryService.movies;
          // envia o encapsulamento da lista de filmes para a pagina de busca
          return _showMovies(context, movies);
        } else {
          // Círculo de processo de carregando
          return Center(child: CircularProgressIndicator(strokeWidth: 4));
        }
      },
    );
  }

// Constroe a tela com sugesões relacionadas ao obtido no campo de pesquisa
  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('');
  }

  String _formatTime(DateTime time) {
    return DateFormat('dd/MM/yyyy').format(time);
  }

// Constroe a exibição de cards dos filmes obtidos nos resultados
  Widget _showMovies(BuildContext context, List<Movie> movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (_, i) {
        final movie = movies[i];

        return Padding(
            padding: EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 5.0),
            child: ListTile(
              leading: movie.posterPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w220_and_h330_face/${movie.posterPath}',
                    )
                  : Image.asset('images/posters/poster1.png'),
              title: Container(
                child: Padding(
                    padding: EdgeInsets.only(top: 1.0, bottom: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${movie.title}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold))
                        ])),
              ),
              subtitle: Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.0, left: 6.0),
                              child: Icon(
                                Icons.favorite,
                                size: 13.0,
                                color: Colors.red,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 12.0),
                                child: Text(
                                  '${movie.voteAverage}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                )),
                            Padding(
                              padding: EdgeInsets.only(right: 8.0, left: 6.0),
                              child: Icon(
                                Icons.access_time,
                                size: 13.0,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '${_formatTime(movie.releaseDate)}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                print(movie.title);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new MovieDetailPage(
                      movie.id,
                    ),
                  ),
                );
              },
            ));
      },
    );
  }
}
