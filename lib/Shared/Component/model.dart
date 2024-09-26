class ModelDatabase {
  int? id;
  String title;
  String date;
  String time;
  String status;

  ModelDatabase({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'status': status,
    };
  }

}