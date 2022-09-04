import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_movies_app/environment/environment.dart';
import 'package:flutter_movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = dotenv.get(EnvKeys.tmdbApiKey);
  final String _apiBaseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];

  int _popularsPage = 0;
  bool _popularsLoading = false;

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonMoviesData(String path, [int page = 1]) async {
    final Uri url = Uri.https(
      _apiBaseUrl,
      path,
      {'api_key': _apiKey, 'language': _language, 'page': '$page'},
    );

    final http.Response response = await http.get(url);
    return response.body;
  }

  Future<void> getOnDisplayMovies() async {
    final responseBody = await _getJsonMoviesData('/3/movie/now_playing');
    final NowPlayingResponse data = NowPlayingResponse.fromJson(responseBody);
    nowPlayingMovies.addAll(data.results);
    notifyListeners();
  }

  Future<void> getPopularMovies() async {
    if (_popularsLoading) return;

    _popularsPage++;
    _popularsLoading = true;

    final responseBody =
        await _getJsonMoviesData('/3/movie/popular', _popularsPage);
    final PopularsResponse data = PopularsResponse.fromJson(responseBody);

    popularMovies.addAll(data.results);

    _popularsLoading = false;

    notifyListeners();
  }
}
