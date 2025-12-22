import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider.dart';
import '../../models/service.dart';
import '../../widgets/common_layout.dart';
import '../../widgets/common_widget';
import '../../utils/constants.dart';

class CreateService extends StatefulWidget {
  const CreateService({Key? key}) : super(key: key);

  @override
  _CreateServiceState createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _createService() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final service = Service(
        id: 0,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        status: 'inactive',
        images: [],
      );

      await Provider.of<ServiceProvider>(context, listen: false).createService(service);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Service created successfully'),
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
            content: Text('Failed to create service: ${e.toString()}'),
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
      title: 'Create Service',
      showBackButton: true,
      submitButtonText: 'Create Service',
      isLoading: _isLoading,
      onSubmit: _createService,
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextField(
              label: 'Service Name',
              hint: 'Enter service name',
              controller: _nameController,
              prefixIcon: const Icon(Icons.build),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Service name is required';
                }
                if (value.trim().length < 2) {
                  return 'Service name must be at least 2 characters';
                }
                return null;
              },
            ),
            SizedBox(height: Constants.spacingL),
            CommonTextField(
              label: 'Description',
              hint: 'Enter service description',
              controller: _descriptionController,
              maxLines: 3,
              prefixIcon: const Icon(Icons.description),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            SizedBox(height: Constants.spacingL),
            CommonTextField(
              label: 'Price',
              hint: 'Enter service price',
              controller: _priceController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.attach_money),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Price is required';
                }
                final price = double.tryParse(value.trim());
                if (price == null || price <= 0) {
                  return 'Please enter a valid price';
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