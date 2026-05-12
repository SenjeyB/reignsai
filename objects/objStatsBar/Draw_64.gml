draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(fntPS2P_stats)

var bx = gui_x;
var by = gui_y;

if (variable_global_exists("player_name") && is_struct(global.player_name)) {
    var _name_text = scrNamesFormat(global.player_name);
    if (string_length(_name_text) > 0) {
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(make_color_rgb(20, 20, 20));
        draw_text(bx + 1, by - 26 + 1, _name_text);
        draw_set_color(make_color_rgb(230, 230, 230));
        draw_text(bx, by - 26, _name_text);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
    }
}

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

    if (bar_war_timer[i] > 0) {
        var wt = bar_war_timer[i] / change_display_time;
        var wa = wt;
        var wdiff = bar_war_amount[i];
        var w_sign = wdiff >= 0 ? "+" : "";
        var w_txt = w_sign + string(wdiff);
        var w_popup_x = bx + bar_width + 36;
        var w_popup_y = y_top - 14 - (1 - wt) * 14;

        draw_set_alpha(wa);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(20, 0, 0));
        draw_text(w_popup_x + 1, w_popup_y + h/2 + 1, w_txt);
        draw_set_color(make_color_rgb(245, 110, 90));
        draw_text(w_popup_x, w_popup_y + h/2, w_txt);

        var _w_text_w = string_width(w_txt);
        var _icon_scale_w = 1.5;
        var _war_icon_x = w_popup_x + _w_text_w + 10 + (12 * _icon_scale_w);
        var _war_icon_y = w_popup_y + h/2;
        var _prev_filter = gpu_get_tex_filter();
        gpu_set_tex_filter(false);
        draw_sprite_ext(sprAbilityIntervention, 0, _war_icon_x, _war_icon_y, _icon_scale_w, _icon_scale_w, 0, c_white, wa);
        gpu_set_tex_filter(_prev_filter);

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(1);
    }

    if (bar_ability_timer[i] > 0) {
        var abt = bar_ability_timer[i] / change_display_time;
        var aba = abt;
        var abdiff = bar_ability_amount[i];
        var ab_sign = abdiff >= 0 ? "+" : "";
        var ab_txt = ab_sign + string(abdiff);
        var ab_popup_x = bx + bar_width + 36;
        var ab_popup_y = y_top - (1 - abt) * 14;

        draw_set_alpha(aba);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(0, 20, 30));
        draw_text(ab_popup_x + 1, ab_popup_y + h/2 + 1, ab_txt);
        draw_set_color(abdiff >= 0 ? make_color_rgb(120, 230, 255) : make_color_rgb(240, 200, 110));
        draw_text(ab_popup_x, ab_popup_y + h/2, ab_txt);

        var _ab_text_w = string_width(ab_txt);
        var _icon_scale_a = 1.5;
        var _ab_icon_x = ab_popup_x + _ab_text_w + 10 + (12 * _icon_scale_a);
        var _ab_icon_y = ab_popup_y + h/2;
        var _ab_spr = bar_ability_sprite[i];
        if (sprite_exists(_ab_spr)) {
            var _prev_filter_a = gpu_get_tex_filter();
            gpu_set_tex_filter(false);
            draw_sprite_ext(_ab_spr, 0, _ab_icon_x, _ab_icon_y, _icon_scale_a, _icon_scale_a, 0, c_white, aba);
            gpu_set_tex_filter(_prev_filter_a);
        }

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(1);
    }
}

var month_y_top = by + n_bars * (bar_height + bar_spacing) + month_bar_extra_gap;
var month_h = bar_height;
var month_col = scrCalendarMonthColor();

var mr = color_get_red(month_col);
var mg = color_get_green(month_col);
var mb = color_get_blue(month_col);
var month_light = make_color_rgb(
    floor(lerp(mr, 255, 0.25)),
    floor(lerp(mg, 255, 0.25)),
    floor(lerp(mb, 255, 0.25))
);

draw_set_alpha(0.95);
draw_set_color(make_color_rgb(38, 38, 38));
draw_rectangle(bx, month_y_top, bx + bar_width, month_y_top + month_h, false);
draw_rectangle_color(
    bx, month_y_top, bx + bar_width, month_y_top + month_h,
    month_light, month_light, month_col, month_col, false
);
draw_set_color(make_color_rgb(28, 28, 28));
draw_rectangle(bx, month_y_top, bx + bar_width, month_y_top + month_h, true);

draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var month_txt = scrCalendarMonthName() + ", Year " + string(scrCalendarReignYear());
var month_tx = bx + bar_width * 0.5;
var month_ty = month_y_top + month_h * 0.5;
draw_set_color(make_color_rgb(18, 18, 18));
draw_text(month_tx + 1, month_ty + 1, month_txt);
draw_set_color(make_color_rgb(230, 230, 230));
draw_text(month_tx, month_ty, month_txt);

if (variable_global_exists("status") && global.status[IN_WAR] > 0) {
    var _gw_local = display_get_gui_width();
    var _war_icon_size = 32 * 2;
    var _war_x = _gw_local * 0.5;
    var _war_y = 56;
    war_icon_x1 = _war_x - _war_icon_size * 0.5;
    war_icon_y1 = _war_y - _war_icon_size * 0.5;
    war_icon_x2 = _war_x + _war_icon_size * 0.5;
    war_icon_y2 = _war_y + _war_icon_size * 0.5;

    var _prev_filter_w = gpu_get_tex_filter();
    gpu_set_tex_filter(false);
    draw_sprite_ext(sprAbilityIntervention, 0, _war_x, _war_y, _war_icon_size / 24, _war_icon_size / 24, 0, c_white, 1);
    gpu_set_tex_filter(_prev_filter_w);

    var _no_go = !variable_global_exists("game_over") || !global.game_over;
    if (war_icon_hover && _no_go) {
        var _war_txt = scrIsEternalWar()
            ? "Currently at Eternal War."
            : "Currently in War. " + string(global.status[IN_WAR]) + " months left.";
        scrDrawBottomBox(_war_txt, fntPS2P_stats);
    }
} else {
    war_icon_x1 = 0;
    war_icon_y1 = 0;
    war_icon_x2 = 0;
    war_icon_y2 = 0;
}

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
