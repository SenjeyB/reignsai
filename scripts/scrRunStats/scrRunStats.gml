function scrRunStatsDefault() {
    return {
        total_runs: 0,
        total_turns: 0,
        best_turns: 0,
        sum_resources: 0,
        sum_support: 0,
        sum_army: 0,
        sum_science: 0
    };
}

function scrRunStatsLoad() {
    var _default = scrRunStatsDefault();
    if (!file_exists("run_stats.json")) {
        global.run_stats = _default;
        return;
    }

    var _fh = file_text_open_read("run_stats.json");
    if (_fh == -1) {
        global.run_stats = _default;
        return;
    }

    var _content = "";
    while (!file_text_eof(_fh)) {
        _content += file_text_readln(_fh);
    }
    file_text_close(_fh);

    var _parsed = json_parse(_content);
    if (!is_struct(_parsed)) {
        global.run_stats = _default;
        return;
    }

    global.run_stats = {
        total_runs: max(0, real(variable_struct_exists(_parsed, "total_runs") ? _parsed.total_runs : 0)),
        total_turns: max(0, real(variable_struct_exists(_parsed, "total_turns") ? _parsed.total_turns : 0)),
        best_turns: max(0, real(variable_struct_exists(_parsed, "best_turns") ? _parsed.best_turns : 0)),
        sum_resources: real(variable_struct_exists(_parsed, "sum_resources") ? _parsed.sum_resources : 0),
        sum_support: real(variable_struct_exists(_parsed, "sum_support") ? _parsed.sum_support : 0),
        sum_army: real(variable_struct_exists(_parsed, "sum_army") ? _parsed.sum_army : 0),
        sum_science: real(variable_struct_exists(_parsed, "sum_science") ? _parsed.sum_science : 0)
    };
}

function scrRunStatsSave() {
    if (!variable_global_exists("run_stats") || !is_struct(global.run_stats)) {
        global.run_stats = scrRunStatsDefault();
    }

    var _map = ds_map_create();
    _map[? "total_runs"] = global.run_stats.total_runs;
    _map[? "total_turns"] = global.run_stats.total_turns;
    _map[? "best_turns"] = global.run_stats.best_turns;
    _map[? "sum_resources"] = global.run_stats.sum_resources;
    _map[? "sum_support"] = global.run_stats.sum_support;
    _map[? "sum_army"] = global.run_stats.sum_army;
    _map[? "sum_science"] = global.run_stats.sum_science;

    var _json = json_encode(_map);
    ds_map_destroy(_map);

    var _fh = file_text_open_write("run_stats.json");
    if (_fh == -1) return;
    file_text_write_string(_fh, _json);
    file_text_close(_fh);
}

function scrRunStatsRecordRun() {
    if (!variable_global_exists("run_stats_recorded")) global.run_stats_recorded = false;
    if (global.run_stats_recorded) return;

    if (!variable_global_exists("run_stats") || !is_struct(global.run_stats)) {
        scrRunStatsLoad();
    }

    var _turns = 0;
    if (variable_global_exists("turns_timer")) {
        _turns = max(0, real(global.turns_timer));
    }

    var _start = [0, 0, 0, 0];
    if (variable_global_exists("run_start_stat") && is_array(global.run_start_stat) && array_length(global.run_start_stat) >= 4) {
        _start = global.run_start_stat;
    }

    var _current = [0, 0, 0, 0];
    if (variable_global_exists("stat") && is_array(global.stat) && array_length(global.stat) >= 4) {
        _current = global.stat;
    } else {
        _current = _start;
    }

    global.run_stats.total_runs += 1;
    global.run_stats.total_turns += _turns;
    global.run_stats.best_turns = max(global.run_stats.best_turns, _turns);
    global.run_stats.sum_resources += (_current[0] - _start[0]);
    global.run_stats.sum_support += (_current[1] - _start[1]);
    global.run_stats.sum_army += (_current[2] - _start[2]);
    global.run_stats.sum_science += (_current[3] - _start[3]);

    scrRunStatsSave();
    global.run_stats_recorded = true;
}

function scrRunStatsAverageTurns() {
    if (!variable_global_exists("run_stats") || !is_struct(global.run_stats)) return 0;
    if (global.run_stats.total_runs <= 0) return 0;
    return global.run_stats.total_turns / global.run_stats.total_runs;
}

function scrRunStatsMostInheritedAbilityId() {
    if (!variable_global_exists("parents") || !ds_exists(global.parents, ds_type_map)) return -1;

    var _counts = ds_map_create();
    var _best_id = -1;
    var _best_count = -1;

    var _key = ds_map_find_first(global.parents);
    while (!is_undefined(_key)) {
        var _entry = global.parents[? _key];
        if (is_struct(_entry) && variable_struct_exists(_entry, "ability_id")) {
            var _ability_id = real(_entry.ability_id);
            var _id_key = string(_ability_id);
            var _count = 1;
            if (ds_map_exists(_counts, _id_key)) {
                _count = ds_map_find_value(_counts, _id_key) + 1;
            }
            ds_map_set(_counts, _id_key, _count);
            if (_count > _best_count) {
                _best_count = _count;
                _best_id = _ability_id;
            }
        }
        _key = ds_map_find_next(global.parents, _key);
    }

    ds_map_destroy(_counts);
    return _best_id;
}

function scrRunStatsMostInheritedAbilityLabel() {
    var _ability_id = scrRunStatsMostInheritedAbilityId();
    if (_ability_id < 0) return "-";

    var _fallback_names = [
        "Eternal War",
        "Unemotional Community",
        "MANHATTAN PROJECT",
        "Pay taxes",
        "Bribery",
        "Public Speech",
        "Scientific ambitions",
        "Intervention"
    ];

    if (variable_global_exists("ability_name") && is_array(global.ability_name)) {
        if (_ability_id < array_length(global.ability_name)) {
            return string(global.ability_name[_ability_id]);
        }
    }

    if (_ability_id < array_length(_fallback_names)) {
        return _fallback_names[_ability_id];
    }

    return "Ability #" + string(_ability_id);
}

function scrRunStatsReset() {
    global.run_stats = scrRunStatsDefault();
    scrRunStatsSave();

    if (file_exists("parents.json")) {
        file_delete("parents.json");
    }

    if (variable_global_exists("parents") && ds_exists(global.parents, ds_type_map)) {
        ds_map_destroy(global.parents);
    }
    global.parents = ds_map_create();
    global.player_iterations = 1;

    if (variable_global_exists("cards_queue")) global.cards_queue = [];
    if (variable_global_exists("cards_ready")) global.cards_ready = 0;
    if (variable_global_exists("cards_bootstrap_done")) global.cards_bootstrap_done = false;
    if (variable_global_exists("cards_refresh_on_mainmenu")) global.cards_refresh_on_mainmenu = true;
    if (variable_global_exists("cards_reseed_after_restart")) global.cards_reseed_after_restart = false;
    if (variable_global_exists("turns_timer")) global.turns_timer = 0;
}
