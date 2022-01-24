import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/screens/screens.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Permite tener multiples providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            //lazy define si el provider se crea al iniciar la app o hasta que se necesite
            create: (context) => MoviesProvider(),
            lazy: false)
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mover',
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomeScreen(),
        'details': (context) => const DetailsScreen()
      },
      //ThemeData permite aplicar un tema a la aplicacion
      //ya sea uno por defecto o un tema custom
      //En este caso estamos generando una copia
      //del tema por defecto light y modificando
      //algunos de sus paramtros como el backgroundColor de las appBar
      theme: ThemeData.light().copyWith(
          appBarTheme:
              AppBarTheme(backgroundColor: Colors.pinkAccent.shade400)),
    );
  }
}
