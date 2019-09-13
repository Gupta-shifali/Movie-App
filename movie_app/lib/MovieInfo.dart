import 'package:flutter/material.dart';

class MovieInfo extends StatefulWidget {
  final List data;
  final int index;

  MovieInfo(this.data, this.index);

  @override
  _MovieInfoState createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff1A1347),
        title: Text("FlixDB"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildMovieImage(),
            buildMovieHeading(),
            buildUiDivider(),
            buildMoviePlot(),
            buildDetails('Director'),
            buildDetails('Country'),
            buildDetails('imdbRating'),
            buildDetails('Language'),
            buildDetails('Genre'),
            buildDetails('Released'),
            buildDetails('Year'),
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
            )
          ],
        ),
      ),
    );
  }

  Container buildMoviePlot() {
    return Container(
            padding: EdgeInsets.all(16.0),
            child: Text(widget.data[widget.index]['Plot'],
                style: TextStyle(
                    color: Colors.black,)),
          );
  }

  Container buildMovieHeading() {
    return Container(
            alignment: Alignment.center,
            child: Text(widget.data[widget.index]['Title'],
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30)),
          );
  }

  Container buildUiDivider() {
    return Container(
            padding: EdgeInsets.all(3.0),
            child: Divider(
              indent: 30,
              endIndent: 30,
              color: Color(0xff1A1347),
            ),
          );
  }

  Row buildDetails(String heading,) {
    return Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
              alignment: Alignment.centerLeft,
              child: Text("$heading: ",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
            Container(
              child: Text(widget.data[widget.index][heading],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ],
        );
  }

  Container buildMovieImage() => Container(
        margin: EdgeInsets.all(16.0),
        width: 300,
        height: 250,
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new NetworkImage(widget.data[widget.index]['Images'][1]),
                fit: BoxFit.cover)),
      );
}
