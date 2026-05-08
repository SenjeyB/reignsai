var _game_over_now = variable_global_exists("game_over") && global.game_over;
var _is_waiting = (instance_number(objBaseCard) <= 0) && !_game_over_now;

if (_is_waiting) {
    wait_timer += 1;
} else {
    wait_timer = 0;
}

spinner_angle += spin_speed;
if (spinner_angle >= 360) spinner_angle -= 360;

var _target = (wait_timer >= delay_frames) ? 1.0 : 0.0;
visible_alpha = lerp(visible_alpha, _target, 0.15);
