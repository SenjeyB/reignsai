var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _items_count = array_length(items_array);
var required_selected = (_items_count <= 1) ? _items_count : 2;

if (_items_count > 0) {
    if (mouse_wheel_up() || keyboard_check_pressed(vk_up)) {
        arc_focus_target = max(0, arc_focus_target - 1);
    }
    if (mouse_wheel_down() || keyboard_check_pressed(vk_down)) {
        arc_focus_target = min(_items_count - 1, arc_focus_target + 1);
    }
    arc_focus_target = clamp(arc_focus_target, 0, max(0, _items_count - 1));
    arc_focus_index = lerp(arc_focus_index, arc_focus_target, arc_smooth);
}

hover_parent_index = -1;
hover_child = false;
hover_arc_index = -1;

var _icon_native = icon_native_size;
var _scheme_icon_size = _icon_native * icon_scale;
var _slot_first_x  = scheme_x + slot_right_off[0] * scheme_scale;
var _slot_first_y  = scheme_y + slot_right_off[1] * scheme_scale;
var _slot_second_x = scheme_x + slot_left_off[0]  * scheme_scale;
var _slot_second_y = scheme_y + slot_left_off[1]  * scheme_scale;
var _slot_child_x  = scheme_x + slot_child_off[0] * scheme_scale;
var _slot_child_y  = scheme_y + slot_child_off[1] * scheme_scale;
var _slot_half = _scheme_icon_size * 0.5;

if (array_length(selected_items) >= 1) {
    if (point_in_rectangle(_mx, _my,
        _slot_first_x - _slot_half, _slot_first_y - _slot_half,
        _slot_first_x + _slot_half, _slot_first_y + _slot_half)) {
        hover_parent_index = 0;
    }
}
if (array_length(selected_items) >= 2) {
    if (point_in_rectangle(_mx, _my,
        _slot_second_x - _slot_half, _slot_second_y - _slot_half,
        _slot_second_x + _slot_half, _slot_second_y + _slot_half)) {
        hover_parent_index = 1;
    }
    if (point_in_rectangle(_mx, _my,
        _slot_child_x - _slot_half, _slot_child_y - _slot_half,
        _slot_child_x + _slot_half, _slot_child_y + _slot_half)) {
        hover_child = true;
    }
}

var _namebox_w = sprite_get_width(sprNameBox);
var _namebox_h = sprite_get_height(sprNameBox);

for (var i = 0; i < _items_count; i++) {
    var _delta = i - arc_focus_index;
    var _abs_delta = abs(_delta);
    if (_abs_delta > arc_visible_half + 0.5) continue;
    var _angle = _delta * arc_angle_step;
    var _ix = arc_center_x + lengthdir_x(arc_radius, _angle);
    var _iy = arc_center_y + lengthdir_y(arc_radius, _angle);
    var _t = 1 - clamp(_abs_delta / arc_visible_half, 0, 1);
    var _scale = lerp(namebox_scale_min, namebox_scale_focused, _t);
    var _half_w = _namebox_w * _scale * 0.5;
    var _half_h = _namebox_h * _scale * 0.5;
    if (point_in_rectangle(_mx, _my, _ix - _half_w, _iy - _half_h, _ix + _half_w, _iy + _half_h)) {
        hover_arc_index = i;
    }
}

if (mouse_check_button_released(mb_left)) {
    if (hover_arc_index != -1) {
        if (abs(hover_arc_index - arc_focus_index) > 0.4) {
            arc_focus_target = hover_arc_index;
        } else {
            var _item = items_array[hover_arc_index];
            var _already = -1;
            for (var j = 0; j < array_length(selected_items); j++) {
                if (selected_items[j] == _item) {
                    _already = j;
                    break;
                }
            }
            if (_already != -1) {
                array_delete(selected_items, _already, 1);
            } else if (required_selected > 0) {
                if (array_length(selected_items) >= required_selected) {
                    array_delete(selected_items, 0, 1);
                }
                array_push(selected_items, _item);
            }
        }
    }

    if (point_in_rectangle(_mx, _my, button_back_x1, button_back_y1, button_back_x2, button_back_y2)) {
        scrAudioPlayButton();
        room_goto(rmMainMenu);
        exit;
    }

    if (array_length(selected_items) == required_selected && global.cards_ready == 1) {
        if (point_in_rectangle(_mx, _my, button_start_x1, button_start_y1, button_start_x2, button_start_y2)) {
            scrAudioPlayButton();
            if (required_selected == 2) {
                global.multipliers = scrMultCalc(selected_items[0], selected_items[1]);
                global.current_abilities[0] = selected_items[0].ability_id;
                global.current_abilities[1] = selected_items[1].ability_id;
                global.selected_parents = [selected_items[0], selected_items[1]];
            } else if (required_selected == 1) {
                global.multipliers = scrMultCalc(selected_items[0], selected_items[0]);
                global.current_abilities[0] = selected_items[0].ability_id;
                global.current_abilities[1] = -1;
                global.selected_parents = [selected_items[0]];
            } else {
                global.multipliers = [1, 1, 1, 1];
                global.current_abilities[0] = -1;
                global.current_abilities[1] = -1;
                global.selected_parents = [];
            }
            room_goto(rmScenario);
        }
    }
}
