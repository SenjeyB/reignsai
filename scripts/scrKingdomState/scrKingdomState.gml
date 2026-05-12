function scrKingdomLoad() {
    var filename = "kingdom.json";
    if (!file_exists(filename)) return undefined;
    var fh = file_text_open_read(filename);
    var content = "";
    while (!file_text_eof(fh)) {
        content += file_text_readln(fh);
    }
    file_text_close(fh);
    if (string_length(string_trim(content)) <= 0) return undefined;
    var data = json_parse(content);
    if (!is_struct(data)) return undefined;
    return data;
}

function scrKingdomSave(_end_month_idx, _end_turns) {
    var entry = ds_map_create();
    ds_map_add(entry, "last_end_month_index", real(_end_month_idx));
    ds_map_add(entry, "last_end_turns", real(_end_turns));
    var jsonstr = json_encode(entry);
    ds_map_destroy(entry);
    if (file_exists("kingdom.json")) file_delete("kingdom.json");
    var fh = file_text_open_write("kingdom.json");
    file_text_write_string(fh, jsonstr);
    file_text_close(fh);
}

function scrKingdomClear() {
    if (file_exists("kingdom.json")) file_delete("kingdom.json");
}
