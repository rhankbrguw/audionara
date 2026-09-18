import 'package:audionara/core/constants/auth_strings.dart';
import 'package:audionara/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:audionara/features/auth/presentation/bloc/auth_state.dart';
import 'package:audionara/features/auth/presentation/widgets/otp_verification_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthBloc extends Fake implements AuthBloc {
  @override
  AuthState get state => AuthInitial();

  @override
  Stream<AuthState> get stream => const Stream<AuthState>.empty();
}

void main() {
  testWidgets('OtpVerificationForm renders email and placeholder', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AuthBloc>.value(
            value: _FakeAuthBloc(),
            child: const OtpVerificationForm(email: 'test@audionara.com'),
          ),
        ),
      ),
    );

    expect(find.text(AuthStrings.verifyEmail), findsOneWidget);
    expect(find.text(AuthStrings.otpPlaceholder), findsOneWidget);
    expect(find.text(AuthStrings.verify), findsOneWidget);
  });
}
