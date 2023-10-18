// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Statistics extends Equatable {
  final String date;
  int totalFocusingTime;

  Statistics({
    required this.date,
    required this.totalFocusingTime,
  });

  @override
  List<Object?> get props => [date, totalFocusingTime];
}
