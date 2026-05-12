scrAudioEnsureDefaults();
scrDisplayEnsureDefaults();
if (!instance_exists(objBgScroller)) instance_create_layer(0, 0, "Instances", objBgScroller);

title_text = "SETTINGS";
status_text = "";
reset_taps_left = 3;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _center_x = _gw * 0.5;

slider_width = 420;
slider_height = 26;
slider_gap = 86;
slider_label_offset = 24;

slider_music_x1 = _center_x - (slider_width * 0.5);
slider_music_y1 = _gh * 0.3;
slider_music_x2 = slider_music_x1 + slider_width;
slider_music_y2 = slider_music_y1 + slider_height;

slider_sfx_x1 = slider_music_x1;
slider_sfx_y1 = slider_music_y1 + slider_gap;
slider_sfx_x2 = slider_sfx_x1 + slider_width;
slider_sfx_y2 = slider_sfx_y1 + slider_height;

drag_music_slider = false;
drag_sfx_slider = false;
sfx_preview_last_volume = global.audio_sfx_volume;
sfx_preview_step = 0.05;

reset_taps_timer = 0;
reset_taps_timeout = max(1, ceil(game_get_speed(gamespeed_fps) * 2));

button_mode_w = 520;
button_mode_h = 60;
button_mode_x1 = _center_x - (button_mode_w * 0.5);
button_mode_y1 = slider_sfx_y2 + 40;
button_mode_x2 = button_mode_x1 + button_mode_w;
button_mode_y2 = button_mode_y1 + button_mode_h;

button_tutorial_w = 520;
button_tutorial_h = 60;
button_tutorial_x1 = _center_x - (button_tutorial_w * 0.5);
button_tutorial_y1 = button_mode_y2 + 14;
button_tutorial_x2 = button_tutorial_x1 + button_tutorial_w;
button_tutorial_y2 = button_tutorial_y1 + button_tutorial_h;

button_reset_w = 520;
button_reset_h = 78;
button_reset_x1 = _center_x - (button_reset_w * 0.5);
button_reset_y1 = button_tutorial_y2 + 28;
button_reset_x2 = button_reset_x1 + button_reset_w;
button_reset_y2 = button_reset_y1 + button_reset_h;

button_back_w = 354;
button_back_h = 56;
button_back_x1 = _center_x - (button_back_w * 0.5);
button_back_y1 = button_reset_y2 + 22;
button_back_x2 = button_back_x1 + button_back_w;
button_back_y2 = button_back_y1 + button_back_h;
