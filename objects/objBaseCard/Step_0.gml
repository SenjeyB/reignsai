position = 0;

var mx = device_mouse_x(0);
var my = device_mouse_y(0);

var left = x - card_w/2;
var right = x + card_w/2;
var top = y - card_h/2;
var bottom = y + card_h/2;

var grab_left  = left  - (card_w * (grab_zone_mul - 1) * 0.5);
var grab_right = right + (card_w * (grab_zone_mul - 1) * 0.5);

if (mouse_check_button_pressed(mb_left)) {
    if (mx > grab_left && mx < grab_right && my > top && my < bottom) {
        grabbed = true;
    }
}

if (mouse_check_button_released(mb_left)) {
    grabbed = false;
    grab_angle_x_t = 0;
    grab_angle_y_t = 0;
}

if (grabbed) {
    x = lerp(x, mx, grab_move_smooth);
    y = lerp(y, my, grab_move_smooth);
	
    var dw = display_get_width();
    var dh = display_get_height();

    var nx = clamp((mx - dw/2) / (dw/2), -1, 1);
    var ny = clamp((my - dh/2) / (dh/2), -1, 1);

    grab_angle_x_t = clamp(-ny * grab_tilt_angle * screen_tilt_mul, -30, 30);
    grab_angle_y_t = clamp(nx * grab_tilt_angle * screen_tilt_mul, -30, 30);

    grab_angle_x = lerp(grab_angle_x, grab_angle_x_t, grab_smooth);
    grab_angle_y = lerp(grab_angle_y, grab_angle_y_t, grab_smooth);

    angle = lerp(angle, 0, grab_smooth);
    offset = lerp(offset, 0, grab_smooth);
} else {
    angle_target = 0;
    offset_target = 0;

    if (mx > (x - card_w/2) - corner_extend && mx < (x - card_w/2) + corner_w && my > (y - card_h/2) && my < (y - card_h/2) + corner_h + corner_extend) {
        angle_target = tilt_angle;
        offset_target = -tilt_offset;
		position = 1;
    }

    if (mx < (x + card_w/2) + corner_extend && mx > (x + card_w/2) - corner_w && my > (y - card_h/2) && my < (y - card_h/2) + corner_h + corner_extend) {
        angle_target = -tilt_angle;
        offset_target = tilt_offset;
		position = 2;
    }

    angle = lerp(angle, angle_target, smooth);
    offset = lerp(offset, offset_target, smooth);

    grab_angle_x = lerp(grab_angle_x, 0, grab_smooth);
    grab_angle_y = lerp(grab_angle_y, 0, grab_smooth);

    x = lerp(x, home_x, smooth);
    y = lerp(y, home_y, smooth);
	
}

opt = collision_rectangle(left, top, right, bottom, objOption, true, true);

if (mouse_check_button_released(mb_left)) {
    grabbed = false;
    grab_angle_x_t = 0;
    grab_angle_y_t = 0;
	
	if (opt != noone && global.game_over) {
		scrAudioPlayButton();
		room_goto(global.start_room);
		return;
	}
	
    if (opt != noone && opt.option_type == 1) {
		scrCardChoice(stat[0]);
    } else if (opt != noone && opt.option_type == 2) {
		scrCardChoice(stat[1]);
	};
}
