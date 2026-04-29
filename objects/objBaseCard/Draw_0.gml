var xx = x + offset;
var yy = y;

var draw_x = sprite_get_xoffset(sprite_index) - card_w/2;
var draw_y = sprite_get_yoffset(sprite_index) - card_h/2;

var _vapor_progress = 0;
if (is_vaporizing) {
    _vapor_progress = clamp(vapor_timer / vapor_duration, 0, 1);
}

var _vapor_scale = 1 - (_vapor_progress * 0.24);
var _vapor_alpha = 1 - (_vapor_progress * 0.95);
xx += vapor_direction * _vapor_progress * 120;
yy -= _vapor_progress * 54;

var m = matrix_build(xx, yy, 0, grab_angle_x, grab_angle_y, angle, _vapor_scale, _vapor_scale, 1);
matrix_set(matrix_world, m);

draw_sprite_ext(sprite_index, image_index, draw_x, draw_y, 1, 1, 0, c_white, _vapor_alpha);

if (is_vaporizing) {
    gpu_set_blendmode(bm_add);
    draw_set_color(c_white);
    for (var i = 0; i < 6; i++) {
        var _t = i / 5;
        var _w = card_w * (0.24 + _t * 0.36) * (1 - _vapor_progress * 0.45);
        var _h = 8 + (i * 4);
        var _y = -18 - (i * 24) - (_vapor_progress * 84);
        var _a = (1 - _vapor_progress) * (0.17 - i * 0.02);
        draw_set_alpha(max(_a, 0));
        draw_rectangle(-_w * 0.5, _y, _w * 0.5, _y + _h, false);
    }
    gpu_set_blendmode(bm_normal);
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text(0, 0, "");

matrix_set(matrix_world, matrix_build_identity());
draw_set_alpha(1);
