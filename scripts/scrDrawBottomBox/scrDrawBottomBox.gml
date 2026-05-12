function scrDrawBottomBox(_text, _base_font)
{
	var sw = display_get_gui_width();
	var sh = display_get_gui_height();
	var text_value = is_string(_text) ? _text : string(_text);
	if (text_value == "") text_value = " ";
	var old_font = draw_get_font();
	var old_color = draw_get_color();
	var old_halign = draw_get_halign();
	var old_valign = draw_get_valign();

	var splash_w = max(1, sprite_get_width(sprSplash));
	var splash_h = max(1, sprite_get_height(sprSplash));
	var splash_scale = 1.2;
	var box_w = min(sw * 0.98, sw * 0.86 * splash_scale);
	var box_h = clamp(box_w * (splash_h / splash_w), sh * 0.14, sh * 0.28);
	var box_x = (sw - box_w) * 0.5;
	var box_y = sh - box_h;

	var pad_left = box_w * 0.21;
	var pad_right = box_w * 0.16;
	var pad_top = box_h * 0.30;
	var pad_bottom = box_h * 0.10;
	var inner_w = box_w - pad_left - pad_right;
	var inner_h = box_h - pad_top - pad_bottom;

	var words = ds_list_create();
	var pos = 1;
	var len = string_length(text_value);
	while (pos <= len) {
	    var c = string_char_at(text_value, pos);
	    if (c == "\n") {
	        ds_list_add(words, "\n");
	        pos++;
	        continue;
	    }
	    if (c == " ") {
	        pos++;
	        continue;
	    }
	    var s = pos;
	    while (pos <= len) {
	        var c2 = string_char_at(text_value, pos);
	        if (c2 == " " || c2 == "\n") break;
	        pos++;
	    }
	    ds_list_add(words, string_copy(text_value, s, pos - s));
	}
	if (ds_list_size(words) == 0) ds_list_add(words, " ");

	draw_set_font(_base_font);
	var base_h = string_height("Ay");
	if (base_h <= 0) base_h = 12;

	var max_scale = max(1, floor(inner_h / base_h));
	if (max_scale > 2) max_scale = 2;

	var _candidates = [];
	for (var _ci = max_scale; _ci >= 1; _ci--) array_push(_candidates, _ci);
	array_push(_candidates, 0.9, 0.8, 0.7, 0.6, 0.5);

	var best_scale = -1;
	for (var _ci2 = 0; _ci2 < array_length(_candidates); _ci2++) {
	    var s = _candidates[_ci2];
	    var scaled_h = base_h * s;

	    var too_large = false;
	    var lines_needed = 0;
	    var cur = "";
	    var wc = ds_list_size(words);

	    for (var i = 0; i < wc; i++) {
	        var wword = words[| i];
	        if (wword == "\n") {
	            lines_needed++;
	            cur = "";
	            continue;
	        }
	        var ww = string_width(wword) * s;
	        if (ww > inner_w) { too_large = true; break; }
	        var cand = (cur == "") ? wword : cur + " " + wword;
	        if (string_width(cand) * s <= inner_w) cur = cand;
	        else { lines_needed++; cur = wword; }
	    }
	    if (!too_large && cur != "") lines_needed++;

	    if (!too_large && lines_needed * scaled_h <= inner_h) {
	        best_scale = s;
	        break;
	    }
	}

	if (best_scale == -1) best_scale = 0.5;

	var line_h = base_h * best_scale;

	var final_lines = ds_list_create();
	var cur2 = "";
	var wc2 = ds_list_size(words);
	for (var i2 = 0; i2 < wc2; i2++) {
	    var wword2 = words[| i2];
	    if (wword2 == "\n") {
	        ds_list_add(final_lines, cur2);
	        cur2 = "";
	        continue;
	    }
	    var cand2 = (cur2 == "") ? wword2 : cur2 + " " + wword2;
	    if (string_width(cand2) * best_scale <= inner_w) cur2 = cand2;
	    else {
	        ds_list_add(final_lines, cur2);
	        cur2 = wword2;
	    }
	}
	if (cur2 != "") ds_list_add(final_lines, cur2);
	if (ds_list_size(final_lines) == 0) ds_list_add(final_lines, " ");

	var n_lines = ds_list_size(final_lines);
	var total_h = n_lines * line_h;
	var center_x = box_x + pad_left + inner_w * 0.5;
	var start_y = box_y + pad_top + (inner_h - total_h) * 0.5;
	start_y = clamp(start_y, box_y + pad_top, box_y + box_h - pad_bottom - total_h);

	draw_sprite_stretched_ext(sprSplash, 0, box_x, box_y, box_w, box_h, c_white, 0.75);

	var prev_filter = gpu_get_tex_filter();
	gpu_set_tex_filter(best_scale < 1);

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	var yy = start_y;
	for (var k = 0; k < n_lines; k++) {
	    draw_set_color(c_black);
	    draw_text_transformed(center_x + 2, yy + 2, final_lines[| k], best_scale, best_scale, 0);
	    draw_set_color(c_white);
	    draw_text_transformed(center_x, yy, final_lines[| k], best_scale, best_scale, 0);
	    yy += line_h;
	}

	gpu_set_tex_filter(prev_filter);

	if (old_font != -1) draw_set_font(old_font);
	draw_set_color(old_color);
	draw_set_halign(old_halign);
	draw_set_valign(old_valign);

	ds_list_destroy(words);
	ds_list_destroy(final_lines);
}
