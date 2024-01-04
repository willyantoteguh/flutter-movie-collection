import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/movie/remote/movie_remote_datasource.dart';
import '../../../data/models/request/movie_request.dart';
import '../../../data/models/response/movie.dart';

part 'movie_bloc.freezed.dart';
part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(const _Initial()) {
    List<Movie> listMovieData = [];

    on<_GetAll>((event, emit) async {
      emit(const _Loading());
      final response =
          await MovieRemoteDatasource().getMovies(event.movieRequest);
      response.fold(
        (failure) => emit(_Error(failure)),
        (data) {
          emit(_Loaded(data));

          listMovieData = data.results;
        },
      );
    });

    on<_CreateOne>((event, emit) {
      emit(const _Loading());
      listMovieData.add(event.movie);
      MovieResponse movieResponse = MovieResponse(results: listMovieData);
      debugPrint(
          "movieResponse create: ${movieResponse.results.map((e) => e.title).toList().toString()}");

      emit(_Loaded(movieResponse));
    });

    on<_UpdateOne>((event, emit) {
      emit(const _Loading());
      // listMovieData.removeWhere((element) => element.id == event.movie.id);
      int index =
          listMovieData.indexWhere((element) => element.id == event.movie.id);
      listMovieData[index] = event.movie;
      MovieResponse movieResponse = MovieResponse(results: listMovieData);
      // debugPrint(
          // "movie update: ${event.movie.genreIds.map((e) => e["id"]).toList().toString()}");

      emit(_Loaded(movieResponse));
    });

    on<_Delete>((event, emit) {
      emit(const _Loading());
      listMovieData.removeWhere((element) => element.id == event.id);
      MovieResponse movieResponse = MovieResponse(results: listMovieData);
      debugPrint(
          "movieResponse create: ${movieResponse.results.map((e) => e.title).toList().toString()}");

      emit(_Loaded(movieResponse));
    });
  }
}
