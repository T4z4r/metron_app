import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event.dart';
import '../../widgets/common_widget';
import '../../widgets/common_card.dart';
import '../../utils/constants.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _visibility = 'public';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(hours: 2));
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime =
      TimeOfDay(hour: TimeOfDay.now().hour + 2, minute: TimeOfDay.now().minute);

  bool _isLoading = false;
  bool _isDraft = false;

  final List<String> _visibilityOptions = ['public', 'private'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: _startTime,
      );

      if (selectedTime != null) {
        setState(() {
          _startDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          _endTime = TimeOfDay(
              hour: selectedTime.hour + 2, minute: selectedTime.minute);
          _endDate = _startDate.add(Duration(hours: 2));
        });
      }
    }
  }

  Future<void> _selectEndDateTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: _endTime,
      );

      if (selectedTime != null) {
        setState(() {
          _endDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      Event newEvent = Event(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        visibility: _visibility,
        startDate: _startDate,
        endDate: _endDate,
      );

      await Provider.of<EventProvider>(context, listen: false)
          .createEvent(newEvent);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isDraft
                ? 'Event saved as draft!'
                : 'Event created successfully!'),
            backgroundColor: Constants.successColor,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create event: ${e.toString()}'),
            backgroundColor: Constants.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'Today at ${time.format(context)}';
    } else {
      return '${date.day}/${date.month}/${date.year} at ${time.format(context)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Create Event'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Constants.primaryColor, Constants.secondaryColor],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.help_outline),
                onPressed: () => _showHelpDialog(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(Constants.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(),
                    SizedBox(height: Constants.spacingL),
                    _buildDateTimeSection(),
                    SizedBox(height: Constants.spacingXL),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Constants.primaryColor,
              ),
              SizedBox(width: Constants.spacingS),
              Text(
                'Basic Information',
                style: Constants.titleLarge,
              ),
            ],
          ),
          SizedBox(height: Constants.spacingL),
          CommonTextField(
            label: 'Event Title *',
            hint: 'Enter a compelling event title',
            controller: _titleController,
            prefixIcon: Icon(Icons.title),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter an event title';
              }
              if (value.trim().length < 3) {
                return 'Title must be at least 3 characters';
              }
              return null;
            },
          ),
          SizedBox(height: Constants.spacingM),
          CommonTextField(
            label: 'Description',
            hint: 'Describe your event in detail (optional)',
            controller: _descriptionController,
            prefixIcon: Icon(Icons.description),
            maxLines: 4,
            maxLength: 500,
            validator: (value) {
              if (value != null &&
                  value.trim().isNotEmpty &&
                  value.trim().length < 10) {
                return 'Description must be at least 10 characters if provided';
              }
              return null;
            },
          ),
          SizedBox(height: Constants.spacingM),
          CommonDropdownField<String>(
            label: 'Visibility *',
            hint: 'Select visibility',
            items: _visibilityOptions
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option.toUpperCase()),
                    ))
                .toList(),
            value: _visibility,
            onChanged: (value) {
              setState(() {
                _visibility = value!;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select visibility';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: Constants.primaryColor,
              ),
              SizedBox(width: Constants.spacingS),
              Text(
                'Date & Time',
                style: Constants.titleLarge,
              ),
            ],
          ),
          SizedBox(height: Constants.spacingL),
          _buildDateTimeSelector(
            'Start Date & Time',
            _formatDateTime(_startDate, _startTime),
            Icons.play_circle_outline,
            _selectDateTime,
          ),
          SizedBox(height: Constants.spacingM),
          _buildDateTimeSelector(
            'End Date & Time',
            _formatDateTime(_endDate, _endTime),
            Icons.stop_circle,
            _selectEndDateTime,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelector(
      String label, String value, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Constants.spacingM),
        decoration: BoxDecoration(
          border: Border.all(color: Constants.borderColor),
          borderRadius: Constants.borderRadiusM,
        ),
        child: Row(
          children: [
            Icon(icon, color: Constants.primaryColor),
            SizedBox(width: Constants.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Constants.labelMedium,
                  ),
                  Text(
                    value,
                    style: Constants.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Constants.textSecondaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading
                ? null
                : () {
                    setState(() => _isDraft = true);
                    _handleSubmit();
                  },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: Constants.spacingM),
            ),
            child: Text('Save Draft'),
          ),
        ),
        SizedBox(width: Constants.spacingM),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : () {
                    setState(() => _isDraft = false);
                    _handleSubmit();
                  },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: Constants.spacingM),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text('Create Event'),
          ),
        ),
      ],
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Creating an Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tips for creating a great event:'),
            SizedBox(height: Constants.spacingS),
            Text('• Use a clear, descriptive title'),
            Text('• Provide detailed description'),
            Text('• Set correct date and time'),
            Text('• Choose appropriate visibility'),
            SizedBox(height: Constants.spacingS),
            Text(
              'Note: Required fields are marked with * (Description is optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }
}
