scrInitApiSession();

menu_x = 50;
menu_y = 50;
menu_width = 300;
menu_height = 500;
item_height = 40;
padding = 10;

selected_items = [];
button_start_x = menu_x;
button_start_y = menu_y + menu_height + 20;
button_width = 300;
button_height = 50;
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
    return _val_a - _val_b;
});

var _total_count = array_length(items_array);
if (_total_count > 10) {
    var _trimmed_array = [];
    array_copy(_trimmed_array, 0, items_array, _total_count - 10, 10);
    items_array = _trimmed_array;
}
