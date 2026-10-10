import '../errors/invalid_watch_description.error.dart';

class WatchDescription {
  const WatchDescription._(this.value);

  factory WatchDescription.create(String value) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      throw const InvalidWatchDescriptionError();
    }
    return WatchDescription._(normalizedValue);
  }

  final String value;

  @override
  bool operator ==(Object other) =>
      other is WatchDescription && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
