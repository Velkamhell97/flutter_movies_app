import 'package:flutter/material.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';

class MovieSlider extends StatefulWidget {
  final double posterWidth;
  final double posterHeight;
  final MoviesState moviesState;
  final Function onNextPage;
  final VoidCallback onErrorTap;

  //-Es bueno utilizar tamaño en px en vez de en base al screen porque si en una pantalla pequeña
  //-se ven 3 elementos en grandes se veran los mismos por tener como referencia el screenSize
  const MovieSlider({
    Key? key,
    this.posterWidth = 140,
    this.posterHeight = 200, 
    required this.moviesState, 
    required this.onNextPage, 
    required this.onErrorTap
  }) : super(key: key);

  @override
  _MovieSliderState createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController sliderScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    sliderScrollController.addListener(() {
      if (sliderScrollController.position.extentAfter < 400) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    sliderScrollController.dispose();
    super.dispose();
  }

  static const _posterGap = 7.0;

  @override
  Widget build(BuildContext context) {
    if(widget.moviesState.error != null) {
      return ErrorBuilder(
        error: widget.moviesState.error.toString(), 
        posterHeight: widget.posterHeight,
        onTap: widget.onErrorTap,
      );
    }
    
    final movies = widget.moviesState.movies;

    if(movies.isEmpty || widget.moviesState.fetching){
      return LoadingBuilder(posterHeight: widget.posterHeight);
    }

    return SizedBox(
      width: double.infinity,
      height: widget.posterHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: sliderScrollController,
        itemExtent: widget.posterWidth + _posterGap,        
        itemCount: movies.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 5),
        itemBuilder: (_, index) {
          final movie = movies[index];

          return Padding(
            padding: const EdgeInsets.only(right: _posterGap),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'detail', arguments: movie),
              child: MoviePoster(movie: movie)
            ),
          );
        }
      ),
    );
  }
}