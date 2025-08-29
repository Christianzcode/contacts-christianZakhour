// lib/data/local/app_db.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDb {
  static const _dbName = 'contacts.db';
  static const _dbVersion = 1;
  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, _) async {
        await db.execute('''
        CREATE TABLE contacts(
          id TEXT PRIMARY KEY,              -- UUID (local id)
          remoteId INTEGER,                 -- id from API (nullable)
          name TEXT NOT NULL,
          email TEXT,
          phone TEXT,
          company TEXT,
          updatedAt INTEGER NOT NULL,       -- millis since epoch
          pendingSync INTEGER NOT NULL,     -- 0/1
          deleted INTEGER NOT NULL,         -- tombstone 0/1
          deletedAt INTEGER                 -- nullable
        );
        ''');

        await db.execute('''
        CREATE TABLE history(
          id TEXT PRIMARY KEY,              -- UUID
          contactId TEXT NOT NULL,
          createdAt INTEGER NOT NULL,
          op TEXT NOT NULL,                 -- create/update/delete
          diff TEXT NOT NULL                -- JSON {field: {before, after}}
        );
        ''');

        await db.execute('''
        CREATE TABLE pending_ops(
          id TEXT PRIMARY KEY,
          contactId TEXT NOT NULL,
          op TEXT NOT NULL,                 -- upsert/delete
          payload TEXT NOT NULL,            -- JSON of the record we try to push
          updatedAt INTEGER NOT NULL
        );
        ''');
      },
    );
    return _db!;
  }
}
