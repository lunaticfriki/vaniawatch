import '../errors/invalid_watch_complication.error.dart';

class WatchComplication {
  const WatchComplication._(this.value);

  factory WatchComplication.create(String value) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      throw const InvalidWatchComplicationError();
    }
    return WatchComplication._(normalizedValue);
  }

  final String value;

  @override
  bool operator ==(Object other) =>
      other is WatchComplication && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
