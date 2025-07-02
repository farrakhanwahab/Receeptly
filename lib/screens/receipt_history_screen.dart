import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/receipt_provider.dart';
import '../models/receipt.dart';
import '../theme/app_theme.dart';
import '../widgets/receipt_preview_widget.dart';
import '../services/export_service.dart';

class ReceiptHistoryScreen extends StatefulWidget {
  const ReceiptHistoryScreen({super.key});

  @override
  State<ReceiptHistoryScreen> createState() => _ReceiptHistoryScreenState();
}

class _ReceiptHistoryScreenState extends State<ReceiptHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReceiptProvider>().loadReceipts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipts'),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<ReceiptProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.recentReceipts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved receipts yet',
                    style: AppTheme.headingSmall.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create and save receipts to see them here',
                    style: AppTheme.bodySmall.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            itemCount: provider.recentReceipts.length,
            itemBuilder: (context, index) {
              final receipt = provider.recentReceipts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(AppTheme.spacingM),
                  title: Text(
                    receipt.merchantName,
                    style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        'Receipt #: ${receipt.receiptNumber ?? 'N/A'}',
                        style: AppTheme.bodySmall,
                      ),
                      Text(
                        'Date: ${DateFormat('MMM dd, yyyy HH:mm').format(receipt.date)}',
                        style: AppTheme.bodySmall,
                      ),
                      Text(
                        'Items: ${receipt.items.length}',
                        style: AppTheme.bodySmall,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: ${_formatCurrency(receipt.total, receipt.currency)}',
                            style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingS,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStyleColor(receipt.style),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusS),
                            ),
                            child: Text(
                              _getStyleName(receipt.style),
                              style: AppTheme.bodyXSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      switch (value) {
                        case 'view':
                          _showReceiptPreview(context, receipt);
                          break;
                        case 'edit':
                          provider.loadReceipt(receipt);
                          // Navigate to creation screen
                          break;
                        case 'share':
                          await _shareReceipt(receipt);
                          break;
                        case 'delete':
                          _showDeleteDialog(context, provider, receipt);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility),
                            SizedBox(width: AppTheme.spacingS),
                            Text('View'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: AppTheme.spacingS),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share),
                            SizedBox(width: AppTheme.spacingS),
                            Text('Share'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: AppTheme.spacingS),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showReceiptPreview(BuildContext context, Receipt receipt) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Receipt Preview', style: AppTheme.headingSmall),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: ReceiptPreviewWidget(receipt: receipt),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareReceipt(Receipt receipt) async {
    try {
      final exportService = ExportService();
      await exportService.shareReceipt(receipt);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Receipt shared successfully!'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing receipt: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context, ReceiptProvider provider, Receipt receipt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Receipt', style: AppTheme.headingMedium),
        content: Text(
          'Are you sure you want to delete the receipt from ${receipt.merchantName}?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await provider.deleteReceipt(receipt);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Receipt deleted'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              }
            },
            style: AppTheme.dangerButtonStyle,
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount, String currency) {
    switch (currency) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      default:
        return '${amount.toStringAsFixed(2)} $currency';
    }
  }

  String _getStyleName(ReceiptStyle style) {
    switch (style) {
      case ReceiptStyle.bank:
        return 'Bank';
      case ReceiptStyle.restaurant:
        return 'Restaurant';
      case ReceiptStyle.retail:
        return 'Retail';
      case ReceiptStyle.document:
        return 'Document';
    }
  }

  Color _getStyleColor(ReceiptStyle style) {
    switch (style) {
      case ReceiptStyle.bank:
        return AppTheme.bankStyleColor;
      case ReceiptStyle.restaurant:
        return AppTheme.restaurantStyleColor;
      case ReceiptStyle.retail:
        return AppTheme.retailStyleColor;
      case ReceiptStyle.document:
        return AppTheme.documentStyleColor;
    }
  }
} 