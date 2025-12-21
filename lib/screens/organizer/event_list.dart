import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event.dart';

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Events')),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          if (eventProvider.events.isEmpty) {
            return Center(child: Text('No events found'));
          }
          return ListView.builder(
            itemCount: eventProvider.events.length,
            itemBuilder: (context, index) {
              Event event = eventProvider.events[index];
              return ListTile(
                title: Text(event.title),
                subtitle: Text(event.description),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create event screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
