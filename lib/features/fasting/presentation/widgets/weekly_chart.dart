import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:elena_app/ui/elena_ui_system.dart';

class WeeklyFastingBarChart extends StatelessWidget {
  final List<bool> weekData; // lun-dom

  const WeeklyFastingBarChart({required this.weekData, super.key});
  @override
  Widget build(BuildContext context) {
    final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tu racha semanal',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ElenaColors.primary, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 160,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 1.0,
              minY: 0.0,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(),
                leftTitles: AxisTitles(),
                rightTitles: AxisTitles(),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, meta) => Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(days[v.toInt()],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13))),
                        reservedSize: 36)),
              ),
              barGroups: List.generate(
                  7,
                  (i) => BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: weekData[i] ? 1.0 : 0.5,
                            color: weekData[i] ? Colors.green : Colors.red,
                            width: 20,
                            borderRadius: BorderRadius.circular(6),
                            backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 1.0,
                                color: ElenaColors.border.withOpacity(0.19)),
                          ),
                        ],
                      )),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Verde = día con ayuno • Rojo = fallaste el ayuno',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: ElenaColors.textSecondary)),
      ],
    );
  }
}
