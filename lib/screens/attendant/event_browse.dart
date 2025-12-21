import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event.dart';

class EventBrowse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Browse Events')),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          if (eventProvider.events.isEmpty) {
            return Center(child: Text('No events available'));
          }
          return ListView.builder(
            itemCount: eventProvider.events.length,
            itemBuilder: (context, index) {
              Event event = eventProvider.events[index];
              return ListTile(
                title: Text(event.title),
                subtitle: Text(event.description),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Navigate to ticket purchase or details
                  },
                  child: Text('Buy Ticket'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}