import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_card.dart';
import '../../widgets/common_widget';
import '../../widgets/common_layout.dart';
import '../../utils/constants.dart';

class VenueList extends StatefulWidget {
  @override
  _VenueListState createState() => _VenueListState();
}

class _VenueListState extends State<VenueList> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildVenueList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateVenue(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Venues',
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
                Constants.secondaryColor,
                Constants.accentColor,
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          margin: EdgeInsets.all(Constants.spacingM),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search venues...',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: Constants.borderRadiusL,
                borderSide: BorderSide.none,
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

  Widget _buildVenueList() {
    // Mock data - replace with actual provider data
    final venues = _getMockVenues();

    if (venues.isEmpty) {
      return EmptyStateCard(
        icon: Icons.business,
        title: 'No Venues Yet',
        subtitle: 'Add your first venue to get started!',
        action: () => _navigateToCreateVenue(),
        actionLabel: 'Add Venue',
      );
    }

    return Padding(
      padding: EdgeInsets.all(Constants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${venues.length} Venues',
            style: Constants.titleMedium,
          ),
          SizedBox(height: Constants.spacingM),
          ...venues.map((venue) => 
            Padding(
              padding: EdgeInsets.only(bottom: Constants.spacingM),
              child: _buildVenueCard(venue),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildVenueCard(Map<String, dynamic> venue) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Venue icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Constants.secondaryColor.withOpacity(0.1),
                  borderRadius: Constants.borderRadiusM,
                ),
                child: Icon(
                  Icons.business,
                  color: Constants.secondaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: Constants.spacingM),
              // Venue details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue['name'],
                      style: Constants.titleMedium,
                    ),
                    SizedBox(height: Constants.spacingXS),
                    Text(
                      venue['address'],
                      style: Constants.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Constants.spacingS),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 14,
                          color: Constants.textSecondaryColor,
                        ),
                        SizedBox(width: Constants.spacingXS),
                        Text(
                          'Capacity: ${venue['capacity']}',
                          style: Constants.bodySmall,
                        ),
                        SizedBox(width: Constants.spacingM),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Constants.spacingS,
                            vertical: Constants.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: venue['status'] == 'available' 
                                ? Constants.successColor.withOpacity(0.1)
                                : Constants.warningColor.withOpacity(0.1),
                            borderRadius: Constants.borderRadiusS,
                          ),
                          child: Text(
                            venue['status'].toString().toUpperCase(),
                            style: Constants.labelSmall.copyWith(
                              color: venue['status'] == 'available' 
                                  ? Constants.successColor 
                                  : Constants.warningColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz),
                onSelected: (value) => _handleVenueAction(value, venue),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'manage', child: Text('Manage Bookings')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockVenues() {
    return [
      {
        'name': 'Grand Conference Hall',
        'address': '123 Business District, City Center',
        'capacity': '500 people',
        'status': 'available',
      },
      {
        'name': 'Skyline Rooftop Venue',
        'address': '456 High Street, Downtown',
        'capacity': '200 people',
        'status': 'booked',
      },
      {
        'name': 'Modern Workshop Space',
        'address': '789 Innovation Drive, Tech Park',
        'capacity': '100 people',
        'status': 'available',
      },
    ];
  }

  void _navigateToCreateVenue() {
    Navigator.pushNamed(context, '/create-venue');
  }

  void _handleVenueAction(String action, Map<String, dynamic> venue) {
    switch (action) {
      case 'edit':
        _editVenue(venue);
        break;
      case 'manage':
        _manageVenueBookings(venue);
        break;
      case 'delete':
        _deleteVenue(venue);
        break;
    }
  }

  void _editVenue(Map<String, dynamic> venue) {
    // Navigate to edit venue
  }

  void _manageVenueBookings(Map<String, dynamic> venue) {
    // Navigate to manage bookings
  }

  void _deleteVenue(Map<String, dynamic> venue) {
    // Show delete confirmation and handle deletion
  }
}