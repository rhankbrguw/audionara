import '../constants/app_constants.dart';
import '../constants/auth_strings.dart';
import '../constants/settings_strings.dart';
import '../constants/playlist_strings.dart';

/// Unified client-side validation rules mirrored with backend pkg/validator.
abstract final class AppValidators {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _otpRegex = RegExp(r'^\d{6}$');
  static final RegExp _upperCaseRegex = RegExp(r'[A-Z]');
  static final RegExp _digitRegex = RegExp(r'[0-9]');
  static final RegExp _usernameRegex = RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9._-]{1,28}[a-zA-Z0-9]$');
  static final RegExp _nameRegex = RegExp(r"^[a-zA-Z\s'-]{2,50}$");
  static final RegExp _phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');

  static bool hasEmailTypo(String email) {
    final lowerEmail = email.toLowerCase();
    for (final typo in AppConstants.commonEmailTypos) {
      if (lowerEmail.endsWith(typo)) {
        final atIndex = lowerEmail.indexOf('@');
        if (atIndex != -1 && typo.length == lowerEmail.substring(atIndex).length) {
          return true;
        }
      }
    }
    return false;
  }

  static bool isValidEmail(String email) {
    if (email.isEmpty || !_emailRegex.hasMatch(email)) return false;
    return !hasEmailTypo(email);
  }

  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return AuthStrings.invalidEmail;
    if (!_emailRegex.hasMatch(email)) return AuthStrings.invalidEmail;
    if (hasEmailTypo(email)) return AuthStrings.emailTypo;
    return null;
  }

  static bool isValidPassword(String password) {
    if (password.length < 8) return false;
    if (!_upperCaseRegex.hasMatch(password)) return false;
    if (!_digitRegex.hasMatch(password)) return false;
    return true;
  }

  static String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return AuthStrings.emptyPassword;
    if (password.length < 8 ||
        !_upperCaseRegex.hasMatch(password) ||
        !_digitRegex.hasMatch(password)) {
      return AuthStrings.shortPassword;
    }
    return null;
  }

  static bool isValidUsername(String username) {
    return _usernameRegex.hasMatch(username);
  }

  static String? validateUsername(String? value) {
    final username = value?.trim() ?? '';
    if (username.isEmpty) return AuthStrings.emptyUsername;
    if (username.length < 3 || username.length > 30 || !_usernameRegex.hasMatch(username)) {
      return AuthStrings.invalidUsername;
    }
    return null;
  }

  static String? validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return null;
    if (!_nameRegex.hasMatch(name)) return SettingsStrings.invalidName;
    return null;
  }

  static String? validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return null;
    if (!_phoneRegex.hasMatch(phone)) return SettingsStrings.invalidPhone;
    return null;
  }

  static bool isValidOTP(String otp) {
    return _otpRegex.hasMatch(otp.trim());
  }

  static String? validateOTP(String? value) {
    final otp = value?.trim() ?? '';
    if (otp.isEmpty) return AuthStrings.emptyOtp;
    if (!_otpRegex.hasMatch(otp)) return AuthStrings.invalidOtp;
    return null;
  }

  static String? validatePlaylistName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return PlaylistStrings.emptyPlaylistName;
    if (name.length > 50) return PlaylistStrings.playlistNameTooLong;
    return null;
  }

  static String? validateBio(String? value) {
    final bio = value?.trim() ?? '';
    if (bio.length > 250) return SettingsStrings.bioTooLong;
    return null;
  }
}
