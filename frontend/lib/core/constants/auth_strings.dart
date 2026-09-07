abstract final class AuthStrings {
  static const String logInOrSignUp = 'Log In or Sign Up';
  static const String maybeLater = 'Maybe Later';
  static const String signInRequired = 'Sign In Required';
  static const String signInRequiredDesc =
        'Log in to save your favorite vibes and access custom playlists.';
  static const String login = 'Login';
  static const String signUp = 'Sign Up';
  static const String verify = 'Verify';
  static const String sendResetToken = 'Send Reset Token';
  static const String updatePassword = 'Update Password';
  static const String dontHaveAccount = 'Don\'t have an account? Sign up';
  static const String forgotPassword = 'Forgot Password?';
  static const String invalidEmail =
        'Please enter a valid email address (e.g., name@gmail.com)';
  static const String emailTypo = 'Please check your email address for typos.';
  static const String emptyPassword = 'Password cannot be empty';
  static const String shortPassword =
        'Password must be at least 8 characters, with 1 uppercase letter and 1 number';
  static const String emptyUsername = 'Username cannot be empty';
  static const String invalidUsername =
        'Username must be 3-30 characters (letters, numbers, _, ., -).';
  static const String emptyOtp =
        'Please enter the 6-digit code sent to your email';
  static const String emptyResetToken =
        'Please enter the reset token from your email';
  static const String invalidOtp = 'Please enter a valid 6-digit code';
  static const String invalidPassword = 'Password must be at least 8 characters long';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String resetLinkSent =
        "If this email is registered with AudioNara, you'll receive a reset code shortly.";
  static const String passwordResetSuccess =
        'Password reset successfully! You can now log in with your new password.';
  static const String guestUser = 'Guest User';
  static const String guestUserDesc = 'Log in to sync your favorites and custom playlists across devices.';
  static const String welcomeBack = 'Welcome Back';
  static const String signInToSync = 'Sign in to sync your playlists.';
  static const String createAccount = 'Create Account';
  static const String joinAudioNara = 'Join AudioNara today.';
  static const String verifyEmail = 'Verify Email';
  static String otpSentDesc(String email) => 'We sent a 6-digit code to\n$email';
  static const String forgotPasswordTitle = 'Forgot Password';
  static const String forgotPasswordDesc = 'Enter your email and we\'ll send you a verification code.';
  static const String resetPasswordTitle = 'Reset Password';
  static const String newPassword = 'New Password';
  static const String confirmPassword = 'Confirm Password';
  static const String resetPasswordDesc = 'Enter the 6-digit code sent to your email and your new password.';
  static const String logIn = 'Log In';
  static const String emailHint = 'Email';
  static const String passwordHint = 'Password';
  static const String otpCodeHint = '6-digit OTP';
  static const String authFailed = 'Authentication failed. Please try again.';
}
