import 'package:intl/intl.dart';

/// Helpers para manejo de fechas y horas
class DateHelpers {
  /// Formato de fecha corta: "20 Nov"
  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM', 'es_ES').format(date);
  }

  /// Formato de fecha larga: "20 de Noviembre de 2025"
  static String formatLongDate(DateTime date) {
    return DateFormat('d \'de\' MMMM \'de\' y', 'es_ES').format(date);
  }

  /// Formato de hora: "14:30"
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// Formato de fecha y hora: "20 Nov 14:30"
  static String formatDateTime(DateTime dateTime) {
    return '${formatShortDate(dateTime)} ${formatTime(dateTime)}';
  }

  /// Obtiene identificador de fecha para Firestore: "2025-11-20"
  static String getDateIdentifier(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Obtiene identificador de semana: "2025-W47"
  static String getWeekIdentifier(DateTime date) {
    final year = date.year;
    final weekNumber = getWeekNumber(date);
    return '$year-W${weekNumber.toString().padLeft(2, '0')}';
  }

  /// Calcula número de semana del año
  static int getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
  }

  /// Verifica si dos fechas son el mismo día
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Verifica si una fecha es hoy
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Obtiene el inicio del día
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Obtiene el fin del día
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Calcula duración en formato legible: "2h 30m"
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Calcula tiempo restante hasta una hora objetivo
  static Duration timeUntil(DateTime targetTime) {
    final now = DateTime.now();
    return targetTime.difference(now);
  }

  /// Verifica si dos fechas son días consecutivos
  static bool areConsecutiveDays(DateTime date1, DateTime date2) {
    final diff = date2.difference(date1);
    return diff.inDays == 1;
  }

  /// Obtiene el lunes de la semana actual
  static DateTime getMondayOfWeek(DateTime date) {
    final daysToMonday = (date.weekday - DateTime.monday) % 7;
    return startOfDay(date.subtract(Duration(days: daysToMonday)));
  }
}
