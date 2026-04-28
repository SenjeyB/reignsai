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
