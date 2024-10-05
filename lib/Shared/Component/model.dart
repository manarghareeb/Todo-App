class ModelDatabase {
  int? id;
  String title;
  String date;
  String time;
  String status;
  String archived;

  ModelDatabase({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.status,
    required this.archived
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'status': status,
      'archived': archived
    };
  }

}