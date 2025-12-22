import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event.dart';
import '../../widgets/common_card.dart';
import '../../widgets/common_widget';
import '../../widgets/common_layout.dart';
import '../../utils/constants.dart';
import '../../screens/organizer/create_event.dart';
import '../../screens/attendant/ticket_screen.dart';

class EventBrowse extends StatefulWidget {
  @override
  _EventBrowseState createState() => _EventBrowseState();
}

class _EventBrowseState extends State<EventBrowse> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  int _selectedIndex = 0;
  final List<String> _filters = [
    'All',
    'Today',
    'This Week',
    'This Month',
    'Public',
    'Private'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = EventBrowseContent();
        break;
      case 1:
        body = TicketScreen();
        break;
      case 2:
        body = _buildProfileScreen();
        break;
      default:
        body = EventBrowseContent();
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Constants.primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildProfileScreen() {
    return Center(
      child: Text('Profile Screen - Coming Soon'),
    );
  }
}

class EventBrowseContent extends StatefulWidget {
  @override
  _EventBrowseContentState createState() => _EventBrowseContentState();
}

class _EventBrowseContentState extends State<EventBrowseContent> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Today',
    'This Week',
    'This Month',
    'Public',
    'Private'
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildFilters(),
              _buildEventsList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Discover Events',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Constants.primaryColor,
                Constants.secondaryColor,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                bottom: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                left: -30,
                top: 30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Constants.spacingM),
          margin: EdgeInsets.only(bottom: Constants.spacingM),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: Constants.borderRadiusL,
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: Constants.spacingM,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: Constants.spacingM),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: Constants.spacingS),
              padding: EdgeInsets.symmetric(
                horizontal: Constants.spacingM,
                vertical: Constants.spacingS,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? Constants.primaryColor
                    : Constants.surfaceColor,
                borderRadius: Constants.borderRadiusL,
                border: Border.all(
                  color: isSelected
                      ? Constants.primaryColor
                      : Constants.borderColor,
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Constants.textColor,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventsList() {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        if (eventProvider.events.isEmpty) {
          return EmptyStateCard(
            icon: Icons.event_available,
            title: 'No Events Found',
            subtitle:
                'There are no events available at the moment. Check back later!',
          );
        }

        // Filter events based on search query and selected filter
        List<Event> filteredEvents = eventProvider.events.where((event) {
          bool matchesSearch = _searchQuery.isEmpty ||
              event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              event.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());

          bool matchesFilter = true;
          if (_selectedFilter == 'Public') {
            matchesFilter = event.visibility == 'public';
          } else if (_selectedFilter == 'Private') {
            matchesFilter = event.visibility == 'private';
          }
          // Add more filter logic as needed

          return matchesSearch && matchesFilter;
        }).toList();

        if (filteredEvents.isEmpty) {
          return EmptyStateCard(
            icon: Icons.search_off,
            title: 'No Matching Events',
            subtitle: 'Try adjusting your search or filters to find events.',
          );
        }

        return Padding(
          padding: EdgeInsets.all(Constants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredEvents.length} Events Found',
                    style: Constants.titleMedium,
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () => _showFilterDialog(context),
                  ),
                ],
              ),
              SizedBox(height: Constants.spacingM),
              ...filteredEvents.map((event) => Padding(
                    padding: EdgeInsets.only(bottom: Constants.spacingM),
                    child: EventCard(
                      title: event.title,
                      description: event.description,
                      date: _formatEventDate(event.startDate),
                      location:
                          'TBD', // You can add location to your Event model
                      price: 'Free', // You can add price to your Event model
                      onTap: () => _showEventDetails(context, event),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  String _formatEventDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days from now';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showEventDetails(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventDetailsSheet(event: event),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Events'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _filters.map((filter) {
            return RadioListTile<String>(
              title: Text(filter),
              value: filter,
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

}

class EventDetailsSheet extends StatelessWidget {
  final Event event;

  const EventDetailsSheet({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Constants.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.all(Constants.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Constants.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: Constants.spacingL),
            // Event title and image placeholder
            Text(
              event.title,
              style: Constants.headlineMedium,
            ),
            SizedBox(height: Constants.spacingM),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Constants.primaryLightColor,
                borderRadius: Constants.borderRadiusL,
              ),
              child: Center(
                child: Icon(
                  Icons.event,
                  size: 64,
                  color: Constants.primaryColor,
                ),
              ),
            ),
            SizedBox(height: Constants.spacingL),
            // Event details
            Text(
              'Description',
              style: Constants.titleMedium,
            ),
            SizedBox(height: Constants.spacingS),
            Text(
              event.description,
              style: Constants.bodyMedium,
            ),
            SizedBox(height: Constants.spacingL),
            Text(
              'Details',
              style: Constants.titleMedium,
            ),
            SizedBox(height: Constants.spacingS),
            _buildDetailRow(Icons.calendar_today, 'Date', 'Event Date'),
            _buildDetailRow(Icons.access_time, 'Time', 'Event Time'),
            _buildDetailRow(Icons.location_on, 'Location', 'Venue TBD'),
            SizedBox(height: Constants.spacingXL),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    text: 'Buy Ticket',
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to ticket purchase
                    },
                    type: ButtonType.primary,
                  ),
                ),
                SizedBox(width: Constants.spacingM),
                Expanded(
                  child: CommonButton(
                    text: 'Share',
                    onPressed: () {
                      Navigator.pop(context);
                      // Share functionality
                    },
                    type: ButtonType.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constants.spacingS),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Constants.textSecondaryColor,
          ),
          SizedBox(width: Constants.spacingM),
          Text(
            '$label: ',
            style: Constants.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: Constants.bodyMedium,
          ),
        ],
      ),
    );
  }
}
