import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSqFlite {
  static Database? _db;
  static DatabaseSqFlite? _i;

  final String dbname = 'sqlite.db';
  static String? _path;

  DatabaseSqFlite._();

  factory DatabaseSqFlite() {
    return _i ??= DatabaseSqFlite._();
  }

  Future<Database?> get db async => _db ??= await _init();
  get path async => _path ??= join(await getDatabasesPath(), dbname);

  Future<Database?> _init() async {
    String pathh = join(await getDatabasesPath(), dbname);

    return await openDatabase(
      pathh,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(_pragmakeys);
    await db.execute(_calculosImc);
  }

  Future _onConfigure(Database db) async {
    await db.execute(_pragmakeys);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  get _pragmakeys => 'PRAGMA foreign_keys = ON';

  get _calculosImc => '''
  CREATE TABLE calculos_imc (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    data TEXT NOT NULL,
    imc REAL NOT NULL,
    peso REAL NOT NULL,
    classificacao TEXT
  )
  ''';
}
