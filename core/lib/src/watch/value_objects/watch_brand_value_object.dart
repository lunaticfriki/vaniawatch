import 'package:core/src/shared/errors/domain_error.dart';

final class WatchBrand {
  const WatchBrand._(this.value);

  factory WatchBrand.create(String value) {
    final trimmed = value.trim();
    if (trimmed.length < minLength || trimmed.length > maxLength) {
      throw InvalidWatchBrandError(value);
    }
    return WatchBrand._(trimmed);
  }

  factory WatchBrand.empty() => const WatchBrand._('');

  static const int minLength = 1;
  static const int maxLength = 50;

  final String value;

  bool get isEmpty => value.isEmpty;

  @override
  bool operator ==(Object other) => other is WatchBrand && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidWatchBrandError extends DomainError {
  const InvalidWatchBrandError(String value)
    : super(
        '"$value" is not a valid watch brand: it must have between '
        '${WatchBrand.minLength} and ${WatchBrand.maxLength} characters',
      );
}
