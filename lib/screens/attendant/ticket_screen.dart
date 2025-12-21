import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendant_provider.dart';
import '../../models/ticket.dart';

class TicketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Tickets')),
      body: Consumer<AttendantProvider>(
        builder: (context, attendantProvider, child) {
          if (attendantProvider.tickets.isEmpty) {
            return Center(child: Text('No tickets found'));
          }
          return ListView.builder(
            itemCount: attendantProvider.tickets.length,
            itemBuilder: (context, index) {
              Ticket ticket = attendantProvider.tickets[index];
              return ListTile(
                title: Text(ticket.eventTitle),
                subtitle: Text('Status: ${ticket.status}'),
                trailing: Text(ticket.qrCode), // Or display QR code
              );
            },
          );
        },
      ),
    );
  }
}