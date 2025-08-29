// lib/data/local/history_dao.dart
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/change_record.dart';
import 'data_base_scheme.dart';

class HistoryDao {
  Future<Database> get _db async => AppDb.instance();

  Future<void> insert(ChangeRecord r) async {
    final db = await _db;
    await db.insert('history', {
      'id': r.id,
      'contactId': r.contactId,
      'createdAt': r.createdAt.millisecondsSinceEpoch,
      'op': r.op,
      'diff': jsonEncode(r.diff), // store as JSON text
    });
  }

  Future<List<ChangeRecord>> forContact(String contactId) async {
    final db = await _db;
    final rows = await db.query(
      'history',
      where: 'contactId=?',
      whereArgs: [contactId],
      orderBy: 'createdAt DESC',
    );

    Map<String, dynamic> _safeDecodeDiff(dynamic raw) {
      // Already a map? (in case of future changes)
      if (raw is Map<String, dynamic>) return raw;

      if (raw is String) {
        // 1) try proper JSON
        try {
          final m = jsonDecode(raw);
          if (m is Map<String, dynamic>) return m;
        } catch (_) {
          // 2) try to repair legacy formats like: company = { ... } / single quotes, etc.
          String s = raw;

          // replace `key =` → `"key":`
          s = s.replaceAllMapped(
            RegExp(r'([A-Za-z0-9_]+)\s*='),
                (m) => '"${m[1]}":',
          );

          // single quotes → double quotes
          s = s.replaceAll("'", '"');

          // try decode again
          try {
            final m2 = jsonDecode(s);
            if (m2 is Map<String, dynamic>) return m2;
          } catch (_) {/* fall through */}
        }
      }
      // last resort: empty diff so UI doesn't crash
      return <String, dynamic>{};
    }

    return rows.map((r) {
      final diffMap = _safeDecodeDiff(r['diff']);
      return ChangeRecord.fromJson({
        'id': r['id'],
        'contactId': r['contactId'],
        'createdAt': DateTime
            .fromMillisecondsSinceEpoch(r['createdAt'] as int)
            .toIso8601String(),
        'op': r['op'],
        'diff': diffMap,
      });
    }).toList();
  }
}
