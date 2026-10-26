import 'package:core/src/shared/errors/domain_error.dart';

final class WatchName {
  const WatchName._(this.value);

  factory WatchName.create(String value) {
    final trimmed = value.trim();
    if (trimmed.length < minLength || trimmed.length > maxLength) {
      throw InvalidWatchNameError(value);
    }
    return WatchName._(trimmed);
  }

  factory WatchName.empty() => const WatchName._('');

  static const int minLength = 1;
  static const int maxLength = 100;

  final String value;

  bool get isEmpty => value.isEmpty;

  @override
  bool operator ==(Object other) => other is WatchName && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidWatchNameError extends DomainError {
  const InvalidWatchNameError(String value)
    : super(
        '"$value" is not a valid watch name: it must have between '
        '${WatchName.minLength} and ${WatchName.maxLength} characters',
      );
}
