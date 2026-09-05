import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../../../core/constants/settings_strings.dart';
import '../../../../features/user/presentation/bloc/user_bloc.dart';
import '../../../../features/user/presentation/bloc/user_event.dart';
import '../../../../features/user/presentation/bloc/user_state.dart';
import '../../../../features/user/domain/entities/user_entity.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/edit_profile_form.dart';
import '../widgets/change_password_sheet.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  String _selectedImagePath = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _bioController = TextEditingController(text: widget.user.bio);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImagePath = result.files.single.path!;
      });
    }
  }

  void _saveProfile() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final bio = _bioController.text.trim();

    final userErr = AppValidators.validateUsername(username);
    if (userErr != null) {
      AppSnackbar.show(context, userErr, isError: true);
      return;
    }

    final emailErr = AppValidators.validateEmail(email);
    if (emailErr != null) {
      AppSnackbar.show(context, emailErr, isError: true);
      return;
    }

    final bioErr = AppValidators.validateBio(bio);
    if (bioErr != null) {
      AppSnackbar.show(context, bioErr, isError: true);
      return;
    }

    context.read<UserBloc>().add(
      UpdateUserProfile(
        username: username,
        email: email,
        bio: bio,
        profilePictureFilePath: _selectedImagePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          AppSnackbar.show(context, SettingsStrings.profileUpdated);
          Navigator.pop(context);
        } else if (state is UserPasswordChanged) {
          AppSnackbar.show(context, SettingsStrings.passwordChangedSuccess);
        } else if (state is UserError) {
          AppSnackbar.show(context, state.message, isError: true);
        }
      },
      builder: (context, state) {
        final isLoading = state is UserLoading;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            title: Text(
              SettingsStrings.editProfile,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: ResponsiveWrapper(
            maxWidth: 600,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: EditProfileForm(
                formKey: _formKey,
                usernameController: _usernameController,
                emailController: _emailController,
                bioController: _bioController,
                selectedImagePath: _selectedImagePath,
                profilePictureUrl: widget.user.profilePictureUrl,
                onPickImage: _pickImage,
                onSave: _saveProfile,
                onChangePassword: () => ChangePasswordSheet.show(context),
                isLoading: isLoading,
              ),
            ),
          ),
        );
      },
    );
  }
}
