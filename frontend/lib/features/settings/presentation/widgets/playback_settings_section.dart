import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';

class PlaybackSettingsSection extends StatelessWidget {
  final int streamQualityKbps;
  final bool filterExplicit;

  const PlaybackSettingsSection({
    super.key,
    required this.streamQualityKbps,
    required this.filterExplicit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),
        Text(
          PlayerStrings.playbackQuality,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 16),
        _buildQualityOption(
          context,
          PlayerStrings.qualityStandard,
          64,
          streamQualityKbps,
        ),
        _buildQualityOption(
          context,
          PlayerStrings.qualityHigh,
          128,
          streamQualityKbps,
        ),
        _buildQualityOption(
          context,
          PlayerStrings.qualityLossless,
          256,
          streamQualityKbps,
        ),
        const SizedBox(height: 48),
        Text(
          SettingsStrings.contentFilters,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeThumbColor: AppColors.primary,
          title: Text(
            SettingsStrings.hideExplicitContent,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          subtitle: Text(
            SettingsStrings.hideExplicitContentDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          value: filterExplicit,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  ToggleExplicitFilter(filterEnabled: value),
                );
            AppSnackbar.show(
              context,
              value
                  ? SettingsStrings.explicitContentHidden
                  : SettingsStrings.explicitContentVisible,
            );
          },
        ),
      ],
    );
  }

  Widget _buildQualityOption(
    BuildContext context,
    String title,
    int kbps,
    int currentKbps,
  ) {
    final isSelected = kbps == currentKbps;
    final subtitleMap = {
      64: PlayerStrings.qualityStandardDesc,
      128: PlayerStrings.qualityHighDesc,
      256: PlayerStrings.qualityLosslessDesc,
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        context.read<SettingsBloc>().add(UpdateStreamQuality(kbps: kbps));
        AppSnackbar.show(context, PlayerStrings.qualitySet(title));
      },
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            ),
      ),
      subtitle: Text(
        subtitleMap[kbps] ?? '',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : const Icon(Icons.circle_outlined, color: AppColors.textSecondary),
    );
  }
}
