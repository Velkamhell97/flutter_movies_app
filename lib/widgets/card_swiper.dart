import 'package:flutter/material.dart';
// import 'package:card_swiper/card_swiper.dart';

import 'package:peliculas_app/models/models.dart';
// import 'package:peliculas_app/widgets/stack_swipper_old.dart';
import 'package:peliculas_app/widgets/stack_swipper.dart';

class CardSwiper extends StatelessWidget {
  final MoviesState moviesState;

  CardSwiper({required this.moviesState});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final swiperHeight = (size.height * 0.65) -  (kToolbarHeight + 24);

    // final error = moviesState.error; //handle error
    final movies = moviesState.movies;

    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: swiperHeight,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
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
                placeholder: AssetImage('assets/no-image.jpg'),
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

