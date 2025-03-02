import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  // Singleton-Muster
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabaseFromAssets();
    return _database!;
  }

  Future<Database> _openDatabaseFromAssets() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDir.path, "JOTHAsoft.FiveStars.db");
    bool dbExists = await databaseExists(dbPath);

    if (!dbExists) {
      // Datenbank existiert nicht, erstelle eine leere Kopie
      await _createEmptyDatabase(dbPath);
    }

    return openDatabase(dbPath);
  }

  Future<void> _createEmptyDatabase(String dbPath) async {
    // Lade die leere Datenbank aus den Assets
    ByteData data = await rootBundle.load("assets/JOTHAsoft.FiveStars.db");
    List<int> bytes = data.buffer.asUint8List();

    // Schreibe die leere Datenbank in den Speicher
    await File(dbPath).writeAsBytes(bytes, flush: true);
  }
}
