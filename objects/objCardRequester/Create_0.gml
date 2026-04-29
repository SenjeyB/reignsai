if (!variable_global_exists("http_save_targets")) {
    global.http_save_targets = ds_map_create();
}

http_set_connect_timeout(20000);

global.http_retry_count = 0;
global.http_retry_max = 3;
global.last_url = "";
global.last_payload = "";
global.waiting_http = false;
global.waiting_req = "";
global.cards_ready = 0;
global.cards_path = "";
if (!variable_global_exists("api_session_id")) global.api_session_id = "";
if (!variable_global_exists("api_session_init_pending")) global.api_session_init_pending = false;
if (!variable_global_exists("api_session_init_req")) global.api_session_init_req = "";
