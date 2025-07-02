import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BannerMessageType { success, error }

class BannerMessage extends StatefulWidget {
  final String message;
  final BannerMessageType type;
  final VoidCallback? onClose;
  final Duration duration;

  const BannerMessage({
    super.key,
    required this.message,
    required this.type,
    this.onClose,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<BannerMessage> createState() => _BannerMessageState();
}

class _BannerMessageState extends State<BannerMessage> {
  @override
  void initState() {
    super.initState();
    if (widget.onClose != null) {
      Future.delayed(widget.duration, () {
        if (mounted) widget.onClose!();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.type == BannerMessageType.success
        ? AppTheme.successColor
        : AppTheme.errorColor;
    return SafeArea(
      bottom: false,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingL,
              vertical: AppTheme.spacingM,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    widget.message,
                    style: AppTheme.bodyMedium.copyWith(color: Colors.white),
                  ),
                ),
                if (widget.onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: widget.onClose,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 