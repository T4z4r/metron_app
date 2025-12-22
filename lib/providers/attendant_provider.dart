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

  Future<void> purchaseTicket(String ticketId) async {
    try {
      final data = await _apiService.post('/tickets/purchase', {'ticket_id': ticketId});
      final newTicket = Ticket.fromJson(data['data']);
      _tickets.add(newTicket);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to purchase ticket');
    }
  }

  Future<bool> validateQR(String qrCode) async {
    try {
      final data = await _apiService.post('/tickets/validate-qr', {'qr': qrCode});
      // Return validation result from API
      return data['valid'] ?? false;
    } catch (e) {
      throw Exception('Failed to validate QR code');
    }
  }

  // Add more methods as needed
}
