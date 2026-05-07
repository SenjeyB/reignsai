function scrNamesEnsureDefaults() {
    if (!variable_global_exists("name_first_list") || !is_array(global.name_first_list) || array_length(global.name_first_list) == 0) {
        global.name_first_list = ["William", "James", "Edward", "Henry", "Arthur"];
    }
    if (!variable_global_exists("name_last_list") || !is_array(global.name_last_list) || array_length(global.name_last_list) == 0) {
        global.name_last_list = ["Whitcombe", "Ashworth", "Blackwood", "Hartwell", "Sinclair"];
    }
    if (!variable_global_exists("name_nickname_list") || !is_array(global.name_nickname_list) || array_length(global.name_nickname_list) == 0) {
        global.name_nickname_list = ["Great", "Brave", "Wise", "Bold", "Mad"];
    }
}

function scrNamesLoad() {
    scrNamesEnsureDefaults();
    if (!file_exists("names.json")) return;
    var fh = file_text_open_read("names.json");
    if (fh == -1) return;
    var content = "";
    while (!file_text_eof(fh)) content += file_text_readln(fh) + "\n";
    file_text_close(fh);

    if (string_length(content) > 0 && ord(string_char_at(content, 1)) == 65279) {
        content = string_delete(content, 1, 1);
    }

    try {
        var parsed = json_parse(content);
        if (!is_struct(parsed)) return;
        if (variable_struct_exists(parsed, "first_names") && is_array(parsed.first_names) && array_length(parsed.first_names) > 0) {
            global.name_first_list = parsed.first_names;
        }
        if (variable_struct_exists(parsed, "last_names") && is_array(parsed.last_names) && array_length(parsed.last_names) > 0) {
            global.name_last_list = parsed.last_names;
        }
        if (variable_struct_exists(parsed, "nicknames") && is_array(parsed.nicknames) && array_length(parsed.nicknames) > 0) {
            global.name_nickname_list = parsed.nicknames;
        }
    } catch (_e) {
        show_debug_message("scrNamesLoad: failed to parse names.json");
    }
}

function _scrNamesPickRandomFromSlot(_slot) {
    scrNamesEnsureDefaults();
    var _list;
    switch (_slot) {
        case "first":    _list = global.name_first_list;    break;
        case "last":     _list = global.name_last_list;     break;
        case "nickname": _list = global.name_nickname_list; break;
        default:         _list = global.name_first_list;    break;
    }
    return string(_list[irandom(array_length(_list) - 1)]);
}

function scrNamesGenerateRandom() {
    return {
        first:    _scrNamesPickRandomFromSlot("first"),
        last:     _scrNamesPickRandomFromSlot("last"),
        nickname: _scrNamesPickRandomFromSlot("nickname")
    };
}

function _scrNamesParentSlot(_parent, _slot) {
    if (is_struct(_parent) && variable_struct_exists(_parent, "name")) {
        var _nm = _parent.name;
        if (is_struct(_nm) && variable_struct_exists(_nm, _slot)) {
            return string(_nm[$ _slot]);
        }
    }
    return _scrNamesPickRandomFromSlot(_slot);
}

function scrNamesGenerateInherited(_p_a, _p_b) {
    var _slots = ["first", "last", "nickname"];
    var _order = [0, 1, 2];
    for (var _i = 2; _i > 0; _i--) {
        var _j = irandom(_i);
        var _tmp = _order[_i];
        _order[_i] = _order[_j];
        _order[_j] = _tmp;
    }

    var _result = { first: "", last: "", nickname: "" };
    var _slot_a = _slots[_order[0]];
    var _slot_b = _slots[_order[1]];
    var _slot_c = _slots[_order[2]];

    _result[$ _slot_a] = (irandom(1) == 0)
        ? _scrNamesParentSlot(_p_a, _slot_a)
        : _scrNamesPickRandomFromSlot(_slot_a);

    _result[$ _slot_b] = (irandom(1) == 0)
        ? _scrNamesParentSlot(_p_b, _slot_b)
        : _scrNamesPickRandomFromSlot(_slot_b);

    _result[$ _slot_c] = _scrNamesPickRandomFromSlot(_slot_c);

    return _result;
}

function scrNamesFormat(_name) {
    if (!is_struct(_name)) return "";
    var _f = variable_struct_exists(_name, "first")    ? string(_name.first)    : "";
    var _l = variable_struct_exists(_name, "last")     ? string(_name.last)     : "";
    var _n = variable_struct_exists(_name, "nickname") ? string(_name.nickname) : "";
    var _out = string_trim(_f + " " + _l);
    if (string_length(_n) > 0) _out += " the " + _n;
    return _out;
}

function scrNamesParentLabel(_parent) {
    if (is_struct(_parent) && variable_struct_exists(_parent, "name") && is_struct(_parent.name)) {
        var _formatted = scrNamesFormat(_parent.name);
        if (string_length(_formatted) > 0) return _formatted;
    }
    var _iter = (is_struct(_parent) && variable_struct_exists(_parent, "iteration")) ? _parent.iteration : 0;
    return "Iteration #" + string(_iter);
}
