import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/venue_provider.dart';
import '../../models/venue.dart';
import '../../widgets/common_layout.dart';
import '../../widgets/common_widget';
import '../../utils/constants.dart';

class CreateVenue extends StatefulWidget {
  const CreateVenue({Key? key}) : super(key: key);

  @override
  _CreateVenueState createState() => _CreateVenueState();
}

class _CreateVenueState extends State<CreateVenue> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _createVenue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final venue = Venue(
        id: 0,
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        capacity: int.parse(_capacityController.text.trim()),
        status: 'pending',
        images: [],
      );

      await Provider.of<VenueProvider>(context, listen: false).createVenue(venue);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Venue created successfully'),
            backgroundColor: Constants.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create venue: ${e.toString()}'),
            backgroundColor: Constants.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonFormScaffold(
      title: 'Create Venue',
      showBackButton: true,
      submitButtonText: 'Create Venue',
      isLoading: _isLoading,
      onSubmit: _createVenue,
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextField(
              label: 'Venue Name',
              hint: 'Enter venue name',
              controller: _nameController,
              prefixIcon: const Icon(Icons.business),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Venue name is required';
                }
                if (value.trim().length < 2) {
                  return 'Venue name must be at least 2 characters';
                }
                return null;
              },
            ),
            SizedBox(height: Constants.spacingL),
            CommonTextField(
              label: 'Location',
              hint: 'Enter venue location',
              controller: _locationController,
              prefixIcon: const Icon(Icons.location_on),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Location is required';
                }
                return null;
              },
            ),
            SizedBox(height: Constants.spacingL),
            CommonTextField(
              label: 'Capacity',
              hint: 'Enter maximum capacity',
              controller: _capacityController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.people),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Capacity is required';
                }
                final capacity = int.tryParse(value.trim());
                if (capacity == null || capacity <= 0) {
                  return 'Please enter a valid capacity';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}