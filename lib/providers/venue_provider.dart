import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      final data = await _apiService.post('/venue-owner/venues', {
        'name': venue.name,
        'location': venue.location,
        'capacity': venue.capacity,
      });
      final newVenue = Venue.fromJson(data['data']);
      _venues.add(newVenue);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create venue');
    }
  }

  Future<void> uploadVenuePhotos(int venueId, List<http.MultipartFile> files) async {
    try {
      await _apiService.uploadFiles('/venue-owner/venues/$venueId/photos', files);
      // You might want to refresh the venue data to get updated photo URLs
    } catch (e) {
      throw Exception('Failed to upload venue photos');
    }
  }

  Future<void> approveBooking(int bookingId) async {
    try {
      await _apiService.post('/venue-owner/bookings/$bookingId/approve', {});
      // Update booking status locally or refetch data
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to approve booking');
    }
  }

  Future<void> rejectBooking(int bookingId) async {
    try {
      await _apiService.post('/venue-owner/bookings/$bookingId/reject', {});
      // Update booking status locally or refetch data
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to reject booking');
    }
  }

  // Add update and delete methods as needed
}
