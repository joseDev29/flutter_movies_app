import 'dart:convert';

import 'package:flutter_movies_app/models/models.dart';

class PopularsResponse {
  PopularsResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory PopularsResponse.fromJson(String str) =>
      PopularsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PopularsResponse.fromMap(Map<String, dynamic> json) =>
      PopularsResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toMap() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}
