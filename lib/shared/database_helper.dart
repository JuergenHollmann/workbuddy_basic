import 'dart:developer';
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
    log('0046 - DatabaseHelper - Öffnet die Datenbank');
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDir.path, "JOTHAsoft.FiveStars.db");
    bool dbExists = await databaseExists(dbPath);

    if (!dbExists) {
      ByteData data = await rootBundle.load("assets/JOTHAsoft.FiveStars.db");
      List<int> bytes = data.buffer.asUint8List();
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }
    return openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS KundenDaten (
          TKD_Feld_001 TEXT,
          TKD_Feld_002 TEXT,
          TKD_Feld_003 TEXT,
          TKD_Feld_004 TEXT,
          TKD_Feld_005 TEXT,
          TKD_Feld_006 TEXT,
          TKD_Feld_007 TEXT,
          TKD_Feld_008 TEXT,
          TKD_Feld_009 TEXT,
          TKD_Feld_010 TEXT,
          TKD_Feld_011 TEXT,
          TKD_Feld_012 TEXT,
          TKD_Feld_013 TEXT,
          TKD_Feld_014 TEXT,
          TKD_Feld_015 TEXT,
          TKD_Feld_016 TEXT,
          TKD_Feld_017 TEXT,
          TKD_Feld_018 TEXT,
          TKD_Feld_019 TEXT,
          TKD_Feld_020 TEXT,
          TKD_Feld_021 TEXT,
          TKD_Feld_022 TEXT,
          TKD_Feld_023 TEXT,
          TKD_Feld_024 TEXT,
          TKD_Feld_025 TEXT,
          TKD_Feld_026 TEXT,
          TKD_Feld_027 TEXT,
          TKD_Feld_028 TEXT,
          TKD_Feld_029 TEXT,
          TKD_Feld_030 TEXT PRIMARY KEY
        )
      ''');
    });
  }
}

// /*--------------------------------- SQL-Datenbank ---*/
// class DatabaseHelper {
//   static Database? _database;

//   // Singleton-Muster
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _openDatabaseFromAssets();
//     return _database!;
//   }

//   Future<Database> _openDatabaseFromAssets() async {
//     log('0046 - ContactScreen - Öffnet die Datenbank');
//     Directory documentsDir = await getApplicationDocumentsDirectory();
//     String dbPath = join(documentsDir.path, "JOTHAsoft.FiveStars.db");
//     bool dbExists = await databaseExists(dbPath);

//     if (!dbExists) {
//       ByteData data = await rootBundle.load("assets/JOTHAsoft.FiveStars.db");
//       List<int> bytes = data.buffer.asUint8List();
//       await File(dbPath).writeAsBytes(bytes, flush: true);
//     }
//     return openDatabase(dbPath);
//   }
// }

// Future<int> updateTest(Map<String, dynamic> row) async {
//   Database db = await instance.database;
//   int id = row[columnId];
//   return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
// }

// Future<void> updateDog() async {
//   // Get a reference to the database.
//   final db = await database;

//   // Update the given Dog.
//   await db.update(
//     'dogs',
//     dog.toMap(),
//     // Ensure that the Dog has a matching id.
//     where: "id = ?",
//     // Pass the Dog's id as a whereArg to prevent SQL injection.
//     whereArgs: [dog.id],
//   );
// }
