import 'package:flutter/material.dart';

import 'package:flutter_movies_app/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String title;
  final Function onMore;

  const MovieSlider({
    Key? key,
    required this.movies,
    required this.onMore,
    this.title = 'Movies',
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onMore();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 280,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 280,
      // color: Colors.yellow,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Expanded es necesario para evitar error, ya que
          // ListView.builder depende del height de su padre y
          // en este caso su padre es un Column por lo tanto su height
          // es relativo a su contenido
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                itemCount: widget.movies.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final Movie movie = widget.movies[index];

                  return Container(
                    width: 130,
                    height: 190,
                    // color: Colors.green,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            'details',
                            arguments: movie,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: FadeInImage(
                              imageErrorBuilder: (context, error, stackTrace) {
                                debugPrint('OHHH ERROR: $error');
                                return Image.asset('assets/no-image.jpg');
                              },
                              placeholder:
                                  const AssetImage('assets/no-image.jpg'),
                              image: NetworkImage(movie.posterUrl),
                              width: 130,
                              height: 190,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          movie.title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
