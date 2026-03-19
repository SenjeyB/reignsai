draw_set_font(fntPS2P_stats);
draw_set_color(c_dkgray);
draw_rectangle(menu_x, menu_y, menu_x + menu_width, menu_y + menu_height, false);
draw_set_color(c_white);
draw_rectangle(menu_x, menu_y, menu_x + menu_width, menu_y + menu_height, true);

var _hovered_data = undefined;
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

gpu_set_scissor(menu_x, menu_y, menu_width, menu_height);

draw_set_valign(fa_middle);
draw_set_halign(fa_left);

var _len = array_length(items_array);

for (var i = 0; i < _len; i++) {
    var _iy = menu_y + (i * item_height);
    var _ix = menu_x;

    if (_iy + item_height < menu_y || _iy > menu_y + menu_height) continue;

    var _item = items_array[i];

    var _is_selected = false;
    for (var j = 0; j < array_length(selected_items); j++) {
        if (selected_items[j] == _item) {
            _is_selected = true;
            break;
        }
    }

    var _iteration_val = 0;
    if (variable_struct_exists(_item, "iteration")) _iteration_val = _item.iteration;

    var _name = "Iteration #" + string(_iteration_val);

    var _is_hover = point_in_rectangle(_mx, _my, _ix, _iy, _ix + menu_width, _iy + item_height);

    if (_is_hover && _my >= menu_y && _my <= menu_y + menu_height) {
        draw_set_color(c_gray);
        draw_rectangle(_ix, _iy, _ix + menu_width, _iy + item_height, false);
        _hovered_data = _item;
    } else if (_is_selected) {
        draw_set_color(c_yellow);
        draw_rectangle(_ix, _iy, _ix + menu_width, _iy + item_height, false);
    }

    draw_set_color(c_white);
    draw_text(_ix + padding, _iy + item_height / 2, _name);
    draw_line(_ix, _iy + item_height, _ix + menu_width, _iy + item_height);
}

gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());

var _display_x = menu_x + menu_width + 50;
var _display_y = menu_y;

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

var required_selected = (array_length(items_array) <= 1) ? array_length(items_array) : 2;

draw_text(_display_x, _display_y, "Picked iterations: " + string(array_length(selected_items)) + " (max. " + string(required_selected) + ")");

for (var k = 0; k < array_length(selected_items); k++) {
    var _struct = selected_items[k];
    var _iter_num = 0;
    if (variable_struct_exists(_struct, "iteration")) _iter_num = _struct.iteration;

    var _draw_text = string(k + 1) + ". Iteration #" + string(_iter_num);

    var _sy = _display_y + 30 + (k * 25);
    draw_text(_display_x, _sy, _draw_text);
}

if (array_length(selected_items) == required_selected && global.cards_ready == 1) {
    var _button_hover = point_in_rectangle(_mx, _my, button_start_x, button_start_y, button_start_x + button_width, button_start_y + button_height);

    draw_set_color(_button_hover ? c_green : c_lime);
    draw_rectangle(button_start_x, button_start_y, button_start_x + button_width, button_start_y + button_height, false);

    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(button_start_x + button_width / 2, button_start_y + button_height / 2, button_text);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
} else if (array_length(selected_items) == required_selected) {
    draw_set_color(c_gray);
    draw_rectangle(button_start_x, button_start_y, button_start_x + button_width, button_start_y + button_height, false);

    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(button_start_x + button_width / 2, button_start_y + button_height / 2, button_text_waiting);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
} else {
    draw_set_color(c_gray);
    draw_rectangle(button_start_x, button_start_y, button_start_x + button_width, button_start_y + button_height, false);

    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(button_start_x + button_width / 2, button_start_y + button_height / 2, button_text);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

if (!is_undefined(_hovered_data)) {
    var _info_struct = undefined;
	var _ability_id = -1;
    if (variable_struct_exists(_hovered_data, "choices_done")) _info_struct = _hovered_data.choices_done;
	if (variable_struct_exists(_hovered_data, "ability_id")) _ability_id = _hovered_data.ability_id;

    if (is_struct(_info_struct)) {
        var _tooltip_str = "Stats:\n";
		
		if (_ability_id != -1) _tooltip_str += "Ability: " + global.ability_name[_ability_id] + "\n";
		if (variable_struct_exists(_info_struct, "resources")) _tooltip_str += "Resources: " + string(_info_struct.resources) + "\n";
        if (variable_struct_exists(_info_struct, "support")) _tooltip_str += "Support: " + string(_info_struct.support) + "\n";
        if (variable_struct_exists(_info_struct, "army")) _tooltip_str += "Militia: " + string(_info_struct.army) + "\n";
        if (variable_struct_exists(_info_struct, "science")) _tooltip_str += "Science: " + string(_info_struct.science);

        var _tw = string_width(_tooltip_str) + 20;
        var _th = string_height(_tooltip_str) + 20;
        var _tx = device_mouse_x_to_gui(0) + 15;
        var _ty = device_mouse_y_to_gui(0);

        draw_set_color(c_black);
        draw_rectangle(_tx, _ty, _tx + _tw, _ty + _th, false);
        draw_set_color(c_white);
        draw_rectangle(_tx, _ty, _tx + _tw, _ty + _th, true);

        draw_set_valign(fa_top);
        draw_text(_tx + 10, _ty + 10, _tooltip_str);
    }
}