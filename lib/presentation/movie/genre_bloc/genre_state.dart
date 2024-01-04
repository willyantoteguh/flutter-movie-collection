part of 'genre_bloc.dart';

@freezed
class GenreState with _$GenreState {
  const factory GenreState.initial() = _Initial;
  const factory GenreState.loading() = _Loading;
  const factory GenreState.loaded(GenreResponse data) = _Loaded;
  const factory GenreState.error(String errorMessage) = _Error;
}
