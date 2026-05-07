function scrSaveParent(){
    var filename = "parents.json";

    var choices = ds_map_create();
    ds_map_add(choices, "army",      global.choices_done[ARMY_POWER]);
    ds_map_add(choices, "support",   global.choices_done[SUPPORT]);
    ds_map_add(choices, "resources", global.choices_done[RESOURCES]);
    ds_map_add(choices, "science",   global.choices_done[SCIENCE]);
	
	var abs_max = 0;
	var choice_max = 0;
	for (var i = 0; i < 4; i++) {
		if (abs_max < abs(global.choices_done[i])) {
			abs_max = abs(global.choices_done[i]);
			choice_max = i;
		}
	}	

    var entry = ds_map_create();
	ds_map_add(entry, "iteration", global.player_iterations);
	ds_map_add(entry, "ability_id", scrPickAbility(choice_max));
    ds_map_add_map(entry, "choices_done", choices);

    var name_map = noone;
    if (variable_global_exists("player_name") && is_struct(global.player_name)) {
        name_map = ds_map_create();
        ds_map_add(name_map, "first",    string(global.player_name.first));
        ds_map_add(name_map, "last",     string(global.player_name.last));
        ds_map_add(name_map, "nickname", string(global.player_name.nickname));
        ds_map_add_map(entry, "name", name_map);
    }

    var jsonline = json_encode(entry);

    var fh = file_text_open_append(filename);
    file_text_write_string(fh, jsonline + "\n");
    file_text_close(fh);

    ds_map_destroy(choices);
    if (name_map != noone) ds_map_destroy(name_map);
    ds_map_destroy(entry);
}
