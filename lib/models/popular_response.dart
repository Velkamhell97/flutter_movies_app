import 'package:peliculas_app/models/models.dart';

class PopularResponse {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  const PopularResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory PopularResponse.fromJson(Map<String, dynamic> json) => PopularResponse(
    page: json["page"],
    results: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x, 'popular'))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );
}