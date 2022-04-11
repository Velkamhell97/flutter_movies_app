import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../search/search_delegate.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('Home Screen Built');

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      //------------------------
      // AppBar
      //------------------------
      appBar: AppBar(
        title: const Text('Peliculas en cine'),
        elevation: 0,
        actions: [
          Selector<MovieProvider, bool>(
            selector: (_, model) => model.darkMode,
            builder: (_, darkMode, __) => IconButton(
              onPressed: () => context.read<MovieProvider>().darkMode = !darkMode, 
              icon: darkMode ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode)
            ),
          ),

          IconButton(
            onPressed: () => showSearch(
              context: context, 
              delegate: MovieSearchDelegate(context.read<MovieProvider>())
            ), 
            icon: const Icon(Icons.search_outlined)
          )
        ],
      ),

      //------------------------
      // Body
      //------------------------
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Selector<MovieProvider, MoviesState>(
              selector: (_, model) => model.onDisplayMovies,
              builder: (x_, recentsState, __) => CardSwiper(moviesState: recentsState),
            ),

            const _Categoria('Populares'),

            Selector<MovieProvider, MoviesState>(
              selector: (_, model) => model.popularMovies,
              builder: (_, popularsState, __) => MovieSlider(
                moviesState: popularsState, 
                onNextPage: () => context.read<MovieProvider>().getPopularMovies(), 
                onErrorTap: () => context.read<MovieProvider>().getPopularMovies(),
              ),
            ),

            const _Categoria('Destacadas'),

            Selector<MovieProvider, MoviesState>(
              selector: (_, model) => model.topRankedMovies,
              builder: (_, rankedsState, __) => MovieSlider(
                moviesState: rankedsState, 
                onNextPage: () => context.read<MovieProvider>().getTopRnakedMovies(), 
                onErrorTap: () => context.read<MovieProvider>().getPopularMovies(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Categoria extends StatelessWidget {
  final String nombre;

  const _Categoria(this.nombre, {Key? key}) : super(key: key);

  static const _style = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Text(nombre, textAlign: TextAlign.start, style: _style),
    );
  }
}