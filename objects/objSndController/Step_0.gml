var _fps = max(1, game_get_speed(gamespeed_fps));

if (variable_global_exists("glitch_transition_active") && global.glitch_transition_active) {
	global.glitch_transition_timer += 1;

	var _alive_bands = [];
	var _band_count = array_length(global.glitch_bands);
	for (var i = 0; i < _band_count; i++) {
		var _band = global.glitch_bands[i];
		_band.life -= 1;
		if (_band.life > 0) {
			array_push(_alive_bands, _band);
		}
	}
	global.glitch_bands = _alive_bands;

	global.glitch_band_spawn_timer += 1;
	if (global.glitch_band_spawn_timer >= global.glitch_band_next_spawn) {
		global.glitch_band_spawn_timer = 0;
		global.glitch_band_next_spawn = irandom_range(
			max(1, ceil(_fps * 0.4)),
			max(1, ceil(_fps * 0.7))
		);

		var _gw = display_get_gui_width();
		var _gh = display_get_gui_height();
		var _group_h = irandom_range(12, 84);
		var _line_h = 5;
		var _line_gap = _line_h;
		var _line_pitch = _line_h + _line_gap;
		var _line_count = max(1, floor((_group_h + _line_gap) / _line_pitch));
		var _block_h = (_line_count * _line_h) + ((_line_count - 1) * _line_gap);
		var _y_start = irandom_range(0, max(0, _gh - _block_h));
		var _base_col = choose(
			c_black,
			make_color_rgb(0, 58, 0),
			make_color_rgb(0, 100, 0),
			make_color_rgb(0, 162, 0),
			make_color_rgb(0, 210, 0)
		);
		var _base_r = color_get_red(_base_col);
		var _base_g = color_get_green(_base_col);
		var _base_b = color_get_blue(_base_col);
		var _life = irandom_range(
			max(1, ceil(_fps * 1.0)),
			max(1, ceil(_fps * 1.5))
		);
		for (var _line_i = 0; _line_i < _line_count; _line_i++) {
			var _line_y = _y_start + (_line_i * _line_pitch);
			var _line_col = make_color_rgb(
				clamp(_base_r + irandom_range(-6, 6), 0, 255),
				clamp(_base_g + irandom_range(-20, 20), 0, 255),
				clamp(_base_b + irandom_range(-6, 6), 0, 255)
			);
			array_push(global.glitch_bands, {
				x1: 0,
				x2: _gw,
				y: _line_y,
				h: _line_h,
				col: _line_col,
				alpha: 1,
				life: _life,
				max_life: _life
			});
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
		global.glitch_bands = [];
		global.glitch_band_spawn_timer = 0;
		global.glitch_band_next_spawn = max(1, ceil(_fps * 0.2));
		if (_target_room != -1) {
			if (_target_room == rmMainMenu) {
				global.cards_refresh_on_mainmenu = true;
				global.cards_reseed_after_restart = true;
				global.menu_reveal_active = true;
				global.menu_reveal_timer = 0;
				global.menu_reveal_duration = max(1, ceil(_fps * 0.5));
			}
			room_goto(_target_room);
		}
	}
	exit;
}

if (array_length(global.glitch_bands) > 0) {
	global.glitch_bands = [];
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
