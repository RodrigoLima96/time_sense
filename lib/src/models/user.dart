class User {
  String? name;
  List<int>? image;
  int totalFocusTime;
  int totalTasksDone;

  User({
    required this.name,
    required this.image,
    required this.totalFocusTime,
    required this.totalTasksDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'totalFocusTime': totalFocusTime,
      'totalTasksDone': totalTasksDone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? 'Sem Nome',
      image: map['image'],
      totalFocusTime: map['totalFocusTime'] ?? 0,
      totalTasksDone: map['totalTasksDone'] ?? 0,
    );
  }
}
