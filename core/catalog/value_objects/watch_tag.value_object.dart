import '../errors/invalid_watch_tag.error.dart';

class WatchTag {
  const WatchTag._(this.value);

  factory WatchTag.create(String value) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      throw const InvalidWatchTagError();
    }
    return WatchTag._(normalizedValue);
  }

  final String value;

  @override
  bool operator ==(Object other) => other is WatchTag && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
