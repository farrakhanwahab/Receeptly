import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/receipt.dart';
import '../widgets/receipt_preview_widget.dart';

class ExportService {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> exportToPDF(Receipt receipt) async {
    try {
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Text(
                    receipt.merchantName,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                if (receipt.merchantAddress != null) ...[
                  pw.SizedBox(height: 8),
                  pw.Center(
                    child: pw.Text(
                      receipt.merchantAddress!,
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ),
                ],
                if (receipt.merchantPhone != null) ...[
                  pw.SizedBox(height: 4),
                  pw.Center(
                    child: pw.Text(
                      receipt.merchantPhone!,
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ),
                ],
                pw.SizedBox(height: 16),
                pw.Divider(),
                
                // Receipt details
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Receipt #:', style: pw.TextStyle(fontSize: 12)),
                    pw.Text(
                      receipt.receiptNumber ?? 'N/A',
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Date:', style: pw.TextStyle(fontSize: 12)),
                    pw.Text(
                      _formatDate(receipt.date),
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),
                
                // Items table
                if (receipt.items.isNotEmpty) ...[
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: [
                      // Header
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text('Item', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text('Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text('Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                      // Items
                      ...receipt.items.map((item) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(item.name),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text('${item.quantity}'),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(_formatCurrency(item.price, receipt.currency)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(_formatCurrency(item.total, receipt.currency)),
                          ),
                        ],
                      )),
                    ],
                  ),
                  pw.SizedBox(height: 16),
                ],
                
                // Totals
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Subtotal:'),
                    pw.Text(_formatCurrency(receipt.subtotal, receipt.currency)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tax (${receipt.taxRate}%):'),
                    pw.Text(_formatCurrency(receipt.taxAmount, receipt.currency)),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('TOTAL:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      _formatCurrency(receipt.total, receipt.currency),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                
                if (receipt.notes != null) ...[
                  pw.SizedBox(height: 16),
                  pw.Divider(),
                  pw.Text('Notes:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text(receipt.notes!),
                ],
                
                pw.SizedBox(height: 16),
                pw.Text(
                  'Thank you for your business!',
                  style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                ),
              ],
            );
          },
        ),
      );
      
      // Save PDF
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/receipt_${receipt.receiptNumber}.pdf');
      await file.writeAsBytes(await pdf.save());
      
      // Share PDF
      await Share.shareXFiles([XFile(file.path)], text: 'Receipt from ${receipt.merchantName}');
      
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  Future<void> exportToImage(Receipt receipt) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission not granted');
      }
      
      // Create a widget to screenshot
      final widget = MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: ReceiptPreviewWidget(receipt: receipt),
        ),
      );
      
      // Take screenshot
      final Uint8List? imageBytes = await _screenshotController.captureFromWidget(
        widget,
        delay: const Duration(milliseconds: 10),
        context: null,
      );
      
      if (imageBytes != null) {
        // Save to gallery
        final result = await ImageGallerySaver.saveImage(
          imageBytes,
          quality: 100,
          name: 'receipt_${receipt.receiptNumber}',
        );
        
        if (result['isSuccess'] == true) {
          // Share image
          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/receipt_${receipt.receiptNumber}.png');
          await tempFile.writeAsBytes(imageBytes);
          await Share.shareXFiles([XFile(tempFile.path)], text: 'Receipt from ${receipt.merchantName}');
        } else {
          throw Exception('Failed to save image to gallery');
        }
      } else {
        throw Exception('Failed to capture screenshot');
      }
      
    } catch (e) {
      throw Exception('Failed to export image: $e');
    }
  }

  Future<void> shareReceipt(Receipt receipt) async {
    try {
             // Create a simple text representation for sharing
       final receiptText = '''
Receipt from ${receipt.merchantName}
Receipt #: ${receipt.receiptNumber ?? 'N/A'}
Date: ${_formatDate(receipt.date)}

Items:
${receipt.items.map((item) => '${item.name} - ${item.quantity}x ${_formatCurrency(item.price, receipt.currency)} = ${_formatCurrency(item.total, receipt.currency)}').join('\n')}

Subtotal: ${_formatCurrency(receipt.subtotal, receipt.currency)}
Tax (${receipt.taxRate}%): ${_formatCurrency(receipt.taxAmount, receipt.currency)}
TOTAL: ${_formatCurrency(receipt.total, receipt.currency)}

${receipt.notes != null ? 'Notes: ${receipt.notes}' : ''}
      '''.trim();
      
      await Share.share(receiptText, subject: 'Receipt from ${receipt.merchantName}');
      
    } catch (e) {
      throw Exception('Failed to share receipt: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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
} 