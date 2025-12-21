import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  final ApiService _apiService = ApiService();

  List<Event> get events => _events;

  Future<void> fetchEvents() async {
    try {
      final data = await _apiService.get('/events');
      _events = (data['events'] as List).map((e) => Event.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch events');
    }
  }

  Future<void> createEvent(Event event) async {
    try {
      final data = await _apiService.post('/events', {
        'title': event.title,
        'description': event.description,
        'visibility': event.visibility,
        'start_date': event.startDate.toIso8601String(),
        'end_date': event.endDate.toIso8601String(),
      });
      final newEvent = Event.fromJson(data);
      _events.add(newEvent);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create event');
    }
  }

  // Add update and delete methods as needed
}