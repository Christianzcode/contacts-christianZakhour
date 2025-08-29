class Validators {
  static String? requiredField(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final ok = RegExp(r'^[\w.\-]+@[\w.\-]+\.[A-Za-z]{2,}$').hasMatch(v.trim());
    return ok ? null : 'Invalid email';
  }
  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final ok = RegExp(r'^[0-9+]+$').hasMatch(v.trim());
    return ok ? null : 'Digits/+ only';
  }
}