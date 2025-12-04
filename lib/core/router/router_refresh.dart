import 'dart:async';
import 'package:flutter/widgets.dart';

/// Permite que GoRouter se reconstruya cuando el authState cambia
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyOnListen();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  void notifyOnListen() {
    Future.microtask(notifyListeners);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
