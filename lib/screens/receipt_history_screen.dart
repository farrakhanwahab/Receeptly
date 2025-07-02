import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/receipt_provider.dart';
import '../models/receipt.dart';
import '../theme/app_theme.dart';
import '../services/export_service.dart';
import '../screens/receipt_preview_screen.dart';

class ReceiptHistoryScreen extends StatefulWidget {
  const ReceiptHistoryScreen({super.key});

  @override
  State<ReceiptHistoryScreen> createState() => _ReceiptHistoryScreenState();
}

class _ReceiptHistoryScreenState extends State<ReceiptHistoryScreen> {
  final Set<String> _selectedReceiptIds = <String>{};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReceiptProvider>().loadReceipts();
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedReceiptIds.clear();
      }
    });
  }

  void _toggleReceiptSelection(String receiptId) {
    setState(() {
      if (_selectedReceiptIds.contains(receiptId)) {
        _selectedReceiptIds.remove(receiptId);
      } else {
        _selectedReceiptIds.add(receiptId);
      }
      if (_selectedReceiptIds.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  Future<void> _bulkExport() async {
    if (_selectedReceiptIds.isEmpty) return;
    
    try {
      final provider = context.read<ReceiptProvider>();
      final selectedReceipts = provider.recentReceipts
          .where((receipt) => _selectedReceiptIds.contains(receipt.id))
          .toList();
      
      final exportService = ExportService();
      for (final receipt in selectedReceipts) {
        await exportService.exportToPDF(receipt);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${selectedReceipts.length} receipts exported successfully!'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
        _toggleSelectionMode();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting receipts: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _bulkDelete() async {
    if (_selectedReceiptIds.isEmpty) return;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${_selectedReceiptIds.length} Receipts', style: AppTheme.headingMedium),
        content: Text(
          'Are you sure you want to delete ${_selectedReceiptIds.length} receipts? This action cannot be undone.',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: AppTheme.dangerButtonStyle,
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      try {
        final provider = context.read<ReceiptProvider>();
        final selectedReceipts = provider.recentReceipts
            .where((receipt) => _selectedReceiptIds.contains(receipt.id))
            .toList();
        
        for (final receipt in selectedReceipts) {
          await provider.deleteReceipt(receipt);
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${selectedReceipts.length} receipts deleted'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
          _toggleSelectionMode();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting receipts: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelectionMode ? '${_selectedReceiptIds.length} Selected' : 'Receipts'),
        iconTheme: AppTheme.iconTheme,
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: _bulkExport,
              tooltip: 'Export Selected',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _bulkDelete,
              tooltip: 'Delete Selected',
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _toggleSelectionMode,
              tooltip: 'Cancel Selection',
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.check_box_outline_blank),
              onPressed: _toggleSelectionMode,
              tooltip: 'Select Multiple',
            ),
          ],
        ],
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
              final isSelected = _selectedReceiptIds.contains(receipt.id);
              
              return Card(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(AppTheme.spacingM),
                  leading: _isSelectionMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (value) => _toggleReceiptSelection(receipt.id),
                        )
                      : null,
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
                  trailing: _isSelectionMode
                      ? null
                      : PopupMenuButton<String>(
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
                  onTap: _isSelectionMode
                      ? () => _toggleReceiptSelection(receipt.id)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showReceiptPreview(BuildContext context, Receipt receipt) {
    final provider = Provider.of<ReceiptProvider>(context, listen: false);
    provider.loadReceipt(receipt);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReceiptPreviewScreen()),
    );
  }

  Future<void> _shareReceipt(Receipt receipt) async {
    try {
      final exportService = ExportService();
      await exportService.exportToPDF(receipt);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Receipt exported and shared successfully!'),
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
        return 'Classic';
      case ReceiptStyle.restaurant:
        return 'Modern';
      case ReceiptStyle.retail:
        return 'Simple';
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