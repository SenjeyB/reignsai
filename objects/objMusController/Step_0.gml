var _target_music = -1;
if (variable_global_exists("glitch_transition_active") && global.glitch_transition_active) {
	if (music_instance != -1) {
		audio_stop_sound(music_instance);
		music_instance = -1;
	}
	music_asset = -1;
	exit;
}

if (room == rmMainMenu || room == rmMenu || room == rmStatsMenu || room == rmSettingsMenu) {
	_target_music = musMainMenu;
} else if (room == rmScenario) {
	var _is_game_over = variable_global_exists("game_over") && global.game_over;
	_target_music = _is_game_over ? musGameOver : musGame;
}

if (_target_music == -1) {
	if (music_instance != -1) {
		audio_stop_sound(music_instance);
		music_instance = -1;
	}
	music_asset = -1;
	exit;
}

var _needs_restart = (music_asset != _target_music);
if (!_needs_restart) {
	if (!audio_is_playing(_target_music)) {
		_needs_restart = true;
	}
}

if (_needs_restart) {
	if (music_instance != -1) {
		audio_stop_sound(music_instance);
	}
	music_asset = _target_music;
	music_instance = audio_play_sound(music_asset, 0, true);
}

if (music_instance != -1) {
	audio_sound_gain(music_instance, global.audio_music_volume, 0);
}
