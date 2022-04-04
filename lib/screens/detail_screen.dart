import 'package:flutter/material.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)?.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(movie: movie),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _PosterAndTitle(movie: movie),
                _OverView(movie: movie),
                _OverView(movie: movie),
                CastingCards(movieId: movie.id)
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  _CustomAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      expandedHeight: size.height * 0.3,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(movie.title, textAlign: TextAlign.center),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  _PosterAndTitle({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPoserImg),
                height: size.height * 0.24,
                width: size.width * 0.32,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis, 
                  style: textStyle.headline6
                ),
                Text(
                  movie.originalTitle,
                   overflow: TextOverflow.ellipsis, 
                  style: textStyle.subtitle1
                ),
                Row(
                  children: [
                    Icon(Icons.star_outline),
                    SizedBox(width: 5),
                    Text(movie.voteAverage.toString(), style: textStyle.caption)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverView extends StatelessWidget {
  final Movie movie;

  _OverView({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: textStyle.bodyText2,
      ),
    );
  }
}
