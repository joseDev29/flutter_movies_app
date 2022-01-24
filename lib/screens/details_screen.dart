import 'package:flutter/material.dart';
import 'package:movies_app/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Se obtienen los argumentos que vienen en la ruta
    final String movie =
        ModalRoute.of(context)?.settings.arguments.toString() ?? 'no-movie';

    return Scaffold(
        //Los slivers son widgets con un comportamiento
        //preprogramado para reaccionar al scroll
        //del padre
        body: CustomScrollView(slivers: [
      _CustomAppBar(),
      //Sliver list permite agregar a la lista de slivers del CustomScrollView
      //Widgets que no sean slivers mediante la propiedad delegate la cual recibe
      //SliverChildListDelegate que recibe una lista de widgets
      SliverList(
          delegate: SliverChildListDelegate([
        _PosterAndTitle(),
        _Overview(),
        _Overview(),
        _Overview(),
        CastingCards()
      ]))
    ]));
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Es un AppBar mas customizable
    //y reacciona al scroll
    return SliverAppBar(
        //backgroundColor: Colors.amber,
        expandedHeight: 200,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.all(0),
            centerTitle: true,
            //Se oscurece la imagen para que el texto sea visible
            //aunque la imagen de fonof sea blanca
            title: Container(
                padding: EdgeInsets.only(bottom: 20),
                color: Colors.black12,
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child:
                    const Text('Movie title', style: TextStyle(fontSize: 16))),
            background: const FadeInImage(
              placeholder: AssetImage('assets/loading.gif'),
              image: NetworkImage('https://via.placeholder.com/500x300'),
              fit: BoxFit.cover,
            )));
  }
}

class _PosterAndTitle extends StatelessWidget {
  const _PosterAndTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Them.of permite obtener datos de la configuracion del tema global de la aplicacion
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
        margin: EdgeInsets.only(top: 24),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                  height: 150,
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage('https://via.placeholder.com/200x300')),
            ),
            SizedBox(width: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Movie title',
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2),
              Text(
                'Original title',
                style: textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.star_outline,
                      size: 16, color: Colors.yellow.shade600),
                  SizedBox(width: 4),
                  Text(
                    '4.5',
                    style: textTheme.caption,
                  )
                ],
              )
            ])
          ],
        ));
  }
}

class _Overview extends StatelessWidget {
  const _Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Occaecat nostrud labore cillum Lorem laboris. Adipisicing est enim qui est. Id incididunt culpa mollit laborum sunt sint dolore ipsum mollit eiusmod. Minim nisi laboris ex cillum officia consequat Lorem mollit voluptate magna irure. Laborum laboris adipisicing duis sit ipsum. Exercitation cillum ad dolor adipisicing enim anim cillum deserunt Lorem ullamco non culpa.',
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
