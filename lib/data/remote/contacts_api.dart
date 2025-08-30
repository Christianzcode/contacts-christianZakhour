// lib/data/remote/contacts_api.dart
import 'package:dio/dio.dart';
import '../dto/contact_dto.dart';

class ContactsApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {
        'User-Agent': 'contacts-app/1.0 (Flutter; iOS)', // 👈 add this
        'Accept': 'application/json',
      },
    ),
  );

  Future<List<ContactDto>> fetchAll() async {
    try {
      final res = await _dio.get('/users');
      final list = (res.data as List).cast<Map<String, dynamic>>();
      return list.map(ContactDto.fromJson).toList();
    } on DioException catch (e) {
      // log diagnostics
      // ignore: avoid_print
      print('[ContactsApi.fetchAll] DioException: ${e.type} ${e.message} '
          'status=${e.response?.statusCode}');
      rethrow;
    } catch (e) {
      // ignore: avoid_print
      print('[ContactsApi.fetchAll] Error: $e');
      rethrow;
    }
  }

  Future<void> upsert(Map<String, dynamic> payload, {int? remoteId}) async {
    try {
      if (remoteId == null) {
        await _dio.post('/users', data: payload);
      } else {
        await _dio.put('/users/$remoteId', data: payload);
      }
    } on DioException catch (e) {
      print('[ContactsApi.upsert] ${e.type} ${e.message} status=${e.response?.statusCode}');
      rethrow;
    }
  }

  Future<void> deleteRemote(int remoteId) async {
    try {
      await _dio.delete('/users/$remoteId');
    } on DioException catch (e) {
      print('[ContactsApi.deleteRemote] ${e.type} ${e.message} status=${e.response?.statusCode}');
      rethrow;
    }
  }
}
