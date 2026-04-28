function scrCardRequest(_count) {
    if (global.waiting_http) {
        show_debug_message("HTTP request already in progress");
        return;
    }

    global.waiting_http = true;
    global.cards_ready = 0;
	
	scrGenerateState();

    var base_url = "http://localhost:5000";
    var url = base_url + "/api/v1/cards/generate";

    var _resources = 50;
    var _support = 50;
    var _army = 50;
    var _science = 50;
    if (variable_global_exists("stat") && is_array(global.stat) && array_length(global.stat) >= 4) {
        _resources = global.stat[RESOURCES];
        _support = global.stat[SUPPORT];
        _army = global.stat[ARMY_POWER];
        _science = global.stat[SCIENCE];
    }

    var _payload = ds_map_create();
    _payload[? "count"] = _count;
    if (variable_global_exists("api_session_id") && string_length(global.api_session_id) > 0) {
        _payload[? "session_id"] = global.api_session_id;
    }
    var _attrs = ds_map_create();
    _attrs[? "science"] = _science;
    _attrs[? "army"] = _army;
    _attrs[? "support"] = _support;
    _attrs[? "resources"] = _resources;
    ds_map_add_map(_payload, "attributes", _attrs);

    var _in_war = 0;
    if (variable_global_exists("status") && is_array(global.status) && array_length(global.status) > IN_WAR) {
        _in_war = global.status[IN_WAR];
    }

    var _statuses = ds_list_create();
    if (_in_war > 0) ds_list_add(_statuses, "in_war");
    ds_map_add_list(_payload, "statuses", _statuses);

    var _status_values = ds_map_create();
    _status_values[? "in_war"] = _in_war;
    ds_map_add_map(_payload, "status_values", _status_values);

    var _payload_json = json_encode(_payload);
    ds_map_destroy(_payload);

    global.last_url = url;
    global.last_payload = _payload_json;
    global.http_retry_count = 0;

    var _headers = ds_map_create();
    _headers[? "Content-Type"] = "application/json";
    var req_id = http_request(url, "POST", _headers, _payload_json);
    ds_map_destroy(_headers);
    ds_map_add(global.http_save_targets, string(req_id), "upcoming_events.json");
    global.waiting_req = string(req_id);
}


function scrInitApiSession() {
    if (variable_global_exists("api_session_init_pending") && global.api_session_init_pending) return;
    if (!variable_global_exists("http_save_targets")) {
        global.http_save_targets = ds_map_create();
    }

    var base_url = "http://localhost:5000";
    var url = base_url + "/api/v1/session/init";

    var headers = ds_map_create();
    headers[? "Content-Type"] = "application/json";
    var req_id = http_request(url, "POST", headers, "{}");
    ds_map_destroy(headers);

    global.api_session_id = "";
    global.api_session_init_pending = true;
    global.api_session_init_req = string(req_id);
    ds_map_add(global.http_save_targets, string(req_id), "__session_init__");
}
