import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:movies_app/models/movie.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiper({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Obtenemos las medidas de pantalla
    final size = MediaQuery.of(context).size;

    if (movies.isEmpty) return _Loading(size: size);

    return SizedBox(
      //Hace que el container tome todo el ancho posible
      //basado en su padre
      width: double.infinity,
      //El height sera del 50% de la medida de la pantalla
      height: size.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.45,
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',
                arguments: 'movie-data'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                  //cover permite que la imagen se acople a su contanedor
                  //y asi denotar el border radicus del ClipRRect
                  fit: BoxFit.cover,
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg)),
            ),
          );
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  final Size size;
  const _Loading({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
