import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/weather_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'weather.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cities(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            condition TEXT NOT NULL,
            temperature REAL NOT NULL,
            forecast TEXT NOT NULL
          )
        ''');
      },
      version: 1,
    );
  }

  Future<int> insertCity(WeatherModel city) async {
    final db = await database;

    // Ensure forecast is serialized correctly
    final forecastJson = jsonEncode(city.forecast);

    return db.insert(
      'cities',
      {
        'name': city.name,
        'condition': city.condition,
        'temperature': city.temperature,
        'forecast': forecastJson,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WeatherModel>> getCities() async {
    final db = await database;
    final maps = await db.query('cities');

    return List.generate(maps.length, (i) {
      return WeatherModel(
        name: maps[i]['name'] as String,
        condition: maps[i]['condition'] as String,
        temperature: maps[i]['temperature'] as double,
        forecast: List<Map<String, dynamic>>.from(
          jsonDecode(maps[i]['forecast'] as String), // Decode directly
        ),
      );
    });
  }

  Future<int> deleteCity(String cityName) async {
    final db = await database;
    return db.delete(
      'cities',
      where: 'name = ?',
      whereArgs: [cityName],
    );
  }

  Future<void> deleteAllCities() async {
    final db = await database;
    await db.delete('cities');
  }
}
