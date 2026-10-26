import 'package:core/src/shared/errors/domain_error.dart';

final class WatchCategory {
  const WatchCategory._(this.value);

  factory WatchCategory.mechanical() => const WatchCategory._(_mechanical);

  factory WatchCategory.quartz() => const WatchCategory._(_quartz);

  factory WatchCategory.create(String value) {
    final normalized = value.trim().toLowerCase();
    if (!_values.contains(normalized)) {
      throw InvalidWatchCategoryError(value);
    }
    return WatchCategory._(normalized);
  }

  static const String _mechanical = 'mechanical';
  static const String _quartz = 'quartz';
  static const List<String> _values = [_mechanical, _quartz];

  final String value;

  bool get isMechanical => value == _mechanical;

  bool get isQuartz => value == _quartz;

  @override
  bool operator ==(Object other) =>
      other is WatchCategory && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

final class InvalidWatchCategoryError extends DomainError {
  const InvalidWatchCategoryError(String value)
    : super('"$value" is not a watch category: expected mechanical or quartz');
}
