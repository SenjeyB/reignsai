function scrGenerateState() {
    var save_map = ds_map_create();

    for (var i = 0; i < array_length(global.stat); i++) {
        var stat_name = global.stat_name[i];
        save_map[? stat_name] = global.stat[i];
    }

    var status_list = ds_list_create();

    for (var i = 0; i < array_length(global.status); i++) {
        if (global.status[i] > 0) {
            ds_list_add(status_list, global.status_name[i]);
        }
    }

    save_map[? "statuses"] = status_list;
	
    var json = json_encode(save_map);
    var file = file_text_open_write("game_state.json");
    file_text_write_string(file, json);
	
    file_text_close(file);
    ds_map_destroy(save_map);
    ds_list_destroy(status_list);
}