// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class MovieResponse {
  final List<Movie> results;
  MovieResponse({
    required this.results,
  });

  MovieResponse copyWith({
    List<Movie>? results,
  }) {
    return MovieResponse(
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'results': results.map((x) => x.toMap()).toList(),
    };
  }

  factory MovieResponse.fromMap(Map<String, dynamic> map) {
    return MovieResponse(
      results: List<Movie>.from(
        (map['results'] as List<dynamic>).map<Movie>(
          (x) => Movie.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieResponse.fromJson(String source) =>
      MovieResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MovieResponse(results: $results)';

  @override
  bool operator ==(covariant MovieResponse other) {
    if (identical(this, other)) return true;

    return listEquals(other.results, results);
  }

  @override
  int get hashCode => results.hashCode;
}

class Movie {
  final int id;
  final String title;
  final String? director;
  final String summary;
  final List<dynamic> genreIds;

  Movie(
      {required this.id,
      required this.title,
      this.director,
      required this.summary,
      required this.genreIds});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'director': director,
      'overview': summary,
      'genre_ids': genreIds,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int,
      title: map['title'] as String,
      director: map['director'] == null ? "" : map['director'] as String,
      summary: map['overview'] as String,
      genreIds: List<dynamic>.from((map['genre_ids'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) =>
      Movie.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, director: $director, summary: $summary, genreIds: $genreIds)';
  }
}
