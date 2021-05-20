import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieItemView extends StatefulWidget {
  const MovieItemView(
      {@required this.imgUrl,
      @required this.title,
      @required this.overview,
      @required this.releaseDate,
      this.index});

  final String imgUrl;
  final String title;
  final String overview;
  final String releaseDate;
  final int index;

  @override
  _MovieItem createState() => _MovieItem();
}

class _MovieItem extends State<MovieItemView> {
  @override
  Widget build(BuildContext context) {
    return Ink(
        color: widget.index % (2) == 0 ? Colors.grey[100] : Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 92,
              height: 138,
              margin: EdgeInsets.all(7),
              child: Stack(
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  Center(
                    child: widget.imgUrl == null
                        ? Container(
                            color: widget.index % (2) == 0
                                ? Colors.grey[100]
                                : Colors.white,
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
                              width: 92,
                              placeholder: kTransparentImage,
                              image:
                                  "https://image.tmdb.org/t/p/w92${widget.imgUrl}",
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 16.0)),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10, top: 10),
                  child: Text(
                    "${widget.title} (${widget.releaseDate})",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10.0)),
                Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    widget.overview,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 6,
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.normal,
                        fontSize: 11),
                  ),
                )
              ],
            ))
          ],
        ));
  }
}
