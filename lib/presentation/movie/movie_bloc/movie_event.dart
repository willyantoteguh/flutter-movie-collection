part of 'movie_bloc.dart';

@freezed
class MovieEvent with _$MovieEvent {
  const factory MovieEvent.started() = _Started;
  const factory MovieEvent.getAll(MovieRequest movieRequest) = _GetAll;
  const factory MovieEvent.create(Movie movie) = _CreateOne;
  const factory MovieEvent.update(Movie movie) = _UpdateOne;
  const factory MovieEvent.delete(int id) = _Delete;
}