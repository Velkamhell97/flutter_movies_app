import 'package:peliculas_app/models/models.dart';


class CreditResponse {
  int id;
  List<Actor> cast;

  CreditResponse({
    required this.id,
    required this.cast,
  });

  factory CreditResponse.fromJson(Map<String, dynamic> json) => CreditResponse(
      id: json["id"],
      cast: List<Actor>.from(json["cast"].map((x) => Actor.fromMap(x))),
  );
}
