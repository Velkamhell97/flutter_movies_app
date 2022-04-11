import 'package:flutter/material.dart';
import 'dart:async';

import '../models/models.dart';
import '../services/moviedb_service.dart';

class MovieProvider extends ChangeNotifier {
  final MoviedbService _api;
  static const _httpError = 'There was an error, please check your internet connection';

  //-A pesar de que solo se utiliza un stream si no le ponemos el broadcast tendremos que
  //-reinicializarlo cada vez que entramos al search delegate cuando se entra y se sale
  //-por esta razon se deja el broadcast
  final StreamController<List<Movie>?> _suggestionStreamController = StreamController.broadcast();
  late final Stream<List<Movie>?> suggestionStream;
  
  MovieProvider(this._api) {
    suggestionStream = _suggestionStreamController.stream.distinct();
    
    Future.wait<void>([
      getRecentMovies(),
      getPopularMovies(),
      getTopRnakedMovies()
    ]);
  }

  bool _darkMode = false;
  bool get darkMode => _darkMode;
  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }

  @override
  void dispose() {
    _suggestionStreamController.close();
    super.dispose();
  }

  MoviesState onDisplayMovies = const MoviesState();
  MoviesState popularMovies = const MoviesState();
  MoviesState topRankedMovies = const MoviesState();

  /// Almacena la lista de peliculas que devuelve un query
  Map<String, List<Movie>> queryCache = {};

  /// El loading inicial lo maneja el arreglo vacio de peliculas, luego si ocurre un error el loading lo
  /// notificamos y lo maneja el widget LoadingBuilder
  Future<void> getRecentMovies() async {
    /// A pesar que no se utilizan la pagina en esta categoria se deja similar a las demas
    onDisplayMovies = onDisplayMovies.fetchingState();

    /// Solo si existe esta llamando por un reload (error) notificamos para mostrar el loading
    /// con esto el loading inicial aun seguiria a cargo de la lista vacia
    if(onDisplayMovies.reload) notifyListeners();

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

    if(popularMovies.reload) notifyListeners();

    try {
      final movies = await _api.fetchPopularMovies(popularMovies.page);
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

    if(topRankedMovies.reload) notifyListeners();

    try {
      final movies = await _api.fetchTopRankedMovies(topRankedMovies.page);
      topRankedMovies = topRankedMovies.dataState(movies);
    } catch (e) {
      topRankedMovies = topRankedMovies.errorState(_httpError);
    } finally {
      notifyListeners();
    }
  }


  /// En el servicio se almacena el casting de los movieId a los que se va ingresando al detalle, luego
  /// si ya se entro a esta pelicula previamente se devuelve esa lista y si no se consulta en cache
  Future<List<Actor>> getMovieCast(int movieId) async {
    try {
      final cast = await _api.fetchMovieCast(movieId);
      return cast;
    } catch (e) {
      return Future.error(_httpError);
    }
  }

  /// Siempre que se escriba una letra en el search delegate agregamos un null para mostrar el loading
  /// gracias al distinc del constructor solo el primer null se esucha el resto se ignora y no redibuja
  void startSearching() {
    _suggestionStreamController.add(null);
  }


  /// Luego de buscar las peliculas por ese query se almacenan en cache por si vuelve a utilizar ese query
  /// antes de ejecutar este metodo se chequea que el query no este en la lista de cache para evitar que 
  /// se guarde de nuevo
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
