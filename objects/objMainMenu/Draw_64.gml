var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

draw_set_font(fntPS2P_stats);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(display_get_gui_width() * 0.5, display_get_gui_height() * 0.3, title_text);

var _start_hover = point_in_rectangle(_mx, _my, button_start_x1, button_start_y1, button_start_x2, button_start_y2);
draw_set_color(_start_hover ? c_lime : c_green);
draw_rectangle(button_start_x1, button_start_y1, button_start_x2, button_start_y2, false);
draw_set_color(c_black);
draw_text((button_start_x1 + button_start_x2) * 0.5, (button_start_y1 + button_start_y2) * 0.5, button_start_text);

var _exit_hover = point_in_rectangle(_mx, _my, button_exit_x1, button_exit_y1, button_exit_x2, button_exit_y2);
draw_set_color(_exit_hover ? c_orange : c_red);
draw_rectangle(button_exit_x1, button_exit_y1, button_exit_x2, button_exit_y2, false);
draw_set_color(c_black);
draw_text((button_exit_x1 + button_exit_x2) * 0.5, (button_exit_y1 + button_exit_y2) * 0.5, button_exit_text);

var _music_value = global.audio_music_volume;
var _sfx_value = global.audio_sfx_volume;

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_text(slider_music_x1, slider_music_y1 - slider_label_offset, "Music: " + string(floor(_music_value * 100)) + "%");
draw_text(slider_sfx_x1, slider_sfx_y1 - slider_label_offset, "Sounds: " + string(floor(_sfx_value * 100)) + "%");

draw_set_color(c_black);
draw_rectangle(slider_music_x1, slider_music_y1, slider_music_x2, slider_music_y2, false);
var _music_fill_x = slider_music_x1 + ((slider_music_x2 - slider_music_x1) * _music_value);
if (_music_fill_x > slider_music_x1 + 2) {
    draw_set_color(c_lime);
    draw_rectangle(slider_music_x1 + 2, slider_music_y1 + 2, _music_fill_x - 2, slider_music_y2 - 2, false);
}
draw_set_color(c_white);
draw_rectangle(slider_music_x1, slider_music_y1, slider_music_x2, slider_music_y2, true);

draw_set_color(c_black);
draw_rectangle(slider_sfx_x1, slider_sfx_y1, slider_sfx_x2, slider_sfx_y2, false);
var _sfx_fill_x = slider_sfx_x1 + ((slider_sfx_x2 - slider_sfx_x1) * _sfx_value);
if (_sfx_fill_x > slider_sfx_x1 + 2) {
    draw_set_color(c_lime);
    draw_rectangle(slider_sfx_x1 + 2, slider_sfx_y1 + 2, _sfx_fill_x - 2, slider_sfx_y2 - 2, false);
}
draw_set_color(c_white);
draw_rectangle(slider_sfx_x1, slider_sfx_y1, slider_sfx_x2, slider_sfx_y2, true);
