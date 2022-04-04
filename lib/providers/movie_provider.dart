import 'package:flutter/material.dart';
import 'dart:async';

import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/services/moviedb_service.dart';

class MovieProvier extends ChangeNotifier {
  final MoviedbService _api;
  static const _httpError = 'There was an error, please check your internet connection';

  //-A pesar de que solo se utiliza un stream si no le ponemos el broadcast tendremos que
  //-reinicializarlo cada vez que entramos al search delegate cuando se entra y se sale
  //-por esta razon se deja el broadcast
  final StreamController<List<Movie>?> _suggestionStreamController = StreamController.broadcast();
  late final Stream<List<Movie>?> suggestionStream;
  
  MovieProvier(this._api) {
    suggestionStream = _suggestionStreamController.stream.distinct();
    initMovies();
  }

  bool _darkMode = false;
  bool get darkMode => _darkMode;
  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }

  void initMovies() async {
    Future.wait<void>([
      getRecentMovies(),
      getPopularMovies(),
      getTopRnakedMovies()
    ]);
  }

  @override
  void dispose() {
    _suggestionStreamController.close();
    super.dispose();
  }

  MoviesState onDisplayMovies = MoviesState();
  MoviesState popularMovies = MoviesState();
  MoviesState topRankedMovies = MoviesState();

  Map<String, List<Movie>> queryCache = {};

  Future<void> getRecentMovies() async {
    try {
      final movies = await _api.fetchRecentMovies();
      onDisplayMovies = onDisplayMovies.dataState(movies);
    } catch (e) {
      onDisplayMovies = onDisplayMovies.errorState(_httpError);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getPopularMovies() async {
    if(popularMovies.fetching) return;

    popularMovies = popularMovies.fetchingState();

    try {
      final movies = await _api.fetchPopularMovies();
      popularMovies = popularMovies.dataState(movies);
    } catch (e) {
      popularMovies = popularMovies.errorState(_httpError);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getTopRnakedMovies() async {
    if(topRankedMovies.fetching) return;

    topRankedMovies = topRankedMovies.fetchingState();

    try {
      final movies = await _api.fetchTopRankedMovies();
      topRankedMovies = topRankedMovies.dataState(movies);
    } catch (e) {
      topRankedMovies = topRankedMovies.errorState(_httpError);
    } finally {
      notifyListeners();
    }
  }

  Future<List<Actor>> getMovieCast(int movieId) async {
    try {
      final cast = await _api.fetchMovieCast(movieId);
      return cast;
    } catch (e) {
      return Future.error(_httpError);
    }
  }

  void startSearching() {
    _suggestionStreamController.add(null);
  }

  Future<void> searchMovie(String query) async {
    try {
      final movies = await _api.fetchMovieByQuery(query);

      queryCache[query] = movies;

      _suggestionStreamController.add(movies);
    } catch (e) {
      _suggestionStreamController.addError(_httpError);
    }
  }
}
