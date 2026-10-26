import 'package:core/src/shared/errors/domain_error.dart';

final class WatchType {
  const WatchType._(this.value);

  factory WatchType.analog() => const WatchType._(_analog);

  factory WatchType.digital() => const WatchType._(_digital);

  factory WatchType.anaDigi() => const WatchType._(_anaDigi);

  factory WatchType.create(String value) {
    final normalized = value.trim().toLowerCase();
    if (!_values.contains(normalized)) {
      throw InvalidWatchTypeError(value);
    }
    return WatchType._(normalized);
  }

  static const String _analog = 'analog';
  static const String _digital = 'digital';
  static const String _anaDigi = 'anadigi';
  static const List<String> _values = [_analog, _digital, _anaDigi];

  final String value;

  bool get isAnalog => value == _analog;

  bool get isDigital => value == _digital;

  bool get isAnaDigi => value == _anaDigi;

  @override
  bool operator ==(Object other) => other is WatchType && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidWatchTypeError extends DomainError {
  const InvalidWatchTypeError(String value)
    : super(
        '"$value" is not a watch type: expected analog, digital or anadigi',
      );
}
