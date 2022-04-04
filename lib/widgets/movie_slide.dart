import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:peliculas_app/models/models.dart';

class MovieSlider extends StatefulWidget {
  final double posterWidth;
  final double posterHeight;
  final MoviesState moviesState;
  final String label;

  final Function onNextPage;

  //-Es bueno utilizar tamaño en px en vez de en base al screen porque si en una pantalla pequeña
  //-se ven 3 elementos en grandes se veran los mismos por tener como referencia el screenSize
  const MovieSlider({
    this.posterWidth = 140,
    this.posterHeight = 200, 
    required this.moviesState, 
    required this.onNextPage, 
    required this.label
  });

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
    // final error = widget.moviesState.error; //handle error
    final movies = widget.moviesState.movies;

    if(movies.isEmpty){
      return SizedBox(
        height: widget.posterHeight,
        width: double.infinity,
        child: Align(child: CircularProgressIndicator()),
      );
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
              child: _MoviePoster(movie: movie)
            ),
          );
        }
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  _MoviePoster({required this.movie});

  @override
  Widget build(BuildContext context) {

    //-Se coloca el hero aqui para que al volver muestre toda la card pero lo ideal seria colocarlo
    //-unicamente sobre el elemento que se desplaza, es decir, la imagen
    return Hero(
      tag: movie.heroId,
      child: Card(
        // margin: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Flexible( //-Recordar que la ventaja del flex es que no causa overflow (corta elementso)
              flex: 8, //80% (8 / (8+2))
              //-Forma de implementar un shimer placeholder en vez de una imagen
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Shimmer.fromColors(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.white),
                    ), 
                    baseColor: const Color(0xFFF4F4F4), 
                    highlightColor: const Color(0xFFDADADA)
                  ),
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: movie.fullPoserImg,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2, //20%
              fit: FlexFit.tight,
              child: Align(
                child: Text(
                  movie.title, 
                  overflow: TextOverflow.ellipsis, 
                  textAlign: TextAlign.center, 
                  maxLines: 2
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
