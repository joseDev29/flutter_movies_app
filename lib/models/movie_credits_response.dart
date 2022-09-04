import 'dart:convert';

import 'package:flutter_movies_app/models/models.dart';

class MovieCreditsResponse {
  MovieCreditsResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  int id;
  List<CastPerson> cast;
  List<CastPerson> crew;

  factory MovieCreditsResponse.fromJson(String str) =>
      MovieCreditsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MovieCreditsResponse.fromMap(Map<String, dynamic> json) =>
      MovieCreditsResponse(
        id: json["id"],
        cast: List<CastPerson>.from(
            json["cast"].map((x) => CastPerson.fromMap(x))),
        crew: List<CastPerson>.from(
            json["crew"].map((x) => CastPerson.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "cast": List<dynamic>.from(cast.map((x) => x.toMap())),
        "crew": List<dynamic>.from(crew.map((x) => x.toMap())),
      };
}
