if (variable_global_exists("game_over") && global.game_over) {
    if (global.scenario_paused) {
        global.scenario_paused = false;
        drag_music_slider = false;
        drag_sfx_slider = false;
    }
    exit;
}

if (keyboard_check_pressed(vk_escape)) {
    global.scenario_paused = !global.scenario_paused;
    drag_music_slider = false;
    drag_sfx_slider = false;
    scrAudioPlayButton();
}

if (!global.scenario_paused) exit;

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

if (mouse_check_button_released(mb_left)) {
    drag_music_slider = false;
    drag_sfx_slider = false;

    if (point_in_rectangle(_mx, _my, button_resume_x1, button_resume_y1, button_resume_x2, button_resume_y2)) {
        scrAudioPlayButton();
        global.scenario_paused = false;
        exit;
    }

    if (point_in_rectangle(_mx, _my, button_exit_x1, button_exit_y1, button_exit_x2, button_exit_y2)) {
        scrAudioPlayButton();
        game_end();
    }
}
