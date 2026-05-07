var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var required_selected = (array_length(items_array) <= 1) ? array_length(items_array) : 2;

if (mouse_check_button_released(mb_left)) {
    if (point_in_rectangle(_mx, _my, menu_x, menu_y, menu_x + menu_width, menu_y + menu_height)) {
        var _relative_y = _my - menu_y;
        var _index = floor(_relative_y / item_height);

        if (_index >= 0 && _index < array_length(items_array)) {
            var _item = items_array[_index];

            var _already_selected_index = -1;
            for (var i = 0; i < array_length(selected_items); i++) {
                if (selected_items[i] == _item) {
                    _already_selected_index = i;
                    break;
                }
            }

            if (_already_selected_index != -1) {
                array_delete(selected_items, _already_selected_index, 1);
            } else {
                if (array_length(selected_items) < required_selected) {
                    array_push(selected_items, _item);
                }
            }
        }
    }

    if (array_length(selected_items) == required_selected && global.cards_ready == 1) {
        if (point_in_rectangle(_mx, _my, button_start_x, button_start_y, button_start_x + button_width, button_start_y + button_height)) {
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
