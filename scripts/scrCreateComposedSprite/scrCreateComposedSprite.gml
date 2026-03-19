function __get_cached_font(_file, _size)
{
	if (!variable_global_exists("__font_cache")) {
        global.__font_cache = ds_map_create();
    }
	
    var key = _file + "_" + string(_size);

    if (ds_map_exists(global.__font_cache, key))
    {
        return global.__font_cache[? key];
    }

    var f = font_add(_file, _size, false, false, 32, 65535);

    if (f != -1)
    {
        global.__font_cache[? key] = f;
    }

    return f;
}



function scrCreateComposedSprite(_base, _char_list, _text_list, _font)
{
    var w = sprite_get_width(_base);
    var h = sprite_get_height(_base);

    var sprChar = _char_list[ irandom(array_length(_char_list)-1) ];
    var t_full  = _text_list;
    if (t_full == "") t_full = " ";

    var box_w = w * 0.86;
    var box_h = h * 0.36;
    var box_x = (w - box_w) / 2;
    var box_y = h * 0.56;

    var pad_x = box_w * 0.08;
    var pad_y = box_h * 0.10;
    var inner_w = box_w - pad_x*2;
    var inner_h = box_h - pad_y*2;

    var surf = surface_create(w, h);
    surface_set_target(surf);
    draw_clear_alpha(c_black, 0);
    draw_sprite(_base, 0, w/2, h/2);
    draw_sprite(sprChar, 0, w/2, h/4);

    var border = 4;
    draw_set_color(c_black);
    draw_rectangle(box_x, box_y, box_x + box_w, box_y + box_h, false);
    draw_rectangle(box_x + border, box_y + border, box_x + box_w - border, box_y + box_h - border, false);
    draw_set_color(c_white);
    draw_rectangle(box_x + 1, box_y + 1, box_x + box_w - 1, box_y + box_h - 1, true);

    var words = ds_list_create();
    var pos = 1, len = string_length(t_full);

    while (pos <= len)
    {
        while (pos <= len && string_char_at(t_full, pos) == " ") pos++;
        if (pos > len) break;

        var s = pos;
        while (pos <= len && string_char_at(t_full, pos) != " ") pos++;

        ds_list_add(words, string_copy(t_full, s, pos - s));
    }

    if (ds_list_size(words) == 0) ds_list_add(words, " ");

    var use_dynamic = is_string(_font);
    var final_lines = ds_list_create();
    var used_font = -1;
    var line_h = 16;

    if (use_dynamic)
    {
        var max_test_size = min(floor(inner_h), 256);
        var min_test_size = 6;
        if (max_test_size < min_test_size) max_test_size = min_test_size;

        var low = min_test_size;
        var high = max_test_size;

        var best_size = -1;
        var best_font = -1;

        while (low <= high)
        {
            var mid = floor((low + high) * 0.5);

            var f = __get_cached_font(_font, mid);

            if (f == -1)
            {
                high = mid - 1;
                continue;
            }

            draw_set_font(f);

            var lh = string_height("Ay");
            if (lh <= 0) lh = 1;

            var too_large = false;
            var lines_needed = 0;

            var cur = "";
            var wc = ds_list_size(words);

            for (var i = 0; i < wc; i++)
            {
                var wword = words[| i];

                if (string_width(wword) > inner_w)
                {
                    too_large = true;
                    break;
                }

                var cand = (cur == "") ? wword : cur + " " + wword;

                if (string_width(cand) <= inner_w)
                {
                    cur = cand;
                }
                else
                {
                    lines_needed++;
                    cur = wword;
                }
            }

            if (!too_large)
            {
                if (cur != "") lines_needed++;
            }

            var fits = (!too_large) && (lines_needed * lh <= inner_h);

            if (fits)
            {
                best_size = mid;
                best_font = f;
                low = mid + 1;
            }
            else
            {
                high = mid - 1;
            }
        }

        if (best_size == -1)
        {
            best_size = min_test_size;
            best_font = __get_cached_font(_font, best_size);
        }

        used_font = best_font;
        draw_set_font(used_font);

        line_h = string_height("Ay");
        if (line_h <= 0) line_h = 16;

        var cur2 = "";
        var wc2 = ds_list_size(words);

        for (var i2 = 0; i2 < wc2; i2++)
        {
            var wword2 = words[| i2];
            var cand2 = (cur2 == "") ? wword2 : cur2 + " " + wword2;

            if (string_width(cand2) <= inner_w)
            {
                cur2 = cand2;
            }
            else
            {
                ds_list_add(final_lines, cur2);
                cur2 = wword2;
            }

            if (i2 == wc2 - 1)
            {
                if (cur2 != "") ds_list_add(final_lines, cur2);
            }
        }
    }
    else
    {
        draw_set_font(_font);
        line_h = string_height("Ay");
        if (line_h <= 0) line_h = 16;

        var cur3 = "";
        var wc3 = ds_list_size(words);

        for (var i3 = 0; i3 < wc3; i3++)
        {
            var wword3 = words[| i3];
            var cand3 = (cur3 == "") ? wword3 : cur3 + " " + wword3;

            if (string_width(cand3) <= inner_w)
            {
                cur3 = cand3;
            }
            else
            {
                ds_list_add(final_lines, cur3);
                cur3 = wword3;
            }

            if (i3 == wc3 - 1)
            {
                if (cur3 != "") ds_list_add(final_lines, cur3);
            }
        }
    }


    if (ds_list_size(final_lines) == 0)
        ds_list_add(final_lines, " ");

    var n_lines = ds_list_size(final_lines);
    var max_line_width = 0;

    for (var j = 0; j < n_lines; j++)
    {
        var lw = string_width(final_lines[| j]);
        if (lw > max_line_width) max_line_width = lw;
    }

    var total_h = n_lines * line_h;

    var tsw = max(1, ceil(max_line_width));
    var tsh = max(1, ceil(total_h));

    var tmp = surface_create(tsw, tsh);
    surface_set_target(tmp);
    draw_clear_alpha(c_black, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);

    var yy = 0;
    for (var k = 0; k < n_lines; k++)
    {
        draw_text(0, yy, final_lines[| k]);
        yy += line_h;
    }

    surface_reset_target();


    var dx = w/2 - tsw/2;
    var dy = box_y + pad_y + (inner_h - tsh)/2;

    draw_surface(tmp, dx, dy);
    surface_free(tmp);


    surface_reset_target();

    var final_sprite = sprite_create_from_surface(surf, 0, 0, w, h, false, false, 0, 0);

    ds_list_destroy(words);
    ds_list_destroy(final_lines);
    surface_free(surf);

    return final_sprite;
}
