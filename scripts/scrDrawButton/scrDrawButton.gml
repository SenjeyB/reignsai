function scrDrawButton(_x1, _y1, _x2, _y2, _color) {
    var _prev_filter = gpu_get_tex_filter();
    gpu_set_tex_filter(false);
    draw_sprite_stretched_ext(sprButton, 0, _x1, _y1, _x2 - _x1, _y2 - _y1, _color, 1);
    gpu_set_tex_filter(_prev_filter);
}
