import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:moviedb/data/model/movies.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieItem movie;
  MovieDetailPage({Key key, @required this.movie}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.movie.title} (${DateFormat('yyyy').format(DateFormat('yyyy-MM-dd').parse(widget.movie.releaseDate))})",
          style: TextStyle(fontSize: 16),
        ),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(7),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Center(
                          child: widget.movie.posterPath == null
                              ? Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: FadeInImage.memoryNetwork(
                                    width: 154,
                                    placeholder: kTransparentImage,
                                    image:
                                        "https://image.tmdb.org/t/p/w154${widget.movie.posterPath}",
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        infoRow("Original title", widget.movie.originalTitle),
                        flagRow("Language", widget.movie.originalLanguage),
                        infoRow(
                            "Release date",
                            DateFormat("dd/MM/yyyy").format(
                                DateFormat("yyyy-MM-dd")
                                    .parse(widget.movie.releaseDate))),
                        infoRow("Rating", widget.movie.voteAverage.toString()),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(Colors.blue.red, Colors.blue.green,
                      Colors.blue.blue, 0.3),
                  borderRadius: BorderRadius.circular(7)),
              padding: EdgeInsets.all(15),
              child: Text(widget.movie.overview, textAlign: TextAlign.justify),
            )
          ],
        ),
      ),
    );
  }

  Widget infoRow(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      dense: true,
    );
  }

  Widget flagRow(String title, String value) {
    String flag = value.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));
    return ListTile(
      title: Text(title),
      subtitle: RichText(text: TextSpan(text: flag)),
      dense: true,
    );
  }
}
