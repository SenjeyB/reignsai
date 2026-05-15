depth = -10000;

global.scenario_paused = false;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _center_x = _gw * 0.5;

title_y = _gh * 0.28;

slider_width = 420;
slider_height = 26;
slider_label_offset = 24;

slider_music_x1 = _center_x - slider_width * 0.5;
slider_music_y1 = title_y + 56;
slider_music_x2 = slider_music_x1 + slider_width;
slider_music_y2 = slider_music_y1 + slider_height;

slider_sfx_x1 = slider_music_x1;
slider_sfx_y1 = slider_music_y1 + 78;
slider_sfx_x2 = slider_sfx_x1 + slider_width;
slider_sfx_y2 = slider_sfx_y1 + slider_height;

button_w = 280;
button_h = 56;
button_gap = 18;

button_resume_x1 = _center_x - button_w * 0.5;
button_resume_y1 = slider_sfx_y2 + 64;
button_resume_x2 = button_resume_x1 + button_w;
button_resume_y2 = button_resume_y1 + button_h;

button_exit_x1 = button_resume_x1;
button_exit_y1 = button_resume_y2 + button_gap;
button_exit_x2 = button_exit_x1 + button_w;
button_exit_y2 = button_exit_y1 + button_h;

drag_music_slider = false;
drag_sfx_slider = false;
sfx_preview_last_volume = global.audio_sfx_volume;
sfx_preview_step = 0.05;
