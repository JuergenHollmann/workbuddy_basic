// import 'dart:io';
// // import 'package:flutter/services.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static Database? _database;

//   // Singleton-Muster
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     Directory documentsDir = await getApplicationDocumentsDirectory();
//     String dbPath = join(documentsDir.path, "JOTHAsoft.WorkBuddy.db");

//     return await openDatabase(
//       dbPath,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE KontaktDaten (
//         TKD_000 INTEGER PRIMARY KEY AUTOINCREMENT,
//         TKD_001 TEXT,
//         TKD_002 TEXT,
//         TKD_003 TEXT,
//         TKD_004 TEXT,
//         TKD_005 TEXT,
//         TKD_006 TEXT,
//         TKD_007 TEXT,
//         TKD_008 TEXT,
//         TKD_009 TEXT,
//         TKD_010 TEXT,
//         TKD_011 TEXT,
//         TKD_012 TEXT,
//         TKD_013 TEXT,
//         TKD_014 TEXT,
//         TKD_015 TEXT,
//         TKD_016 TEXT,
//         TKD_017 TEXT,
//         TKD_018 TEXT,
//         TKD_019 TEXT,
//         TKD_020 TEXT,
//         TKD_021 TEXT,
//         TKD_022 TEXT,
//         TKD_023 TEXT,
//         TKD_024 TEXT,
//         TKD_025 TEXT,
//         TKD_026 TEXT,
//         TKD_027 TEXT,
//         TKD_028 TEXT,
//         TKD_029 TEXT,
//         TKD_030 TEXT
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE BenutzerDaten (
//         TBD_000 INTEGER PRIMARY KEY AUTOINCREMENT,
//         TBD_001 TEXT,
//         TBD_002 TEXT,
//         TBD_003 TEXT,
//         TBD_004 TEXT,
//         TBD_005 TEXT,
//         TBD_006 TEXT,
//         TBD_007 TEXT,
//         TBD_008 TEXT,
//         TBD_009 TEXT,
//         TBD_010 TEXT,
//         TBD_011 TEXT,
//         TBD_012 TEXT,
//         TBD_013 TEXT,
//         TBD_014 TEXT,
//         TBD_015 TEXT,
//         TBD_016 TEXT,
//         TBD_017 TEXT,
//         TBD_018 TEXT,
//         TBD_019 TEXT,
//         TBD_020 TEXT,
//         TBD_021 TEXT,
//         TBD_022 TEXT,
//         TBD_023 TEXT,
//         TBD_024 TEXT,
//         TBD_025 TEXT,
//         TBD_026 TEXT,
//         TBD_027 TEXT,
//         TBD_028 TEXT,
//         TBD_029 TEXT,
//         TBD_030 TEXT
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE EinstellungenKontakte (
//         TEK_000 INTEGER PRIMARY KEY AUTOINCREMENT,
//         TEK_001 TEXT,
//         TEK_002 TEXT,
//         TEK_003 TEXT,
//         TEK_004 TEXT,
//         TEK_005 TEXT,
//         TEK_006 TEXT,
//         TEK_007 TEXT,
//         TEK_008 TEXT,
//         TEK_009 TEXT,
//         TEK_010 TEXT,
//         TEK_011 TEXT,
//         TEK_012 TEXT,
//         TEK_013 TEXT,
//         TEK_014 TEXT,
//         TEK_015 TEXT,
//         TEK_016 TEXT,
//         TEK_017 TEXT,
//         TEK_018 TEXT,
//         TEK_019 TEXT,
//         TEK_020 TEXT,
//         TEK_021 TEXT,
//         TEK_022 TEXT,
//         TEK_023 TEXT,
//         TEK_024 TEXT,
//         TEK_025 TEXT,
//         TEK_026 TEXT,
//         TEK_027 TEXT,
//         TEK_028 TEXT,
//         TEK_029 TEXT,
//         TEK_030 TEXT
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE EinstellungenBenutzer (
//         TEB_000 INTEGER PRIMARY KEY AUTOINCREMENT,
//         TEB_001 TEXT,
//         TEB_002 TEXT,
//         TEB_003 TEXT,
//         TEB_004 TEXT,
//         TEB_005 TEXT,
//         TEB_006 TEXT,
//         TEB_007 TEXT,
//         TEB_008 TEXT,
//         TEB_009 TEXT,
//         TEB_010 TEXT,
//         TEB_011 TEXT,
//         TEB_012 TEXT,
//         TEB_013 TEXT,
//         TEB_014 TEXT,
//         TEB_015 TEXT,
//         TEB_016 TEXT,
//         TEB_017 TEXT,
//         TEB_018 TEXT,
//         TEB_019 TEXT,
//         TEB_020 TEXT,
//         TEB_021 TEXT,
//         TEB_022 TEXT,
//         TEB_023 TEXT,
//         TEB_024 TEXT,
//         TEB_025 TEXT,
//         TEB_026 TEXT,
//         TEB_027 TEXT,
//         TEB_028 TEXT,
//         TEB_029 TEXT,
//         TEB_030 TEXT
//       )
//     ''');

//     // Tabelle "EinkaufVerkauf"
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS EinkaufVerkauf (
//         TEV_000 INTEGER PRIMARY KEY AUTOINCREMENT,
//         TEV_001 TEXT,
//         TEV_002 TEXT,
//         TEV_003 TEXT,
//         TEV_004 TEXT,
//         TEV_005 TEXT,
//         TEV_006 TEXT,
//         TEV_007 TEXT,
//         TEV_008 TEXT,
//         TEV_009 TEXT,
//         TEV_010 TEXT,
//         TEV_011 TEXT,
//         TEV_012 TEXT,
//         TEV_013 TEXT,
//         TEV_014 TEXT,
//         TEV_015 TEXT,
//         TEV_016 TEXT,
//         TEV_017 TEXT,
//         TEV_018 TEXT,
//         TEV_019 TEXT,
//         TEV_020 TEXT,
//         TEV_021 TEXT,
//         TEV_022 TEXT,
//         TEV_023 TEXT,
//         TEV_024 TEXT,
//         TEV_025 TEXT,
//         TEV_026 TEXT,
//         TEV_027 TEXT,
//         TEV_028 TEXT,
//         TEV_029 TEXT,
//         TEV_030 TEXT
//       )
//     ''');
    
//   }
// }



// // import 'dart:io';
// // import 'package:flutter/services.dart';
// // import 'package:path/path.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:sqflite/sqflite.dart';

// // class DatabaseHelper {
// //   static Database? _database;

// //   // Singleton-Muster
// //   Future<Database> get database async {
// //     if (_database != null) return _database!;
// //     _database = await _openDatabaseFromAssets();
// //     return _database!;
// //   }

// //   Future<Database> _openDatabaseFromAssets() async {
// //     Directory documentsDir = await getApplicationDocumentsDirectory();
// //     String dbPath = join(documentsDir.path, "JOTHAsoft.FiveStars.db");
// //     bool dbExists = await databaseExists(dbPath);

// //     if (!dbExists) {
// //       // Datenbank existiert nicht, erstelle eine leere Kopie
// //       await _createEmptyDatabase(dbPath);
// //     }

// //     return openDatabase(dbPath);
// //   }

// //   Future<void> _createEmptyDatabase(String dbPath) async {
// //     // Lade die leere Datenbank aus den Assets
// //     ByteData data = await rootBundle.load("assets/JOTHAsoft.FiveStars.db");
// //     List<int> bytes = data.buffer.asUint8List();

// //     // Schreibe die leere Datenbank in den Speicher
// //     await File(dbPath).writeAsBytes(bytes, flush: true);
// //   }
// // }
