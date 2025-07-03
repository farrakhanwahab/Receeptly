import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/receipt.dart';
import '../providers/receipt_provider.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../models/settings.dart';

class ReceiptPreviewWidget extends StatelessWidget {
  final Receipt receipt;

  const ReceiptPreviewWidget({
    super.key,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false).settings;
    switch (receipt.style) {
      case ReceiptStyle.bank:
        return _buildBankStyle(settings);
      case ReceiptStyle.restaurant:
        return _buildRestaurantStyle(settings);
      case ReceiptStyle.retail:
        return _buildRetailStyle(settings);
      case ReceiptStyle.document:
        return _buildDocumentStyle(settings);
    }
  }

  Widget _buildLogo(String? logoPath) {
    if (logoPath == null || logoPath.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Center(
        child: SizedBox(
          height: 60,
          child: Image.asset(
            logoPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 40, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildBankStyle(Settings settings) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(receipt.logoPath ?? settings.logoPath),
          Text(receipt.merchantName, style: AppTheme.receiptTitle, textAlign: TextAlign.center),
          if (receipt.merchantAddress != null) ...[
            const SizedBox(height: 8),
            Text(receipt.merchantAddress!, style: AppTheme.bodySmall, textAlign: TextAlign.center),
          ],
          if (receipt.merchantPhone != null) ...[
            const SizedBox(height: 4),
            Text(receipt.merchantPhone!, style: AppTheme.bodySmall),
          ],
          if (receipt.merchantEmail != null) ...[
            const SizedBox(height: 4),
            Text(receipt.merchantEmail!, style: AppTheme.bodySmall),
          ],
          const SizedBox(height: 16),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Receipt #:', style: AppTheme.bodySmall),
              Text(receipt.receiptNumber ?? 'N/A', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date:', style: AppTheme.bodySmall),
              Text(_formatDate(receipt.date), style: AppTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecipientInfo(),
          const SizedBox(height: 16),
          _buildItemsTable(),
          const SizedBox(height: 12),
          _buildTotals(),
          const SizedBox(height: 12),
          _buildNotes(settings),
        ],
      ),
    );
  }

  Widget _buildRestaurantStyle(Settings settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(receipt.logoPath ?? settings.logoPath),
          Center(child: Text(receipt.merchantName, style: AppTheme.receiptTitle.copyWith(fontSize: 18))),
          if (receipt.merchantAddress != null) ...[
            const SizedBox(height: 4),
            Center(child: Text(receipt.merchantAddress!, style: AppTheme.bodyXSmall)),
          ],
          if (receipt.merchantPhone != null) ...[
            const SizedBox(height: 2),
            Center(child: Text(receipt.merchantPhone!, style: AppTheme.bodyXSmall)),
          ],
          if (receipt.merchantEmail != null) ...[
            const SizedBox(height: 2),
            Center(child: Text(receipt.merchantEmail!, style: AppTheme.bodyXSmall)),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Receipt #: ${receipt.receiptNumber ?? 'N/A'}', style: AppTheme.bodyXSmall),
              Text(_formatDate(receipt.date), style: AppTheme.bodyXSmall),
            ],
          ),
          const SizedBox(height: 8),
          _buildRecipientInfo(),
          const SizedBox(height: 12),
          _buildItemsTable(),
          const SizedBox(height: 8),
          _buildTotals(),
          const SizedBox(height: 8),
          _buildNotes(settings),
        ],
      ),
    );
  }

  Widget _buildRetailStyle(Settings settings) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(receipt.logoPath ?? settings.logoPath),
          Center(child: Text(receipt.merchantName, style: AppTheme.receiptTitle.copyWith(fontSize: 16))),
          if (receipt.merchantAddress != null) ...[
            const SizedBox(height: 4),
            Center(child: Text(receipt.merchantAddress!, style: AppTheme.bodyXSmall)),
          ],
          const SizedBox(height: 8),
          Text('Receipt #: ${receipt.receiptNumber ?? 'N/A'}', style: AppTheme.bodyXSmall),
          Text('Date: ${_formatDate(receipt.date)}', style: AppTheme.bodyXSmall),
          const SizedBox(height: 8),
          _buildRecipientInfo(),
          const SizedBox(height: 8),
          _buildItemsTable(),
          const SizedBox(height: 8),
          _buildTotals(),
          const SizedBox(height: 8),
          _buildNotes(settings),
        ],
      ),
    );
  }

  Widget _buildDocumentStyle(Settings settings) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(receipt.logoPath ?? settings.logoPath),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(receipt.merchantName, style: AppTheme.receiptTitle.copyWith(fontSize: 24)),
                    if (receipt.merchantAddress != null) ...[
                      const SizedBox(height: 4),
                      Text(receipt.merchantAddress!, style: AppTheme.bodyMedium),
                    ],
                    if (receipt.merchantPhone != null) ...[
                      const SizedBox(height: 2),
                      Text(receipt.merchantPhone!, style: AppTheme.bodyMedium),
                    ],
                    if (receipt.merchantEmail != null) ...[
                      const SizedBox(height: 2),
                      Text(receipt.merchantEmail!, style: AppTheme.bodyMedium),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('RECEIPT', style: AppTheme.receiptTitle.copyWith(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text('Receipt #: ${receipt.receiptNumber ?? 'N/A'}', style: AppTheme.bodySmall),
                  Text('Date: ${_formatDate(receipt.date)}', style: AppTheme.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildRecipientInfo(),
          const SizedBox(height: 16),
          _buildItemsTable(),
          const SizedBox(height: 16),
          _buildTotals(),
          const SizedBox(height: 12),
          _buildNotes(settings),
        ],
      ),
    );
  }

  Widget _buildRecipientInfo() {
    if (receipt.recipientName.isEmpty &&
        (receipt.recipientAddress == null || receipt.recipientAddress!.isEmpty) &&
        (receipt.recipientPhone == null || receipt.recipientPhone!.isEmpty) &&
        (receipt.recipientEmail == null || receipt.recipientEmail!.isEmpty)) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text('Recipient', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        if (receipt.recipientName.isNotEmpty)
          Text(receipt.recipientName, style: AppTheme.bodySmall),
        if (receipt.recipientAddress != null && receipt.recipientAddress!.isNotEmpty)
          Text(receipt.recipientAddress!, style: AppTheme.bodyXSmall),
        if (receipt.recipientPhone != null && receipt.recipientPhone!.isNotEmpty)
          Text('Phone: ${receipt.recipientPhone!}', style: AppTheme.bodyXSmall),
        if (receipt.recipientEmail != null && receipt.recipientEmail!.isNotEmpty)
          Text('Email: ${receipt.recipientEmail!}', style: AppTheme.bodyXSmall),
      ],
    );
  }

  Widget _buildItemsTable() {
    if (receipt.items.isEmpty) {
      return Text('No items', style: AppTheme.bodySmall);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Row(
          children: [
            Expanded(flex: 3, child: Text('Item', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold))),
            Expanded(child: Text('Qty', style: AppTheme.bodySmall)),
            Expanded(child: Text('Price', style: AppTheme.bodySmall)),
            Expanded(child: Text('Discount', style: AppTheme.bodySmall)),
            Expanded(child: Text('Total', style: AppTheme.bodySmall)),
          ],
        ),
        const SizedBox(height: 4),
        ...receipt.items.map((item) => Row(
              children: [
                Expanded(flex: 3, child: Text(item.name, style: AppTheme.bodyXSmall)),
                Expanded(child: Text('${item.quantity}', style: AppTheme.bodyXSmall)),
                Expanded(child: Text(_formatCurrency(item.price), style: AppTheme.bodyXSmall)),
                Expanded(child: Text(_formatCurrency(item.discount), style: AppTheme.bodyXSmall)),
                Expanded(child: Text(_formatCurrency(item.total), style: AppTheme.bodyXSmall)),
              ],
            )),
      ],
    );
  }

  Widget _buildTotals() {
    final taxes = receipt.taxes;
    final hasMultipleTaxes = taxes.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildTotalRow('Subtotal', receipt.subtotal),
        if (receipt.discount > 0) _buildTotalRow('Discount', receipt.discount),
        if (hasMultipleTaxes)
          ...taxes.map((tax) => _buildTotalRow(
                '${tax['name']} (${tax['rate']}%)',
                tax['amount'] as double,
              )),
        if (hasMultipleTaxes && taxes.length > 1)
          _buildTotalRow('Total Tax', taxes.fold(0.0, (sum, t) => sum + (t['amount'] as double))),
        if (!hasMultipleTaxes && receipt.taxAmount > 0)
          _buildTotalRow('Tax', receipt.taxAmount),
        if (receipt.vatAmount > 0) _buildTotalRow('VAT', receipt.vatAmount),
        if (receipt.otherAmount > 0) _buildTotalRow('Other', receipt.otherAmount),
        const Divider(),
        _buildTotalRow('TOTAL', receipt.total, isTotal: true),
      ],
    );
  }

  Widget _buildTotalRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal ? AppTheme.receiptTotal : AppTheme.bodySmall),
          Text(_formatCurrency(value), style: isTotal ? AppTheme.receiptTotal : AppTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildNotes(Settings settings) {
    final note = receipt.notes?.isNotEmpty == true
        ? receipt.notes!
        : (settings.defaultNote.isNotEmpty ? settings.defaultNote : null);
    if (note == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text(note, style: AppTheme.bodyXSmall, textAlign: TextAlign.left),
      ],
    );
  }

  String _formatCurrency(double value) {
    // This should use the provider/settings currency formatter if available
    return '\$${value.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
} 