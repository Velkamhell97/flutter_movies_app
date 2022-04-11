import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/models.dart';

class MoviePoster extends StatelessWidget {
  final Movie movie;

  const MoviePoster({Key? key, required this.movie}): super(key: key);

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
                    child: const DecoratedBox(
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