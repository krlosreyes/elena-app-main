import 'package:flutter/material.dart';
import 'package:elena_app/ui/elena_ui_system.dart';

class AyunoDropdown extends StatelessWidget {
  final List<String> protocolos;
  final String seleccionado;
  final bool enabled;
  final Function(String?) onChanged;

  const AyunoDropdown({
    required this.protocolos,
    required this.seleccionado,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        color: ElenaColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ElenaColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          isExpanded: false,
          value: seleccionado,
          items: protocolos.map((p) {
            return DropdownMenuItem(
              value: p,
              child: Row(
                children: [
                  Text(
                    p,
                    style: TextStyle(
                        color: p == seleccionado
                            ? ElenaColors.primary
                            : ElenaColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          icon: Icon(Icons.edit,
              size: 18,
              color: enabled ? ElenaColors.primary : ElenaColors.border),
          dropdownColor: ElenaColors.surface,
        ),
      ),
    );
  }
}
