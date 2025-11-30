import 'package:flutter/material.dart';

class ElenaCenteredLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  const ElenaCenteredLayout({
    super.key,
    required this.child,
    this.maxWidth = 480,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding,
        child: child,
      ),
    );
  }
}

class ElenaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const ElenaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
