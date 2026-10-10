import '../errors/invalid_watch_model.error.dart';

class WatchModel {
  const WatchModel._(this.value);

  factory WatchModel.create(String value) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      throw const InvalidWatchModelError();
    }
    return WatchModel._(normalizedValue);
  }

  factory WatchModel.empty() => const WatchModel._('');

  final String value;

  @override
  bool operator ==(Object other) => other is WatchModel && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
