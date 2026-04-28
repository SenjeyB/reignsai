function _safe(v, def) {
    return is_undefined(v) ? def : v;
}

function _struct_get_safe(st, key, def) {
    if (!is_struct(st)) return def;
    if (!variable_struct_exists(st, key)) return def;
    return struct_get(st, key);
}

function scrParseJson(_file) {
	// Check if file exists first
	if (!file_exists(_file)) {
	    show_debug_message("scrParseJson: File not found: " + _file);
	    return [];
	}

	var file = file_text_open_read(_file);
	if (file == -1) {
	    show_debug_message("scrParseJson: Cannot open file: " + _file);
	    return [];
	}

	var content = "";

	while (!file_text_eof(file)) {
	    content += file_text_readln(file);
	    //file_text_readln(file);
		content += "\n";
	}
	
	if (string_length(content) > 0 && ord(string_char_at(content, 1)) == 65279) {
        content = string_delete(content, 1, 1);
    }

	file_text_close(file);
	
	var root = json_parse(content);

	if (!is_struct(root) || !variable_struct_exists(root, "data")) {
	    show_debug_message("Invalid JSON structure: no data");
	    return [];
	}

	var data_block = root.data;

	if (!is_struct(data_block) || !variable_struct_exists(data_block, "cards")) {
	    show_debug_message("Invalid JSON structure: no cards");
	    return [];
	}

	var cards = data_block.cards;

	if (!is_array(cards)) {
	    cards = [cards];
	}
	
	var n = array_length(cards);
	var result = [];
	for (var i = 0; i < n; i++) {
	    var item = cards[i];
	    var rec = {};
	    rec.situation  = _struct_get_safe(item, "situation", "");
	    var opt1 = _struct_get_safe(item, "option_1", {});
	    var opt2 = _struct_get_safe(item, "option_2", {});
	    rec.desc_opt1 = _struct_get_safe(opt1, "description", "");
	    rec.desc_opt2 = _struct_get_safe(opt2, "description", "");

	    rec.stats_opt1 = [];
	    rec.stats_opt1[ARMY_POWER] = _struct_get_safe(opt1, "army", 0);
	    rec.stats_opt1[SUPPORT]     = _struct_get_safe(opt1, "support", 0);
	    rec.stats_opt1[RESOURCES]     = _struct_get_safe(opt1, "resources", 0);
	    rec.stats_opt1[SCIENCE]     = _struct_get_safe(opt1, "science", 0);

	    rec.stats_opt2 = [];
	    rec.stats_opt2[ARMY_POWER] = _struct_get_safe(opt2, "army", 0);
	    rec.stats_opt2[SUPPORT]     = _struct_get_safe(opt2, "support", 0);
	    rec.stats_opt2[RESOURCES]     = _struct_get_safe(opt2, "resources", 0);
	    rec.stats_opt2[SCIENCE]     = _struct_get_safe(opt2, "science", 0);

	    result[i] = rec;
	}
	// Only delete temporary files, not bundled files
	if (_file != "events.json" && _file != "game_over.json") {
	    file_delete(_file);
	}
	return result;
}
