import 'package:restaurant_app_new/data/model/favorite_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoriteDatabase {
  static FavoriteDatabase? _databaseHelper;
  static late Database _database;

  FavoriteDatabase._internal() {
    _databaseHelper = this;
  }
  factory FavoriteDatabase() => _databaseHelper ?? FavoriteDatabase._internal();

  Future<Database> get database async {
    _database = await _initializeDb('favorites_db.db');
    return _database;
  }

  static const String _tableName = 'favorites';

  Future<Database> _initializeDb(String file) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, file);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tableName (
      ${FavoriteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${FavoriteFields.restaurantId} TEXT NOT NULL,
      ${FavoriteFields.name} TEXT NOT NULL,
      ${FavoriteFields.pictureId} TEXT NOT NULL,
      ${FavoriteFields.city} TEXT NOT NULL,
      ${FavoriteFields.rating} TEXT NOT NULL,
      ${FavoriteFields.createdAt} TEXT NOT NULL)
''');
  }

  Future<List<Favorite>> readFavorites() async {
    final db = await database;
    final maps = await db.query(favoriteTable,
        orderBy: '${FavoriteFields.createdAt} DESC');
    if (maps.isNotEmpty) {
      final favorites = List<Favorite>.from(maps.map(
        (favorite) => Favorite.fromMap(favorite),
      ));
      return favorites;
    }
    return <Favorite>[];
  }

  Future<Favorite> createFavorite(Favorite favorite) async {
    final db = await database;
    final id = await db.insert(favoriteTable, favorite.toMap());
    
    return favorite.copyWith(id: id);
  }

  Future<bool> isFavoriteAlreadyExist(String restaurantId) async {
    final db = await database;
    final maps = await db.query(
      favoriteTable,
      columns: [FavoriteFields.restaurantId],
      where: '${FavoriteFields.restaurantId} = ?',
      whereArgs: [restaurantId],
    );

    if (maps.isNotEmpty) return Future.value(true);
    return Future.value(false);
  }

  Future<int> deletedFavorite() async {
    final db = await database;
    final maps = await db.delete(favoriteTable);
    return maps;
  }

  Future<int> deletedFavoriteById(int id) async {
    final db = await database;
    final maps = await db.delete(favoriteTable,
        where: '${FavoriteFields.id} = ?', whereArgs: [id]);
    return maps;
  }

  Future<int> deletedFavoriteByRestaurantId(String restaurantId) async {
    final db = await database;
    final maps = await db.delete(favoriteTable,
        where: '${FavoriteFields.restaurantId} = ?', whereArgs: [restaurantId]);
    return maps;
  }
}
