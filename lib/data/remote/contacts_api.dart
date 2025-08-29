// lib/data/remote/contacts_api.dart
import 'package:dio/dio.dart';
import '../dto/contact_dto.dart';

class ContactsApi {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

  Future<List<ContactDto>> fetchAll() async {
    final res = await _dio.get('/users');
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(ContactDto.fromJson).toList();
  }

  // jsonplaceholder accepts POST/PUT/DELETE (fake) — good for demo of sync.
  Future<void> upsert(Map<String, dynamic> payload, {int? remoteId}) async {
    if (remoteId == null) {
      await _dio.post('/users', data: payload);
    } else {
      await _dio.put('/users/$remoteId', data: payload);
    }
  }

  Future<void> deleteRemote(int remoteId) async {
    await _dio.delete('/users/$remoteId');
  }
}
