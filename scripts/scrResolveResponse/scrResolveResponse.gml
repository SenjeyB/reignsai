function scrResolveResponse(){
	if (!variable_global_exists("http_save_targets")) exit;

	var req_key = string(async_load[? "id"]);
	if (!ds_map_exists(global.http_save_targets, req_key)) exit;

	var status = async_load[? "status"];
	if (status < 0) {
	    show_debug_message("Network error for " + req_key + " (status < 0)");

	    if (global.http_retry_count < global.http_retry_max) {
	        global.http_retry_count += 1;
	        show_debug_message("Retry " + string(global.http_retry_count) + " of " + string(global.http_retry_max));
	        var fname = ds_map_find_value(global.http_save_targets, req_key);
	        ds_map_delete(global.http_save_targets, req_key);
	        global._retry_filename = fname;
	        alarm[0] = 10;
	        exit;
	    } else {
	        show_debug_message("HTTP failed after retries");
	        if (global.waiting_req == req_key) {
	            global.waiting_http = false;
	            global.waiting_req = "";
	        }
	        ds_map_delete(global.http_save_targets, req_key);
	        exit;
	    }
	}
	if (status == 1) exit;

	var http_status = async_load[? "http_status"];
	if (http_status != 200) {
	    show_debug_message("HTTP returned code " + string(http_status));
	    ds_map_delete(global.http_save_targets, req_key);
	    if (global.waiting_req == req_key) {
	        global.waiting_http = false;
	        global.waiting_req = "";
	    }
	    exit;
	}

	var json_text = async_load[? "result"];
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