function scrResolveResponse(){
	if (!variable_global_exists("http_save_targets")) exit;

	var req_key = string(async_load[? "id"]);
	if (!ds_map_exists(global.http_save_targets, req_key)) exit;
	var target = ds_map_find_value(global.http_save_targets, req_key);
	var is_session_init = (target == "__session_init__");

	var status = async_load[? "status"];
	if (status < 0) {
	    show_debug_message("Network error for " + req_key + " (status < 0)");
	    if (is_session_init) {
	        ds_map_delete(global.http_save_targets, req_key);
	        if (variable_global_exists("api_session_init_req") && global.api_session_init_req == req_key) {
	            global.api_session_init_pending = false;
	            global.api_session_init_req = "";
	        }
	        exit;
	    }

	    if (global.http_retry_count < global.http_retry_max) {
	        global.http_retry_count += 1;
	        show_debug_message("Retry " + string(global.http_retry_count) + " of " + string(global.http_retry_max));
	        var fname = ds_map_find_value(global.http_save_targets, req_key);
	        ds_map_delete(global.http_save_targets, req_key);
	        global._retry_filename = fname;
	        alarm[0] = 10;
	        exit;
	    } else {
	        show_debug_message("HTTP failed after retries - using fallback data");
	        if (global.waiting_req == req_key) {
	            global.waiting_http = false;
	            global.waiting_req = "";
	        }
	        ds_map_delete(global.http_save_targets, req_key);
	        // Use fallback data so game can continue
	        global.cards_ready = 1;
	        global.cards_path = "events.json";
	        exit;
	    }
	}
	if (status == 1) exit;

	var http_status = async_load[? "http_status"];
	if (http_status != 200) {
	    show_debug_message("HTTP returned code " + string(http_status) + " - using fallback data");
	    if (is_session_init) {
	        ds_map_delete(global.http_save_targets, req_key);
	        if (variable_global_exists("api_session_init_req") && global.api_session_init_req == req_key) {
	            global.api_session_init_pending = false;
	            global.api_session_init_req = "";
	        }
	        exit;
	    }
	    ds_map_delete(global.http_save_targets, req_key);
	    if (global.waiting_req == req_key) {
	        global.waiting_http = false;
	        global.waiting_req = "";
	    }
	    // Use fallback data so game can continue
	    global.cards_ready = 1;
	    global.cards_path = "events.json";
	    exit;
	}

	var json_text = async_load[? "result"];
	if (is_session_init) {
	    var init_parsed = json_parse(json_text);
	    if (is_struct(init_parsed) && variable_struct_exists(init_parsed, "success") && init_parsed.success) {
	        var init_data = variable_struct_exists(init_parsed, "data") ? init_parsed.data : undefined;
	        if (is_struct(init_data) && variable_struct_exists(init_data, "session_id")) {
	            global.api_session_id = string(init_data.session_id);
	            show_debug_message("API session initialized: " + global.api_session_id);
	        } else {
	            show_debug_message("Session init response missing session_id");
	        }
	    } else {
	        show_debug_message("Session init failed: " + json_text);
	    }

	    if (variable_global_exists("api_session_init_req") && global.api_session_init_req == req_key) {
	        global.api_session_init_pending = false;
	        global.api_session_init_req = "";
	    }
	    ds_map_delete(global.http_save_targets, req_key);
	    exit;
	}

	// Validate success field in response
	var parsed = json_parse(json_text);
	if (is_struct(parsed) && variable_struct_exists(parsed, "success")) {
	    if (!parsed.success) {
	        var error_msg = variable_struct_exists(parsed, "error") ? parsed.error : "Unknown error";
	        show_debug_message("Server returned error: " + error_msg + " - using fallback data");

	        // Handle rate limit
	        if (http_status == 429 && variable_struct_exists(parsed, "retry_after")) {
	            show_debug_message("Rate limited. Retry after: " + string(parsed.retry_after));
	        }

	        ds_map_delete(global.http_save_targets, req_key);
	        if (global.waiting_req == req_key) {
	            global.waiting_http = false;
	            global.waiting_req = "";
	        }
	        // Use fallback data so game can continue
	        global.cards_ready = 1;
	        global.cards_path = "events.json";
	        exit;
	    }
	}

	var filename = ds_map_find_value(global.http_save_targets, req_key);
	var path = working_directory + filename;
	var f = file_text_open_write(path);
	if f != -1 {
	    file_text_write_string(f, json_text);
	    file_text_close(f);
	    show_debug_message("Saved JSON to: " + path);

	    global.cards_ready = 1;
	    global.cards_path = path;
	} else {
	    show_debug_message("Failed to open file for writing: " + path);
	}

	if (global.waiting_req == req_key) {
	    global.waiting_http = false;
	    global.waiting_req = "";
	}
	ds_map_delete(global.http_save_targets, req_key);


}
