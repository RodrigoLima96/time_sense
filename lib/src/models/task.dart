class Task {
  final String id;
  final String text;
  final String status;
  final int totalFocusingTime;
  final DateTime? creationDate;
  final DateTime? completionDate;

  Task({
    required this.id,
    required this.text,
    required this.status,
    required this.totalFocusingTime,
    required this.creationDate,
    required this.completionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'status': status,
      'totalFocusingTime': totalFocusingTime,
      'creationDate': creationDate.toString(),
      'completionDate': completionDate.toString(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      text: map['text'],
      status: map['status'],
      totalFocusingTime: map['totalFocusingTime'],
      creationDate: map['creationDate'] != null ? DateTime.parse(map['creationDate']) : null,
      completionDate: map['completionDate'] != "null" ? DateTime.parse(map['completionDate']) : null,
    );
  }
}
