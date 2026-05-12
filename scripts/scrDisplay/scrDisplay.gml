#macro DISPLAY_ASPECT 1.7777777777

function scrDisplayModeNames() {
    return ["Windowed", "Fullscreen", "Borderless"];
}

function scrDisplayEnsureDefaults() {
    if (!variable_global_exists("display_window_mode")) global.display_window_mode = 0;
    global.display_window_mode = clamp(global.display_window_mode, 0, 2);
}

function scrDisplayApplyMode() {
    scrDisplayEnsureDefaults();
    var _mode = global.display_window_mode;

    if (_mode == 1) {
        window_set_showborder(true);
        window_set_fullscreen(true);
        return;
    }

    window_set_fullscreen(false);
    window_set_showborder(_mode != 2);

    if (_mode == 2) {
        window_set_showborder(false);
        window_set_fullscreen(true);
        return;
    }

    var _hw = 720;
    var _ww = round(_hw * DISPLAY_ASPECT);
    window_set_size(_ww, _hw);
    var _dw = display_get_width();
    var _dh = display_get_height();
    window_set_position((_dw - _ww) div 2, (_dh - _hw) div 2);
}

function scrDisplaySnapAspect() {
    scrDisplayEnsureDefaults();
    if (global.display_window_mode == 1) return;
    var _h = window_get_height();
    var _w = window_get_width();
    var _expected_w = round(_h * DISPLAY_ASPECT);
    if (abs(_w - _expected_w) > 2) {
        window_set_size(_expected_w, _h);
    }
}
