if (!variable_global_exists("glitch_transition_active") || !global.glitch_transition_active) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _visual_duration = max(1, global.glitch_transition_visual_duration);
var _t = clamp(global.glitch_transition_timer / _visual_duration, 0, 1);

var _sound_live = false;
if (global.glitch_transition_instance != -1) {
	_sound_live = audio_is_playing(global.glitch_transition_instance);
}
if (!_sound_live && global.glitch_transition_sound != -1) {
	_sound_live = audio_is_playing(global.glitch_transition_sound);
}
if (_sound_live && global.glitch_transition_timer >= _visual_duration) {
	_t = 0.88;
}

var _intensity = 1 - _t;
if (_sound_live) {
	_intensity = max(_intensity, 0.12);
}

if (global.glitch_stripes_on) {
	for (var i = 0; i < 10; i++) {
		var _h_black = irandom_range(6, 26);
		var _y_black = irandom_range(0, _gh - _h_black);
		draw_set_alpha(random_range(0.04, 0.14) * _intensity);
		draw_set_color(c_black);
		draw_rectangle(0, _y_black, _gw, _y_black + _h_black, false);
	}

	gpu_set_blendmode(bm_add);
	for (var j = 0; j < 12; j++) {
		var _h_green = irandom_range(4, 22);
		var _y_green = irandom_range(0, _gh - _h_green);
		var _col = choose(
			make_color_rgb(0, 25, 0),
			make_color_rgb(0, 75, 0),
			make_color_rgb(0, 140, 0),
			make_color_rgb(90, 235, 120)
		);
		draw_set_color(_col);
		draw_set_alpha(random_range(0.08, 0.26) * _intensity);
		draw_rectangle(0, _y_green, _gw, _y_green + _h_green, false);
	}
	gpu_set_blendmode(bm_normal);
}

draw_set_alpha(_t);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);
