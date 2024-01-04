import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_movie/data/models/response/genre.dart';
import 'package:flutter_movie/presentation/movie/genre_bloc/genre_bloc.dart';
import 'package:flutter_movie/presentation/movie/screens/movie_detail_screen.dart';

import '../../../common/components/loading_indicator.dart';
import '../../../data/models/request/movie_request.dart';
import '../../../data/models/response/movie.dart';
import '../movie_bloc/movie_bloc.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  List<Movie> listMovieFromResult = [];
  List<Movie> listMovie = [];
  List<Genres> listGenreFromResult = [];
  final scrollController = ScrollController();
  final searchController = SearchController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getGenres();
    getMovies();
  }

  getMovies() async {
    MovieRequest movieRequest = MovieRequest(page: 1, language: "en-US");
    context.read<MovieBloc>().add(MovieEvent.getAll(movieRequest));
  }

  getGenres() async {
    context.read<GenreBloc>().add(const GenreEvent.getAllGenre());
  }

  void _onSearch(String value) {
    setState(() {
      listMovieFromResult = listMovie
          .where((element) =>
              element.title.toLowerCase().contains(value.toLowerCase()))
          .toList();

      log(listMovieFromResult.map((e) => e.title).toList().toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<GenreBloc, GenreState>(
        listener: (context, state) {
          state.maybeWhen(
              orElse: () {},
              loaded: (data) {
                listGenreFromResult = data.genres ?? [];

                log("listGenreFromResult: ${listGenreFromResult.map((e) => e.toJson()).toList().toString()}");
              });
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("Movies Collection"),
          ),
          body: BlocConsumer<MovieBloc, MovieState>(
            listener: (context, state) {
              state.maybeWhen(
                  orElse: () {},
                  loaded: (data) {
                    listMovieFromResult = data.results;
                    listMovie = data.results;
                  });
            },
            builder: (context, state) {
              return state.maybeWhen(loading: () {
                return buildLoadingIndicator();
              }, orElse: () {
                var listGenresTemp;
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: buildInputField(
                            hintText: "Search Now...",
                            controller: searchController,
                            ),
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height,
                        child: Scrollbar(
                          controller: scrollController,
                          child: ListView.builder(
                              // padding: const EdgeInsets.symmetric(horizontal: 16),
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: listMovieFromResult.length,
                              itemBuilder: (context, index) {
                                var movie = listMovieFromResult[index];

                                return Container(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                            color: Colors.black)),
                                    child: ListTile(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailScreen(
                                                    movie: movie,
                                                    isCreate: false,
                                                  ))),
                                      contentPadding: const EdgeInsets.all(8),
                                      title: Text(movie.title,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      subtitle: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Wrap(
                                              children:
                                                  movie.genreIds.map<Widget>((e) {
                                                var genre = listGenreFromResult
                                                    .firstWhere((element) =>
                                                        element.id == e);
                                      
                                                return Card(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(6.0),
                                                    child: Text(
                                                        genre.name.toString()),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MovieDetailScreen(
                          movie: null,
                          isCreate: true,
                        ))),
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  TextField buildInputField(
      {required String hintText, required TextEditingController controller}) {
    return TextField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.go,
      controller: controller,
      onChanged: _onSearch,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.black),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black))),
    );
  }
}
