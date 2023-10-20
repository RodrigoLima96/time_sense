// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Statistic extends Equatable {
  final String date;
  int totalFocusingTime;

  Statistic({
    required this.date,
    required this.totalFocusingTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'totalFocusingTime': totalFocusingTime,
    };
  }

  factory Statistic.fromMap(Map<String, dynamic> map) {
    return Statistic(
      date: map['date'],
      totalFocusingTime: map['totalFocusingTime'],
    );
  }

  @override
  List<Object?> get props => [date, totalFocusingTime];
}
