import 'package:backend/modules/watch/presentation/watch_openapi.dart';
import 'package:backend/shared/http/health_openapi.dart';
import 'package:backend/shared/http/openapi_document.dart';

abstract final class ApiDocument {
  static Map<String, Object?> build() => OpenApiDocument.create(
    sections: [HealthOpenApi.section, WatchOpenApi.section],
  );
}
