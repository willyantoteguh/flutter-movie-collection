import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/movie/remote/movie_remote_datasource.dart';
import '../../../data/models/response/genre.dart';

part 'genre_bloc.freezed.dart';
part 'genre_event.dart';
part 'genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc() : super(const _Initial()) {
    on<_GetAll>((event, emit) async {
      emit(const _Loading());

      final response = await MovieRemoteDatasource().getGenre();
      return response.fold(
        (failure) => emit(_Error(failure)),
        (data) => emit(_Loaded(data)),
      );
    });
  }
}
