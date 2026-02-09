import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {

  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;

  const MyHeatMap({super.key, required this.datasets, required this.startDateYYYYMMDD});

  // create DateTime object from dayKey string
  DateTime createDateTimeObject(String yyyymmdd) {
    int yyyy = int.parse(yyyymmdd.substring(0, 4));
    int mm = int.parse(yyyymmdd.substring(4, 6));
    int dd = int.parse(yyyymmdd.substring(6, 8));

    DateTime dateTimeObject = DateTime(yyyy, mm, dd);
    return dateTimeObject;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.0),
      child: HeatMap(
        startDate: createDateTimeObject(startDateYYYYMMDD),
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.white.withValues(alpha: 0.7),
        textColor: Theme.of(context).textTheme.titleMedium?.color,
        showColorTip: false,
        scrollable: true,
        showText: true,
        size: 40,
        colorsets: {
            1: Colors.green[100]!,
            2: Colors.green[300]!,
            3: Colors.green[500]!,
            4: Colors.green[700]!,
            5: Colors.green[900]!,
          },
      ),
    );
  }
}