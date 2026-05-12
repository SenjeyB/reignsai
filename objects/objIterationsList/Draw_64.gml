draw_set_font(fntPS2P_stats);

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _items_count = array_length(items_array);
var required_selected = (_items_count <= 1) ? _items_count : 2;

var _namebox_w = sprite_get_width(sprNameBox);
var _namebox_h = sprite_get_height(sprNameBox);

var _title = "Choose DNA Samples";
if (required_selected > 0) {
    _title += " (" + string(array_length(selected_items)) + "/" + string(required_selected) + ")";
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(20, 20, 20));
draw_text(arc_center_x + arc_radius + 1, _gh * 0.10 + 1, _title);
draw_set_color(c_white);
draw_text(arc_center_x + arc_radius, _gh * 0.10, _title);

if (_items_count == 0) {
    var _ix = arc_center_x + arc_radius;
    var _iy = arc_center_y;
    var _scale = namebox_scale_focused;
    draw_sprite_ext(sprNameBox, 0, _ix, _iy, _scale, _scale, 0, c_white, 1);

    var _label = "No DNA samples found";
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _text_scale = _scale * 0.55;
    var _label_w = string_width(_label);
    var _max_text_w = _namebox_w * _scale * 0.86;
    if (_label_w * _text_scale > _max_text_w && _label_w > 0) {
        _text_scale = _max_text_w / _label_w;
    }
    draw_set_color(c_black);
    draw_text_transformed(_ix + 1, _iy + 1, _label, _text_scale, _text_scale, 0);
    draw_set_color(c_white);
    draw_text_transformed(_ix, _iy, _label, _text_scale, _text_scale, 0);
}

for (var i = 0; i < _items_count; i++) {
    var _delta = i - arc_focus_index;
    var _abs_delta = abs(_delta);
    if (_abs_delta > arc_visible_half + 0.5) continue;
    var _angle = _delta * arc_angle_step;
    var _ix = arc_center_x + lengthdir_x(arc_radius, _angle);
    var _iy = arc_center_y + lengthdir_y(arc_radius, _angle);
    var _t = 1 - clamp(_abs_delta / arc_visible_half, 0, 1);
    var _alpha = power(_t, 1.4);
    var _scale = lerp(namebox_scale_min, namebox_scale_focused, _t);

    var _item = items_array[i];
    var _is_selected = false;
    for (var j = 0; j < array_length(selected_items); j++) {
        if (selected_items[j] == _item) { _is_selected = true; break; }
    }

    var _draw_scale = _scale * (_is_selected ? 1.08 : 1.0);
    var _tint = _is_selected ? make_color_rgb(150, 255, 90) : c_white;
    draw_sprite_ext(sprNameBox, 0, _ix, _iy, _draw_scale, _draw_scale, 0, _tint, _alpha);

    var _label = scrNamesParentLabel(_item);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(_alpha);

    var _text_scale = _draw_scale * 0.55;
    var _label_w = string_width(_label);
    var _max_text_w = _namebox_w * _draw_scale * 0.86;
    if (_label_w * _text_scale > _max_text_w && _label_w > 0) {
        _text_scale = _max_text_w / _label_w;
    }
    draw_set_color(c_black);
    draw_text_transformed(_ix + 1, _iy + 1, _label, _text_scale, _text_scale, 0);
    draw_set_color(c_white);
    draw_text_transformed(_ix, _iy, _label, _text_scale, _text_scale, 0);
}
draw_set_alpha(1);

draw_sprite_ext(sprScheme, 0, scheme_x, scheme_y, scheme_scale, scheme_scale, 0, c_white, 1);

var _scheme_icon_size = icon_native_size * icon_scale;
var _slot_first_x  = scheme_x + slot_right_off[0] * scheme_scale;
var _slot_first_y  = scheme_y + slot_right_off[1] * scheme_scale;
var _slot_second_x = scheme_x + slot_left_off[0]  * scheme_scale;
var _slot_second_y = scheme_y + slot_left_off[1]  * scheme_scale;
var _slot_child_x  = scheme_x + slot_child_off[0] * scheme_scale;
var _slot_child_y  = scheme_y + slot_child_off[1] * scheme_scale;

var _spr1 = -1;
var _spr2 = -1;

if (array_length(selected_items) >= 1) {
    var _p1 = selected_items[0];
    if (variable_struct_exists(_p1, "ability_id") && _p1.ability_id >= 0 && _p1.ability_id < array_length(global.ability_sprite)) {
        _spr1 = global.ability_sprite[_p1.ability_id];
    }
    if (sprite_exists(_spr1)) {
        var _prev_filter = gpu_get_tex_filter();
        gpu_set_tex_filter(false);
        draw_sprite_ext(_spr1, 0, _slot_first_x, _slot_first_y, icon_scale, icon_scale, 0, c_white, 1);
        gpu_set_tex_filter(_prev_filter);
    }
}
if (array_length(selected_items) >= 2) {
    var _p2 = selected_items[1];
    if (variable_struct_exists(_p2, "ability_id") && _p2.ability_id >= 0 && _p2.ability_id < array_length(global.ability_sprite)) {
        _spr2 = global.ability_sprite[_p2.ability_id];
    }
    if (sprite_exists(_spr2)) {
        var _prev_filter = gpu_get_tex_filter();
        gpu_set_tex_filter(false);
        draw_sprite_ext(_spr2, 0, _slot_second_x, _slot_second_y, icon_scale, icon_scale, 0, c_white, 1);
        gpu_set_tex_filter(_prev_filter);
    }

    if (sprite_exists(_spr1) && sprite_exists(_spr2)) {
        scrDrawCrossedAbility(_slot_child_x, _slot_child_y, _spr1, _spr2, _scheme_icon_size);
    }
}

