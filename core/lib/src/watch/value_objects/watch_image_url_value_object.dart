import 'package:core/src/shared/errors/domain_error.dart';

final class WatchImageUrl {
  const WatchImageUrl._(this.value);

  factory WatchImageUrl.create(String value) {
    final trimmed = value.trim();
    if (!_isValid(trimmed)) {
      throw InvalidWatchImageUrlError(value);
    }
    return WatchImageUrl._(trimmed);
  }

  factory WatchImageUrl.empty() => const WatchImageUrl._('');

  static const Set<String> _schemes = {'http', 'https'};

  static bool _isValid(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.isAbsolute &&
        _schemes.contains(uri.scheme) &&
        uri.host.isNotEmpty;
  }

  final String value;

  bool get isEmpty => value.isEmpty;

  @override
  bool operator ==(Object other) =>
      other is WatchImageUrl && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidWatchImageUrlError extends DomainError {
  const InvalidWatchImageUrlError(String value)
    : super(
        '"$value" is not a valid image url: it must be an http or https url',
      );
}
