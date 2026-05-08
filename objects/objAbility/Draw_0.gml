var col = c_white;

if (hover) col = make_color_rgb(180, 180, 180);
if (pressed && ability_mode == ACTIVE) col = make_color_rgb(110, 110, 110);

if (available_turn >= global.turns_timer) {
	col = make_color_rgb(90, 90, 90);
}

image_blend = c_white;
draw_self();

var _icon_spr = -1;
if (variable_global_exists("ability_sprite") && is_array(global.ability_sprite)) {
	if (ability_type < array_length(global.ability_sprite)) {
		_icon_spr = global.ability_sprite[ability_type];
	}
}

if (_icon_spr != -1 && sprite_exists(_icon_spr)) {
	var _prev_filter = gpu_get_tex_filter();
	gpu_set_tex_filter(false);
	draw_sprite_ext(_icon_spr, 0, x, y, 4, 4, 0, col, 1);
	gpu_set_tex_filter(_prev_filter);
}
