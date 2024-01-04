import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_movie/common/components/button_select_genre.dart';
import 'package:flutter_movie/data/models/response/crew.dart';
import 'package:flutter_movie/presentation/movie/movie_bloc/movie_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../common/components/loading_indicator.dart';
import '../../../data/models/response/genre.dart';
import '../../../data/models/response/movie.dart';
import '../crew_bloc/crew_bloc.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie? movie;
  final bool isCreate;

  const MovieDetailScreen({super.key, this.movie, this.isCreate = false});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  List<Genres> listGenreFromResult = [];
  List<Genres> selectedGenres = [];
  // Movie? movieDetail;
  var movie;
  int movieId = 0;
  bool isUpdate = false;
  bool isCreate = false;

  final titleController = TextEditingController();
  final directorController = TextEditingController();
  final summaryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    isCreate = widget.isCreate;
    if (widget.movie != null) {
      movieId = widget.movie!.id;
      getDirector(movieId);
      isUpdate = true;
    }

    // listGenreFromResult = widget.movie.genreIds;
  }

  getDirector(int id) async {
    context.read<CrewBloc>().add(CrewEvent.getCrewByMovieId(id));
    debugPrint(id.toString());
    debugPrint(widget.movie?.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: Colors.black,
            title: const Text("Movie Detail"),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Visibility(
                        visible: isUpdate,
                        child: buildCustomButton(title: "Delete")),
                    const SizedBox(width: 8),
                    buildCustomButton(title: "Save"),
                  ],
                ),
              )
            ],
          )),
      body: BlocConsumer<CrewBloc, CrewState>(
        listener: (context, state) {
          state.maybeWhen(
              loaded: (data) {},
              orElse: () {},
              error: (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error),
                    backgroundColor: Colors.red.shade800));
              });
        },
        builder: (context, state) {
          return state.maybeWhen(loaded: (data) {
            final crewData = data;
            final movieDetail = Movie(
                id: widget.movie?.id ?? 0,
                title: widget.movie?.title ?? "",
                director: crewData.crew?.first.name,
                summary: widget.movie?.summary ?? "",
                genreIds: widget.movie?.genreIds ?? []);
            return buildCustomForm(movieDetail, context);
          }, orElse: () {
            var movieDetail =
                Movie(id: 0, title: "", summary: "", genreIds: []);
            return buildCustomForm(movieDetail, context);
          }, loading: () {
            return buildLoadingIndicator();
          });
        },
      ),
    );
  }

  Padding buildCustomForm(Movie movieDetail, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Title",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            buildInputField(
                labelText: "Title",
                hintText:
                    (movieDetail.title.isEmpty) ? "Title" : movieDetail.title,
                controller: titleController),
            const SizedBox(height: 16),
            const Text(
              "Director",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            buildInputField(
                labelText: "Director",
                hintText: (movieDetail.director == null)
                    ? "Director"
                    : movieDetail.director.toString(),
                controller: directorController),
            const SizedBox(height: 16),
            const Text(
              "Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            buildInputField(
                labelText: "Summary",
                hintText: (movieDetail.summary.isEmpty)
                    ? "Summary"
                    : movieDetail.summary,
                controller: summaryController,
                isSummary: true),
            // Wrap(
            //   // alignment: WrapAlignment.center,
            //   // crossAxisAlignment: WrapCrossAlignment.center,
            //   runSpacing: 12,
            //   children: listStaticGenre.map<Widget>((e) {
            //     // var genre = listGenreFromResult
            //     //     .firstWhere((element) => element.id == e);

            //     return Card(
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20)),
            //       child: Padding(
            //         padding: const EdgeInsets.all(20.0),
            //         child: Text(e.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
            //       ),
            //     );
            //   }).toList(),
            // )
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: listStaticGenre.map<Widget>((e) {
                return ButtonSelectGenre(e.name.toString(),
                    width: (MediaQuery.of(context).size.width) / 3.5,
                    isSelected: selectedGenres.contains(e), onTap: () {
                  onSelectGenre(e);
                });
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  MaterialButton buildCustomButton({required String title}) {
    return MaterialButton(
      onPressed: () {
        if (isUpdate && title.toLowerCase().contains("save")) {
            List<int?> selectedGenreId = [];
          String? title = titleController.text.isEmpty ? widget.movie!.title : titleController.text;
          String? director = (directorController.text.isEmpty) ? widget.movie!.director : directorController.text;
          String? summary = (summaryController.text.isEmpty) ? widget.movie!.summary : summaryController.text;
          for(Genres genres in selectedGenres) {
            selectedGenreId.add(genres.id);
          }
          movie = Movie(
              id: widget.movie!.id,
              title:  title,
              director: director,
              summary: summary,
              genreIds: selectedGenreId);
          context.read<MovieBloc>().add(MovieEvent.update(movie));
          Navigator.of(context).maybePop();
        } else if (isCreate) {
          movie = Movie(
              id: Random().nextInt(10000),
              title: titleController.text,
              director: directorController.text,
              summary: summaryController.text,
              genreIds: selectedGenres);
          context.read<MovieBloc>().add(MovieEvent.create(movie));
          Navigator.of(context).maybePop();
        } else if (title.toLowerCase().contains("delete")) {
          context.read<MovieBloc>().add(MovieEvent.delete(widget.movie!.id));
          Navigator.of(context).maybePop();
        }
      },
      color: Colors.white,
      minWidth: 60,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black)),
      child: Text(title),
    );
  }

  TextField buildInputField({
    required String labelText,
    required String hintText,
    bool isSummary = false,
    required TextEditingController controller,
  }) {
    return TextField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.go,
      controller: controller,
      maxLength: (isSummary) ? 100 : null,
      maxLengthEnforcement: (isSummary) ? MaxLengthEnforcement.enforced : null,
      maxLines: (isSummary) ? 5 : null,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black))),
    );
  }

  List<Genres> listStaticGenre = [
    Genres(
      id: 18,
      name: "Drama",
    ),
    Genres(
      id: 28,
      name: "Action",
    ),
    Genres(
      id: 16,
      name: "Animation",
    ),
    Genres(
      id: 878,
      name: "Sci-Fi",
    ),
    Genres(
      id: 27,
      name: "Horror",
    ),
  ];

  void onSelectGenre(Genres genre) {
    if (selectedGenres.contains(genre)) {
      setState(() {
        selectedGenres.remove(genre);
      });
    } else {
      if (selectedGenres.length < 5) {
        setState(() {
          selectedGenres.add(genre);
        });
      }
    }
  }
}
