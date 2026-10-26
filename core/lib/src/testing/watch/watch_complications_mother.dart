import 'package:core/src/testing/shared/primitive_mother.dart';

abstract final class WatchComplicationsMother {
  static const List<String> known = [
    'chronograph',
    'date',
    'day-date',
    'gmt',
    'moon phase',
    'power reserve',
    'tourbillon',
    'minute repeater',
    'perpetual calendar',
    'alarm',
    'world time',
  ];

  static List<String> random({int? count}) {
    final shuffled = [...known]..shuffle();
    return shuffled
        .take(count ?? PrimitiveMother.integer(min: 1, max: 4))
        .toList();
  }

  static List<String> empty() => const [];
}
