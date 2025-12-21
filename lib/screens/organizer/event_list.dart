import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event.dart';
import '../../widgets/common_card.dart';
import '../../widgets/common_widget';
import '../../widgets/common_layout.dart';
import '../../utils/constants.dart';

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Upcoming', 'Past', 'Public', 'Private'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildFilters(),
                _buildEventTabs(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateEvent(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Events',
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
                color: isSelected ? Constants.primaryColor : Constants.surfaceColor,
                borderRadius: Constants.borderRadiusL,
                border: Border.all(
                  color: isSelected ? Constants.primaryColor : Constants.borderColor,
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Constants.textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventTabs() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: Constants.spacingM),
          decoration: BoxDecoration(
            color: Constants.surfaceColor,
            borderRadius: Constants.borderRadiusM,
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Constants.primaryColor,
            unselectedLabelColor: Constants.textSecondaryColor,
            indicatorColor: Constants.primaryColor,
            indicator: BoxDecoration(
              color: Constants.primaryColor,
              borderRadius: Constants.borderRadiusM,
            ),
            tabs: [
              Tab(text: 'All Events'),
              Tab(text: 'Analytics'),
            ],
          ),
        ),
        SizedBox(height: Constants.spacingM),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildEventList(),
              _buildAnalyticsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        if (eventProvider.events.isEmpty) {
          return EmptyStateCard(
            icon: Icons.event_note,
            title: 'No Events Yet',
            subtitle: 'Create your first event to get started!',
            action: () => _navigateToCreateEvent(),
            actionLabel: 'Create Event',
          );
        }

        // Filter events based on search query and selected filter
        List<Event> filteredEvents = eventProvider.events.where((event) {
          bool matchesSearch = _searchQuery.isEmpty ||
              event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              event.description.toLowerCase().contains(_searchQuery.toLowerCase());

          bool matchesFilter = true;
          if (_selectedFilter == 'Public') {
            matchesFilter = event.visibility == 'public';
          } else if (_selectedFilter == 'Private') {
            matchesFilter = event.visibility == 'private';
          } else if (_selectedFilter == 'Upcoming') {
            matchesFilter = event.startDate.isAfter(DateTime.now());
          } else if (_selectedFilter == 'Past') {
            matchesFilter = event.endDate.isBefore(DateTime.now());
          }

          return matchesSearch && matchesFilter;
        }).toList();

        if (filteredEvents.isEmpty) {
          return EmptyStateCard(
            icon: Icons.search_off,
            title: 'No Matching Events',
            subtitle: 'Try adjusting your search or filters.',
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Constants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredEvents.length} Events',
                    style: Constants.titleMedium,
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert),
                    onSelected: (value) => _handleMenuAction(value),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'bulk_delete',
                        child: Text('Bulk Delete'),
                      ),
                      PopupMenuItem(
                        value: 'export',
                        child: Text('Export Events'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Constants.spacingM),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return _buildEventCard(event, context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventCard(Event event, BuildContext context) {
    final now = DateTime.now();
    final isUpcoming = event.startDate.isAfter(now);
    final isPast = event.endDate.isBefore(now);
    final isLive = now.isAfter(event.startDate) && now.isBefore(event.endDate);

    return Container(
      margin: EdgeInsets.only(bottom: Constants.spacingM),
      child: CommonCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Constants.spacingS,
                    vertical: Constants.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(isUpcoming, isPast, isLive).withOpacity(0.1),
                    borderRadius: Constants.borderRadiusS,
                  ),
                  child: Text(
                    _getStatusText(isUpcoming, isPast, isLive),
                    style: Constants.labelSmall.copyWith(
                      color: _getStatusColor(isUpcoming, isPast, isLive),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_horiz),
                  onSelected: (value) => _handleEventMenuAction(value, event),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                    PopupMenuItem(value: 'share', child: Text('Share')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            SizedBox(height: Constants.spacingM),
            // Event content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: Constants.primaryGradient,
                    borderRadius: Constants.borderRadiusM,
                  ),
                  child: Icon(
                    Icons.event,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: Constants.spacingM),
                // Event details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: Constants.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Constants.spacingXS),
                      Text(
                        event.description,
                        style: Constants.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Constants.spacingS),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: Constants.textSecondaryColor,
                          ),
                          SizedBox(width: Constants.spacingXS),
                          Text(
                            _formatEventDateTime(event.startDate, event.endDate),
                            style: Constants.bodySmall,
                          ),
                          SizedBox(width: Constants.spacingM),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: event.visibility == 'public' ? Constants.successColor : Constants.warningColor,
                            ),
                          ),
                          SizedBox(width: Constants.spacingXS),
                          Text(
                            event.visibility.toUpperCase(),
                            style: Constants.bodySmall.copyWith(
                              color: event.visibility == 'public' ? Constants.successColor : Constants.warningColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Constants.spacingM),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _viewEventDetails(event),
                    icon: Icon(Icons.visibility, size: 16),
                    label: Text('View Details'),
                    style: TextButton.styleFrom(
                      foregroundColor: Constants.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: Constants.spacingS),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _editEvent(event),
                    icon: Icon(Icons.edit, size: 16),
                    label: Text('Edit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatEventDateTime(DateTime start, DateTime end) {
    final now = DateTime.now();
    final isToday = start.year == now.year && start.month == now.month && start.day == now.day;
    final isTomorrow = start.year == now.year && start.month == now.month && start.day == now.day + 1;

    if (isToday) {
      return 'Today ${TimeOfDay.fromDateTime(start).format(context)}';
    } else if (isTomorrow) {
      return 'Tomorrow ${TimeOfDay.fromDateTime(start).format(context)}';
    } else {
      return '${start.day}/${start.month}/${start.year}';
    }
  }

  Color _getStatusColor(bool isUpcoming, bool isPast, bool isLive) {
    if (isLive) return Constants.successColor;
    if (isUpcoming) return Constants.infoColor;
    if (isPast) return Constants.textMutedColor;
    return Constants.textSecondaryColor;
  }

  String _getStatusText(bool isUpcoming, bool isPast, bool isLive) {
    if (isLive) return 'LIVE';
    if (isUpcoming) return 'UPCOMING';
    if (isPast) return 'COMPLETED';
    return 'DRAFT';
  }

  Widget _buildAnalyticsTab() {
    return Padding(
      padding: EdgeInsets.all(Constants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Analytics',
            style: Constants.titleLarge,
          ),
          SizedBox(height: Constants.spacingL),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Events',
                  '12',
                  Icons.event_note,
                  Constants.primaryColor,
                ),
              ),
              SizedBox(width: Constants.spacingM),
              Expanded(
                child: _buildStatCard(
                  'Live Events',
                  '2',
                  Icons.radio_button_on,
                  Constants.successColor,
                ),
              ),
            ],
          ),
          SizedBox(height: Constants.spacingM),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Upcoming',
                  '8',
                  Icons.schedule,
                  Constants.infoColor,
                ),
              ),
              SizedBox(width: Constants.spacingM),
              Expanded(
                child: _buildStatCard(
                  'Past Events',
                  '2',
                  Icons.history,
                  Constants.textMutedColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Constants.bodyMedium,
              ),
              Icon(icon, color: color),
            ],
          ),
          SizedBox(height: Constants.spacingS),
          Text(
            value,
            style: Constants.headlineMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  void _navigateToCreateEvent() {
    Navigator.pushNamed(context, '/create-event');
  }

  void _viewEventDetails(Event event) {
    // Navigate to event details
  }

  void _editEvent(Event event) {
    // Navigate to edit event
  }

  void _handleEventMenuAction(String action, Event event) {
    switch (action) {
      case 'edit':
        _editEvent(event);
        break;
      case 'duplicate':
        _duplicateEvent(event);
        break;
      case 'share':
        _shareEvent(event);
        break;
      case 'delete':
        _deleteEvent(event);
        break;
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'bulk_delete':
        _showBulkDeleteDialog();
        break;
      case 'export':
        _exportEvents();
        break;
    }
  }

  void _duplicateEvent(Event event) {
    // Implement event duplication
  }

  void _shareEvent(Event event) {
    // Implement event sharing
  }

  void _deleteEvent(Event event) {
    // Implement event deletion
  }

  void _showBulkDeleteDialog() {
    // Show bulk delete dialog
  }

  void _exportEvents() {
    // Implement events export
  }
}
