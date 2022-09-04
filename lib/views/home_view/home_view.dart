import 'package:flutter/material.dart';
import 'package:flutter_movies_app/providers/movies_provider.dart';
import 'package:flutter_movies_app/search/movie_search_delegate.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // La propiedad listen le inidica al provider
    // que le notifique cada que en el provider
    // se ejecute un notifyListeners
    // en este caso nos permitira redibujar la lista
    // cada que cambien los datos en el provider
    final MoviesProvider moviesProvider =
        Provider.of<MoviesProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peliculas en cine'),
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: MovieSearchDelegate(),
            ),
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          CardSwiper(movies: moviesProvider.nowPlayingMovies),
          MovieSlider(
            title: 'Populars',
            movies: moviesProvider.popularMovies,
            onMore: () {
              moviesProvider.getPopularMovies();
            },
          ),
        ],
      ),
    );
  }
}
