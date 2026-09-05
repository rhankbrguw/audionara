import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../bloc/custom_playlist_bloc.dart';
import '../bloc/custom_playlist_event.dart';
import '../bloc/custom_playlist_state.dart';
import '../widgets/playlist_cover_art_picker.dart';
import '../widgets/playlist_text_field.dart';
import '../widgets/playlist_save_button.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class CreatePlaylistPage extends StatefulWidget {
  const CreatePlaylistPage({super.key});

  @override
  State<CreatePlaylistPage> createState() => _CreatePlaylistPageState();
}

class _CreatePlaylistPageState extends State<CreatePlaylistPage> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  String _coverArtPath = '';

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _coverArtPath = result.files.single.path!;
      });
    }
  }

  void _createPlaylist() {
    final name = _nameController.text.trim();
    final bio = _bioController.text.trim();

    final nameErr = AppValidators.validatePlaylistName(name);
    if (nameErr != null) {
      ErrorSnackbar.show(context, nameErr, isError: true);
      return;
    }

    final bioErr = AppValidators.validateBio(bio);
    if (bioErr != null) {
      ErrorSnackbar.show(context, bioErr, isError: true);
      return;
    }

    context.read<CustomPlaylistBloc>().add(
      CreateCustomPlaylistRequested(
        name: name,
        bio: bio,
        coverArtFilePath: _coverArtPath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          PlaylistStrings.createPlaylist,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<CustomPlaylistBloc, CustomPlaylistState>(
        listener: (context, state) {
          if (state is CustomPlaylistError) {
            ErrorSnackbar.show(context, state.message, isError: true);
          } else if (state is CustomPlaylistsLoaded) {
            AppSnackbar.showGlobal(PlaylistStrings.playlistCreated);
            context.pop();
          }
        },
        child: ResponsiveWrapper(
          maxWidth: 600,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlaylistCoverArtPicker(
                  onTap: _pickImage,
                  coverArtPath: _coverArtPath,
                ),
                const SizedBox(height: 24),
                PlaylistTextField(
                  controller: _nameController,
                  hintText: PlaylistStrings.playlistNameHint,
                ),
                const SizedBox(height: 16),
                PlaylistTextField(
                  controller: _bioController,
                  hintText: SettingsStrings.bioHint,
                  maxLines: 3,
                ),
                const SizedBox(height: 28),
                PlaylistSaveButton(
                  onSave: _createPlaylist,
                  text: PlaylistStrings.createPlaylist,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
