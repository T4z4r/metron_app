import 'package:flutter/material.dart';
import '../models/service.dart';
import '../services/api_service.dart';

class ServiceProvider extends ChangeNotifier {
  List<Service> _services = [];
  final ApiService _apiService = ApiService();

  List<Service> get services => _services;

  Future<void> fetchServices() async {
    try {
      final data = await _apiService.get('/provider/services');
      _services = (data['data'] as List).map((s) => Service.fromJson(s)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch services');
    }
  }

  Future<void> createService(Service service) async {
    try {
      final data = await _apiService.post('/provider/services', {
        'name': service.name,
        'description': service.description,
        'price': service.price,
      });
      final newService = Service.fromJson(data['data']);
      _services.add(newService);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create service');
    }
  }

  Future<void> acceptServiceBooking(int bookingId) async {
    try {
      await _apiService.post('/provider/bookings/$bookingId/accept', {});
      // Update booking status locally or refetch data
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to accept service booking');
    }
  }

  Future<void> rejectServiceBooking(int bookingId) async {
    try {
      await _apiService.post('/provider/bookings/$bookingId/reject', {});
      // Update booking status locally or refetch data
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to reject service booking');
    }
  }

  // Add update and delete methods as needed
}