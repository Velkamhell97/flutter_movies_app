import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/models.dart';

class MoviedbService {
  final _apiKey = dotenv.env['MOVIEDB_API_KEY']!;
  static const _urlBase = 'api.themoviedb.org';
  static const _language = 'es-ES';

  Map<int, List<Actor>> castCache = {};

  Future<dynamic> _fetchResponse(String endpoint, [int page = 1]) async {
    final url = Uri.https(_urlBase, endpoint, {'api_key': _apiKey, 'language': _language, 'page': '$page'});
    
    final response = await http.get(url);
    
    return json.decode(response.body);
  }


  Future<List<Movie>> fetchRecentMovies() async {
    final jsonData = await _fetchResponse('3/movie/now_playing');

    final nowPlayingResponse = MoviesResponse.fromJson(jsonData, 'now_playing');

    return nowPlayingResponse.results;
  }


  Future<List<Movie>> fetchPopularMovies(int page) async {
    final jsonData = await _fetchResponse('3/movie/popular', page);

    final popularResponse = MoviesResponse.fromJson(jsonData, 'popular');

    return popularResponse.results;
  }


  Future<List<Movie>> fetchTopRankedMovies(int page) async {
    final jsonData = await _fetchResponse('3/movie/top_rated', page);

    final topRankedResponse = MoviesResponse.fromJson(jsonData, 'top_ranked');

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
    final url = Uri.https(_urlBase, '3/search/movie', {'api_key': _apiKey, 'language': _language, 'query': query});

    final jsonData = await http.get(url);
    
    final searchResponse = MoviesResponse.fromJson(json.decode(jsonData.body), 'search');

    return searchResponse.results;
  }
}