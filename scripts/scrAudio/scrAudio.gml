function scrAudioEnsureDefaults() {
	if (!variable_global_exists("audio_music_volume")) global.audio_music_volume = 0.8;
	if (!variable_global_exists("audio_sfx_volume")) global.audio_sfx_volume = 0.8;

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
}

function scrAudioSetSfxVolume(_value) {
	scrAudioEnsureDefaults();
	global.audio_sfx_volume = clamp(_value, 0, 1);
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

	var _candidate_names = ["sndGlitch1", "sndGlitch2", "sndGlitch3"];
	var _resolved = [];
	for (var i = 0; i < array_length(_candidate_names); i++) {
		var _asset = asset_get_index(_candidate_names[i]);
		if (_asset != -1) {
			array_push(_resolved, _asset);
		}
	}

	if (array_length(_resolved) <= 0) {
		var _fallback_instance = scrAudioPlayButton();
		return {
			instance: _fallback_instance,
			sound: -1,
			length: 0.0
		};
	}

	var _sound = _resolved[irandom(array_length(_resolved) - 1)];
	var _length = max(0.0, audio_sound_length(_sound));
	var _start_pos = 0.0;
	if (_max_remaining > 0.0 && _length > _max_remaining) {
		_start_pos = _length - _max_remaining;
	}
	scrAudioEnsureDefaults();
	var _instance = audio_play_sound(_sound, 100, false);
	audio_sound_gain(_instance, max(0.85, global.audio_sfx_volume), 0);
	if (_random_start) {
		if (_length > 0.08) {
			_start_pos = random(_length * 0.7);
			if (_max_remaining > 0.0 && (_length - _start_pos) > _max_remaining) {
				_start_pos = _length - _max_remaining;
			}
			audio_sound_set_track_position(_instance, _start_pos);
		}
	} else if (_start_pos > 0.0) {
		audio_sound_set_track_position(_instance, _start_pos);
	}
	return {
		instance: _instance,
		sound: _sound,
		length: max(0.0, _length - _start_pos)
	};
}
