import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/venue_provider.dart';
import '../../models/venue.dart';

class CreateVenue extends StatefulWidget {
  @override
  _CreateVenueState createState() => _CreateVenueState();
}

class _CreateVenueState extends State<CreateVenue> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Venue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _capacityController,
              decoration: InputDecoration(labelText: 'Capacity'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Venue newVenue = Venue(
                  id: 0, // Will be set by API
                  name: _nameController.text,
                  location: _locationController.text,
                  capacity: int.parse(_capacityController.text),
                  status: 'pending',
                  images: [],
                );
                await Provider.of<VenueProvider>(context, listen: false)
                    .createVenue(newVenue);
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}