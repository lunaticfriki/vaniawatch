import 'package:core/core.dart';
import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class WatchTagsMother {
  static WatchTags random({int? count}) => of(
    PrimitiveMother.uniqueWords(
      count ?? PrimitiveMother.integer(min: 1, max: 5),
    ),
  );

  static WatchTags of(List<String> values) =>
      WatchTags.create(values.map(WatchTag.create).toList());

  static WatchTags empty() => WatchTags.empty();
}
