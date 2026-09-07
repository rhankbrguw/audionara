import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../../../../../core/theme/app_colors.dart';

class ScrollingTrackTitle extends StatelessWidget {
  const ScrollingTrackTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        );
        final textPainter = TextPainter(
          text: TextSpan(text: title, style: textStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(minWidth: 0, maxWidth: double.infinity);

        if (textPainter.size.width > constraints.maxWidth) {
          return SizedBox(
            height: 28,
            child: Marquee(
              text: title,
              style: textStyle,
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 40.0,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 2),
            ),
          );
        }
        return Text(
          title,
          style: textStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
