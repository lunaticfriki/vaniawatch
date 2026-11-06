import 'package:flutter/widgets.dart';
import 'package:frontend/app.dart';
import 'package:frontend/composition_root.dart';
import 'package:frontend/shared/infrastructure/api_config.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    CompositionRoot(
      config: ApiConfig.fromEnvironment(),
      client: http.Client(),
      child: const VaniaWatchApp(),
    ),
  );
}
