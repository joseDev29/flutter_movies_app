import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/models.dart';

enum MovieLists { onDisplayMovies, popularMovies }
enum ListOption { totalPages, page, loading, data, endpoint, title }

class MoviesProvider extends ChangeNotifier {
  static const _baseURL = 'api.themoviedb.org';
  static const _apiKey = '';
  static const _languaje = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  final Map<MovieLists, List<Movie>> movieLists = {
    MovieLists.popularMovies: [],
    MovieLists.onDisplayMovies: []
  };

  final Map<MovieLists, Map<ListOption, dynamic>> movieListsParameters = {
    MovieLists.popularMovies: {
      ListOption.title: 'Popular Movies',
      ListOption.endpoint: '/3/movie/popular',
      ListOption.totalPages: 1,
      ListOption.loading: false,
      ListOption.page: 0
    },
    MovieLists.onDisplayMovies: {
      ListOption.title: 'On Display Movies',
      ListOption.endpoint: '/3/movie/now_playing',
      ListOption.totalPages: 1,
      ListOption.loading: false,
      ListOption.page: 0
    }
  };

  MoviesProvider() {
    getMovies(MovieLists.onDisplayMovies);
    getMovies(MovieLists.popularMovies);
  }

  Future<String> _requestData({required String endpoint, int page = 1}) async {
    Uri url = Uri.https(_baseURL, endpoint,
        {'api_key': _apiKey, 'languaje': _languaje, 'page': '$page'});

    final response = await http.get(url);

    return response.body;
  }

  void getMovies(MovieLists movieList) async {
    final parameters = movieListsParameters[movieList];

    if (parameters?[ListOption.loading] == true) return;

    if (parameters?[ListOption.page] >= parameters?[ListOption.totalPages]) {
      return;
    }

    parameters?[ListOption.page]++;
    parameters?[ListOption.loading] = true;
    notifyListeners();

    final responseBody = await _requestData(
        endpoint: parameters?[ListOption.endpoint],
        page: parameters?[ListOption.page]);

    final data = PopularsResponse.fromJson(responseBody);

    parameters?[ListOption.loading] = false;
    parameters?[ListOption.totalPages] = data.totalPages;
    movieLists[movieList] = [...?movieLists[movieList], ...data.results];
    //Notifica a los widgets conectados que la data cambio
    notifyListeners();
  }
}