var _tooltip_parent = undefined;
if (hover_parent_index != -1 && hover_parent_index < array_length(selected_items)) {
    _tooltip_parent = selected_items[hover_parent_index];
} else if (hover_arc_index != -1 && hover_arc_index < array_length(items_array)) {
    _tooltip_parent = items_array[hover_arc_index];
}

if (_tooltip_parent != undefined) {
    var _p = _tooltip_parent;
    var _name_str = scrNamesParentLabel(_p);
    var _ab_id = variable_struct_exists(_p, "ability_id") ? _p.ability_id : -1;
    var _ab_name = (_ab_id >= 0 && _ab_id < array_length(global.ability_name)) ? global.ability_name[_ab_id] : "Unknown";
    var _cd = variable_struct_exists(_p, "choices_done") ? _p.choices_done : undefined;
    var _coffers = (is_struct(_cd) && variable_struct_exists(_cd, "resources")) ? _cd.resources : 0;
    var _support = (is_struct(_cd) && variable_struct_exists(_cd, "support"))   ? _cd.support   : 0;
    var _militia = (is_struct(_cd) && variable_struct_exists(_cd, "army"))      ? _cd.army      : 0;
    var _science = (is_struct(_cd) && variable_struct_exists(_cd, "science"))   ? _cd.science   : 0;

    var _lines = [
        _name_str,
        "[" + string(_ab_name) + "]",
        "Coffers: " + string(_coffers),
        "Support: " + string(_support),
        "Militia: " + string(_militia),
        "Science: " + string(_science)
    ];

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _line_h = 22;
    var _max_w = 0;
    for (var k = 0; k < array_length(_lines); k++) {
        var _w = string_width(_lines[k]);
        if (_w > _max_w) _max_w = _w;
    }
    var _pad = 12;
    var _tw = _max_w + _pad * 2;
    var _th = array_length(_lines) * _line_h + _pad * 2;
    var _tx = _mx + 18;
    var _ty = _my + 12;
    if (_tx + _tw > _gw) _tx = _gw - _tw - 4;
    if (_ty + _th > _gh) _ty = _gh - _th - 4;

    draw_set_alpha(0.92);
    draw_set_color(c_black);
    draw_roundrect(_tx, _ty, _tx + _tw, _ty + _th, false);
    draw_set_alpha(1);

    draw_set_color(c_white);
    for (var m = 0; m < array_length(_lines); m++) {
        draw_text(_tx + _pad, _ty + _pad + m * _line_h, _lines[m]);
    }
}

if (hover_child) {
    var _label = "New Ruler";
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var _pad2 = 12;
    var _tw2 = string_width(_label) + _pad2 * 2;
    var _th2 = 22 + _pad2 * 2;
    var _tx2 = _mx + 18;
    var _ty2 = _my + 12;
    if (_tx2 + _tw2 > _gw) _tx2 = _gw - _tw2 - 4;

    draw_set_alpha(0.92);
    draw_set_color(c_black);
    draw_roundrect(_tx2, _ty2, _tx2 + _tw2, _ty2 + _th2, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_text(_tx2 + _pad2, _ty2 + _pad2, _label);
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

var _can_start = (array_length(selected_items) == required_selected);
var _ready = (variable_global_exists("cards_ready") && global.cards_ready == 1);
var _btn_hover = point_in_rectangle(_mx, _my, button_start_x1, button_start_y1, button_start_x2, button_start_y2);

var _btn_color;
var _btn_label;
if (_can_start && _ready) {
    _btn_color = _btn_hover ? make_color_rgb(180, 255, 180) : make_color_rgb(130, 245, 130);
    _btn_label = button_text;
} else if (_can_start) {
    _btn_color = make_color_rgb(150, 150, 150);
    _btn_label = button_text_waiting;
} else {
    _btn_color = make_color_rgb(120, 120, 120);
    _btn_label = button_text;
}

scrDrawButton(button_start_x1, button_start_y1, button_start_x2, button_start_y2, _btn_color);
draw_set_color(c_white);
draw_text((button_start_x1 + button_start_x2) * 0.5, (button_start_y1 + button_start_y2) * 0.5, _btn_label);

var _back_hover = point_in_rectangle(_mx, _my, button_back_x1, button_back_y1, button_back_x2, button_back_y2);
scrDrawButton(button_back_x1, button_back_y1, button_back_x2, button_back_y2, _back_hover ? make_color_rgb(185, 220, 255) : make_color_rgb(145, 185, 225));
draw_set_color(c_white);
draw_text((button_back_x1 + button_back_x2) * 0.5, (button_back_y1 + button_back_y2) * 0.5, "Back");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
