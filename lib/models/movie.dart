class Movie {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final String heroId;

  const Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.heroId
  });

  // String? heroId; 

  // String get uniqueId => '$id-tarjeta';

  // String get uniqueIdBanner => '$id-banner';

  get fullPoserImg {
    if(posterPath != null) return 'https://image.tmdb.org/t/p/w500$posterPath';

    return 'https://i.stack.imgur.com/GNhxO.png';
  }

  get fullBackdropPath {
    if(backdropPath != null) return 'https://image.tmdb.org/t/p/w500$backdropPath';

    return 'https://i.stack.imgur.com/GNhxO.png';
  }


  factory Movie.fromJson(Map<String, dynamic> json, String heroLabel) => Movie(
    adult            : json["adult"],
    backdropPath     : json["backdrop_path"],
    genreIds         : List<int>.from(json["genre_ids"].map((x) => x)),
    id               : json["id"],
    originalLanguage : json["original_language"],
    originalTitle    : json["original_title"],
    overview         : json["overview"],
    popularity       : json["popularity"].toDouble(),
    posterPath       : json["poster_path"],
    releaseDate      : json["release_date"],
    title            : json["title"],
    video            : json["video"],
    voteAverage      : json["vote_average"].toDouble(),
    voteCount        : json["vote_count"],
    heroId           : 'movie_${json["id"]}_$heroLabel'
  );
}