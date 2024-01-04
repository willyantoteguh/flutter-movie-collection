part of 'movie_bloc.dart';

@freezed
class MovieState with _$MovieState {
  const factory MovieState.initial() = _Initial;
  const factory MovieState.loading() = _Loading;
  const factory MovieState.loaded(MovieResponse data) = _Loaded;
  const factory MovieState.error(String errorMessage) = _Error;
}
