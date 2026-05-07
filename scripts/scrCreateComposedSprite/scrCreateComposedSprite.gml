function scrCreateComposedSprite(_base, _text_list, _base_font)
{
    var w = sprite_get_width(_base);
    var h = sprite_get_height(_base);

    var sprChar = sprCharBase;
    var _char_frames = sprite_get_number(sprChar);
    if (_char_frames <= 0) _char_frames = 1;
    var sprCharIndex = irandom(_char_frames - 1);

    var t_full = _text_list;
    if (t_full == "") t_full = " ";

    var origin_y = sprite_get_yoffset(_base);
    var box_w = w * 0.86;
    var box_x = (w - box_w) / 2;
    var box_y = origin_y + 30;
    var box_bottom = h * 0.88;
    var box_h = max(40, box_bottom - box_y);

    var pad_x = box_w * 0.08;
    var pad_y = box_h * 0.10;
    var inner_w = box_w - pad_x * 2;
    var inner_h = box_h - pad_y * 2;

    var surf = surface_create(w, h);
    surface_set_target(surf);
    draw_clear_alpha(c_black, 0);
    draw_sprite(_base, 0, w / 2, h / 2);
    draw_sprite(sprChar, sprCharIndex, w / 2, h / 3 + 30);

    var words = ds_list_create();
    var pos = 1, len = string_length(t_full);
    while (pos <= len) {
        while (pos <= len && string_char_at(t_full, pos) == " ") pos++;
        if (pos > len) break;
        var s = pos;
        while (pos <= len && string_char_at(t_full, pos) != " ") pos++;
        ds_list_add(words, string_copy(t_full, s, pos - s));
    }
    if (ds_list_size(words) == 0) ds_list_add(words, " ");

    draw_set_font(_base_font);
    var base_h = string_height("Ay");
    if (base_h <= 0) base_h = 12;

    var max_scale = max(1, floor(inner_h * 0.72 / base_h));
    if (max_scale > 12) max_scale = 12;
    max_scale = max(1, max_scale - 1);

    var best_scale = -1;
    var low = 1;
    var high = max_scale;

    while (low <= high) {
        var mid = floor((low + high) * 0.5);
        var scaled_h = base_h * mid;
        var scaled_gap = max(1, round(scaled_h * 0.25));

        var too_large = false;
        var lines_needed = 0;
        var cur = "";
        var wc = ds_list_size(words);

        for (var i = 0; i < wc; i++) {
            var wword = words[| i];
            var ww = string_width(wword) * mid;
            if (ww > inner_w) { too_large = true; break; }
            var cand = (cur == "") ? wword : cur + " " + wword;
            if (string_width(cand) * mid <= inner_w) {
                cur = cand;
            } else {
                lines_needed++;
                cur = wword;
            }
        }
        if (!too_large && cur != "") lines_needed++;

        var required_h = lines_needed * scaled_h + max(0, lines_needed - 1) * scaled_gap;
        var fits = (!too_large) && (required_h <= inner_h);

        if (fits) {
            best_scale = mid;
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }

    if (best_scale == -1) best_scale = 1;

    var line_h = base_h * best_scale;
    var line_gap = max(1, round(line_h * 0.25));

    var final_lines = ds_list_create();
    var cur2 = "";
    var wc2 = ds_list_size(words);
    for (var i2 = 0; i2 < wc2; i2++) {
        var wword2 = words[| i2];
        var cand2 = (cur2 == "") ? wword2 : cur2 + " " + wword2;
        if (string_width(cand2) * best_scale <= inner_w) {
            cur2 = cand2;
        } else {
            ds_list_add(final_lines, cur2);
            cur2 = wword2;
        }
        if (i2 == wc2 - 1) {
            if (cur2 != "") ds_list_add(final_lines, cur2);
        }
    }
    if (ds_list_size(final_lines) == 0) ds_list_add(final_lines, " ");

    var n_lines = ds_list_size(final_lines);
    var total_h = n_lines * line_h + max(0, n_lines - 1) * line_gap;

    var prev_filter = gpu_get_tex_filter();
    gpu_set_tex_filter(false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_black);

    var center_x = box_x + box_w * 0.5;
    var start_y = box_y + pad_y + (inner_h - total_h) * 0.5;

    var yy = start_y;
    for (var k = 0; k < n_lines; k++) {
        draw_text_transformed(center_x, yy, final_lines[| k], best_scale, best_scale, 0);
        yy += line_h + line_gap;
    }

    gpu_set_tex_filter(prev_filter);
    surface_reset_target();

    var final_sprite = sprite_create_from_surface(surf, 0, 0, w, h, false, false, 0, 0);

    ds_list_destroy(words);
    ds_list_destroy(final_lines);
    surface_free(surf);

    return final_sprite;
}
