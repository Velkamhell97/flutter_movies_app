import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide ErrorBuilder;

import '../models/models.dart';
import '../widgets/widgets.dart';
import '../providers/movie_provider.dart';

class CardSwiper extends StatelessWidget {
  final MoviesState moviesState;

  const CardSwiper({Key? key, required this.moviesState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final swiperHeight = (size.height * 0.65) -  (kToolbarHeight + 24);

    if(moviesState.error != null){
      return ErrorBuilder(
        error: moviesState.error.toString(), 
        posterHeight: swiperHeight,
        onTap: () => context.read<MovieProvider>().getRecentMovies(), 
      );
    }

    final movies = moviesState.movies;

    if (movies.isEmpty || moviesState.fetching) {
      return LoadingBuilder(posterHeight: swiperHeight);
    }

    return SizedBox(
      width: double.infinity,
      height: swiperHeight,
      child: StackSwipper(
        itemCount: movies.length,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.5,
        onTap: (index) {
          final Movie movie = movies[index];
          Navigator.pushNamed(context, 'detail', arguments: movie);
        },
        itemBuilder: (context, index) {
          final movie = movies[index];

          return Hero(
            tag: movie.heroId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPoserImg),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      )
    );
  }
}

