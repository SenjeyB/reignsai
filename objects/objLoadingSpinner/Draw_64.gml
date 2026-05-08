if (visible_alpha < 0.01) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw * 0.5;
var _cy = _gh * 0.5;
var _radius = 36;
var _thickness = 5;
var _arc_deg = 270;
var _segments = 32;
var _step_deg = _arc_deg / _segments;

draw_set_color(c_white);
for (var i = 0; i < _segments; i++) {
    var _a = spinner_angle + i * _step_deg;
    var _t = (i + 1) / _segments;
    draw_set_alpha(visible_alpha * _t);
    var _ax = _cx + lengthdir_x(_radius, _a);
    var _ay = _cy + lengthdir_y(_radius, _a);
    var _bx = _cx + lengthdir_x(_radius - _thickness, _a);
    var _by = _cy + lengthdir_y(_radius - _thickness, _a);
    draw_line_width(_ax, _ay, _bx, _by, _thickness);
}
draw_set_alpha(1);
