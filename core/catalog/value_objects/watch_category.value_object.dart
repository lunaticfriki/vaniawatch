import '../errors/invalid_watch_category.error.dart';

class WatchCategory {
  const WatchCategory._(this.value);

  factory WatchCategory.create(String value) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      throw const InvalidWatchCategoryError();
    }
    return WatchCategory._(normalizedValue);
  }

  factory WatchCategory.empty() => const WatchCategory._('');

  final String value;

  @override
  bool operator ==(Object other) =>
      other is WatchCategory && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
