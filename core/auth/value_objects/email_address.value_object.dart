import '../errors/invalid_email_address.error.dart';

class EmailAddress {
  const EmailAddress._(this.value);

  factory EmailAddress.create(String value) {
    final normalizedValue = value.trim().toLowerCase();
    if (!_isValid(normalizedValue)) {
      throw const InvalidEmailAddressError();
    }
    return EmailAddress._(normalizedValue);
  }

  factory EmailAddress.empty() => const EmailAddress._('');

  final String value;

  static bool _isValid(String value) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
  }

  @override
  bool operator ==(Object other) =>
      other is EmailAddress && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
