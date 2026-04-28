if (global.http_retry_count <= global.http_retry_max) {
    var url = global.last_url;
    var payload = global.last_payload;
    var fname = global._retry_filename;
    var headers = ds_map_create();
    headers[? "Content-Type"] = "application/json";
    var new_req = http_request(url, "POST", headers, payload);
    ds_map_destroy(headers);
    ds_map_add(global.http_save_targets, string(new_req), fname);
    global.waiting_req = string(new_req);
}
