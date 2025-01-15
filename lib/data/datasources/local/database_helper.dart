import 'dart:async';

import 'package:snappy/common/constant/app_constant.dart';
import 'package:snappy/data/models/model/model_story.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblSnappy = TABLE_NAME;

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/$DB_NAME';

    var db = await openDatabase(
      databasePath,
      version: DB_VERSION,
      onCreate: _onCreate,
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblSnappy (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        createdAt TEXT,
        lat TEXT,
        lon TEXT
      );
    ''');
  }

  Future<int> insertOrUpdateListStory(List<StoryModel> listStory) async {
    final db = await database;

    final existingStories = await db!.query(_tblSnappy);
    final existingIds = existingStories.map((e) => e['id']).toSet();
    final responseIds = listStory.map((story) => story.id).toSet();

    final batch = db.batch();

    for (final story in listStory) {
      if (!existingIds.contains(story.id)) {
        batch.insert(_tblSnappy, story.toJson());
      } else {
        batch.update(
          _tblSnappy,
          story.toJson(),
          where: 'id = ?',
          whereArgs: [story.id],
        );
      }
    }

    for (final id in existingIds) {
      if (!responseIds.contains(id)) {
        batch.delete(
          _tblSnappy,
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    }

    await batch.commit(noResult: true);

    return 1;
  }

  Future<Map<String, dynamic>?> getStoryById(String id) async {
    final db = await database;
    final results = await db!.query(
      _tblSnappy,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getStories() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblSnappy);

    return results;
  }
}
