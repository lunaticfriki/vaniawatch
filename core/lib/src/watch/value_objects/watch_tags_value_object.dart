import 'package:core/src/shared/errors/domain_error.dart';
import 'package:core/src/watch/value_objects/watch_tag_value_object.dart';

final class WatchTags {
  WatchTags._(List<WatchTag> values) : values = List.unmodifiable(values);

  factory WatchTags.create(List<WatchTag> values) {
    final unique = values.toSet().toList();
    if (unique.length > maxLength) {
      throw InvalidWatchTagsError(unique.length);
    }
    return WatchTags._(unique);
  }

  factory WatchTags.empty() => WatchTags._(const []);

  static const int maxLength = 20;

  final List<WatchTag> values;

  int get length => values.length;

  bool get isEmpty => values.isEmpty;

  bool contains(WatchTag tag) => values.contains(tag);

  WatchTags add(WatchTag tag) => WatchTags.create([...values, tag]);

  WatchTags remove(WatchTag tag) =>
      WatchTags.create(values.where((value) => value != tag).toList());

  @override
  bool operator ==(Object other) =>
      other is WatchTags &&
      other.length == length &&
      other.values.toSet().containsAll(values);

  @override
  int get hashCode => Object.hashAllUnordered(values);

  @override
  String toString() => values.join(', ');
}

final class InvalidWatchTagsError extends DomainError {
  const InvalidWatchTagsError(int count)
    : super(
        'A watch cannot have $count tags: the maximum is '
        '${WatchTags.maxLength}',
      );
}
