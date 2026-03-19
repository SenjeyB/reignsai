function scrGetParents(){
    var filename = "parents.json";
    if (!file_exists(filename)){
        global.parents = ds_map_create();
        global.player_iterations = 1;
        return;
    }
    var fh = file_text_open_read(filename);
    var _all = ds_map_create();
    var max_iter = 0;
    
    while (!file_text_eof(fh)){
        var line = string_trim(file_text_readln(fh));
        if (line == "") continue;
        var obj_struct = json_parse(line);
        if (obj_struct == undefined) continue;
        if (!variable_struct_exists(obj_struct, "iteration")) continue;
        var iter = obj_struct.iteration; 
        ds_map_set(_all, string(iter), obj_struct);
        if (iter > max_iter) max_iter = iter;
    }
    file_text_close(fh);
    global.parents = _all;
    global.player_iterations = (max_iter > 0) ? max_iter + 1 : 1;
}