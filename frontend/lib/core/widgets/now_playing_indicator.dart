import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NowPlayingIndicator extends StatefulWidget {
  final Color color;
  final double size;
  final bool isPlaying;

  const NowPlayingIndicator({
    super.key,
    this.color = AppColors.primary,
    this.size = 18.0,
    this.isPlaying = true,
  });

  @override
  State<NowPlayingIndicator> createState() => _NowPlayingIndicatorState();
}

class _NowPlayingIndicatorState extends State<NowPlayingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant NowPlayingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBar(0.2, 0.9, 0.0),
            _buildBar(0.4, 1.0, 0.3),
            _buildBar(0.1, 0.8, 0.6),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double minH, double maxH, double phaseOffset) {
    final t = (_controller.value + phaseOffset) % 1.0;
    final curve = (t < 0.5 ? t * 2 : (1.0 - t) * 2);
    final factor = minH + (maxH - minH) * curve;
    return Container(
      width: widget.size * 0.22,
      height: widget.size * factor,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.size * 0.1),
      ),
    );
  }
}
