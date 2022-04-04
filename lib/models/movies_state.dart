import 'package:equatable/equatable.dart';

import 'package:peliculas_app/models/models.dart';

class MoviesState extends Equatable {
  final List<Movie> movies;
  final String? error;
  final bool fetching;

  const MoviesState({this.movies = const [], this.error, this.fetching = false});

  MoviesState copyWith({List<Movie>? movies, String? error, bool? fetching, bool clear = false}){
    return MoviesState(
      movies: movies ?? this.movies,
      error: clear ? null : error ?? this.error,
      fetching: fetching ?? this.fetching,
    );
  }

  MoviesState fetchingState(){
    return MoviesState(movies: this.movies, error: null, fetching: true);
  }

  MoviesState dataState(List<Movie> movies){
    return MoviesState(movies: [...this.movies, ...movies], error: null, fetching: false);
  }

  MoviesState errorState(String error){
    return MoviesState(movies: this.movies, error: error, fetching: false);
  }

  @override
  List<Object?> get props => [movies, error];
}