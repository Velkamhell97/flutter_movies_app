import '../models/models.dart';

class MoviesResponse {
  final Dates? dates;
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  const MoviesResponse({
    this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json, String category) => MoviesResponse(
    dates        : json["dates"] == null ? null : Dates.fromMap(json["dates"]),
    page         : json["page"],
    results      : List<Movie>.from(json["results"].map((x) => Movie.fromJson(x, category))),
    totalPages   : json["total_pages"],
    totalResults : json["total_results"],
  );
}

class Dates {
  final DateTime maximum;
  final DateTime minimum;

  const Dates({
    required this.maximum,
    required this.minimum,
  });

  factory Dates.fromMap(Map<String, dynamic> json) => Dates(
      maximum: DateTime.parse(json["maximum"]),
      minimum: DateTime.parse(json["minimum"]),
  );
}


