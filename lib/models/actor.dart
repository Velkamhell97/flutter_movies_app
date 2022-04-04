import 'dart:convert';

class Actor {
  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;
  final int? castId;
  final String? character;
  final String creditId;
  final int? order;
  final String? department;
  final String? job;

  const Actor({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    this.castId,
    this.character,
    required this.creditId,
    this.order,
    this.department,
    this.job,
  });

  get fullProfilePath {
    if(profilePath != null) return 'https://image.tmdb.org/t/p/w500$profilePath';

    return 'https://i.stack.imgur.com/GNhxO.png';
  }

  factory Actor.fromJson(String str) => Actor.fromMap(json.decode(str));

  factory Actor.fromMap(Map<String, dynamic> json) => Actor(
    adult: json["adult"],
    gender: json["gender"],
    id: json["id"],
    knownForDepartment: json["known_for_department"],
    name: json["name"],
    originalName: json["original_name"],
    popularity: json["popularity"].toDouble(),
    profilePath: json["profile_path"] == null ? null : json["profile_path"],
    castId: json["cast_id"] == null ? null : json["cast_id"],
    character: json["character"] == null ? null : json["character"],
    creditId: json["credit_id"],
    order: json["order"] == null ? null : json["order"],
    department: json["department"] == null ? null : json["department"],
    job: json["job"] == null ? null : json["job"],
  );
}
