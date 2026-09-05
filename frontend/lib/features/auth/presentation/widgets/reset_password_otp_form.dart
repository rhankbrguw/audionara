import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/auth_strings.dart';
import '../../../../core/constants/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ResetPasswordOtpForm extends StatefulWidget {
  final String email;
  const ResetPasswordOtpForm({super.key, required this.email});

  @override
  State<ResetPasswordOtpForm> createState() => _ResetPasswordOtpFormState();
}

class _ResetPasswordOtpFormState extends State<ResetPasswordOtpForm> {
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _onSubmit() {
    final otp = _otpController.text.trim();
    final newPassword = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final otpErr = AppValidators.validateOTP(otp);
    if (otpErr != null) {
      ErrorSnackbar.show(context, otpErr, isError: true);
      return;
    }

    final passErr = AppValidators.validatePassword(newPassword);
    if (passErr != null) {
      ErrorSnackbar.show(context, passErr, isError: true);
      return;
    }

    if (newPassword != confirmPassword) {
      ErrorSnackbar.show(context, AuthStrings.passwordsDoNotMatch, isError: true);
      return;
    }

    context.read<AuthBloc>().add(ResetPasswordRequested(widget.email, otp, newPassword));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_reset_rounded, size: 48, color: AppColors.primary),
        const SizedBox(height: 16),
        const Text(
          AuthStrings.resetPasswordTitle,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textInverse, letterSpacing: 0.5),
        ),
        const SizedBox(height: 6),
        Text(
          '${AuthStrings.resetPasswordDesc}\n${widget.email}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13.5, color: AppColors.textInverse70, height: 1.4),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: _otpController,
          hint: AuthStrings.otpCodeHint,
          icon: Icons.pin_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _passwordController,
          hint: AuthStrings.newPassword,
          icon: Icons.lock_outline_rounded,
          isPassword: true,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _confirmPasswordController,
          hint: AuthStrings.confirmPassword,
          icon: Icons.lock_reset_rounded,
          isPassword: true,
        ),
        const SizedBox(height: 24),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const CircularProgressIndicator(color: AppColors.primary);
            }
            return Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _onSubmit,
                icon: const Icon(Icons.check_circle_outline_rounded, color: AppColors.textInverse, size: 18),
                label: const Text(
                  SettingsStrings.saveChanges,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textInverse),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.transparent,
                  shadowColor: AppColors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
