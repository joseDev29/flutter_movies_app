import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';

class MovieSlider extends StatefulWidget {
  final String? title;
  final List<Movie> movies;
  final Function onNextPage;
  final MovieLists listType;

  const MovieSlider(
      {Key? key,
      this.title,
      required this.movies,
      required this.onNextPage,
      required this.listType})
      : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  //Se ejecuta al inicializar el widget
  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      //position.pixels retorna la posicion actual y posicion.maxScrollExtent
      //retorna la posicion maxima a la que puede llegar en base al contenido

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage(widget.listType);
      }
    });
  }

  //Se ejecuta al destruir el widget
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.title!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          const SizedBox(height: 8),
          Expanded(
              child: widget.movies.isEmpty
                  ? const _Loading(height: 260)
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: widget.movies.length,
                      //Determina la direccion del scroll
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, int index) =>
                          _MoviePoster(movie: widget.movies[index])))
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  const _MoviePoster({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',
                arguments: 'movie-data'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg)),
            ),
          ),
          //TextOverflow.ellipsis corta el texto en caso de que se desborde y agrega ...
          const SizedBox(height: 5),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  final double height;
  const _Loading({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
