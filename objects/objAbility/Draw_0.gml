var col = c_white;

if (hover) col = make_color_rgb(100, 100, 100);
if (pressed && ability_mode == ACTIVE) col = make_color_rgb(50, 50, 50);

if (available_turn >= global.turns_timer) {
	col = make_color_rgb(50, 50, 50);
}

image_blend = col;
draw_self();
