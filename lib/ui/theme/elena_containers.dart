import 'package:elena_app/ui/theme/elena_colors.dart';
import 'package:flutter/material.dart';

class ElenaContainerCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double maxWidth;

  const ElenaContainerCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.maxWidth = 650,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          margin: const EdgeInsets.only(bottom: 32),
          padding: padding,
          decoration: BoxDecoration(
            color: ElenaColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.black12.withOpacity(0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
