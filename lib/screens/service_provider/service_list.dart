import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider.dart';
import '../../models/service.dart';

class ServiceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Services')),
      body: Consumer<ServiceProvider>(
        builder: (context, serviceProvider, child) {
          if (serviceProvider.services.isEmpty) {
            return Center(child: Text('No services found'));
          }
          return ListView.builder(
            itemCount: serviceProvider.services.length,
            itemBuilder: (context, index) {
              Service service = serviceProvider.services[index];
              return ListTile(
                title: Text(service.name),
                subtitle: Text(service.description),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create service screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}