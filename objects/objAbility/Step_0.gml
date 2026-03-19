hover = point_in_rectangle(
    mouse_x, mouse_y,
    bbox_left, bbox_top,
    bbox_right, bbox_bottom
);

pressed = hover && mouse_check_button(mb_left);

if (available_turn < global.turns_timer) {
	if (ability_mode == ACTIVE && mouse_check_button_released(mb_left) && hover) {
		scrUseAbility(ability_type);
	}
}

