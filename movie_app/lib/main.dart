import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/db/movie_db.dart';

import 'MovieInfo.dart';
import 'db/model/movie_model.dart';

void main() => runApp(MovieApp());

class MovieApp extends StatelessWidget {
  final Movie movies;

  MovieApp({this.movies});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MovieAppUI(movies: movies),
    );
  }
}

class MovieAppUI extends StatefulWidget {
  final Movie movies;

  MovieAppUI({this.movies});

  @override
  _MovieAppUIState createState() => _MovieAppUIState();
}

class _MovieAppUIState extends State<MovieAppUI> {

  Movie _movie;
  MovieDatabaseHelper _databaseHelper;
  List<Movie> _movieList;
  String title;
  String director;
  String rating;

  String url =
      "https://gist.githubusercontent.com/saniyusuf/406b843afdfb9c6a86e25753fe2761f4/raw/523c324c7fcc36efab8224f9ebb7556c09b69a14/Film.JSON";
  List data;

  Future<String> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': 'application/json'});
    print(response.body);

    setState(() {
      data = json.decode(response.body);
    });
    return response.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getJsonData();
    _databaseHelper = new MovieDatabaseHelper();
    if(widget.movies != null){
      title = widget.movies.title ?? "";
      director = widget.movies.director ?? "";
      rating = widget.movies.rating ?? "";

      _movie = widget.movies;
    }
  }

  Future<void> _addMovieDetails(List data, int index) async{
    _movie.title = data[index]['Title'];
    _movie.director = data[index]['Director'];
    _movie.rating = data[index]['imdbRating'];
    _movie.setUserId(this._movie.id);
    await _databaseHelper.saveMovieDetails(_movie);
    debugPrint(_movie.toString());
  }

  Align buildMovieDetails(int index) {
    return Align(
      heightFactor: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff434273),
          borderRadius: BorderRadius.circular(10.0),
        ),
        width: 250,
        height: 105,
        alignment: Alignment.bottomRight,
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  data[index]['Title'],
                  style: TextStyle(color: Colors.white),
                )),
            Text(
              data[index]['Director'],
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80, right: 70),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Text(
              data[index]['imdbRating'],
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Stack buildMovieItem(int index) {
    return Stack(
      children: <Widget>[
        buildMovieDetails(index),
        GestureDetector(
            child: Container(
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: NetworkImage(data[index]['Images'][0]),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieInfo(data, index)));
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1A1347),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "FlixDb",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.delete, color: Colors.black,),
          onPressed: (){
            _databaseHelper.deleteAllMovies();
          },
        ),
        actions: <Widget>[
          Container(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.refresh,
                color: Colors.black,
              ))
        ],
      ),
      body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            _addMovieDetails(data, index);
            return Container(
              margin: EdgeInsets.all(32.0),
              child: buildMovieItem(index),
            );
          }),
    );
  }
}
