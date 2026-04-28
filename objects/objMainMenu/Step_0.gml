var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(_mx, _my, slider_music_x1, slider_music_y1, slider_music_x2, slider_music_y2)) {
        drag_music_slider = true;
        scrAudioSetMusicVolume((_mx - slider_music_x1) / (slider_music_x2 - slider_music_x1));
        scrAudioPlayButton();
    } else if (point_in_rectangle(_mx, _my, slider_sfx_x1, slider_sfx_y1, slider_sfx_x2, slider_sfx_y2)) {
        drag_sfx_slider = true;
        scrAudioSetSfxVolume((_mx - slider_sfx_x1) / (slider_sfx_x2 - slider_sfx_x1));
        scrAudioPlayButton();
    }
}

if (mouse_check_button(mb_left)) {
    if (drag_music_slider) {
        scrAudioSetMusicVolume((_mx - slider_music_x1) / (slider_music_x2 - slider_music_x1));
    } else if (drag_sfx_slider) {
        scrAudioSetSfxVolume((_mx - slider_sfx_x1) / (slider_sfx_x2 - slider_sfx_x1));
    }
}

if (!mouse_check_button_released(mb_left)) exit;

drag_music_slider = false;
drag_sfx_slider = false;

if (point_in_rectangle(_mx, _my, button_start_x1, button_start_y1, button_start_x2, button_start_y2)) {
    scrAudioPlayButton();
    room_goto(rmMenu);
    exit;
}

if (point_in_rectangle(_mx, _my, button_exit_x1, button_exit_y1, button_exit_x2, button_exit_y2)) {
    scrAudioPlayButton();
    game_end();
}
