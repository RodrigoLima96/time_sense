class Task {
  final String id;
  final String text;
  bool pending;
  int totalFocusingTime;
  final DateTime? creationDate;
  final DateTime? completionDate;
  bool showDetails;

  Task({
    required this.id,
    required this.text,
    required this.pending,
    required this.totalFocusingTime,
    required this.creationDate,
    required this.completionDate,
    required this.showDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'pending': pending ? 1 : 0,
      'totalFocusingTime': totalFocusingTime,
      'creationDate': creationDate.toString(),
      'completionDate': completionDate.toString(),
      'showDetails': showDetails ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      text: map['text'],
      pending: map['pending'] == 1,
      totalFocusingTime: map['totalFocusingTime'],
      creationDate: map['creationDate'] != null
          ? DateTime.parse(map['creationDate'])
          : null,
      completionDate: map['completionDate'] != "null"
          ? DateTime.parse(map['completionDate'])
          : null,
      showDetails: map['showDetails'] == 1,
    );
  }
}
