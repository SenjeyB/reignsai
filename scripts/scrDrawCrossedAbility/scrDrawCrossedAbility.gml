function scrDrawCrossedAbility(_cx, _cy, _spr_a, _spr_b, _size) {
    if (!sprite_exists(_spr_a) || !sprite_exists(_spr_b)) return;

    var _spr_w = sprite_get_width(_spr_a);
    var _spr_h = sprite_get_height(_spr_a);

    static surf_a = noone;
    static surf_b = noone;
    static surf_w = 0;
    static surf_h = 0;

    if (!surface_exists(surf_a) || surf_w != _spr_w || surf_h != _spr_h) {
        if (surface_exists(surf_a)) surface_free(surf_a);
        if (surface_exists(surf_b)) surface_free(surf_b);
        surf_a = surface_create(_spr_w, _spr_h);
        surf_b = surface_create(_spr_w, _spr_h);
        surf_w = _spr_w;
        surf_h = _spr_h;
    }
    if (!surface_exists(surf_b)) {
        surf_b = surface_create(_spr_w, _spr_h);
    }

    surface_set_target(surf_a);
    draw_clear_alpha(c_black, 0);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_sprite(_spr_a, 0, sprite_get_xoffset(_spr_a), sprite_get_yoffset(_spr_a));
    gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
    draw_triangle(_spr_w, 0, _spr_w, _spr_h, 0, _spr_h, false);
    gpu_set_blendmode(bm_normal);
    surface_reset_target();

    surface_set_target(surf_b);
    draw_clear_alpha(c_black, 0);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_sprite(_spr_b, 0, sprite_get_xoffset(_spr_b), sprite_get_yoffset(_spr_b));
    gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
    draw_triangle(0, 0, _spr_w, 0, 0, _spr_h, false);
    gpu_set_blendmode(bm_normal);
    surface_reset_target();

    var _scale = _size / _spr_w;
    var _half = _size * 0.5;
    var _x1 = _cx - _half;
    var _y1 = _cy - _half;
    var _x2 = _cx + _half;
    var _y2 = _cy + _half;

    var _prev_filter = gpu_get_tex_filter();
    gpu_set_tex_filter(false);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_surface_ext(surf_a, _x1, _y1, _scale, _scale, 0, c_white, 1);
    draw_surface_ext(surf_b, _x1, _y1, _scale, _scale, 0, c_white, 1);
    gpu_set_tex_filter(_prev_filter);

    draw_set_color(c_white);
    draw_line_width(_x2, _y1, _x1, _y2, 2);
}
