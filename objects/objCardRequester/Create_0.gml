if (variable_global_exists("card_requester_id") && instance_exists(global.card_requester_id) && global.card_requester_id != id) {
    instance_destroy();
    exit;
}
global.card_requester_id = id;

http_set_connect_timeout(20000);

if (!variable_global_exists("http_save_targets")) global.http_save_targets = ds_map_create();
if (!variable_global_exists("http_retry_count")) global.http_retry_count = 0;
if (!variable_global_exists("http_retry_max")) global.http_retry_max = 3;
if (!variable_global_exists("last_url")) global.last_url = "";
if (!variable_global_exists("last_payload")) global.last_payload = "";
if (!variable_global_exists("waiting_http")) global.waiting_http = false;
if (!variable_global_exists("waiting_req")) global.waiting_req = "";
if (!variable_global_exists("cards_ready")) global.cards_ready = 0;
if (!variable_global_exists("cards_path")) global.cards_path = "";
if (!variable_global_exists("api_session_id")) global.api_session_id = "";
if (!variable_global_exists("api_session_init_pending")) global.api_session_init_pending = false;
if (!variable_global_exists("api_session_init_req")) global.api_session_init_req = "";
if (!variable_global_exists("api_session_init_attempted")) global.api_session_init_attempted = false;
if (!variable_global_exists("cards_queue")) global.cards_queue = [];
if (!variable_global_exists("cards_queue_limit")) global.cards_queue_limit = 1;
if (!variable_global_exists("cards_prefetch_enabled")) global.cards_prefetch_enabled = false;
if (!variable_global_exists("cards_reseed_after_restart")) global.cards_reseed_after_restart = false;
