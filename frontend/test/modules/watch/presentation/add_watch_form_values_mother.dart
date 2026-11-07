import 'package:core/testing.dart';
import 'package:frontend/modules/watch/presentation/add_watch_form_values.dart';

abstract final class AddWatchFormValuesMother {
  static AddWatchFormValues valid() => AddWatchFormValues.create(
    name: WatchNameMother.random().value,
    brand: WatchBrandMother.random().value,
    type: WatchTypeMother.random().value,
    category: WatchCategoryMother.random().value,
    description: WatchDescriptionMother.random().value,
    tags: 'chrono, steel',
    complications: 'chronograph, date',
  );

  static AddWatchFormValues invalid() => AddWatchFormValues.create(
    name: '',
    brand: '',
    type: 'analog',
    category: 'quartz',
    description: '',
    tags: '',
    complications: '',
  );
}
