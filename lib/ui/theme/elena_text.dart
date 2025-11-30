import 'package:flutter/material.dart';
import 'elena_colors.dart';

class ElenaText {
  static const title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: ElenaColors.textPrimary,
  );

  static const subtitle = TextStyle(
    fontSize: 18,
    color: ElenaColors.textSecondary,
  );

  static const body = TextStyle(
    fontSize: 16,
    color: ElenaColors.textPrimary,
  );

  static const caption = TextStyle(
    fontSize: 14,
    color: ElenaColors.textSecondary,
  );

  static const button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

class ElenaTitle extends StatelessWidget {
  final String text;
  const ElenaTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: ElenaText.title);
  }
}

class ElenaSubtitle extends StatelessWidget {
  final String text;
  const ElenaSubtitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: ElenaText.subtitle);
  }
}

class ElenaLabel extends StatelessWidget {
  final String text;
  const ElenaLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: ElenaText.caption.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class ElenaSectionTitle extends StatelessWidget {
  final String text;

  const ElenaSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ElenaColors.textDark,
          ),
    );
  }
}
