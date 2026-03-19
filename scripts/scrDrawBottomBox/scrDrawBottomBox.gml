function scrDrawBottomBox(_text, _font)
{
	var box_w_pct = 0.86;
	var box_h_pct = 0.18;

	var sw = display_get_gui_width();
	var sh = display_get_gui_height();

	var box_w = sw * clamp(box_w_pct, 0.05, 1);
	var box_h = sh * clamp(box_h_pct, 0.03, 0.6);
	var box_x = (sw - box_w) * 0.5;
	var box_y = sh - box_h - (sh * 0.03);

	var pad_x = box_w * 0.08;
	var pad_y = box_h * 0.10;
	var inner_w = box_w - pad_x * 2;
	var inner_h = box_h - pad_y * 2;

	var words = ds_list_create();
	var pos = 1;
	var len = string_length(_text);
	while (pos <= len)
	{
	    while (pos <= len && string_char_at(_text, pos) == " ") pos++;
	    if (pos > len) break;
	    var s = pos;
	    while (pos <= len && string_char_at(_text, pos) != " ") pos++;
	    ds_list_add(words, string_copy(_text, s, pos - s));
	}
	if (ds_list_size(words) == 0) ds_list_add(words, " ");

	var use_dynamic = is_string(_font);
	var used_font = -1;
	var line_h = 16;

	if (use_dynamic)
	{
	    var max_test_size = min(32, floor(inner_h));
	    var min_test_size = 6;
	    var low = min_test_size;
	    var high = max_test_size;
	    var best_size = -1;
	    var best_font = -1;

	    while (low <= high)
	    {
	        var mid = floor((low + high) * 0.5);
	        var f = __get_cached_font(_font, mid);
	        if (f == -1) { high = mid - 1; continue; }
	        draw_set_font(f);
	        var lh = string_height("Ay"); if (lh <= 0) lh = 1;

	        var too_large = false;
	        var lines_needed = 0;
	        var cur = "";
	        var wc = ds_list_size(words);
	        for (var i = 0; i < wc; i++)
	        {
	            var wword = words[| i];
	            if (string_width(wword) > inner_w) { too_large = true; break; }
	            var cand = (cur == "") ? wword : cur + " " + wword;
	            if (string_width(cand) <= inner_w) cur = cand;
	            else { lines_needed++; cur = wword; }
	        }
	        if (!too_large && cur != "") lines_needed++;
	        var fits = (!too_large) && (lines_needed * lh <= inner_h);

	        if (fits) { best_size = mid; best_font = f; low = mid + 1; }
	        else { high = mid - 1; }
	    }

	    if (best_size == -1)
	    {
	        best_size = min_test_size;
	        best_font = __get_cached_font(_font, best_size);
	    }

	    used_font = best_font;
	    draw_set_font(used_font);
	    line_h = string_height("Ay"); if (line_h <= 0) line_h = 16;
	}
	else
	{
	    used_font = _font;
	    if (used_font != -1) draw_set_font(used_font);
	    line_h = string_height("Ay"); if (line_h <= 0) line_h = 16;
	}

	var final_lines = ds_list_create();
	var cur2 = "";
	var wc2 = ds_list_size(words);
	for (var i2 = 0; i2 < wc2; i2++)
	{
	    var wword2 = words[| i2];
	    var cand2 = (cur2 == "") ? wword2 : cur2 + " " + wword2;
	    if (string_width(cand2) <= inner_w) cur2 = cand2;
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
	if (ds_list_size(final_lines) == 0) ds_list_add(final_lines, " ");

	var n_lines = ds_list_size(final_lines);
	var max_line_width = 0;
	for (var j = 0; j < n_lines; j++)
	{
	    var lw = string_width(final_lines[| j]);
	    if (lw > max_line_width) max_line_width = lw;
	}
	var total_h = n_lines * line_h;
	var start_x = box_x + (box_w - max_line_width) * 0.5;
	var start_y = box_y + pad_y + (inner_h - total_h) * 0.5;

	var old_font = draw_get_font();
	var old_color = draw_get_color();
	var old_halign = draw_get_halign();
	var old_valign = draw_get_valign();

	var border = 4;
	draw_set_color(c_black);
	draw_rectangle(box_x, box_y, box_x + box_w, box_y + box_h, false);
	draw_rectangle(box_x + border, box_y + border, box_x + box_w - border, box_y + box_h - border, false);
	draw_set_color(c_white);
	draw_rectangle(box_x + 1, box_y + 1, box_x + box_w - 1, box_y + box_h - 1, true);

	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	var yy = start_y;
	for (var k = 0; k < n_lines; k++)
	{
	    draw_text(start_x, yy, final_lines[| k]);
	    yy += line_h;
	}

	if (old_font != -1) draw_set_font(old_font);
	draw_set_color(old_color);
	draw_set_halign(old_halign);
	draw_set_valign(old_valign);

	ds_list_destroy(words);
	ds_list_destroy(final_lines);
}