class Task {
  final String id;
  final String text;
  final String status;
  final int totalFocusingTime;
  final DateTime creationDate;

  Task({
    required this.id,
    required this.text,
    required this.status,
    required this.totalFocusingTime,
    required this.creationDate,
  });
}
