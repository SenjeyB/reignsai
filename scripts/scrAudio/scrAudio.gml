function scrAudioLoadSettings() {
	if (!file_exists("settings.json")) return;
	var f = file_text_open_read("settings.json");
	if (f == -1) return;
	var content = "";
	while (!file_text_eof(f)) content += file_text_readln(f);
	file_text_close(f);

	if (string_length(content) > 0 && ord(string_char_at(content, 1)) == 65279) {
		content = string_delete(content, 1, 1);
	}

	try {
		var parsed = json_parse(content);
		if (!is_struct(parsed)) return;
		if (variable_struct_exists(parsed, "audio_music_volume")) {
			global.audio_music_volume = clamp(real(parsed.audio_music_volume), 0, 1);
		}
		if (variable_struct_exists(parsed, "audio_sfx_volume")) {
			global.audio_sfx_volume = clamp(real(parsed.audio_sfx_volume), 0, 1);
		}
		if (variable_struct_exists(parsed, "display_window_mode")) {
			global.display_window_mode = real(parsed.display_window_mode);
		}
	} catch (_e) {
		show_debug_message("scrAudioLoadSettings: failed to parse settings.json");
	}
}

function scrAudioSaveSettings() {
	var data = {
		audio_music_volume: global.audio_music_volume,
		audio_sfx_volume: global.audio_sfx_volume,
		display_window_mode: variable_global_exists("display_window_mode") ? global.display_window_mode : 0
	};
	var content = json_stringify(data);
	var f = file_text_open_write("settings.json");
	if (f == -1) return;
	file_text_write_string(f, content);
	file_text_close(f);
}

function scrAudioEnsureDefaults() {
	if (!variable_global_exists("audio_music_volume")) global.audio_music_volume = 0.8;
	if (!variable_global_exists("audio_sfx_volume")) global.audio_sfx_volume = 0.8;

	if (!variable_global_exists("audio_settings_loaded")) {
		global.audio_settings_loaded = true;
		scrAudioLoadSettings();
	}

	global.audio_music_volume = clamp(global.audio_music_volume, 0, 1);
	global.audio_sfx_volume = clamp(global.audio_sfx_volume, 0, 1);
}

function scrAudioSetMusicVolume(_value) {
	scrAudioEnsureDefaults();
	global.audio_music_volume = clamp(_value, 0, 1);

	if (instance_exists(objMusController)) {
		with (objMusController) {
			if (music_instance != -1) {
				audio_sound_gain(music_instance, global.audio_music_volume, 0);
			}
		}
	}

	scrAudioSaveSettings();
}

function scrAudioSetSfxVolume(_value) {
	scrAudioEnsureDefaults();
	global.audio_sfx_volume = clamp(_value, 0, 1);
	scrAudioSaveSettings();
}

function scrAudioPlaySfx(_sound) {
	scrAudioEnsureDefaults();
	var _instance = audio_play_sound(_sound, 1, false);
	audio_sound_gain(_instance, global.audio_sfx_volume, 0);
	return _instance;
}

function scrAudioPlayButton() {
	return scrAudioPlaySfx(sndButton);
}

function scrAudioPlayManChance() {
	if (irandom(1) == 0) {
		return scrAudioPlaySfx(choose(sndMan1, sndMan2, sndMan3, sndMan4, sndMan5, sndMan6));
	}
	return -1;
}

function scrAudioPlayPenChance() {
	if (irandom(1) == 0) {
		return scrAudioPlaySfx(choose(sndPen1, sndPen2, sndPen3));
	}
	return -1;
}

function scrAudioStopAll() {
	audio_stop_all();
}

function scrAudioPlayGlitch(_random_start) {
	var _max_remaining = 0.0;
	if (argument_count > 1) {
		_max_remaining = max(0.0, real(argument[1]));
	}

	var _sound_pool = [sndGlitch1, sndGlitch2, sndGlitch3];
	var _sound = _sound_pool[irandom(array_length(_sound_pool) - 1)];
	var _length = max(0.0, audio_sound_length(_sound));
	var _start_pos = 0.0;
	if (_max_remaining > 0.0 && _length > _max_remaining) {
		_start_pos = _length - _max_remaining;
	}
	scrAudioEnsureDefaults();
	var _instance = audio_play_sound(_sound, 100, false);
	if (_instance == -1) {
		for (var i = 0; i < array_length(_sound_pool); i++) {
			if (_sound_pool[i] == _sound) continue;
			_sound = _sound_pool[i];
			_length = max(0.0, audio_sound_length(_sound));
			_start_pos = 0.0;
			if (_max_remaining > 0.0 && _length > _max_remaining) {
				_start_pos = _length - _max_remaining;
			}
			_instance = audio_play_sound(_sound, 100, false);
			if (_instance != -1) break;
		}
	}
	if (_instance != -1) {
		audio_sound_gain(_instance, 1.35, 0);
	}
	if (_random_start) {
		if (_instance != -1 && _length > 0.08) {
			_start_pos = random(_length * 0.7);
			if (_max_remaining > 0.0 && (_length - _start_pos) > _max_remaining) {
				_start_pos = _length - _max_remaining;
			}
			audio_sound_set_track_position(_instance, _start_pos);
		}
	} else if (_instance != -1 && _start_pos > 0.0) {
		audio_sound_set_track_position(_instance, _start_pos);
	}
	return {
		instance: _instance,
		sound: _sound,
		length: max(0.0, _length - _start_pos)
	};
}
