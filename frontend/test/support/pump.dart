import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpView on WidgetTester {
  Future<void> pumpView(Widget view) =>
      pumpWidget(MaterialApp(home: Scaffold(body: view)));
}
