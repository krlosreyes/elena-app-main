import 'package:flutter/material.dart';
import 'package:elena_app/ui/elena_ui_system.dart';

class EditableFastingTimeCard extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final bool isEditable;
  final void Function(DateTime)? onStartChanged;

  const EditableFastingTimeCard({
    required this.start,
    required this.end,
    required this.isEditable,
    this.onStartChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: ElenaColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ElenaColors.primary, width: 1.1),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: !isEditable
                  ? null
                  : () async {
                      final now = DateTime.now();
                      final picked = await showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay(hour: start.hour, minute: start.minute),
                      );
                      if (picked != null) {
                        final pickedDate = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          picked.hour,
                          picked.minute,
                        );
                        onStartChanged?.call(pickedDate);
                      }
                    },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('INICIO DEL AYUNO',
                          style: TextStyle(
                              color: ElenaColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      if (isEditable)
                        const Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Icon(Icons.edit,
                              size: 15, color: ElenaColors.primary),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Hoy ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                        color: ElenaColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  )
                ],
              ),
            ),
          ),
          Container(width: 1, height: 40, color: ElenaColors.border),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('FIN DEL AYUNO',
                        style: TextStyle(
                            color: ElenaColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Mañana ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                      color: ElenaColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
