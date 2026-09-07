import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/auth_strings.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/reset_password_otp_form.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class ResetPasswordOtpPage extends StatelessWidget {
  final String email;

  const ResetPasswordOtpPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textInverse),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetSuccess) {
            ErrorSnackbar.show(
              context,
              AuthStrings.passwordResetSuccess,
              isError: false,
            );
            context.go('/login');
          } else if (state is AuthError) {
            ErrorSnackbar.show(context, state.message, isError: true);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.background, AppColors.surfaceVariant],
            ),
          ),
          child: SafeArea(
            child: ResponsiveWrapper(
              maxWidth: 480,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: ResetPasswordOtpForm(email: email),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
