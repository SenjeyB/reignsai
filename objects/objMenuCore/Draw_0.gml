var _cx = display_get_gui_width() * 0.5;
var _cy = display_get_gui_height() * 0.42;

var _has_runs = false;
if (variable_global_exists("parents") && ds_exists(global.parents, ds_type_map)) {
    _has_runs = ds_map_size(global.parents) > 0;
}

var _color;
var _v = (sin(current_time / 2500) + 1.5) / 2;
var _z = min(8, 16 * _v);

if (_has_runs) {
    _color = merge_color(make_color_rgb(0, 220, 220), make_color_rgb(40, 220, 100), 0.5 + sin(current_time / 1000) / 2);
} else {
    _color = make_color_rgb(110, 115, 125);
    _z = 0;
}

if (_has_runs) {
    draw_set_alpha(0.35 * visual_alpha);
    draw_set_color(make_color_rgb(60, 0, 20));
    draw_ellipse(_cx - 60, _cy - 30, _cx + 60, _cy + 30, false);

    gpu_set_blendmode(bm_add);
    draw_set_alpha(0.5 * visual_alpha);
    draw_circle_color(_cx, _cy, radius / 2, _color, c_black, false);
    repeat (7) {
        draw_set_alpha(0.1 * visual_alpha);
        draw_circle_color(_cx + irandom_range(-3, 3), _cy + irandom_range(-3, 3), radius / 2, _color, c_black, false);
    }
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
} else {
    draw_set_alpha(0.4 * visual_alpha);
    draw_set_color(c_black);
    draw_ellipse(_cx - 36, _cy + 12, _cx + 36, _cy + 36, false);
    draw_set_alpha(1);
}

if (_has_runs && array_length(lightning_bolts) > 0) {
    gpu_set_blendmode(bm_add);
    for (var i = 0; i < array_length(lightning_bolts); i++) {
        var b = lightning_bolts[i];
        var _t = b.life / b.max_life;
        var _bt = variable_struct_exists(b, "thick") ? b.thick : 1;
        draw_set_alpha(_t * visual_alpha);
        draw_set_color(_color);
        for (var _s = 0; _s < array_length(b.segments); _s++) {
            var seg = b.segments[_s];
            draw_line_width(seg.x1, seg.y1, seg.x2, seg.y2, 6 * _bt);
        }
        draw_set_color(merge_color(_color, c_white, 0.65));
        for (var _s2 = 0; _s2 < array_length(b.segments); _s2++) {
            var seg2 = b.segments[_s2];
            draw_line_width(seg2.x1, seg2.y1, seg2.x2, seg2.y2, 2.5 * _bt);
        }
    }
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
}

var _off = min(1, 1 + sin(current_time / 1500)) * 2;
var _img_n = sprite_get_number(sprCore);

for (var i = 0; i < _img_n; i++) {
    var _y_off = _cy + (_img_n * 0.5 - i) * visual_scale - _off - _z;

    if (time == 0 && _has_runs && (i == round(light) || i == floor(light) || i == floor(light + 1))) {
        gpu_set_blendmode(bm_add);
    } else {
        gpu_set_blendmode(bm_normal);
    }

    var _frame_angle = angle + i / _img_n;
    draw_sprite_ext(sprCore, i, _cx, _y_off, visual_scale, visual_scale, _frame_angle, _color, visual_alpha);
}
gpu_set_blendmode(bm_normal);
draw_set_alpha(1);

if (_has_runs && array_length(sparks) > 0) {
    gpu_set_blendmode(bm_add);
    for (var i = 0; i < array_length(sparks); i++) {
        var s = sparks[i];
        var _t = s.life / s.max_life;
        draw_set_alpha(_t * 0.7 * visual_alpha);
        draw_set_color(c_white);
        draw_circle(s.x, s.y, 1.5 + _t * 1.2, false);
    }
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
}

draw_set_color(c_white);
