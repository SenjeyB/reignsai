draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(fntPS2P_stats)

var bx = gui_x;
var by = gui_y;

for (var i = 0; i < n_bars; ++i) {
    var name = bar_names[i];
    var col = bar_colors[i];
    var maxv = bar_max[i];
    var val = bar_display[i];
    var _frac = clamp(val / maxv, 0, 1);

    var pulse = 1;
    if (bar_change_timer[i] > 0) {
        pulse = 1 + 0.08 * (bar_change_timer[i] / change_display_time);
    }

    var h = bar_height * pulse;
    var y_top = by + i * (bar_height + bar_spacing);

    draw_set_alpha(0.95);
    draw_set_color(make_color_rgb(38, 38, 38));
    draw_rectangle(bx, y_top, bx + bar_width, y_top + h, false);

    var cr = color_get_red(col);
    var cg = color_get_green(col);
    var cb = color_get_blue(col);
    var lr = floor(lerp(cr, 255, 0.25));
    var lg = floor(lerp(cg, 255, 0.25));
    var lb = floor(lerp(cb, 255, 0.25));
    var col_light = make_color_rgb(lr, lg, lb);
    var dr = floor(lerp(cr, 0, 0.06));
    var dg = floor(lerp(cg, 0, 0.06));
    var db = floor(lerp(cb, 0, 0.06));
    var col_dark = make_color_rgb(dr, dg, db);
    var fillw = bx + bar_width * _frac;
    draw_rectangle_color(bx, y_top, fillw, y_top + h,
                         col_light, col_light, col, col, false);
    draw_set_color(make_color_rgb(28,28,28));
    draw_rectangle(bx, y_top, bx + bar_width, y_top + h, true);

    draw_set_alpha(1);
    var txt = name + "  " + string(round(val)) + " / " + string(maxv);
    var txt_x = bx + bar_width * 0.5;
    var txt_y = y_top + h * 0.5;

    draw_set_color(make_color_rgb(18,18,18));
    draw_text(txt_x + 1, txt_y + 1, txt);
    draw_set_color(make_color_rgb(230,230,230));
    draw_text(txt_x, txt_y, txt);

    if (bar_change_timer[i] > 0) {
        var t = bar_change_timer[i] / change_display_time; 
        var a = t;
        draw_set_alpha(a);
        var diff = bar_change_amount[i];
        var _sign = diff >= 0 ? "+" : "";
        var txt_diff = _sign + string(diff);
        var popup_x = clamp(fillw + 8, bx + 8, bx + bar_width - 8);
        var popup_y = y_top - (1 - t) * 14;
        draw_set_color(diff >= 0 ? make_color_rgb(160,240,160) : make_color_rgb(240,160,160));
        draw_set_alpha(a);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text(popup_x + 1, popup_y + h/2 + 1, txt_diff);
        draw_set_color(diff >= 0 ? make_color_rgb(120,200,120) : make_color_rgb(200,120,120));
        draw_text(popup_x, popup_y + h/2, txt_diff);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(1);
    }
}

// сброс стилей
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
