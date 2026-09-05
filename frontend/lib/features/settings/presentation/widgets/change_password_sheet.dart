import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_event.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<UserBloc>(),
        child: const ChangePasswordSheet(),
      ),
    );
  }

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _currentPw = TextEditingController();
  final _newPw = TextEditingController();

  @override
  void dispose() {
    _currentPw.dispose();
    _newPw.dispose();
    super.dispose();
  }

  void _submit() {
    final current = _currentPw.text;
    final next = _newPw.text;

    if (current.isEmpty) {
      AppSnackbar.show(context, SettingsStrings.currentPasswordHint, isError: true);
      return;
    }

    if (current == next) {
      AppSnackbar.show(context, SettingsStrings.samePasswordError, isError: true);
      return;
    }

    final passErr = AppValidators.validatePassword(next);
    if (passErr != null) {
      AppSnackbar.show(context, passErr, isError: true);
      return;
    }

    Navigator.pop(context);
    context.read<UserBloc>().add(
      ChangeUserPassword(
        currentPassword: current,
        newPassword: next,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            SettingsStrings.changePassword,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _currentPw,
            hint: SettingsStrings.currentPasswordHint,
            icon: Icons.lock_outline_rounded,
            isPassword: true,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _newPw,
            hint: SettingsStrings.newPasswordHint,
            icon: Icons.lock_reset_rounded,
            isPassword: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.key_rounded, size: 20),
            label: const Text(SettingsStrings.updatePassword),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
