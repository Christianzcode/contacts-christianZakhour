// lib/data/local/pending_ops_dao.dart
import 'package:sqflite/sqflite.dart';

import 'data_base_scheme.dart';

class PendingOpsDao {
  Future<Database> get _db async => AppDb.instance();

  Future<void> push(String id, String contactId, String op, String payload, int updatedAt) async {
    final db = await _db;
    await db.insert('pending_ops', {
      'id': id,
      'contactId': contactId,
      'op': op,
      'payload': payload,
      'updatedAt': updatedAt,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String,dynamic>>> all() async {
    final db = await _db;
    return db.query('pending_ops', orderBy: 'updatedAt ASC');
  }

  Future<void> remove(String id) async {
    final db = await _db;
    await db.delete('pending_ops', where: 'id=?', whereArgs: [id]);
  }
}
