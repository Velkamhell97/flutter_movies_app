import '../models/models.dart';

class CreditResponse {
  final int id;
  final List<Actor> cast;

  const CreditResponse({
    required this.id,
    required this.cast,
  });

  factory CreditResponse.fromJson(Map<String, dynamic> json) => CreditResponse(
    id: json["id"],
    cast: List<Actor>.from(json["cast"].map((x) => Actor.fromMap(x))),
  );
}
