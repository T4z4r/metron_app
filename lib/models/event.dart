class Event {
  int? id;
  String title;
  String description;
  String visibility;
  DateTime startDate;
  DateTime endDate;

  Event(
      {this.id,
      required this.title,
      required this.description,
      required this.visibility,
      required this.startDate,
      required this.endDate});

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        visibility: json['visibility'] ?? 'public',
        startDate: DateTime.parse(json['start_date']),
        endDate: DateTime.parse(json['end_date']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'visibility': visibility,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      };
}
