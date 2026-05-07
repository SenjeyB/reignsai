var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (!variable_global_exists("run_stats") || !is_struct(global.run_stats)) {
    scrRunStatsLoad();
}

var _runs = global.run_stats.total_runs;
var _best = global.run_stats.best_turns;
var _avg = scrRunStatsAverageTurns();
var _avg_text = string_format(_avg, 0, 1);
var _ability = scrRunStatsMostInheritedAbilityLabel();

draw_set_font(fntPS2P_stats);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_gw * 0.5, _gh * 0.14, title_text);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
var _x = _gw * 0.18;
var _y = _gh * 0.24;
var _line_h = 38;

draw_text(_x, _y, "Total iterations: " + string(_runs));
_y += _line_h;
draw_text(_x, _y, "Best reign: " + string(_best) + " months");
_y += _line_h;
draw_text(_x, _y, "Average reign: " + _avg_text + " months");
_y += _line_h;
draw_text(_x, _y, "Cumulative stat shift:");
_y += _line_h;
draw_text(_x + 28, _y, "Coffers: " + string(global.run_stats.sum_resources));
_y += _line_h;
draw_text(_x + 28, _y, "Support: " + string(global.run_stats.sum_support));
_y += _line_h;
draw_text(_x + 28, _y, "Militia: " + string(global.run_stats.sum_army));
_y += _line_h;
draw_text(_x + 28, _y, "Science: " + string(global.run_stats.sum_science));
_y += _line_h + 12;
draw_text(_x, _y, "Most inherited ability: " + _ability);

var _back_hover = point_in_rectangle(_mx, _my, button_back_x1, button_back_y1, button_back_x2, button_back_y2);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(_back_hover ? make_color_rgb(185, 220, 255) : make_color_rgb(145, 185, 225));
draw_rectangle(button_back_x1, button_back_y1, button_back_x2, button_back_y2, false);
draw_set_color(c_black);
draw_text((button_back_x1 + button_back_x2) * 0.5, (button_back_y1 + button_back_y2) * 0.5, "Back");
