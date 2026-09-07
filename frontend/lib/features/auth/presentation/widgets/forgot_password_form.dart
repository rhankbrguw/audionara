import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/auth_strings.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordForm extends StatefulWidget {
  final Function(String) onEmailSubmitted;
  const ForgotPasswordForm({super.key, required this.onEmailSubmitted});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _emailController = TextEditingController();

  void _onSubmit() {
    final email = _emailController.text.trim();
    final emailErr = AppValidators.validateEmail(email);
    if (emailErr != null) {
      ErrorSnackbar.show(context, emailErr, isError: true);
      return;
    }

    widget.onEmailSubmitted(email);
    context.read<AuthBloc>().add(ForgotPasswordRequested(email));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.lock_reset_rounded,
          size: 48,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        const Text(
          AuthStrings.forgotPasswordTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textInverse,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          AuthStrings.forgotPasswordDesc,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: AppColors.textInverse70,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: _emailController,
          hint: AuthStrings.emailHint,
          icon: Icons.mail_outline_rounded,
        ),
        const SizedBox(height: 24),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const CircularProgressIndicator(
                color: AppColors.primary,
              );
            }
            return Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
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
                icon: const Icon(Icons.send_rounded, color: AppColors.textInverse, size: 18),
                label: const Text(
                  AuthStrings.sendResetToken,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textInverse,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.transparent,
                  shadowColor: AppColors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
