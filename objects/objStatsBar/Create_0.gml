bar_keys   = [RESOURCES, SUPPORT, ARMY_POWER, SCIENCE];
bar_names  = global.stat_name;
bar_colors = [
    /*make_color_rgb(86,176,74),*/
	make_color_rgb(212,175,55),
    make_color_rgb(80,140,220),
    make_color_rgb(200,80,80),
    make_color_rgb(160,120,220)
];
bar_max    = [global.stat_maximum[RESOURCES], global.stat_maximum[SUPPORT], global.stat_maximum[ARMY_POWER], global.stat_maximum[SCIENCE]];

gui_x = 32;
gui_y = 32;
bar_width = 360;
bar_height = 32;
bar_spacing = 14;
label_space = 120;

smoothing_speed = 8;
change_display_time = 60;
change_threshold = 0.5;

n_bars = array_length(bar_keys);
bar_target = array_create(n_bars, 0);
bar_display = array_create(n_bars, 0);
bar_change_timer = array_create(n_bars, 0);
bar_change_amount = array_create(n_bars, 0);

for (var i = 0; i < n_bars; ++i) {
    var k = bar_keys[i];
    var val = 0;
    if (variable_global_exists("global") && array_length(global.stat) > k) {
        val = global.stat[k];
    }
    bar_target[i] = val;
    bar_display[i] = val;
    bar_change_timer[i] = 0;
    bar_change_amount[i] = 0;
}
