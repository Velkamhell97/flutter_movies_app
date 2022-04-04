import 'package:peliculas_app/models/models.dart';

class PopularResponse {
    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    PopularResponse({
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