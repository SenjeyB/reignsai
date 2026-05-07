var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

draw_set_font(fntPS2P_stats);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(display_get_gui_width() * 0.5, display_get_gui_height() * 0.16, title_text);

var _start_hover = point_in_rectangle(_mx, _my, button_start_x1, button_start_y1, button_start_x2, button_start_y2);
draw_set_color(_start_hover ? make_color_rgb(180, 255, 180) : make_color_rgb(130, 245, 130));
draw_rectangle(button_start_x1, button_start_y1, button_start_x2, button_start_y2, false);
draw_set_color(c_black);
draw_text((button_start_x1 + button_start_x2) * 0.5, (button_start_y1 + button_start_y2) * 0.5, button_start_text);

var _stats_hover = point_in_rectangle(_mx, _my, button_stats_x1, button_stats_y1, button_stats_x2, button_stats_y2);
draw_set_color(_stats_hover ? make_color_rgb(130, 210, 255) : make_color_rgb(90, 185, 240));
draw_rectangle(button_stats_x1, button_stats_y1, button_stats_x2, button_stats_y2, false);
draw_set_color(c_black);
draw_text((button_stats_x1 + button_stats_x2) * 0.5, (button_stats_y1 + button_stats_y2) * 0.5, button_stats_text);

var _settings_hover = point_in_rectangle(_mx, _my, button_settings_x1, button_settings_y1, button_settings_x2, button_settings_y2);
draw_set_color(_settings_hover ? make_color_rgb(235, 235, 235) : make_color_rgb(190, 190, 190));
draw_rectangle(button_settings_x1, button_settings_y1, button_settings_x2, button_settings_y2, false);
draw_set_color(c_black);
draw_text((button_settings_x1 + button_settings_x2) * 0.5, (button_settings_y1 + button_settings_y2) * 0.5, button_settings_text);

var _exit_hover = point_in_rectangle(_mx, _my, button_exit_x1, button_exit_y1, button_exit_x2, button_exit_y2);
draw_set_color(_exit_hover ? c_orange : c_red);
draw_rectangle(button_exit_x1, button_exit_y1, button_exit_x2, button_exit_y2, false);
draw_set_color(c_black);
draw_text((button_exit_x1 + button_exit_x2) * 0.5, (button_exit_y1 + button_exit_y2) * 0.5, button_exit_text);

if (variable_global_exists("api_last_error") && string_length(global.api_last_error) > 0) {
    draw_set_font(fntPS2P_stats);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var _err_x = display_get_gui_width() * 0.5;
    var _err_y = button_exit_y2 + 28;
    draw_set_color(make_color_rgb(20, 0, 0));
    draw_text(_err_x + 1, _err_y + 1, global.api_last_error);
    draw_set_color(make_color_rgb(245, 90, 90));
    draw_text(_err_x, _err_y, global.api_last_error);
}

if (start_transition_active) {
    draw_set_alpha(clamp(start_transition_timer / max(1, start_transition_duration), 0, 1) * 0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}

if (variable_global_exists("menu_reveal_active") && global.menu_reveal_active) {
    var _reveal_t = clamp(global.menu_reveal_timer / max(1, global.menu_reveal_duration), 0, 1);
    draw_set_alpha(1 - _reveal_t);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}
