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
      final data = await _apiService.post('/provider/services', service.toJson());
      final newService = Service.fromJson(data['data']);
      _services.add(newService);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create service');
    }
  }

  // Add update and delete methods as needed
}