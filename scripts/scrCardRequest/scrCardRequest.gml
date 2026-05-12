function scrCardsEnsureState() {
    if (!variable_global_exists("http_save_targets")) global.http_save_targets = ds_map_create();
    if (!variable_global_exists("waiting_http")) global.waiting_http = false;
    if (!variable_global_exists("waiting_req")) global.waiting_req = "";
    if (!variable_global_exists("cards_queue")) global.cards_queue = [];
    if (!variable_global_exists("cards_queue_limit")) global.cards_queue_limit = 1;
    if (!variable_global_exists("cards_prefetch_enabled")) global.cards_prefetch_enabled = false;
    if (!variable_global_exists("cards_reseed_after_restart")) global.cards_reseed_after_restart = false;
    if (!variable_global_exists("cards_ready")) global.cards_ready = 0;
    if (!variable_global_exists("cards_path")) global.cards_path = "";
    if (!variable_global_exists("api_session_id")) global.api_session_id = "";
    if (!variable_global_exists("api_session_init_pending")) global.api_session_init_pending = false;
    if (!variable_global_exists("api_session_init_req")) global.api_session_init_req = "";
    if (!variable_global_exists("api_session_init_attempted")) global.api_session_init_attempted = false;
    if (!variable_global_exists("api_last_error")) global.api_last_error = "";
    global.cards_queue_limit = max(1, real(global.cards_queue_limit));
}

function scrApiSetError(_msg) {
    global.api_last_error = is_string(_msg) ? _msg : string(_msg);
}

function scrApiClearError() {
    global.api_last_error = "";
}

function scrCardsUpdateReadyFlag() {
    scrCardsEnsureState();
    global.cards_ready = (array_length(global.cards_queue) > 0) ? 1 : 0;
}

function scrCardsPushBatch(_cards, _month) {
    scrCardsEnsureState();
    if (!is_array(_cards) || array_length(_cards) <= 0) return false;
    if (array_length(global.cards_queue) >= global.cards_queue_limit) return false;
    var _entry = { cards: _cards, month: _month };
    array_push(global.cards_queue, _entry);
    scrCardsUpdateReadyFlag();
    return true;
}

function scrCardsBatchEntryToArray(_entry) {
    if (is_array(_entry)) return _entry;
    if (is_struct(_entry) && variable_struct_exists(_entry, "cards") && is_array(_entry.cards)) {
        return _entry.cards;
    }
    return [];
}

function scrCardsTakeBatch() {
    scrCardsEnsureState();
    if (array_length(global.cards_queue) <= 0) {
        scrCardsUpdateReadyFlag();
        return [];
    }

    var _current_month = undefined;
    if (variable_global_exists("start_month_index") && variable_global_exists("turns_timer")) {
        _current_month = scrCalendarMonthName();
    }

    var _pick = -1;
    if (!is_undefined(_current_month)) {
        for (var _i = 0; _i < array_length(global.cards_queue); _i++) {
            var _e = global.cards_queue[_i];
            if (is_struct(_e) && variable_struct_exists(_e, "month") && _e.month == _current_month) {
                _pick = _i;
                break;
            }
        }
    }
    if (_pick < 0) {
        for (var _j = 0; _j < array_length(global.cards_queue); _j++) {
            var _ej = global.cards_queue[_j];
            if (is_struct(_ej) && variable_struct_exists(_ej, "month") && is_undefined(_ej.month)) {
                _pick = _j;
                break;
            }
        }
    }
    if (_pick < 0) _pick = 0;

    var _batch = scrCardsBatchEntryToArray(global.cards_queue[_pick]);
    array_delete(global.cards_queue, _pick, 1);
    scrCardsUpdateReadyFlag();
    return _batch;
}

function scrCardsEnsureQueue() {
    scrCardsEnsureState();
    if (!global.cards_prefetch_enabled) return;
    if (global.waiting_http) return;
    if (array_length(global.cards_queue) >= global.cards_queue_limit) return;
    if (global.api_session_init_pending) return;
    if (string_length(global.api_session_id) <= 0 && !global.api_session_init_attempted) {
        scrInitApiSession();
        return;
    }

    if (room == rmScenario) {
        scrCardRequest(5);
    } else {
        scrColdStartRequest(5);
    }
}

