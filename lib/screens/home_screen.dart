import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Obtenemos MoviesProvider del context
    //listen permite que el widget se redibuje al llamar el notifyListenners
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
          //centerTitle: true,
          title: const Text('Movies'),
          actions: [
            IconButton(
                icon: const Icon(Icons.search_outlined), onPressed: () {})
          ],
          elevation: 0),
      //Permite hacer scroll
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CardSwiper(
                movies: moviesProvider.movieLists[MovieLists.onDisplayMovies] ??
                    []),
            MovieSlider(
                title: 'Populars',
                movies:
                    moviesProvider.movieLists[MovieLists.popularMovies] ?? [],
                onNextPage: moviesProvider.getMovies,
                listType: MovieLists.popularMovies)
          ],
        ),
      ),
    );
  }
}
