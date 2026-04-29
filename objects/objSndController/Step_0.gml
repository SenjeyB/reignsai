var _fps = max(1, game_get_speed(gamespeed_fps));

if (variable_global_exists("glitch_transition_active") && global.glitch_transition_active) {
	global.glitch_transition_timer += 1;
	global.glitch_stripes_timer += 1;
	if (global.glitch_stripes_timer >= global.glitch_stripes_phase_frames) {
		global.glitch_stripes_timer = 0;
		global.glitch_stripes_on = !global.glitch_stripes_on;
		if (global.glitch_stripes_on) {
			global.glitch_stripes_phase_frames = irandom_range(
				max(1, ceil(_fps * 0.5)),
				max(1, ceil(_fps * 1.0))
			);
		} else {
			global.glitch_stripes_phase_frames = irandom_range(
				max(1, ceil(_fps * 0.06)),
				max(1, ceil(_fps * 0.22))
			);
		}
	}

	var _sound_playing = false;
	if (global.glitch_transition_instance != -1) {
		_sound_playing = audio_is_playing(global.glitch_transition_instance);
	}
	if (!_sound_playing && global.glitch_transition_sound != -1) {
		_sound_playing = audio_is_playing(global.glitch_transition_sound);
	}
	if (global.glitch_transition_timer < global.glitch_transition_duration) {
		_sound_playing = true;
	}

	if (!_sound_playing) {
		var _target_room = global.glitch_transition_target_room;
		global.glitch_transition_active = false;
		global.glitch_transition_timer = 0;
		global.glitch_transition_duration = 0;
		global.glitch_transition_visual_duration = 0;
		global.glitch_transition_instance = -1;
		global.glitch_transition_sound = -1;
		global.glitch_transition_target_room = -1;
		if (_target_room != -1) {
			room_goto(_target_room);
		}
	}
	exit;
}

if (room != rmScenario) {
	ambient_timer = _fps * 60;
	exit;
}

if (!variable_global_exists("game_over") || global.game_over) {
	ambient_timer = _fps * 60;
	exit;
}

ambient_timer -= 1;
if (ambient_timer > 0) exit;

ambient_timer = _fps * 60;
if (irandom(1) == 1) exit;
if (audio_is_playing(sndCandleAmbient) || audio_is_playing(sndPeopleAmbient)) exit;

scrAudioPlaySfx(choose(sndCandleAmbient, sndPeopleAmbient));
