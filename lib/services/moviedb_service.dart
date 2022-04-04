import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';

class MoviedbService {
  String _apiKey = 'f16776151abea9d2874e39255731fc60';
  String _urlBase = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularPage = 0;
  int _topRankedPage = 0;

  Map<int, List<Actor>> castCache = {};

  Future<dynamic> _fetchResponse(String endpoint, [int page = 1]) async {
    final url = Uri.https(_urlBase, endpoint, {'api_key': _apiKey, 'language': _language, 'page': '$page'});
    
    final response = await http.get(url);
    
    return json.decode(response.body);
  }

  Future<List<Movie>> fetchRecentMovies() async {
    final jsonData = await _fetchResponse('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    return nowPlayingResponse.results;
  }

  Future<List<Movie>> fetchPopularMovies() async {
    _popularPage++;

    final jsonData = await _fetchResponse('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromJson(jsonData);

    return popularResponse.results;
  }

  Future<List<Movie>> fetchTopRankedMovies() async {
    _topRankedPage++;

    final jsonData = await _fetchResponse('3/movie/top_rated', _topRankedPage);

    final topRankedResponse = TopRankedResponse.fromJson(jsonData);

    return topRankedResponse.results;
  }

  Future<List<Actor>> fetchMovieCast(int movieId) async {
    if (castCache.containsKey(movieId)) {
      return castCache[movieId]!;
    }

    final jsonData = await _fetchResponse('3/movie/$movieId/credits');
    final creditsResponse = CreditResponse.fromJson(jsonData);

    castCache[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> fetchMovieByQuery(String query) async {
    final url = Uri.https(_urlBase, '3/search/movie', {'api_key': _apiKey, 'language': _language, 'query': '$query'});

    final jsonData = await http.get(url);
    
    final searchResponse = SearchMovieResponse.fromJson(json.decode(jsonData.body));

    return searchResponse.results;
  }
}