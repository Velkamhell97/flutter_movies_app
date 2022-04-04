import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movie_provider.dart';

class CastingCards extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final int movieId;

  CastingCards({this.cardWidth = 130, this.cardHeight = 180, required this.movieId});

  static const _cardGap = 7.0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Actor>>(
      initialData: [],
      future: context.read<MovieProvier>().getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Actor>> snapshot) {
        if(snapshot.hasError){
          //Hangle error
        }

        final List<Actor> cast = snapshot.data!;

        if(cast.isEmpty) {
          return SizedBox(
            width: double.infinity,
            height: cardHeight,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SizedBox(
          width: double.infinity,
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: cast.length,
            itemExtent: cardWidth + _cardGap,
            padding: const EdgeInsets.only(left: 5.0),
            itemBuilder: (_, index) {
              final actor = cast[index];

              return Padding(
                padding: const EdgeInsets.only(right: _cardGap),
                child: ActorCard(actor: actor)
              );
            }
          ),
        );
      },
    );
  }
}

class ActorCard extends StatelessWidget {
  final Actor actor;

  ActorCard({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Flexible(
            flex: 2,
            child: Align(
              child: Text(
                actor.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      )
    );
  }
}