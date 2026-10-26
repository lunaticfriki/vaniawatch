import 'package:core/src/shared/errors/domain_error.dart';
import 'package:core/src/shared/services/uuid_service.dart';

final class WatchId {
  const WatchId._(this.value);

  factory WatchId.create(String value) {
    final normalized = value.trim().toLowerCase();
    if (!UuidService.isValid(normalized)) {
      throw InvalidWatchIdError(value);
    }
    return WatchId._(normalized);
  }

  factory WatchId.generate() => WatchId._(UuidService.generate());

  factory WatchId.empty() => const WatchId._('');

  final String value;

  bool get isEmpty => value.isEmpty;

  @override
  bool operator ==(Object other) => other is WatchId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidWatchIdError extends DomainError {
  const InvalidWatchIdError(String value)
    : super('"$value" is not a valid watch id');
}
