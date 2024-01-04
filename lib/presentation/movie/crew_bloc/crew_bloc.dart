import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasources/movie/remote/movie_remote_datasource.dart';
import '../../../data/models/response/crew.dart';

part 'crew_bloc.freezed.dart';
part 'crew_event.dart';
part 'crew_state.dart';

class CrewBloc extends Bloc<CrewEvent, CrewState> {
  CrewBloc() : super(const _Initial()) {
    on<_GetOne>((event, emit) async {
      emit(const _Loading());

      final response = await MovieRemoteDatasource().getDirector(event.movieId);
      response.fold(
        (failure) => emit(_Error(failure)),
        (data) => emit(_Loaded(data)),
      );
    });
  }
}
