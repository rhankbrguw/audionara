package repository

// InitSchema contains the SQL DDL to initialize all database tables.
const InitSchema = `
CREATE TABLE IF NOT EXISTS users (
  id VARCHAR(255) PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL,
  is_email_verified BOOLEAN NOT NULL DEFAULT FALSE
);
ALTER TABLE users ADD COLUMN IF NOT EXISTS is_email_verified BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS bio TEXT NOT NULL DEFAULT '';
ALTER TABLE users ADD COLUMN IF NOT EXISTS profile_picture_url TEXT NOT NULL DEFAULT '';
CREATE TABLE IF NOT EXISTS verification_tokens (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL
);
CREATE TABLE IF NOT EXISTS playlist_tracks (
  track_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  artist TEXT NOT NULL,
  stream_url TEXT NOT NULL,
  cover_art TEXT NOT NULL,
  artist_id TEXT NOT NULL DEFAULT '',
  album_id TEXT NOT NULL DEFAULT '',
  added_at TIMESTAMP NOT NULL,
  PRIMARY KEY (user_id, track_id)
);
ALTER TABLE playlist_tracks ADD COLUMN IF NOT EXISTS artist_id TEXT NOT NULL DEFAULT '';
ALTER TABLE playlist_tracks ADD COLUMN IF NOT EXISTS album_id TEXT NOT NULL DEFAULT '';
ALTER TABLE playlist_tracks ADD COLUMN IF NOT EXISTS duration_ms INTEGER NOT NULL DEFAULT 0;
CREATE TABLE IF NOT EXISTS custom_playlists (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  bio TEXT NOT NULL DEFAULT '',
  cover_art_url TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL
);
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='custom_playlists' AND column_name='bio') THEN
    ALTER TABLE custom_playlists ADD COLUMN bio TEXT NOT NULL DEFAULT '';
  END IF;
END $$;
CREATE TABLE IF NOT EXISTS custom_playlist_tracks (
  id VARCHAR(255) PRIMARY KEY,
  playlist_id VARCHAR(255) NOT NULL REFERENCES custom_playlists(id) ON DELETE CASCADE,
  track_id VARCHAR(255) NOT NULL,
  title TEXT NOT NULL,
  artist TEXT NOT NULL,
  stream_url TEXT NOT NULL,
  cover_art TEXT NOT NULL,
  artist_id TEXT NOT NULL DEFAULT '',
  album_id TEXT NOT NULL DEFAULT '',
  duration_ms INTEGER NOT NULL DEFAULT 0,
  added_at TIMESTAMP NOT NULL,
  UNIQUE(playlist_id, track_id)
);
ALTER TABLE custom_playlist_tracks ADD COLUMN IF NOT EXISTS artist_id TEXT NOT NULL DEFAULT '';
ALTER TABLE custom_playlist_tracks ADD COLUMN IF NOT EXISTS album_id TEXT NOT NULL DEFAULT '';
ALTER TABLE custom_playlist_tracks ADD COLUMN IF NOT EXISTS duration_ms INTEGER NOT NULL DEFAULT 0;
CREATE TABLE IF NOT EXISTS listening_history (
  id SERIAL PRIMARY KEY,
  device_id VARCHAR(255) NOT NULL,
  track_id VARCHAR(255) NOT NULL,
  title TEXT NOT NULL,
  artist TEXT NOT NULL,
  genre TEXT NOT NULL,
  duration_ms INTEGER NOT NULL DEFAULT 0,
  played_at TIMESTAMP NOT NULL DEFAULT NOW()
);
ALTER TABLE listening_history ADD COLUMN IF NOT EXISTS duration_ms INTEGER NOT NULL DEFAULT 0;
CREATE INDEX IF NOT EXISTS idx_listening_history_device_id ON listening_history(device_id);
`
