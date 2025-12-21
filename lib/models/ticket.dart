class Ticket {
  final int id;
  final int eventId;
  final String eventTitle;
  final String qrCode;
  final String status;
  final DateTime createdAt;

  Ticket({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.qrCode,
    required this.status,
    required this.createdAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      eventId: json['event_id'],
      eventTitle: json['event_title'] ?? '',
      qrCode: json['qr_code'],
      status: json['status'] ?? 'valid',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'event_title': eventTitle,
      'qr_code': qrCode,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
