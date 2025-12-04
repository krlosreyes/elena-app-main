import 'package:flutter/material.dart';

class ElenaScreenLayout extends StatelessWidget {
  final Widget child;
  final Widget? navBar;

  const ElenaScreenLayout({
    super.key,
    required this.child,
    this.navBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF9),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: child,
            ),
          ),
        ),
      ),
      bottomNavigationBar: navBar, // ⬅️ AQUÍ. Nada más.
    );
  }
}
