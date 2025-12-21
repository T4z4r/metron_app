import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../services/api_service.dart';

class AttendantProvider extends ChangeNotifier {
  List<Ticket> _tickets = [];
  final ApiService _apiService = ApiService();

  List<Ticket> get tickets => _tickets;

  Future<void> fetchTickets() async {
    try {
      // Assuming tickets are fetched from user profile or separate endpoint
      // For now, placeholder
      _tickets = [];
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch tickets');
    }
  }

  Future<void> purchaseTicket(int eventId) async {
    try {
      final data = await _apiService.post('/tickets/purchase', {'event_id': eventId});
      final newTicket = Ticket.fromJson(data['data']);
      _tickets.add(newTicket);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to purchase ticket');
    }
  }

  // Add more methods as needed
}
