var _is_active_card = true;
if (variable_global_exists("current_card_id")) {
    _is_active_card = (global.current_card_id == id);
}

if (!_is_active_card) {
    edge_glow_left = 0;
    edge_glow_right = 0;
    draw_set_alpha(1);
    exit;
}

var _left_target = 0;
var _right_target = 0;

if (!is_vaporizing && opt != noone) {
    if (opt.option_type == 1) _left_target = 1;
    if (opt.option_type == 2) _right_target = 1;
}

edge_glow_left = lerp(edge_glow_left, _left_target, 0.2);
edge_glow_right = lerp(edge_glow_right, _right_target, 0.2);

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _glow_width = floor(_gw * 0.2);

if (edge_glow_left > 0.01 || edge_glow_right > 0.01) {
    var _left_intensity = 0;
    if (edge_glow_left > 0.01) {
        if (edge_glow_left >= 0.5) {
            _left_intensity = 0.62 + ((edge_glow_left - 0.5) / 0.5) * 0.38;
        } else {
            _left_intensity = 0.62 * power(edge_glow_left / 0.5, 2.2);
        }
    }

    var _right_intensity = 0;
    if (edge_glow_right > 0.01) {
        if (edge_glow_right >= 0.5) {
            _right_intensity = 0.62 + ((edge_glow_right - 0.5) / 0.5) * 0.38;
        } else {
            _right_intensity = 0.62 * power(edge_glow_right / 0.5, 2.2);
        }
    }

    gpu_set_blendmode(bm_add);

    if (edge_glow_left > 0.01) {
        draw_set_alpha(_left_intensity * 0.42);
        draw_rectangle_color(0, 0, _glow_width, _gh, c_white, c_black, c_black, c_white, false);
    }

    if (edge_glow_right > 0.01) {
        draw_set_alpha(_right_intensity * 0.42);
        draw_rectangle_color(_gw - _glow_width, 0, _gw, _gh, c_black, c_white, c_white, c_black, false);
    }

    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
}

if (is_vaporizing) exit;

if ((opt != noone && opt.option_type == 1) || position == 1) {
    scrDrawBottomBox(desc_opt1, "PressStart2P.ttf");
} else if ((opt != noone && opt.option_type == 2) || position == 2) {
    scrDrawBottomBox(desc_opt2, "PressStart2P.ttf");
}
