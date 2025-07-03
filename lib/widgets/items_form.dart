import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/receipt_provider.dart';
import '../models/receipt_item.dart';
import '../theme/app_theme.dart';

class ItemsForm extends StatefulWidget {
  const ItemsForm({super.key});

  @override
  State<ItemsForm> createState() => _ItemsFormState();
}

class _ItemsFormState extends State<ItemsForm> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantityController.text = '1';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _addItem() {
    final name = _nameController.text.trim();
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final discount = double.tryParse(_discountController.text) ?? 0.0;

    if (name.isNotEmpty && quantity > 0 && price > 0) {
      final item = ReceiptItem(
        name: name,
        quantity: quantity,
        price: price,
        discount: discount,
      );

      context.read<ReceiptProvider>().addItem(item);

      // Clear form
      _nameController.clear();
      _quantityController.clear();
      _priceController.clear();
      _discountController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Item added successfully!'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields correctly'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _editItem(int index, ReceiptItem item) {
    final nameController = TextEditingController(text: item.name);
    final quantityController = TextEditingController(text: item.quantity.toString());
    final priceController = TextEditingController(text: item.price.toString());
    final discountController = TextEditingController(text: item.discount.toString());

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Item'),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.of(dialogContext).size.height * 0.6,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: discountController,
                    decoration: const InputDecoration(labelText: 'Discount'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedItem = ReceiptItem(
                name: nameController.text,
                quantity: int.tryParse(quantityController.text) ?? 1,
                price: double.tryParse(priceController.text) ?? 0.0,
                discount: double.tryParse(discountController.text) ?? 0.0,
              );
              context.read<ReceiptProvider>().updateItem(index, updatedItem);
              Navigator.pop(dialogContext);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptProvider>(
      builder: (context, provider, child) {
        final items = provider.currentReceipt?.items ?? [];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Item',
                        style: AppTheme.headingSmall,
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Item Name *',
                                hintText: 'Enter item name',
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Expanded(
                            child: TextFormField(
                              controller: _quantityController,
                              decoration: const InputDecoration(
                                labelText: 'Qty *',
                                hintText: '1',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: 'Price *',
                                hintText: '0.00',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Expanded(
                            child: TextFormField(
                              controller: _discountController,
                              decoration: const InputDecoration(
                                labelText: 'Discount',
                                hintText: '0.00',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Item'),
                          style: AppTheme.primaryButtonStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              if (items.isNotEmpty) ...[
                Text(
                  'Items',
                  style: AppTheme.headingSmall,
                ),
                const SizedBox(height: AppTheme.spacingM),
                ...List.generate(items.length, (index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
                    child: ListTile(
                      title: Text(
                        item.name,
                        style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Qty: ${item.quantity} | Price: \$${item.price.toStringAsFixed(2)}',
                            style: AppTheme.bodySmall,
                          ),
                          if (item.discount > 0)
                            Text(
                              'Discount: \$${item.discount.toStringAsFixed(2)}',
                              style: AppTheme.bodySmall.copyWith(color: AppTheme.errorColor),
                            ),
                          Text(
                            'Total: \$${item.total.toStringAsFixed(2)}',
                            style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editItem(index, item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              provider.removeItem(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Item removed'),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }
} 