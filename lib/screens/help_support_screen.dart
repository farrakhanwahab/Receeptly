import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help & Support', style: AppTheme.headingMedium)),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How to use the app:', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingS),
            Text('1. Configure your business settings in this page', style: AppTheme.bodySmall),
            Text('2. Create receipts with recipient information', style: AppTheme.bodySmall),
            Text('3. Add items and set pricing', style: AppTheme.bodySmall),
            Text('4. Choose receipt style and generate', style: AppTheme.bodySmall),
            Text('5. Preview, share, or save receipts', style: AppTheme.bodySmall),
            const SizedBox(height: AppTheme.spacingM),
            Text('For support:', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingS),
            Text('Email: wahabfarrakhan@gmail.com', style: AppTheme.bodySmall),
            Text('Phone: +233-500-428501', style: AppTheme.bodySmall),
          ],
        ),
      ),
    );
  }
} 