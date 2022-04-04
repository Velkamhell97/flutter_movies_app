import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../search/search_delegate.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // print('Home Screen Built');

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      //------------------------
      // AppBar
      //------------------------
      appBar: AppBar(
        title: Text('Peliculas en cine'),
        elevation: 0,
        actions: [
          Selector<MovieProvier, bool>(
            selector: (_, model) => model.darkMode,
            builder: (_, darkMode, __) => IconButton(
              onPressed: () => context.read<MovieProvier>().darkMode = !darkMode, 
              icon: darkMode ? Icon(Icons.light_mode) : Icon(Icons.dark_mode)
            ),
          ),

          IconButton(
            onPressed: () => showSearch(
              context: context, 
              delegate: MovieSearchDelegate(context.read<MovieProvier>())
            ), 
            icon: Icon(Icons.search_outlined)
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
            Selector<MovieProvier, MoviesState>(
              selector: (_, model) => model.onDisplayMovies,
              builder: (x_, recentsState, __) => CardSwiper(moviesState: recentsState),
            ),

            _Categoria('Populares'),

            Selector<MovieProvier, MoviesState>(
              selector: (_, model) => model.popularMovies,
              builder: (_, popularsState, __) => MovieSlider(
                moviesState: popularsState, 
                onNextPage: () => context.read<MovieProvier>().getPopularMovies(), 
                label: 'populares' //-Para los hero id
              ),
            ),

            _Categoria('Destacadas'),

            Selector<MovieProvier, MoviesState>(
              selector: (_, model) => model.topRankedMovies,
              builder: (_, rankedsState, __) => MovieSlider(
                moviesState: rankedsState, 
                onNextPage: () => context.read<MovieProvier>().getTopRnakedMovies(), 
                label: 'destacadas'
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
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Text(nombre, textAlign: TextAlign.start, style: _style),
    );
  }
}