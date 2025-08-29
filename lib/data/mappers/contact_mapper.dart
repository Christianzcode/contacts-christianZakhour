// lib/data/mappers/contact_mapper.dart
import 'package:uuid/uuid.dart';
import '../../domain/entities/contact.dart';
import '../dto/contact_dto.dart';

final _uuid = const Uuid();

extension ContactDtoMapper on ContactDto {
  Contact toEntity() => Contact(
    id: _uuid.v4(),        // local UUID for DB
    remoteId: id,
    name: name,
    email: email,
    phone: phone,
    company: company,
    updatedAt: DateTime.now(),
  );
}
