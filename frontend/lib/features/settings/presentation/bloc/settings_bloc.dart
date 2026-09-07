import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_prefs_keys.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required this.prefs}) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateStreamQuality>(_onUpdateStreamQuality);
    on<ToggleExplicitFilter>(_onToggleExplicitFilter);
  }

  final SharedPreferences prefs;

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final kbps = prefs.getInt(AppPrefsKeys.playbackQuality) ?? 128;
    final filter = prefs.getBool(AppPrefsKeys.hideExplicit) ?? false;
    emit(SettingsState(streamQualityKbps: kbps, filterExplicit: filter));
  }

  Future<void> _onUpdateStreamQuality(
    UpdateStreamQuality event,
    Emitter<SettingsState> emit,
  ) async {
    await prefs.setInt(AppPrefsKeys.playbackQuality, event.kbps);
    emit(state.copyWith(streamQualityKbps: event.kbps));
  }

  Future<void> _onToggleExplicitFilter(
    ToggleExplicitFilter event,
    Emitter<SettingsState> emit,
  ) async {
    await prefs.setBool(AppPrefsKeys.hideExplicit, event.filterEnabled);
    emit(state.copyWith(filterExplicit: event.filterEnabled));
  }
}
