import 'package:peliculas_app/models/models.dart';

class NowPlayingResponse {
  Dates dates;
  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  NowPlayingResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory NowPlayingResponse.fromJson(Map<String, dynamic> json) => NowPlayingResponse(
    dates        : Dates.fromMap(json["dates"]),
    page         : json["page"],
    results      : List<Movie>.from(json["results"].map((x) => Movie.fromJson(x, 'now_playing'))),
    totalPages   : json["total_pages"],
    totalResults : json["total_results"],
  );
}

class Dates {
  DateTime maximum;
  DateTime minimum;

  Dates({
    required this.maximum,
    required this.minimum,
  });

  factory Dates.fromMap(Map<String, dynamic> json) => Dates(
      maximum: DateTime.parse(json["maximum"]),
      minimum: DateTime.parse(json["minimum"]),
  );
}


