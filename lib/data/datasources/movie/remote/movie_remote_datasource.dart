import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_movie/data/models/response/crew.dart';
import 'package:flutter_movie/data/models/response/genre.dart';
import 'package:http/http.dart' as http;

import '../../../../common/constants/api_variables.dart';
import '../../../models/request/movie_request.dart';
import '../../../models/response/movie.dart';

class MovieRemoteDatasource {
  Future<Either<dynamic, MovieResponse>> getMovies(
      MovieRequest movieRequest) async {
    // final headers = {'Content-Type': 'application/json'};
    final response = await http.get(
      Uri.parse(
          "${ApiVariables.baseUrlv3}${ApiVariables.discover}?api_key=${ApiVariables.apiKey}&language=${movieRequest.language}&sort_by=popularity.desc&page=${movieRequest.page}"),
    );

    if (response.statusCode == 200) {
      return Right(MovieResponse.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  Future<Either<dynamic, CrewResponse>> getDirector(int movieId) async {
    final response = await http.get(Uri.parse(
        "${ApiVariables.baseUrlv3}movie/$movieId/credits?api_key=${ApiVariables.apiKey}"));

    if (response.statusCode == 200) {
      return Right(CrewResponse.fromJson(jsonDecode(response.body)));
    } else {
      return Left(response.body);
    }
  }

  Future<Either<dynamic, GenreResponse>> getGenre() async {
    final response = await http.get(Uri.parse(
        "${ApiVariables.baseUrlv3}genre/movie/list?api_key=${ApiVariables.apiKey}"));

    if (response.statusCode == 200) {
      return Right(GenreResponse.fromJson(jsonDecode(response.body)));
    } else {
      return Left(response.body);
    }
  }
}
