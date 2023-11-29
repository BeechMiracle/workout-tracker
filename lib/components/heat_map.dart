import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:workout_tracker/data_time/date_time.dart';

class HeatMaps extends StatelessWidget {
  const HeatMaps({
    super.key,
    required this.dataSets,
    required this.startDate,
  });

  final Map<DateTime, int>? dataSets;
  final String startDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.purple[50],
      child: HeatMap(
        datasets: dataSets,
        startDate: createDateTime(startDate),
        endDate: DateTime.now().add(const Duration(days: 0)),
        colorMode: ColorMode.color,
        defaultColor: Colors.deepPurple[100],
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Colors.deepPurple
        },
      ),
    );
  }
}
