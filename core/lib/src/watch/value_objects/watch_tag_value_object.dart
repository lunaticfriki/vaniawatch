import 'package:core/src/shared/errors/domain_error.dart';

final class WatchTag {
  const WatchTag._(this.value);

  factory WatchTag.create(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty || normalized.length > maxLength) {
      throw InvalidWatchTagError(value);
    }
    return WatchTag._(normalized);
  }

  static const int maxLength = 30;

  final String value;

  @override
  bool operator ==(Object other) => other is WatchTag && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidWatchTagError extends DomainError {
  const InvalidWatchTagError(String value)
    : super(
        '"$value" is not a valid tag: it must have between 1 and '
        '${WatchTag.maxLength} characters',
      );
}
