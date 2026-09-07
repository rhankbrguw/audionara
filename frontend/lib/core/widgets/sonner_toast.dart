import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SonnerToast extends StatefulWidget {
  final String message;
  final bool isError;
  final VoidCallback onDismiss;

  const SonnerToast({
    super.key,
    required this.message,
    required this.isError,
    required this.onDismiss,
  });

  @override
  State<SonnerToast> createState() => _SonnerToastState();
}

class _SonnerToastState extends State<SonnerToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));

    _anim.forward();
    Future.delayed(Duration(seconds: widget.isError ? 4 : 2), _dismiss);
  }

  void _dismiss() {
    if (mounted) {
      _anim.reverse().then((_) {
        if (mounted) widget.onDismiss();
      });
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topOffset = MediaQuery.of(context).padding.top + 8;
    return Positioned(
      top: topOffset,
      left: 56,
      right: 56,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Material(
            color: AppColors.transparent,
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: _dismiss,
                child: _buildToastContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToastContent() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isError ? AppColors.error : AppColors.primary,
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isError ? Icons.error_outline : Icons.check_circle_outline,
            color: widget.isError ? AppColors.error : AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              widget.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
