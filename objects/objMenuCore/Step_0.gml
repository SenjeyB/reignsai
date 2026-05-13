if (room != rmMainMenu && room != rmStatsMenu && room != rmSettingsMenu && room != rmTutorialMenu) {
    instance_destroy();
    exit;
}

core_time += 1;

var _has_runs = false;
if (variable_global_exists("parents") && ds_exists(global.parents, ds_type_map)) {
    _has_runs = ds_map_size(global.parents) > 0;
}

if (_has_runs) {
    var _img_n = sprite_get_number(sprCore);
    if (time == 0) {
        if (light > _img_n) {
            light = 0;
            time = 180;
            radius *= 2;
            circle_width = 0;
        } else {
            light += 0.3;
        }
        radius += light * 2;
    } else {
        time -= 1;
    }
    angle += 1;
    radius = lerp(radius, 48, 0.1);

    var _n_runs = ds_map_size(global.parents);
    var _spark_interval = max(8, 52 - _n_runs * 4);

    spark_spawn_timer += 1;
    if (spark_spawn_timer >= _spark_interval) {
        spark_spawn_timer = 0;
        var _cx = display_get_gui_width() * 0.5;
        var _cy = display_get_gui_height() * 0.42;
        var _ang = random(360);
        var _dist = 60 + random(50);
        var _sp = 0.4 + random(0.6);
        array_push(sparks, {
            x: _cx + lengthdir_x(_dist, _ang),
            y: _cy + lengthdir_y(_dist, _ang),
            vx: lengthdir_x(_sp, _ang),
            vy: lengthdir_y(_sp, _ang) - 0.2,
            life: 50 + irandom(30),
            max_life: 50 + irandom(30)
        });
    }

    if (_n_runs >= 10) {
        lightning_spawn_timer -= 1;
        if (lightning_spawn_timer <= 0) {
            lightning_spawn_timer = irandom_range(60, 140);
            var _lcx = display_get_gui_width() * 0.5;
            var _lcy = display_get_gui_height() * 0.32;
            var _bolt_count = irandom_range(1, 3);
            for (var _b = 0; _b < _bolt_count; _b++) {
                var _ang_b = random(360);
                var _length_b = 150 + random(170);
                var _seg_count = irandom_range(5, 9);
                var _segments = [];
                var _prev_x = _lcx;
                var _prev_y = _lcy;
                for (var _k = 1; _k <= _seg_count; _k++) {
                    var _t = _k / _seg_count;
                    var _base_x = _lcx + lengthdir_x(_length_b * _t, _ang_b);
                    var _base_y = _lcy + lengthdir_y(_length_b * _t, _ang_b);
                    var _jitter = (_k < _seg_count) ? irandom_range(-20, 20) : 0;
                    var _px = _base_x + lengthdir_x(_jitter, _ang_b + 90);
                    var _py = _base_y + lengthdir_y(_jitter, _ang_b + 90);
                    array_push(_segments, { x1: _prev_x, y1: _prev_y, x2: _px, y2: _py });
                    _prev_x = _px;
                    _prev_y = _py;
                }
                var _thick = 1.2 + random(1.4);
                var _life_b = 32 + irandom(22);
                array_push(lightning_bolts, {
                    segments: _segments,
                    life: _life_b,
                    max_life: _life_b,
                    thick: _thick
                });
            }
        }
    }
} else {
    light = lerp(light, 0, 0.4);
    circle_width = 0;
}

var _alive = [];
for (var i = 0; i < array_length(sparks); i++) {
    var s = sparks[i];
    s.x += s.vx;
    s.y += s.vy;
    s.life -= 1;
    if (s.life > 0) array_push(_alive, s);
}
sparks = _alive;

var _alive_bolts = [];
for (var i = 0; i < array_length(lightning_bolts); i++) {
    var b = lightning_bolts[i];
    b.life -= 1;
    if (b.life > 0) array_push(_alive_bolts, b);
}
lightning_bolts = _alive_bolts;
