import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_card.dart';
import '../../widgets/common_widget';
import '../../widgets/common_layout.dart';
import '../../utils/constants.dart';

class ServiceList extends StatefulWidget {
  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Catering',
    'Photography',
    'Decoration',
    'Music',
    'Security'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildCategoryFilter(),
                _buildServiceList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateService(),
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
          'My Services',
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
                Constants.accentColor,
                Constants.primaryColor,
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
              hintText: 'Search services...',
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

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: Constants.spacingM),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: Constants.spacingS),
              padding: EdgeInsets.symmetric(
                horizontal: Constants.spacingM,
                vertical: Constants.spacingXS,
              ),
              decoration: BoxDecoration(
                color:
                    isSelected ? Constants.accentColor : Constants.surfaceColor,
                borderRadius: Constants.borderRadiusL,
                border: Border.all(
                  color: isSelected
                      ? Constants.accentColor
                      : Constants.borderColor,
                ),
              ),
              child: Center(
                child: Text(
                  category,
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

  Widget _buildServiceList() {
    // Mock data - replace with actual provider data
    final services = _getMockServices();

    if (services.isEmpty) {
      return EmptyStateCard(
        icon: Icons.room_service,
        title: 'No Services Yet',
        subtitle: 'Add your first service to get started!',
        action: () => _navigateToCreateService(),
        actionLabel: 'Add Service',
      );
    }

    return Padding(
      padding: EdgeInsets.all(Constants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${services.length} Services',
            style: Constants.titleMedium,
          ),
          SizedBox(height: Constants.spacingM),
          ...services.map((service) => Padding(
                padding: EdgeInsets.only(bottom: Constants.spacingM),
                child: _buildServiceCard(service),
              )),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Service icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Constants.accentColor.withOpacity(0.1),
                  borderRadius: Constants.borderRadiusM,
                ),
                child: Icon(
                  _getServiceIcon(service['category']),
                  color: Constants.accentColor,
                  size: 24,
                ),
              ),
              SizedBox(width: Constants.spacingM),
              // Service details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'],
                      style: Constants.titleMedium,
                    ),
                    SizedBox(height: Constants.spacingXS),
                    Text(
                      service['description'],
                      style: Constants.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Constants.spacingS),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Constants.spacingS,
                            vertical: Constants.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: Constants.primaryLightColor,
                            borderRadius: Constants.borderRadiusS,
                          ),
                          child: Text(
                            service['category'],
                            style: Constants.labelSmall.copyWith(
                              color: Constants.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: Constants.spacingS),
                        Text(
                          '\$${service['price']}/hour',
                          style: Constants.labelMedium.copyWith(
                            color: Constants.successColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz),
                onSelected: (value) => _handleServiceAction(value, service),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(
                      value: 'availability', child: Text('Set Availability')),
                  PopupMenuItem(
                      value: 'bookings', child: Text('View Bookings')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
          SizedBox(height: Constants.spacingM),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _viewServiceDetails(service),
                  icon: Icon(Icons.visibility, size: 16),
                  label: Text('View Details'),
                  style: TextButton.styleFrom(
                    foregroundColor: Constants.accentColor,
                  ),
                ),
              ),
              SizedBox(width: Constants.spacingS),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _editService(service),
                  icon: Icon(Icons.edit, size: 16),
                  label: Text('Edit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String category) {
    switch (category.toLowerCase()) {
      case 'catering':
        return Icons.restaurant;
      case 'photography':
        return Icons.camera_alt;
      case 'decoration':
        return Icons.palette;
      case 'music':
        return Icons.music_note;
      case 'security':
        return Icons.security;
      default:
        return Icons.room_service;
    }
  }

  List<Map<String, dynamic>> _getMockServices() {
    return [
      {
        'name': 'Premium Catering Service',
        'description':
            'Full-service catering for events of all sizes with customizable menus',
        'category': 'Catering',
        'price': '150',
        'status': 'active',
      },
      {
        'name': 'Professional Photography',
        'description':
            'Event photography and videography services with same-day delivery',
        'category': 'Photography',
        'price': '200',
        'status': 'active',
      },
      {
        'name': 'Elegant Decorations',
        'description': 'Beautiful event decorations and setup services',
        'category': 'Decoration',
        'price': '100',
        'status': 'active',
      },
    ];
  }

  void _navigateToCreateService() {
    Navigator.pushNamed(context, '/create-service');
  }

  void _viewServiceDetails(Map<String, dynamic> service) {
    // Navigate to service details
  }

  void _editService(Map<String, dynamic> service) {
    // Navigate to edit service
  }

  void _handleServiceAction(String action, Map<String, dynamic> service) {
    switch (action) {
      case 'edit':
        _editService(service);
        break;
      case 'availability':
        _setAvailability(service);
        break;
      case 'bookings':
        _viewBookings(service);
        break;
      case 'delete':
        _deleteService(service);
        break;
    }
  }

  void _setAvailability(Map<String, dynamic> service) {
    // Navigate to set availability
  }

  void _viewBookings(Map<String, dynamic> service) {
    // Navigate to view bookings
  }

  void _deleteService(Map<String, dynamic> service) {
    // Show delete confirmation and handle deletion
  }
}
