if (!variable_global_exists("glitch_transition_active") || !global.glitch_transition_active) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _sound_live = false;
if (global.glitch_transition_instance != -1) {
	_sound_live = audio_is_playing(global.glitch_transition_instance);
}
if (!_sound_live && global.glitch_transition_sound != -1) {
	_sound_live = audio_is_playing(global.glitch_transition_sound);
}
var _intensity = _sound_live ? 1.0 : 0.9;

var _bands_count = array_length(global.glitch_bands);
for (var i = 0; i < _bands_count; i++) {
	var _band = global.glitch_bands[i];
	draw_set_color(_band.col);
	draw_set_alpha(_band.alpha * _intensity);
	draw_rectangle(_band.x1, _band.y, _band.x2, _band.y + _band.h, false);
}

draw_set_alpha(0.12);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);
