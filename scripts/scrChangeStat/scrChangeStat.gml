function scrChangeStat(_id, choice) {
	show_debug_message(string(global.unemotional_commumity));
	if(_id == SUPPORT && global.unemotional_commumity == true) return;
	global.stat[_id] += choice * 2;
	if (global.stat[_id] >= global.stat_maximum[_id] || global.stat[_id] <= 0) {
		scrGameOver();
	}
}

function scrApplyAbilityStatChange(_id, _amount, _ability_id) {
	if (_id == SUPPORT && global.unemotional_commumity == true) return;
	global.stat[_id] += _amount;

	var _spr = -1;
	if (variable_global_exists("ability_sprite") && is_array(global.ability_sprite)
		&& _ability_id >= 0 && _ability_id < array_length(global.ability_sprite)) {
		_spr = global.ability_sprite[_ability_id];
	}

	if (instance_exists(objStatsBar)) {
		with (objStatsBar) {
			for (var i = 0; i < n_bars; i++) {
				if (bar_keys[i] == _id) {
					bar_target[i] = global.stat[_id];
					bar_ability_amount[i] = _amount;
					bar_ability_timer[i] = change_display_time;
					bar_ability_sprite[i] = _spr;
					break;
				}
			}
		}
	}

	if (global.stat[_id] >= global.stat_maximum[_id] || global.stat[_id] <= 0) {
		scrGameOver();
	}
}

function scrApplyWarStatChange(_id, _amount) {
	if (_id == SUPPORT && global.unemotional_commumity == true) return;
	global.stat[_id] += _amount;

	if (instance_exists(objStatsBar)) {
		with (objStatsBar) {
			for (var i = 0; i < n_bars; i++) {
				if (bar_keys[i] == _id) {
					bar_target[i] = global.stat[_id];
					bar_war_amount[i] = _amount;
					bar_war_timer[i] = change_display_time;
					break;
				}
			}
		}
	}

	if (global.stat[_id] >= global.stat_maximum[_id] || global.stat[_id] <= 0) {
		scrGameOver();
	}
}