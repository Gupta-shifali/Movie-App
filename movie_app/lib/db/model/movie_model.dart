class Movie {
  int id;
  String title;
  String director;
  int rating;

  Movie({this.id, this.title, this.director, this.rating});

  Movie.map(dynamic obj) {
    this.title = obj['title'];
    this.director = obj['director'];
    this.rating = obj['rating'];
  }

  Map<String, dynamic> toMap() => {
        "title": title,
        "director": director,
        "rating": rating,
      };

//  String get firstname => firstName;
//
//  String get lastname => lastName;
//
//  String get stateName => state;
//
  void setUserId(int id) {
    this.id = id;
  }

  @override
  String toString() {
    return 'Movie{id:$id, title:$title, director:$director, rating:$rating';
  }
}
