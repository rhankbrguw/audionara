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

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onRegister() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final userErr = AppValidators.validateUsername(username);
    if (userErr != null) {
      ErrorSnackbar.show(context, userErr, isError: true);
      return;
    }

    final emailErr = AppValidators.validateEmail(email);
    if (emailErr != null) {
      ErrorSnackbar.show(context, emailErr, isError: true);
      return;
    }

    final passErr = AppValidators.validatePassword(password);
    if (passErr != null) {
      ErrorSnackbar.show(context, passErr, isError: true);
      return;
    }

    context.read<AuthBloc>().add(RegisterRequested(username, email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AuthStrings.createAccount,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textInverse,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          AuthStrings.joinAudioNara,
          style: TextStyle(fontSize: 13.5, color: AppColors.textInverse70),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: _usernameController,
          hint: SettingsStrings.usernameLabel,
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 12),
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
                onPressed: _onRegister,
                icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.textInverse, size: 18),
                label: const Text(
                  AuthStrings.signUp,
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
