import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/receipt_provider.dart';

class MerchantInfoForm extends StatefulWidget {
  const MerchantInfoForm({super.key});

  @override
  State<MerchantInfoForm> createState() => _MerchantInfoFormState();
}

class _MerchantInfoFormState extends State<MerchantInfoForm> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentData();
    });
  }

  void _loadCurrentData() {
    final provider = context.read<ReceiptProvider>();
    if (provider.currentReceipt != null) {
      final receipt = provider.currentReceipt!;
      _nameController.text = receipt.merchantName;
      _addressController.text = receipt.merchantAddress ?? '';
      _phoneController.text = receipt.merchantPhone ?? '';
      _emailController.text = receipt.merchantEmail ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        final provider = context.read<ReceiptProvider>();
        provider.updateLogoPath(result.files.single.path);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logo uploaded successfully!'),
            backgroundColor: Colors.black,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading logo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Merchant Name *',
            hintText: 'Enter merchant/business name',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter merchant name';
            }
            return null;
          },
          onChanged: (value) {
            context.read<ReceiptProvider>().updateMerchantInfo(name: value);
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            hintText: 'Enter business address',
          ),
          maxLines: 2,
          onChanged: (value) {
            context.read<ReceiptProvider>().updateMerchantInfo(address: value);
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter phone number',
          ),
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            context.read<ReceiptProvider>().updateMerchantInfo(phone: value);
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter email address',
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<ReceiptProvider>().updateMerchantInfo(email: value);
          },
        ),
        const SizedBox(height: 24),
        Consumer<ReceiptProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                if (provider.currentReceipt?.logoPath != null)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        provider.currentReceipt!.logoPath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickLogo,
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload Logo'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
} 