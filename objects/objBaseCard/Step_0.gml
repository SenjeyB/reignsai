position = 0;

var mx = device_mouse_x(0);
var my = device_mouse_y(0);

var left = x - card_w/2;
var right = x + card_w/2;
var top = y - card_h/2;
var bottom = y + card_h/2;

if (is_vaporizing) {
    grabbed = false;
    grab_angle_x_t = 0;
    grab_angle_y_t = 0;
    grab_angle_x = lerp(grab_angle_x, 0, grab_smooth);
    grab_angle_y = lerp(grab_angle_y, 0, grab_smooth);
    angle = lerp(angle, 0, grab_smooth);
    offset = lerp(offset, 0, grab_smooth);

    vapor_timer += 1;
    if (vapor_timer >= vapor_duration) {
        if (vapor_choice_idx == 0) {
            scrCardChoice(stat[0]);
        } else if (vapor_choice_idx == 1) {
            scrCardChoice(stat[1]);
        }
    }
    exit;
}

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
        scrAudioStopAll();
		var _fps = max(1, game_get_speed(gamespeed_fps));
        var _glitch_data = scrAudioPlayGlitch(false);
        var _glitch_len = 1.0;
        var _glitch_instance = -1;
        var _glitch_sound = -1;
        if (is_struct(_glitch_data)) {
            if (variable_struct_exists(_glitch_data, "instance")) {
                _glitch_instance = _glitch_data.instance;
            }
            if (variable_struct_exists(_glitch_data, "sound")) {
                _glitch_sound = _glitch_data.sound;
            }
            if (variable_struct_exists(_glitch_data, "length")) {
                _glitch_len = max(0.5, real(_glitch_data.length));
            }
        }

        global.glitch_transition_active = true;
        global.glitch_transition_target_room = global.start_room;
        global.glitch_transition_timer = 0;
        global.glitch_transition_duration = max(1, ceil(_glitch_len * _fps));
        global.glitch_transition_visual_duration = global.glitch_transition_duration;
        global.glitch_transition_instance = _glitch_instance;
        global.glitch_transition_sound = _glitch_sound;
        global.glitch_bands = [];
        global.glitch_band_spawn_timer = 0;
        global.glitch_band_next_spawn = 1;
        if (variable_global_exists("current_card_id") && global.current_card_id == id) {
            global.current_card_id = noone;
        }
        instance_destroy();
		return;
	}
	
    if (opt != noone && opt.option_type == 1) {
        is_vaporizing = true;
        vapor_timer = 0;
        vapor_choice_idx = 0;
        vapor_direction = -1;
        scrAudioPlayPenChance();
    } else if (opt != noone && opt.option_type == 2) {
        is_vaporizing = true;
        vapor_timer = 0;
        vapor_choice_idx = 1;
        vapor_direction = 1;
        scrAudioPlayPenChance();
	};
}
