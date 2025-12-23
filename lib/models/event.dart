import 'package:intl/intl.dart';

class Event {
  int? id;
  String title;
  String? description;
  String visibility;
  DateTime startDate;
  DateTime endDate;

  Event(
      {this.id,
      required this.title,
      this.description,
      required this.visibility,
      required this.startDate,
      required this.endDate});

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        visibility: json['visibility'] ?? 'public',
        startDate: DateTime.parse(json['start_date']),
        endDate: DateTime.parse(json['end_date']),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'visibility': visibility,
        'start_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate),
        'end_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate),
      };
}
