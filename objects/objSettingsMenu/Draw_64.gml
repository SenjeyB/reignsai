var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

draw_set_font(fntPS2P_stats);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_gw * 0.5, _gh * 0.15, title_text);

var _music_value = global.audio_music_volume;
var _sfx_value = global.audio_sfx_volume;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
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

var _reset_hover = point_in_rectangle(_mx, _my, button_reset_x1, button_reset_y1, button_reset_x2, button_reset_y2);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
scrDrawButton(button_reset_x1, button_reset_y1, button_reset_x2, button_reset_y2, _reset_hover ? make_color_rgb(255, 130, 130) : make_color_rgb(230, 90, 90));
draw_set_color(c_black);
var _reset_cx = (button_reset_x1 + button_reset_x2) * 0.5;
var _reset_cy = (button_reset_y1 + button_reset_y2) * 0.5;
var _reset_line_gap = 22;
draw_text(_reset_cx, _reset_cy - _reset_line_gap, "Reset Stats + Iterations");
draw_text(_reset_cx, _reset_cy + _reset_line_gap, "(" + string(reset_taps_left) + " taps left)");

var _back_hover = point_in_rectangle(_mx, _my, button_back_x1, button_back_y1, button_back_x2, button_back_y2);
scrDrawButton(button_back_x1, button_back_y1, button_back_x2, button_back_y2, _back_hover ? make_color_rgb(185, 220, 255) : make_color_rgb(145, 185, 225));
draw_set_color(c_black);
draw_text((button_back_x1 + button_back_x2) * 0.5, (button_back_y1 + button_back_y2) * 0.5, "Back");

if (string_length(status_text) > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(_gw * 0.5, button_back_y2 + 18, status_text);
}
