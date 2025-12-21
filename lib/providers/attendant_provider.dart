import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../services/api_service.dart';

class AttendantProvider extends ChangeNotifier {
  List<Ticket> _tickets = [];
  final ApiService _apiService = ApiService();

  List<Ticket> get tickets => _tickets;

  Future<void> fetchTickets() async {
    try {
      final data = await _apiService.get('/tickets');
      _tickets =
          (data['tickets'] as List).map((t) => Ticket.fromJson(t)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch tickets');
    }
  }

  Future<void> purchaseTicket(int eventId) async {
    try {
      final data = await _apiService.post('/tickets', {'event_id': eventId});
      final newTicket = Ticket.fromJson(data);
      _tickets.add(newTicket);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to purchase ticket');
    }
  }

  // Add more methods as needed
}
