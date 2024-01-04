part of 'crew_bloc.dart';

@freezed
class CrewState with _$CrewState {
  const factory CrewState.initial() = _Initial;
  const factory CrewState.loading() = _Loading;
  const factory CrewState.loaded(CrewResponse data) = _Loaded;
  const factory CrewState.error(String errorMessage) = _Error;
}
