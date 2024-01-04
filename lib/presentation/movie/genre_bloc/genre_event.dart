part of 'genre_bloc.dart';

@freezed
class GenreEvent with _$GenreEvent {
  const factory GenreEvent.started() = _Started;
  const factory GenreEvent.getAllGenre() = _GetAll;
}