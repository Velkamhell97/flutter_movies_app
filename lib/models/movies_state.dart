import 'package:equatable/equatable.dart';

import '../models/models.dart';

class MoviesState extends Equatable {
  final List<Movie> movies;
  final int page;
  final String? error;
  final bool fetching;
  final bool reload;

  const MoviesState({
    this.movies = const [], 
    this.page = 0,
    this.fetching = false, 
    this.error, 
    this.reload = false
  });

  MoviesState copyWith({
    List<Movie>? movies,
    int? page,
    bool? fetching, 
    String? error, 
    bool clear = false,
    bool? reload
  }){
    return MoviesState(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      fetching: fetching ?? this.fetching,
      error: clear ? null : error ?? this.error,
      reload: reload ?? this.reload
    );
  }

  /// Aqui se limpian los errores por lo que el reload sirve para saber si hay un error previo
  MoviesState fetchingState() {
    return copyWith(page: page + 1, fetching: true, clear: true);
  }

  /// Cuando se traen los datos el reload vuelve a false
  MoviesState dataState(List<Movie> newMovies){
    final movies = [...this.movies, ...newMovies];
    return copyWith(movies: movies, fetching: false, reload: false);
  }

  /// Si hay un error se muestra y se pone el reload en true para que en siguiente fetch se muestre el loading
  MoviesState errorState(String error) => copyWith(error: error, fetching: false, page: page - 1, reload: true);

  @override
  /// Unicas propiedades que generan un cambio en el UI
  List<Object?> get props => [movies, fetching, error];
}