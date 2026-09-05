import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/auth_strings.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final emailErr = AppValidators.validateEmail(email);
    if (emailErr != null) {
      ErrorSnackbar.show(context, emailErr, isError: true);
      return;
    }
    if (password.isEmpty) {
      ErrorSnackbar.show(context, AuthStrings.emptyPassword, isError: true);
      return;
    }

    context.read<AuthBloc>().add(LoginRequested(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          hint: AuthStrings.emailHint,
          icon: Icons.mail_outline_rounded,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _passwordController,
          hint: AuthStrings.passwordHint,
          icon: Icons.lock_outline_rounded,
          isPassword: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push('/forgot-password'),
            child: const Text(
              AuthStrings.forgotPassword,
              style: TextStyle(color: AppColors.textInverse70, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(height: 12),
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
                onPressed: _onLogin,
                icon: const Icon(Icons.login_rounded, color: AppColors.textInverse, size: 18),
                label: const Text(
                  AuthStrings.login,
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
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.push('/register'),
          child: const Text(
            AuthStrings.dontHaveAccount,
            style: TextStyle(
              color: AppColors.textInverse70,
              fontSize: 13.5,
            ),
          ),
        ),
      ],
    );
  }
}
