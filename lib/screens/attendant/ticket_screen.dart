import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendant_provider.dart';
import '../../models/ticket.dart';
import '../../widgets/common_layout.dart';
import '../../widgets/common_card.dart';
import '../../widgets/common_widget';
import '../../utils/constants.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'My Tickets',
      body: Consumer<AttendantProvider>(
        builder: (context, attendantProvider, child) {
          if (attendantProvider.tickets.isEmpty) {
            return EmptyStateCard(
              icon: Icons.confirmation_number,
              title: 'No Tickets Yet',
              subtitle: 'You haven\'t purchased any tickets. Browse events to get started!',
              action: () => Navigator.pop(context),
              actionLabel: 'Browse Events',
            );
          }

          return ListView.builder(
            itemCount: attendantProvider.tickets.length,
            itemBuilder: (context, index) {
              final ticket = attendantProvider.tickets[index];
              return Padding(
                padding: EdgeInsets.only(bottom: Constants.spacingM),
                child: _buildTicketCard(context, ticket),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, Ticket ticket) {
    return CommonCard(
      onTap: () => _showTicketDetails(context, ticket),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Constants.primaryLightColor,
                  borderRadius: Constants.borderRadiusM,
                ),
                child: Icon(
                  Icons.confirmation_number,
                  color: Constants.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: Constants.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.eventTitle,
                      style: Constants.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Constants.spacingXS),
                    Text(
                      'Ticket ID: ${ticket.id}',
                      style: Constants.bodySmall.copyWith(
                        color: Constants.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Constants.spacingS,
                  vertical: Constants.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(ticket.status).withOpacity(0.1),
                  borderRadius: Constants.borderRadiusS,
                ),
                child: Text(
                  ticket.status.toUpperCase(),
                  style: Constants.labelSmall.copyWith(
                    color: _getStatusColor(ticket.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (ticket.qrCode.isNotEmpty) ...[
            SizedBox(height: Constants.spacingM),
            Container(
              padding: EdgeInsets.all(Constants.spacingS),
              decoration: BoxDecoration(
                color: Constants.backgroundColor,
                borderRadius: Constants.borderRadiusS,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.qr_code,
                    size: 20,
                    color: Constants.textSecondaryColor,
                  ),
                  SizedBox(width: Constants.spacingS),
                  Expanded(
                    child: Text(
                      ticket.qrCode,
                      style: Constants.bodySmall.copyWith(
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'valid':
        return Constants.successColor;
      case 'used':
        return Constants.infoColor;
      case 'expired':
      case 'cancelled':
        return Constants.errorColor;
      default:
        return Constants.warningColor;
    }
  }

  void _showTicketDetails(BuildContext context, Ticket ticket) {
    // TODO: Implement ticket details modal or navigation
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket details for ${ticket.eventTitle}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}