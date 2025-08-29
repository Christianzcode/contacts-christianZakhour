// lib/domain/entities/contact.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'contact.freezed.dart';
part 'contact.g.dart';


@freezed
class Contact with _$Contact {
  const factory Contact({
    required String id,          // local UUID
    int? remoteId,               // server ID if present
    required String name,
    String? email,
    String? phone,
    String? company,
    required DateTime updatedAt,
    @Default(false) bool pendingSync,
    @Default(false) bool deleted,
    DateTime? deletedAt,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
