import 'package:flutter/material.dart';
import '../models/user.dart';
import '../screens/attendant/event_browse.dart';
import '../screens/organizer/event_list.dart';
import '../screens/venue_owner/venue_list.dart';
import '../screens/service_provider/service_list.dart';

class NavigationHelper {
  /// Navigate to the appropriate main screen based on user role
  static void navigateToMainScreen(BuildContext context, User user) {
    Widget destinationScreen;
    
    switch (user.role.toLowerCase()) {
      case 'attendant':
        destinationScreen = EventBrowse();
        break;
      case 'organizer':
        destinationScreen = EventList();
        break;
      case 'venue_owner':
        destinationScreen = VenueList();
        break;
      case 'service_provider':
        destinationScreen = ServiceList();
        break;
      default:
        // Default to attendant screen for unknown roles
        destinationScreen = EventBrowse();
        break;
    }
    
    // Navigate to the appropriate screen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => destinationScreen,
      ),
      (route) => false, // Remove all previous routes
    );
  }
  
  /// Get the display name for a role
  static String getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'attendant':
        return 'Event Attendant';
      case 'organizer':
        return 'Event Organizer';
      case 'venue_owner':
        return 'Venue Owner';
      case 'service_provider':
        return 'Service Provider';
      default:
        return 'User';
    }
  }
  
  /// Get the appropriate icon for a role
  static IconData getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'attendant':
        return Icons.confirmation_number;
      case 'organizer':
        return Icons.event;
      case 'venue_owner':
        return Icons.location_city;
      case 'service_provider':
        return Icons.handshake;
      default:
        return Icons.person;
    }
  }
}