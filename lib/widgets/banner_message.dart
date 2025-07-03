import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BannerMessageType { success, error }

class BannerMessage extends StatefulWidget {
  final String title;
  final String subtitle;
  final BannerMessageType type;
  final VoidCallback? onClose;
  final Duration duration;
  final String? timestamp;
  final IconData? icon;

  const BannerMessage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.type,
    this.onClose,
    this.duration = const Duration(seconds: 5),
    this.timestamp,
    this.icon,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required BannerMessageType type,
    Duration duration = const Duration(seconds: 5),
    String? timestamp,
    IconData? icon,
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _BannerOverlay(
        title: title,
        subtitle: subtitle,
        type: type,
        duration: duration,
        timestamp: timestamp,
        icon: icon,
        onClose: () => overlayEntry.remove(),
      ),
    );
    overlay.insert(overlayEntry);
  }

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
    return _BannerContent(
      title: widget.title,
      subtitle: widget.subtitle,
      type: widget.type,
      onClose: widget.onClose,
      timestamp: widget.timestamp,
      icon: widget.icon,
    );
  }
}

class _BannerOverlay extends StatefulWidget {
  final String title;
  final String subtitle;
  final BannerMessageType type;
  final VoidCallback onClose;
  final Duration duration;
  final String? timestamp;
  final IconData? icon;

  const _BannerOverlay({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.onClose,
    required this.duration,
    this.timestamp,
    this.icon,
  });

  @override
  State<_BannerOverlay> createState() => _BannerOverlayState();
}

class _BannerOverlayState extends State<_BannerOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onClose());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: SlideTransition(
          position: _offsetAnimation,
          child: _BannerContent(
            title: widget.title,
            subtitle: widget.subtitle,
            type: widget.type,
            onClose: widget.onClose,
            timestamp: widget.timestamp,
            icon: widget.icon,
          ),
        ),
      ),
    );
  }
}

class _BannerContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final BannerMessageType type;
  final VoidCallback? onClose;
  final String? timestamp;
  final IconData? icon;

  const _BannerContent({
    required this.title,
    required this.subtitle,
    required this.type,
    this.onClose,
    this.timestamp,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white, // Pure white, no tint
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // App Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/app_icon.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    icon ?? Icons.brush,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black87,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              // Timestamp
              if (timestamp != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    timestamp!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: onClose,
                ),
            ],
          ),
        ),
      ),
    );
  }
} 