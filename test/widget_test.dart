import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elena_app/app.dart';

void main() {
  testWidgets('App smoke test - verifica que inicia correctamente',
      (WidgetTester tester) async {
    // Construir la app
    await tester.pumpWidget(const ElenaApp());

    // Esperar a que se cargue todo
    await tester.pumpAndSettle();

    // Verificar que la app carga sin errores
    // (No hacemos asserts específicos porque depende del estado de auth)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
