import 'package:flutter/material.dart';

class WeeklyCheckinScreen extends StatelessWidget {
  const WeeklyCheckinScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-in Semanal')),
      body: const Center(
        child: Text('Check-in semanal - Próximamente'),
      ),
    );
  }
}
