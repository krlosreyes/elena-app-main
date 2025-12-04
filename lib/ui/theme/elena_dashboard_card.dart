import 'package:flutter/material.dart';

class ElenaDashboardCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color background;

  const ElenaDashboardCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.background = const Color(0xFF1E1E1E),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}
