var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (variable_global_exists("menu_reveal_active") && global.menu_reveal_active) {
    global.menu_reveal_timer += 1;
    if (global.menu_reveal_timer >= global.menu_reveal_duration) {
        global.menu_reveal_active = false;
        global.menu_reveal_timer = 0;
    }
    exit;
}

if (start_transition_active) {
    start_transition_timer += 1;
    var _start_sound_playing = false;
    if (start_glitch_instance != -1) {
        _start_sound_playing = audio_is_playing(start_glitch_instance);
    }
    if (!_start_sound_playing && start_transition_timer >= start_transition_duration) {
        room_goto(rmMenu);
    }
    exit;
}

if (!mouse_check_button_released(mb_left)) exit;

if (point_in_rectangle(_mx, _my, button_start_x1, button_start_y1, button_start_x2, button_start_y2)) {
    if (start_is_restart) {
        room_goto(rmMenu);
        exit;
    }

    var _fps = max(1, game_get_speed(gamespeed_fps));
    var _glitch_data = scrAudioPlayGlitch(true, 0.35);
    start_transition_active = true;
    start_transition_timer = 0;
    start_transition_duration = max(1, ceil(_fps * 0.12));
    start_glitch_instance = -1;
    if (is_struct(_glitch_data)) {
        if (variable_struct_exists(_glitch_data, "instance")) {
            start_glitch_instance = _glitch_data.instance;
        }
        if (variable_struct_exists(_glitch_data, "length")) {
            start_transition_duration = max(
                start_transition_duration,
                ceil(max(0.08, real(_glitch_data.length)) * _fps)
            );
        }
    }
    exit;
}

if (point_in_rectangle(_mx, _my, button_tutorial_x1, button_tutorial_y1, button_tutorial_x2, button_tutorial_y2)) {
    scrAudioPlayButton();
    room_goto(rmTutorialMenu);
    exit;
}

if (point_in_rectangle(_mx, _my, button_stats_x1, button_stats_y1, button_stats_x2, button_stats_y2)) {
    scrAudioPlayButton();
    room_goto(rmStatsMenu);
    exit;
}

if (point_in_rectangle(_mx, _my, button_settings_x1, button_settings_y1, button_settings_x2, button_settings_y2)) {
    scrAudioPlayButton();
    room_goto(rmSettingsMenu);
    exit;
}

if (point_in_rectangle(_mx, _my, button_exit_x1, button_exit_y1, button_exit_x2, button_exit_y2)) {
    scrAudioPlayButton();
    game_end();
}
