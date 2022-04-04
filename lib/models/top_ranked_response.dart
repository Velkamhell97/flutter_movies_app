import 'package:peliculas_app/models/models.dart';

class TopRankedResponse {
    TopRankedResponse({
      required this.page,
      required this.results,
      required this.totalPages,
      required this.totalResults,
    });

    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    factory TopRankedResponse.fromJson(Map<String, dynamic> json) => TopRankedResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x, 'top_ranked'))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );
}

