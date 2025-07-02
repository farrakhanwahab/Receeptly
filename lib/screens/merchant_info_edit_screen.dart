import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

class MerchantInfoEditScreen extends StatefulWidget {
  const MerchantInfoEditScreen({super.key});

  @override
  State<MerchantInfoEditScreen> createState() => _MerchantInfoEditScreenState();
}

class _MerchantInfoEditScreenState extends State<MerchantInfoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>().settings;
    _nameController = TextEditingController(text: settings.merchantName);
    _addressController = TextEditingController(text: settings.merchantAddress ?? '');
    _phoneController = TextEditingController(text: settings.merchantPhone ?? '');
    _emailController = TextEditingController(text: settings.merchantEmail ?? '');
    _notesController = TextEditingController(text: settings.merchantNotes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Merchant Info')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Business Name *'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Business Address'),
                maxLines: 2,
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Business Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: AppTheme.spacingL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await context.read<SettingsProvider>().updateMerchantInfo(
                        name: _nameController.text,
                        address: _addressController.text,
                        phone: _phoneController.text,
                        email: _emailController.text,
                        notes: _notesController.text,
                      );
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 