import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'player_sleep_timer_sheet_content.dart';

void showSleepTimerBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return const SleepTimerSheetContent();
    },
  );
}
