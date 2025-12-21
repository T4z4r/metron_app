import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../services/api_service.dart';

class VenueProvider extends ChangeNotifier {
  List<Venue> _venues = [];
  final ApiService _apiService = ApiService();

  List<Venue> get venues => _venues;

  Future<void> fetchVenues() async {
    try {
      final data = await _apiService.get('/venue-owner/venues');
      _venues = (data['data'] as List).map((v) => Venue.fromJson(v)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch venues');
    }
  }

  Future<void> createVenue(Venue venue) async {
    try {
      final data =
          await _apiService.post('/venue-owner/venues', venue.toJson());
      final newVenue = Venue.fromJson(data['data']);
      _venues.add(newVenue);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create venue');
    }
  }

  // Add update and delete methods as needed
}
