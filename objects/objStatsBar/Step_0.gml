
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
}
