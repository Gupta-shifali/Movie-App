import 'package:movie_app/db/model/movie_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MovieDatabaseHelper {
  static final MovieDatabaseHelper _databaseHelperInstance =
      new MovieDatabaseHelper.internal();

  MovieDatabaseHelper.internal();

  factory MovieDatabaseHelper() => _databaseHelperInstance;
  final String movieTable = 'Movies';
  static Database _movieDatabase;

  Future<Database> get db async {
    if (_movieDatabase == null) {
      _movieDatabase = await initDb();
    }
    return _movieDatabase;
  }

  initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'movies.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int dbVersion) async {
    await db.execute(
        "CREATE TABLE $movieTable(title TEXT PRIMARY KEY, director TEXT, rating INTEGER)");
  }

  Future<int> saveMovieDetails(Movie movie) async {
    var dbClient = await db;
    int result = await dbClient.insert(movieTable, movie.toMap());
    return result;
  }

  Future<List<Movie>> getMovieInfo() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $movieTable');
    List<Movie> movieInfo = new List();
    for (int i = 0; i < movieInfo.length; i++) {
      var item = new Movie(
        title: list[i]["title"],
        director: list[i]["director"],
        rating: list[i]["rating"],
      );
      item.setUserId(list[i]["id"]);
      movieInfo.add(item);
    }
    print("Db data.. " + movieInfo.toString());
    return movieInfo;
  }

  Future<int> deleteAllMovies() async {
    var dbClient = await db;
    int result = await dbClient.rawDelete('DELETE FROM $movieTable');
    return result;
  }

  Future<int> deleteMultipleMovies(Movie movie) async {
    var dbClient = await db;
    int result = await dbClient.rawDelete('DELETE FROM $movieTable WHERE id = ?', [movie.id]);
    return result;
  }
}
