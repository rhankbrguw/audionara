import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../domain/entities/custom_playlist_entity.dart';
import '../bloc/custom_playlist_bloc.dart';
import '../bloc/custom_playlist_event.dart';
import '../bloc/custom_playlist_state.dart';
import '../widgets/playlist_cover_art_picker.dart';
import '../widgets/playlist_text_field.dart';
import '../widgets/playlist_save_button.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class EditPlaylistPage extends StatefulWidget {
  const EditPlaylistPage({super.key, required this.playlist});

  final CustomPlaylistEntity playlist;

  @override
  State<EditPlaylistPage> createState() => _EditPlaylistPageState();
}

class _EditPlaylistPageState extends State<EditPlaylistPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  String _coverArtPath = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.playlist.name);
    _bioController = TextEditingController(text: widget.playlist.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() => _coverArtPath = result.files.single.path!);
    }
  }

  void _save() {
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
      UpdateCustomPlaylistRequested(
        playlistId: widget.playlist.remoteId,
        name: name,
        bio: bio,
        coverArtFilePath: _coverArtPath,
        existingCoverArtUrl: widget.playlist.coverArtUrl,
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
          PlaylistStrings.editPlaylist,
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
          } else if (state is CustomPlaylistUpdated) {
            AppSnackbar.showGlobal(PlaylistStrings.playlistUpdated);
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
                  existingCoverArtUrl: widget.playlist.coverArtUrl,
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
                  onSave: _save,
                  text: PlaylistStrings.editPlaylist,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
