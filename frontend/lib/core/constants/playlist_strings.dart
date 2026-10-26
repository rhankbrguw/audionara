abstract final class PlaylistStrings {
  static const String emptyPlaylistName = 'Please enter a playlist name';
  static const String playlistNameTooLong = 'Playlist name must be 50 characters or fewer.';
  static const String playlistBioTooLong = 'Bio must be 250 characters or fewer.';
  static const String createPlaylist = 'Create Playlist';
  static const String editPlaylist = 'Edit Playlist';
  static const String playlistCreated = 'Playlist created successfully';
  static const String playlistUpdated = 'Playlist updated successfully';
  static const String playlistDeleted = 'Playlist deleted';
  static const String addCoverArt = 'Add Cover Art';
  static const String deletePlaylist = 'Delete Playlist';
  static const String deletePlaylistDesc =
        'Are you sure you want to delete this playlist?';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String noTracksYet = 'No tracks yet';
  static const String noPlaylistsYet = 'No playlists yet';
  static const String failedToLoadTracks = 'Failed to load tracks';
  static const String customPlaylist = 'Custom Playlist';
  static const String noCustomPlaylistsYet = 'No custom playlists yet.';
  static const String playlistNameHint = 'Playlist Name';
  static String addedToPlaylist(String name) => 'Added to $name';
  static const String createPlaylistUnauthDesc = 'Log in to create your own playlists.';
  static const String allPlaylists = 'All Playlists';
  static const String previousPage = 'Previous';
  static const String nextPage = 'Next';
  static String pageOf(int page, int total) => 'Page $page of $total';
}