function scrCardRequest(_count) {
    scrCardsEnsureState();
    if (global.waiting_http) {
        show_debug_message("HTTP request already in progress");
        return;
    }

    global.waiting_http = true;
    scrGenerateState();

    var _ahead = 0;
    if (instance_exists(objCardCreator)) {
        with (objCardCreator) {
            if (variable_instance_exists(id, "parsed") && variable_instance_exists(id, "current_card")) {
                _ahead += max(0, array_length(parsed) - current_card);
            }
        }
    }
    if (variable_global_exists("cards_queue") && is_array(global.cards_queue)) {
        for (var _qi = 0; _qi < array_length(global.cards_queue); _qi++) {
            _ahead += array_length(scrCardsBatchEntryToArray(global.cards_queue[_qi]));
        }
    }

    var base_url = "http://146.103.105.166:5000";
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
    if (string_length(global.api_session_id) > 0) {
        _payload[? "session_id"] = global.api_session_id;
    }
    var _attrs = ds_map_create();
    _attrs[? "science"] = _science;
    _attrs[? "army"] = _army;
    _attrs[? "support"] = _support;
    _attrs[? "resources"] = _resources;
    ds_map_add_map(_payload, "attributes", _attrs);

    var _in_war_now = 0;
    if (variable_global_exists("status") && is_array(global.status) && array_length(global.status) > IN_WAR) {
        _in_war_now = global.status[IN_WAR];
    }
    var _in_war = _in_war_now;
    if (!scrIsEternalWar()) {
        _in_war = max(0, _in_war_now - _ahead);
    }

    var _statuses = ds_list_create();
    if (_in_war > 0) ds_list_add(_statuses, "in_war");
    ds_map_add_list(_payload, "statuses", _statuses);

    var _status_values = ds_map_create();
    _status_values[? "in_war"] = _in_war;
    ds_map_add_map(_payload, "status_values", _status_values);

    _payload[? "month"] = scrCalendarMonthNameAt(_ahead);

    var _payload_json = json_encode(_payload);
    ds_map_destroy(_payload);

    global.last_url = url;
    global.last_payload = _payload_json;
    global.http_retry_count = 0;

    var _headers = ds_map_create();
    _headers[? "Content-Type"] = "application/json";
    var req_id = http_request(url, "POST", _headers, _payload_json);
    ds_map_destroy(_headers);
    ds_map_add(global.http_save_targets, string(req_id), "__cards_batch__");
    global.waiting_req = string(req_id);
}

function scrColdStartRequest(_count) {
    scrCardsEnsureState();
    if (global.waiting_http) {
        show_debug_message("HTTP request already in progress");
        return;
    }

    global.waiting_http = true;

    var base_url = "http://146.103.105.166:5000";
    var url = base_url + "/api/v1/cards/cold";

    var _payload = ds_map_create();
    _payload[? "count"] = _count;
    if (string_length(global.api_session_id) > 0) {
        _payload[? "session_id"] = global.api_session_id;
    }

    var _payload_json = json_encode(_payload);
    ds_map_destroy(_payload);

    global.last_url = url;
    global.last_payload = _payload_json;
    global.http_retry_count = 0;

    var _headers = ds_map_create();
    _headers[? "Content-Type"] = "application/json";
    var req_id = http_request(url, "POST", _headers, _payload_json);
    ds_map_destroy(_headers);
    ds_map_add(global.http_save_targets, string(req_id), "__cards_batch__");
    global.waiting_req = string(req_id);
}

function scrInitApiSession() {
    scrCardsEnsureState();
    if (global.api_session_init_pending) return;
    if (string_length(global.api_session_id) > 0) return;

    var base_url = "http://146.103.105.166:5000";
    var url = base_url + "/api/v1/session/init";

    var headers = ds_map_create();
    headers[? "Content-Type"] = "application/json";
    var req_id = http_request(url, "POST", headers, "{}");
    ds_map_destroy(headers);

    global.api_session_init_pending = true;
    global.api_session_init_req = string(req_id);
    global.api_session_init_attempted = true;
    ds_map_add(global.http_save_targets, string(req_id), "__session_init__");
}
