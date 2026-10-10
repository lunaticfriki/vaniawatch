import '../errors/invalid_user_id.error.dart';

class UserId {
  const UserId._(this.value);

  factory UserId.create(String value) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      throw const InvalidUserIdError();
    }
    return UserId._(normalizedValue);
  }

  factory UserId.empty() => const UserId._('');

  final String value;

  @override
  bool operator ==(Object other) => other is UserId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
