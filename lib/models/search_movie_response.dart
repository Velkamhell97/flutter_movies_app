import 'package:peliculas_app/models/models.dart';

class SearchMovieResponse {
    SearchMovieResponse({
      required this.page,
      required this.results,
      required this.totalPages,
      required this.totalResults,
    });

    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    factory SearchMovieResponse.fromJson(Map<String, dynamic> json) => SearchMovieResponse(
      page: json["page"],
      results: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x,'search'))),
      totalPages: json["total_pages"],
      totalResults: json["total_results"],
    );
}

