import '../errors/invalid_watch_image_url.error.dart';

class WatchImageUrl {
  const WatchImageUrl._(this.value);

  factory WatchImageUrl.create(String value) {
    final normalizedValue = value.trim();
    final uri = Uri.tryParse(normalizedValue);
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw const InvalidWatchImageUrlError();
    }
    return WatchImageUrl._(normalizedValue);
  }

  final String value;

  @override
  bool operator ==(Object other) =>
      other is WatchImageUrl && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
