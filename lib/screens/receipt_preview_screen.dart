import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/receipt_provider.dart';
import '../models/receipt.dart';
import '../widgets/receipt_preview_widget.dart';
import '../services/export_service.dart';
import '../theme/app_theme.dart';

class ReceiptPreviewScreen extends StatelessWidget {
  const ReceiptPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Preview'),
        actions: [
          Consumer<ReceiptProvider>(
            builder: (context, provider, child) {
              if (provider.currentReceipt?.merchantName.isEmpty == true) {
                return const SizedBox.shrink();
              }
              return PopupMenuButton<String>(
                onSelected: (value) async {
                  final exportService = ExportService();
                  try {
                    switch (value) {
                      case 'pdf':
                        await exportService.exportToPDF(provider.currentReceipt!);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('PDF exported successfully!'),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          );
                        }
                        break;
                      case 'image':
                        await exportService.exportToImage(provider.currentReceipt!);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Image exported successfully!'),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          );
                        }
                        break;
                      case 'share':
                        await exportService.shareReceipt(provider.currentReceipt!);
                        break;
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Export failed: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'pdf',
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf),
                        SizedBox(width: 8),
                        Text('Export as PDF'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'image',
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        SizedBox(width: 8),
                        Text('Export as Image'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share),
                        SizedBox(width: 8),
                        Text('Share Receipt'),
                      ],
                    ),
                  ),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.more_vert),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ReceiptProvider>(
        builder: (context, provider, child) {
          if (provider.currentReceipt == null) {
            return const Center(
              child: Text('No receipt to preview'),
            );
          }

          if (provider.currentReceipt!.merchantName.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Complete the receipt details to see preview',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Receipt preview
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ReceiptPreviewWidget(receipt: provider.currentReceipt!),
                ),
                const SizedBox(height: 24),
                
                // Receipt info
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Receipt Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Receipt Number', provider.currentReceipt!.receiptNumber ?? 'N/A'),
                        _buildInfoRow('Date', _formatDate(provider.currentReceipt!.date)),
                        _buildInfoRow('Style', _getStyleName(provider.currentReceipt!.style)),
                        _buildInfoRow('Currency', provider.currentReceipt!.currency),
                        _buildInfoRow('Tax Rate', '${provider.currentReceipt!.taxRate}%'),
                        _buildInfoRow('Items Count', provider.currentReceipt!.items.length.toString()),
                        _buildInfoRow('Subtotal', provider.formatCurrency(provider.currentReceipt!.subtotal)),
                        _buildInfoRow('Tax Amount', provider.formatCurrency(provider.currentReceipt!.taxAmount)),
                        _buildInfoRow('Total', provider.formatCurrency(provider.currentReceipt!.total)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getStyleName(ReceiptStyle style) {
    switch (style) {
      case ReceiptStyle.bank:
        return 'Classic Style';
      case ReceiptStyle.restaurant:
        return 'Modern Style';
      case ReceiptStyle.retail:
        return 'Simple Style';
      case ReceiptStyle.document:
        return 'Document Style';
    }
  }
} 