import 'package:core/src/shared/errors/domain_error.dart';

final class WatchDescription {
  const WatchDescription._(this.value);

  factory WatchDescription.create(String value) {
    final trimmed = value.trim();
    if (trimmed.length > maxLength) {
      throw InvalidWatchDescriptionError(trimmed.length);
    }
    return WatchDescription._(trimmed);
  }

  factory WatchDescription.empty() => const WatchDescription._('');

  static const int maxLength = 2000;

  final String value;

  bool get isEmpty => value.isEmpty;

  @override
  bool operator ==(Object other) =>
      other is WatchDescription && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidWatchDescriptionError extends DomainError {
  const InvalidWatchDescriptionError(int length)
    : super(
        'A watch description of $length characters is too long: '
        'the maximum is ${WatchDescription.maxLength}',
      );
}
