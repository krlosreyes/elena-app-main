import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Entry point principal de la aplicación Elena
///
/// Inicializa Firebase y ejecuta la app con Riverpod
void main() async {
  // Asegurar inicialización de bindings de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase con opciones específicas de la plataforma
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// Requerido para formatear fechas en español
  await initializeDateFormatting('es');

  // Ejecutar app envuelta en ProviderScope para state management con Riverpod
  runApp(
    const ProviderScope(
      child: ElenaApp(),
    ),
  );
}
