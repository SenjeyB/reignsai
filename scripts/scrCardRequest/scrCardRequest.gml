function scrCardRequest(_count) {
    if (global.waiting_http) {
        show_debug_message("HTTP request already in progress");
        return;
    }

    global.waiting_http = true;
    global.cards_ready = 0;
	
	scrGenerateState();

    var base_url = "http://localhost:5000";
    var url = base_url + "/api/v1/cards/random?count=" + string(_count);

    global.last_url = url;
    global.http_retry_count = 0;

    var req_id = http_get(url);
    ds_map_add(global.http_save_targets, string(req_id), "upcoming_events.json");
    global.waiting_req = string(req_id);
}