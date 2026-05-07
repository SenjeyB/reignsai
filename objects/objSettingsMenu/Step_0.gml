var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (reset_taps_left < 3) {
    reset_taps_timer += 1;
    if (reset_taps_timer >= reset_taps_timeout) {
        reset_taps_left = 3;
        reset_taps_timer = 0;
        status_text = "";
    }
}

if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(_mx, _my, slider_music_x1, slider_music_y1, slider_music_x2, slider_music_y2)) {
        drag_music_slider = true;
        scrAudioSetMusicVolume((_mx - slider_music_x1) / (slider_music_x2 - slider_music_x1));
        scrAudioPlayButton();
    } else if (point_in_rectangle(_mx, _my, slider_sfx_x1, slider_sfx_y1, slider_sfx_x2, slider_sfx_y2)) {
        drag_sfx_slider = true;
        scrAudioSetSfxVolume((_mx - slider_sfx_x1) / (slider_sfx_x2 - slider_sfx_x1));
        scrAudioPlayButton();
        sfx_preview_last_volume = global.audio_sfx_volume;
    }
}

if (mouse_check_button(mb_left)) {
    if (drag_music_slider) {
        scrAudioSetMusicVolume((_mx - slider_music_x1) / (slider_music_x2 - slider_music_x1));
    } else if (drag_sfx_slider) {
        scrAudioSetSfxVolume((_mx - slider_sfx_x1) / (slider_sfx_x2 - slider_sfx_x1));
        if (abs(global.audio_sfx_volume - sfx_preview_last_volume) >= sfx_preview_step) {
            scrAudioPlaySfx(sndButton);
            sfx_preview_last_volume = global.audio_sfx_volume;
        }
    }
}

if (!mouse_check_button_released(mb_left)) exit;

drag_music_slider = false;
drag_sfx_slider = false;

if (point_in_rectangle(_mx, _my, button_reset_x1, button_reset_y1, button_reset_x2, button_reset_y2)) {
    scrAudioPlayButton();
    reset_taps_left -= 1;
    reset_taps_timer = 0;
    if (reset_taps_left <= 0) {
        scrRunStatsReset();
        game_restart();
        exit;
    }
    status_text = "Press " + string(reset_taps_left) + " more times.";
    exit;
}

if (point_in_rectangle(_mx, _my, button_back_x1, button_back_y1, button_back_x2, button_back_y2)) {
    scrAudioPlayButton();
    room_goto(rmMainMenu);
}
