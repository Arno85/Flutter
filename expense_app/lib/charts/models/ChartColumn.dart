import 'package:flutter/foundation.dart';

class ChartColumn {
  final String day;
  final DateTime currentDate;
  final double totalSum;
  
  ChartColumn({
    @required this.day,
    @required this.currentDate,
    @required this.totalSum,
  });
}
