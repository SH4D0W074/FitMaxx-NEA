import 'package:fitmaxx/models/exercise_model.dart';

class Workout {
  final String id;
  final String name;
  final DateTime? timestamp;
  final DateTime? date;// for easier querying by day
  

  Workout({required this.id ,required this.name,  required this.timestamp, required this.date});

  // Convert workout object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'timestamp': timestamp?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'date': createDateTimeObject(dayKey(timestamp ?? DateTime.now())),
    };
  }

  String dayKey(DateTime dateTime) {
    final d = dateTime.toLocal();
    return '${d.year}'
          '${d.month.toString().padLeft(2, '0')}'
          '${d.day.toString().padLeft(2, '0')}';
  }

  DateTime createDateTimeObject(String yyyymmdd) {
    int yyyy = int.parse(yyyymmdd.substring(0, 4));
    int mm = int.parse(yyyymmdd.substring(4, 6));
    int dd = int.parse(yyyymmdd.substring(6, 8));

    DateTime dateTimeObject = DateTime(yyyy, mm, dd);
    return dateTimeObject;
  }


  factory Workout.fromMap(Map<String, dynamic> data, String id) {
    return Workout(
      id: id,
      name: data['name'] ?? '',
      timestamp: DateTime.tryParse(data['timestamp'] ?? '') ?? DateTime.now(),
      date: data['date'] ?? '',
    );
  }

}