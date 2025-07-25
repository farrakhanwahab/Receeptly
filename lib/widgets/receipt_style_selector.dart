import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/receipt_provider.dart';
import '../models/receipt.dart';
import '../theme/app_theme.dart';

class ReceiptStyleSelector extends StatelessWidget {
  const ReceiptStyleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Style selection
            Text(
              'Select Receipt Style',
              style: AppTheme.headingSmall,
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: AppTheme.spacingM,
              mainAxisSpacing: AppTheme.spacingM,
              childAspectRatio: 0.8,
              children: ReceiptStyle.values.map((style) {
                final isSelected = provider.currentReceipt?.style == style;
                return GestureDetector(
                  onTap: () {
                    provider.updateReceiptStyle(style);
                  },
                  child: Card(
                    elevation: isSelected ? 4 : 1,
                    color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                    child: Container(
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(color: AppTheme.primaryColor, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getStyleIcon(style),
                              size: 48,
                              color: isSelected ? AppTheme.secondaryColor : AppTheme.primaryColor,
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            Text(
                              _getStyleName(style),
                              style: AppTheme.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppTheme.secondaryColor : AppTheme.textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            Text(
                              _getStyleDescription(style),
                              style: AppTheme.bodySmall.copyWith(
                                color: isSelected ? AppTheme.secondaryColor.withOpacity(0.8) : AppTheme.textColorSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            // Notes field
            Text(
              'Additional Notes (Optional)',
              style: AppTheme.headingSmall,
            ),
            const SizedBox(height: AppTheme.spacingM),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Add any additional notes to the receipt',
              ),
              maxLines: 3,
              onChanged: (value) {
                provider.updateNotes(value.isEmpty ? null : value);
              },
            ),
          ],
        );
      },
    );
  }

  IconData _getStyleIcon(ReceiptStyle style) {
    switch (style) {
      case ReceiptStyle.bank:
        return Icons.receipt_long;
      case ReceiptStyle.restaurant:
        return Icons.trending_up;
      case ReceiptStyle.retail:
        return Icons.list_alt;
      case ReceiptStyle.document:
        return Icons.insert_drive_file;
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

  String _getStyleDescription(ReceiptStyle style) {
    switch (style) {
      case ReceiptStyle.bank:
        return 'Classic, professional layout';
      case ReceiptStyle.restaurant:
        return 'Modern, itemized layout';
      case ReceiptStyle.retail:
        return 'Simple, till-style format';
      case ReceiptStyle.document:
        return 'Formal document/invoice style';
    }
  }
} 