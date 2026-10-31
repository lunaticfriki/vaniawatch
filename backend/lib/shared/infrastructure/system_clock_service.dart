import 'package:backend/shared/application/clock_service.dart';

final class SystemClockService implements ClockService {
  const SystemClockService();

  @override
  DateTime now() => DateTime.now().toUtc();
}
