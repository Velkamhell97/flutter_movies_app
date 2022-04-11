import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/movie_provider.dart';

class CastingCards extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final int movieId;

  const CastingCards({
    Key? key,
    this.cardWidth = 130, 
    this.cardHeight = 180, 
    required this.movieId
  }) : super(key: key);

  static const _cardGap = 7.0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Actor>>(
      initialData: const [],
      future: context.read<MovieProvider>().getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Actor>> snapshot) {
        if(snapshot.hasError){
          //Handle error
        }

        /// Como la initial data es [] podemos usar asignar directamente
        final List<Actor> cast = snapshot.data!;

        if(cast.isEmpty) {
          return SizedBox(
            width: double.infinity,
            height: cardHeight,
            child: const Center(child: CircularProgressIndicator()),
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
                child: _ActorCard(actor: actor)
              );
            }
          ),
        );
      },
    );
  }
}

/// No puede reutilizarse el MoviePoster porque este tiene el Hero
class _ActorCard extends StatelessWidget {
  final Actor actor;

  const _ActorCard({Key? key, required this.actor}) : super(key: key);

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
              placeholder: const AssetImage('assets/no-image.jpg'),
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