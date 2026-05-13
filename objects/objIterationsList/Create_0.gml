selected_items = [];

button_text = "Start";
button_text_waiting = "Loading";

items_array = [];

var _key = ds_map_find_first(global.parents);
while (!is_undefined(_key)) {
    var _data = global.parents[? _key];
    if (is_struct(_data)) {
        array_push(items_array, _data);
    }
    _key = ds_map_find_next(global.parents, _key);
}

array_sort(items_array, function(_a, _b) {
    var _val_a = 0;
    var _val_b = 0;
    if (variable_struct_exists(_a, "iteration")) _val_a = _a.iteration;
    if (variable_struct_exists(_b, "iteration")) _val_b = _b.iteration;
    return _val_b - _val_a;
});

if (array_length(items_array) > 10) {
    array_resize(items_array, 10);
}

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

arc_center_x = -550;
arc_center_y = _gh * 0.5;
arc_radius = 850;
arc_angle_step = 5;
arc_focus_index = 0;
arc_focus_target = 0;
arc_smooth = 0.18;
arc_visible_half = 3;
arc_max_angle = arc_visible_half * arc_angle_step;
namebox_scale_focused = 2.0;
namebox_scale_min = 0.85;

scheme_x = _gw * 0.72;
scheme_y = _gh * 0.45;
scheme_scale = 2.8;
slot_right_off  = [-68, -26];
slot_left_off   = [ 71, -26];
slot_child_off  = [  1,  33];
icon_scale = 5;
icon_native_size = 24;

hover_parent_index = -1;
hover_child = false;
hover_arc_index = -1;

button_w = 354;
button_h = 60;
button_gap = 20;
var _btn_total_w = button_w * 2 + button_gap;
var _btn_left_x = (_gw - _btn_total_w) * 0.5;
var _btn_y = _gh - button_h - 46;

button_back_x1 = _btn_left_x;
button_back_y1 = _btn_y;
button_back_x2 = button_back_x1 + button_w;
button_back_y2 = button_back_y1 + button_h;

button_start_x1 = button_back_x2 + button_gap;
button_start_y1 = _btn_y;
button_start_x2 = button_start_x1 + button_w;
button_start_y2 = button_start_y1 + button_h;
