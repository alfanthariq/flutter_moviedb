import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/cubit/movie_cubit.dart';
import 'package:moviedb/data/model/genres.dart';
import 'package:moviedb/data/model/movies.dart';
import 'package:moviedb/pages/movie_detail_page.dart';
import 'package:moviedb/pages/widget/movie_item.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  var movieItems = List<MovieItem>.empty(growable: true);
  var genreItems = List<Genres>.empty(growable: true);
  var page = 1;
  var genres = "";
  var listSelected = List<String>.empty(growable: true);

  var radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  var _pc = new PanelController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MovieCubit>(context).getMovies(genres, page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie List"),
        actions: [
          BlocBuilder<MovieCubit, MovieState>(
            builder: (context, state) {
              return buildAppBarAction();
            },
          )
        ],
      ),
      body: SlidingUpPanel(
        minHeight: 0,
        maxHeight: 350,
        controller: _pc,
        borderRadius: radius,
        defaultPanelState: PanelState.CLOSED,
        backdropEnabled: true,
        panel: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 10)),
              Text("Genres",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              Center(
                child: BlocBuilder<MovieCubit, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoaded) {
                      return buildGenreList(state.genre);
                    } else {
                      return Text("No Genres Found");
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10, top: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      side: BorderSide(width: 2, color: Colors.blue),
                    ),
                    label: Text("Apply"),
                    onPressed: () {
                      genres = _getSelected();
                      page = 1;
                      BlocProvider.of<MovieCubit>(context)
                          .getMovies(genres, page);
                      _pc.close();
                    },
                    icon: Icon(
                      Icons.check,
                      size: 26.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: BlocConsumer<MovieCubit, MovieState>(
            listener: (context, state) {
              if (state is MovieError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errMsg)));
              }
            },
            builder: (context, state) {
              if (state is MovieInitial) {
                return buildInitialView();
              } else if (state is MovieLoading) {
                return buildLoading();
              } else if (state is MovieLoaded) {
                return buildDataLoaded(state.movies);
              } else {
                return buildInitialView();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildInitialView() {
    return Center(
      child: Text("No Data"),
    );
  }

  Widget buildDataLoaded(Movies movies) {
    if (page == 1) {
      movieItems = movies.results;
    } else {
      movieItems.addAll(movies.results);
    }
    return ListView.builder(
      itemCount: movieItems.length + 1,
      itemBuilder: (context, index) {
        if (index < movieItems.length) {
          var data = movieItems[index];
          var dateFormat = DateFormat("yyyy-MM-dd");
          var dateFormatParse = DateFormat("yyyy");
          var dateTime = dateFormat.parse(data.releaseDate);
          var year = dateFormatParse.format(dateTime);
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: data)));
            },
            child: MovieItemView(
                imgUrl: data.posterPath,
                title: data.title,
                overview: data.overview,
                releaseDate: year,
                index: index),
          );
        } else {
          page += 1;
          BlocProvider.of<MovieCubit>(context).getMovies(genres, page);
          return Center(
            child: Container(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget buildLoading() {
    return Center(
      child: Container(
        width: 150,
        child: LinearProgressIndicator(),
      ),
    );
  }

  Widget buildGenreList(GenresList genresList) {
    genreItems = genresList.genres;
    return Tags(
      key: _tagStateKey,
      itemCount: genreItems.length, // required
      itemBuilder: (int index) {
        final item = genreItems[index];

        return ItemTags(
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          index: index, // required
          title: item.name,
          active: listSelected.contains(item.id.toString()),
          customData: item.id,
          activeColor: Colors.blue,
          border: Border.all(color: Colors.transparent),
          elevation: 3,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          textStyle: TextStyle(
            fontSize: 12,
          ),
          combine: ItemTagsCombine.onlyText,
        );
      },
    );
  }

  Widget buildAppBarAction() {
    return IconButton(
      onPressed: () {
        _pc.open();
      },
      splashColor: Colors.blue,
      icon: listSelected.isEmpty
          ? Icon(
              Icons.filter_alt_rounded,
              size: 26.0,
            )
          : Badge(
              badgeContent: Text(listSelected.length.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 11)),
              child: Icon(
                Icons.filter_alt_rounded,
                size: 26.0,
              ),
            ),
    );
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  String _getSelected() {
    List<Item> lst = _tagStateKey.currentState?.getAllItem;
    listSelected.clear();
    if (lst != null) {
      lst
          .where((a) => a.active == true)
          .forEach((a) => {listSelected.add(a.customData.toString())});
    }
    return listSelected.isEmpty ? "" : listSelected.join(',');
  }
}
