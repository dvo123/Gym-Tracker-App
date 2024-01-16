import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:my_first_flutter_project/date_time/date_time.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;

  const MyHeatMap({
    super.key,
    required this.datasets,
    required this.startDateYYYYMMDD,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: HeatMap(
        startDate: createDateTimeObject(startDateYYYYMMDD),
        endDate: DateTime.now().add(const Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[200],
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromARGB(40, 11, 155, 16),
          2: Color.fromARGB(61, 4, 182, 10),
          3: Color.fromARGB(90, 2, 179, 8),
          4: Color.fromARGB(126, 2, 179, 8),
          5: Color.fromARGB(145, 6, 192, 11),
          6: Color.fromARGB(180, 21, 199, 27),
          7: Color.fromARGB(228, 5, 239, 12),
          8: Color.fromARGB(160, 255, 140, 0),
          9: Color.fromARGB(160, 255, 79, 4),
          10: Color.fromARGB(200, 250, 2, 2),
        },
        onClick: (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.toString())));
        },
      ),
    );
  }
}