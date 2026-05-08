var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

draw_set_font(fntPS2P_stats);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_gw * 0.5, _gh * 0.12, title_text);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _x = _gw * 0.12;
var _y = _gh * 0.22;
var _line_h = 36;

draw_set_color(c_white);
for (var i = 0; i < array_length(body_lines); i++) {
    draw_text(_x, _y, body_lines[i]);
    _y += _line_h;
}

_y += _line_h * 0.6;
draw_set_color(make_color_rgb(170, 200, 255));
for (var j = 0; j < array_length(lore_lines); j++) {
    draw_text(_x, _y, lore_lines[j]);
    _y += _line_h;
}

var _back_hover = point_in_rectangle(_mx, _my, button_back_x1, button_back_y1, button_back_x2, button_back_y2);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
scrDrawButton(button_back_x1, button_back_y1, button_back_x2, button_back_y2, _back_hover ? make_color_rgb(185, 220, 255) : make_color_rgb(145, 185, 225));
draw_set_color(c_black);
draw_text((button_back_x1 + button_back_x2) * 0.5, (button_back_y1 + button_back_y2) * 0.5, "Back");
