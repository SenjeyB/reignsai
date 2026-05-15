if (!global.scenario_paused) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

draw_set_alpha(0.65);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

draw_set_font(fntPS2P_stats);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_gw * 0.5, title_y, "PAUSED");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(slider_music_x1, slider_music_y1 - slider_label_offset, "Music: " + string(floor(global.audio_music_volume * 100)) + "%");
draw_text(slider_sfx_x1, slider_sfx_y1 - slider_label_offset, "Sounds: " + string(floor(global.audio_sfx_volume * 100)) + "%");

draw_set_color(c_black);
draw_rectangle(slider_music_x1, slider_music_y1, slider_music_x2, slider_music_y2, false);
var _music_fill_x = slider_music_x1 + ((slider_music_x2 - slider_music_x1) * global.audio_music_volume);
if (_music_fill_x > slider_music_x1 + 2) {
    draw_set_color(c_lime);
    draw_rectangle(slider_music_x1 + 2, slider_music_y1 + 2, _music_fill_x - 2, slider_music_y2 - 2, false);
}
draw_set_color(c_white);
draw_rectangle(slider_music_x1, slider_music_y1, slider_music_x2, slider_music_y2, true);

draw_set_color(c_black);
draw_rectangle(slider_sfx_x1, slider_sfx_y1, slider_sfx_x2, slider_sfx_y2, false);
var _sfx_fill_x = slider_sfx_x1 + ((slider_sfx_x2 - slider_sfx_x1) * global.audio_sfx_volume);
if (_sfx_fill_x > slider_sfx_x1 + 2) {
    draw_set_color(c_lime);
    draw_rectangle(slider_sfx_x1 + 2, slider_sfx_y1 + 2, _sfx_fill_x - 2, slider_sfx_y2 - 2, false);
}
draw_set_color(c_white);
draw_rectangle(slider_sfx_x1, slider_sfx_y1, slider_sfx_x2, slider_sfx_y2, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _resume_hover = point_in_rectangle(_mx, _my, button_resume_x1, button_resume_y1, button_resume_x2, button_resume_y2);
scrDrawButton(button_resume_x1, button_resume_y1, button_resume_x2, button_resume_y2, _resume_hover ? make_color_rgb(180, 255, 180) : make_color_rgb(130, 245, 130));
draw_set_color(c_white);
draw_text((button_resume_x1 + button_resume_x2) * 0.5, (button_resume_y1 + button_resume_y2) * 0.5, "Resume");

var _exit_hover = point_in_rectangle(_mx, _my, button_exit_x1, button_exit_y1, button_exit_x2, button_exit_y2);
scrDrawButton(button_exit_x1, button_exit_y1, button_exit_x2, button_exit_y2, _exit_hover ? c_orange : c_red);
draw_set_color(c_white);
draw_text((button_exit_x1 + button_exit_x2) * 0.5, (button_exit_y1 + button_exit_y2) * 0.5, "Exit");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
