import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_movies_app/utils/debouncer.dart';
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

  Map<int, List<CastPerson>> moviesCast = {};

  int _popularsPage = 0;
  int _popularsTotalPages = 1;
  bool _popularsLoading = false;

  final List<String> _imageErrors = ['/7uEh9kpQWJgaebgPXVCPf88wsFe.jpg'];

  final debouncer =
      Debouncer<String>(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionsStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionsStream {
    return _suggestionsStreamController.stream;
  }

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

  bool isImageError(imagePath) {
    final searchResult = _imageErrors.singleWhere(
      (imgErr) => imgErr == imagePath,
      orElse: () => 'NOT_FOUND',
    );
    return searchResult != 'NOT_FOUND';
  }

  Future<void> getOnDisplayMovies() async {
    final responseBody = await _getJsonMoviesData('/3/movie/now_playing');
    final NowPlayingResponse data = NowPlayingResponse.fromJson(responseBody);
    nowPlayingMovies = data.results;
    notifyListeners();
  }

  Future<void> getPopularMovies() async {
    if (_popularsLoading || _popularsPage == _popularsTotalPages) return;

    _popularsPage++;
    _popularsLoading = true;

    // debugPrint('Page: $_popularsPage');

    final responseBody =
        await _getJsonMoviesData('/3/movie/popular', _popularsPage);
    final PopularsResponse data = PopularsResponse.fromJson(responseBody);

    final filteredData = data.results.where(
      (movie) => !isImageError(movie.posterPath),
    );

    popularMovies = [...popularMovies, ...filteredData];

    _popularsTotalPages = data.totalPages;
    _popularsLoading = false;

    notifyListeners();
  }

  Future<List<CastPerson>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final responseBody = await _getJsonMoviesData('/3/movie/$movieId/credits');
    final MovieCreditsResponse data =
        MovieCreditsResponse.fromJson(responseBody);

    moviesCast[movieId] = data.cast;

    return moviesCast[movieId]!;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final Uri url = Uri.https(
      _apiBaseUrl,
      '/3/search/movie',
      {'api_key': _apiKey, 'language': _language, 'query': query},
    );

    final http.Response response = await http.get(url);
    final SearchMovieResponse data =
        SearchMovieResponse.fromJson(response.body);

    return data.results;
  }

  void getSuggestionsByQuery(String query) {
    debouncer.onValue = (value) async {
      debugPrint('onValue: $value');
      if (value.isEmpty) {
        return _suggestionsStreamController.add([]);
      }
      final results = await searchMovie(value);
      _suggestionsStreamController.add(results);
    };

    debouncer.nextValue(query);
  }
}
