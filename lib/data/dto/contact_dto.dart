// lib/data/dto/contact_dto.dart
class ContactDto {
  final int id;

  final String name;
  final String email;
  final String phone;
  final String company;

  ContactDto({required this.id, required this.name, required this.email, required this.phone, required this.company});

  factory ContactDto.fromJson(Map<String, dynamic> j) => ContactDto(
    id: j['id'] as int,
    name: j['name'] ?? '',
    email: j['email'] ?? '',
    phone: j['phone'] ?? '',
    company: (j['company']?['name'] ?? '').toString(),
  );
}
