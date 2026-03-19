if (global.http_retry_count <= global.http_retry_max) {
    var url = global.last_url;
    var fname = global._retry_filename;
    var new_req = http_get(url);
    ds_map_add(global.http_save_targets, string(new_req), fname);
    global.waiting_req = string(new_req);
}