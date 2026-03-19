var xx = x + offset;
var yy = y;

var draw_x = sprite_get_xoffset(sprite_index) - card_w/2;
var draw_y = sprite_get_yoffset(sprite_index) - card_h/2;

var m = matrix_build(xx, yy, 0, grab_angle_x, grab_angle_y, angle, 1, 1, 1);
matrix_set(matrix_world, m);

draw_sprite_ext(sprite_index, image_index, draw_x, draw_y, 1, 1, 0, c_white, 1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text(0, 0, "");

matrix_set(matrix_world, matrix_build_identity());