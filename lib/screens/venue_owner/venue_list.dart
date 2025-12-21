import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/venue_provider.dart';
import '../../models/venue.dart';

class VenueList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Venues')),
      body: Consumer<VenueProvider>(
        builder: (context, venueProvider, child) {
          if (venueProvider.venues.isEmpty) {
            return Center(child: Text('No venues found'));
          }
          return ListView.builder(
            itemCount: venueProvider.venues.length,
            itemBuilder: (context, index) {
              Venue venue = venueProvider.venues[index];
              return ListTile(
                title: Text(venue.name),
                subtitle: Text(venue.location),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create venue screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}