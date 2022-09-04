import 'package:flutter/material.dart';

import 'package:flutter_movies_app/models/models.dart';
import 'package:flutter_movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear_outlined),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        // close(context, searchResult)
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('Build result');
  }

  Widget _EmptyContainer() {
    return const Center(
      child: Icon(
        Icons.movie_creation_outlined,
        color: Colors.black38,
        size: 130,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return _EmptyContainer();

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.searchMovie(query),
      builder: ((context, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.isEmpty) return _EmptyContainer();

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final movie = snapshot.data![index];
            movie.heroId = 'search-${movie.id}';
            return ListTile(
              leading: Hero(
                tag: movie.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: FadeInImage(
                    width: 35,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage('assets/no-image.jpg'),
                    image: NetworkImage(movie.posterUrl),
                  ),
                ),
              ),
              title: Text(movie.title),
              subtitle: Text(movie.originalTitle),
              onTap: () {
                Navigator.pushNamed(context, 'details', arguments: movie);
              },
            );
          },
        );
      }),
    );
  }
}
