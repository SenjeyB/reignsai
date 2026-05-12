
var dt = 1 / global.gamefps;
var alpha = clamp(smoothing_speed * dt, 0, 1);

for (var i = 0; i < n_bars; ++i) {
    var key = bar_keys[i];
    var newval = global.stat[key];

    if (newval != bar_target[i]) {
        var diff = newval - bar_target[i];
        if (abs(diff) >= change_threshold) {
            bar_change_amount[i] = diff;
            bar_change_timer[i] = change_display_time;
        }
        bar_target[i] = newval;
    }

    bar_display[i] += (bar_target[i] - bar_display[i]) * alpha;

    if (bar_change_timer[i] > 0) {
        bar_change_timer[i] -= 1;
    }
    if (bar_war_timer[i] > 0) {
        bar_war_timer[i] -= 1;
    }
    if (bar_ability_timer[i] > 0) {
        bar_ability_timer[i] -= 1;
    }
}

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
war_icon_hover = point_in_rectangle(_mx, _my, war_icon_x1, war_icon_y1, war_icon_x2, war_icon_y2);
