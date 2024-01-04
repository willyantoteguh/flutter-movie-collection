part of 'crew_bloc.dart';

@freezed
class CrewEvent with _$CrewEvent {
  const factory CrewEvent.started() = _Started;
  const factory CrewEvent.getCrewByMovieId(int movieId) = _GetOne;
}