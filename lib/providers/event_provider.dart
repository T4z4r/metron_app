import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../services/api_service.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  final ApiService _apiService = ApiService();

  List<Event> get events => _events;

  Future<void> fetchEvents() async {
    try {
      final data = await _apiService.get('/events');
      _events = (data['data'] as List).map((e) => Event.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch events');
    }
  }

  Future<void> createEvent(Event event) async {
    try {
      final data = await _apiService.post('/organizer/events', {
        'title': event.title,
        'description': event.description,
        'visibility': event.visibility,
        'start_date': event.startDate.toIso8601String(),
        'end_date': event.endDate.toIso8601String(),
      });
      if (data['data'] == null) {
        throw Exception(data['message'] ?? 'Failed to create event');
      }
      final newEvent = Event.fromJson(data['data']);
      _events.add(newEvent);
      notifyListeners();
    } catch (e) {
      print(e);
      throw Exception('Failed to create event');
    }
  }

  Future<void> publishEvent(int eventId) async {
    try {
      await _apiService.post('/organizer/events/$eventId/publish', {});
      // Update the event in the list
      final index = _events.indexWhere((event) => event.id == eventId);
      if (index != -1) {
        // You might want to fetch the updated event or update locally
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to publish event');
    }
  }

  Future<void> uploadEventPhotos(
      int eventId, List<http.MultipartFile> files) async {
    try {
      await _apiService.uploadFiles('/organizer/events/$eventId/photos', files);
      // You might want to refresh the event data to get updated photo URLs
    } catch (e) {
      throw Exception('Failed to upload event photos');
    }
  }

  // Add update and delete methods as needed
}
