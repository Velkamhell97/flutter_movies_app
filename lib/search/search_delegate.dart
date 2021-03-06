import 'package:flutter/material.dart';

import '../models/models.dart';
import '../providers/movie_provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  /// Se pasa la referencia del provider, para no repetir tanto el context.of
  final MovieProvider _movieProvier;

  MovieSearchDelegate(this._movieProvier);

  @override
  String? get searchFieldLabel => 'Buscar Pelicula...';

  String _last = '...';
  final _debouncer = Debouncer(duration: const Duration(seconds: 3));

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '', 
        icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('Build Result');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.length < 3){
      _debouncer.cancel();
      return const Center(child: Icon(Icons.movie, size: 100));
    }

    /// Se verifica que el query no se hay utilizado anteiriormente
    if(_movieProvier.queryCache[query] != null){
      final movies =_movieProvier.queryCache[query]!;
      return _MoviesList(movies: movies);
    }

    //-Cuando se oculta el teclado y se vuelve a abrir se dispara de nuevo este metodo
    //-igualmente cuando vamos a el detalle y volvemos por lo que se dispara el fetch sin haber
    //-cambiado nada, para ello siempre que se haga una busqueda exitosa guardamos el ultimo valor
    //-de esta manera no se dispararan los eventos de nuevo
    if(_last != query){
      //-Se muestra el loading al cambiar de query como se tiene el distinc en el stream no se
      //-redibujara con eventos repetidos
      _movieProvier.startSearching();

      _debouncer.run(() async {
        _last = query;
       _movieProvier.searchMovie(query);
      });
    }

    return StreamBuilder<List<Movie>?>(
      initialData: null,
      stream: _movieProvier.suggestionStream,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>?> snapshot) {
        if(snapshot.data == null){
          return const Center(child: CircularProgressIndicator());
        } 

        if(snapshot.hasError){
          return Center(child: Text(snapshot.error.toString()));
        }

        final List<Movie> movies = snapshot.data!;

        if(movies.isEmpty) return const _NoResults();

        return _MoviesList(movies: movies);
      },
    );
  }
}

class _MoviesList extends StatelessWidget {
  final List<Movie> movies;

  const _MoviesList({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (_, index) {
        final movie = movies[index];
        return _MovieItem(movie: movie);
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: movie.heroId,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 50,
            minHeight: 40
          ),
          child: FadeInImage(
            placeholder: const AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.fullPoserImg),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () => Navigator.pushNamed(context, 'detail', arguments: movie),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 80),
          const SizedBox(height: 10),
          Text('Sin resultados', style: Theme.of(context).textTheme.headline5)
        ],
      ),
    );
  }
}