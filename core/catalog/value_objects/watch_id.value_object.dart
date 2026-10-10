import '../errors/invalid_watch_id.error.dart';

class WatchId {
  const WatchId._(this.value);

  factory WatchId.create(String value) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      throw const InvalidWatchIdError();
    }
    return WatchId._(normalizedValue);
  }

  factory WatchId.empty() => const WatchId._('');

  final String value;

  @override
  bool operator ==(Object other) => other is WatchId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
