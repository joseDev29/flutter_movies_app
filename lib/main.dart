import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_movies_app/environment/Environment.dart';
import 'package:flutter_movies_app/providers/movies_provider.dart';

import 'package:flutter_movies_app/views/views.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MoviesProvider(),
          // Deshabilitar la propiedad lazy
          // hace que la instancia de MoviesProvider
          // sea creada al momento de iniciar la app
          // De lo contrario se crearia hasta que un widget la solicitara
          lazy: false,
        )
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.cyan.shade600,
          elevation: 0,
        ),
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomeView(),
        'details': (context) => const DetailsView()
      },
    );
  }
}
