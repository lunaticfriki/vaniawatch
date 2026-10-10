import '../errors/invalid_watch_brand.error.dart';

class WatchBrand {
  const WatchBrand._(this.value);

  factory WatchBrand.create(String value) {
    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) {
      throw const InvalidWatchBrandError();
    }
    return WatchBrand._(normalizedValue);
  }

  factory WatchBrand.empty() => const WatchBrand._('');

  final String value;

  @override
  bool operator ==(Object other) => other is WatchBrand && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
