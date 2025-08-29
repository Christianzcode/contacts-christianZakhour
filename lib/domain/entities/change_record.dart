import 'package:freezed_annotation/freezed_annotation.dart';
part 'change_record.freezed.dart';
part 'change_record.g.dart';

@freezed
class ChangeRecord with _$ChangeRecord {
  const factory ChangeRecord({
    required String id,
    required String contactId,
    required DateTime createdAt,
    required String op, // create/update/delete
    required Map<String, Map<String, dynamic>?> diff,
  }) = _ChangeRecord;

  factory ChangeRecord.fromJson(Map<String, dynamic> json) => _$ChangeRecordFromJson(json);
}