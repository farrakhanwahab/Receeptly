import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/receipt_provider.dart';
import '../models/receipt.dart';
import '../widgets/receipt_preview_widget.dart';
import '../services/export_service.dart';
import '../theme/app_theme.dart';
import '../widgets/banner_message.dart';

class ReceiptPreviewScreen extends StatefulWidget {
  const ReceiptPreviewScreen({super.key});

  @override
  State<ReceiptPreviewScreen> createState() => _ReceiptPreviewScreenState();
}

class _ReceiptPreviewScreenState extends State<ReceiptPreviewScreen> {
  void _showBanner(String title, String subtitle, BannerMessageType type) {
    BannerMessage.show(
      context,
      title: title,
      subtitle: subtitle,
      type: type,
    );
  }

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
                          _showBanner('Success', 'PDF exported successfully!', BannerMessageType.success);
                        }
                        break;
                      case 'image':
                        await exportService.exportToImage(provider.currentReceipt!);
                        if (context.mounted) {
                          _showBanner('Success', 'Image exported successfully!', BannerMessageType.success);
                        }
                        break;
                      case 'share':
                        await exportService.shareReceipt(provider.currentReceipt!);
                        break;
                    }
                  } catch (e) {
                    if (context.mounted) {
                      _showBanner('Error', 'Export failed: $e', BannerMessageType.error);
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
            return const Center(child: CircularProgressIndicator());
          }
          return ReceiptPreviewWidget(receipt: provider.currentReceipt!);
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