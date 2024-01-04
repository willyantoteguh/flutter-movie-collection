class MovieRequest {
  final int page;
  final String language;
  final String? sortBy;

  MovieRequest({
    required this.page,
    required this.language,
    this.sortBy,
  });
}
