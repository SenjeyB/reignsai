function scrCardChoice(_choice) {
	var is_game_over = false;
	for (i = 0; i < 4; i++) {
		scrChangeStat(i,  _choice[i]);
		if (global.game_over) {
			is_game_over = true;
			break;
		}
		if (_choice[i] > 0) {
			global.choices_done[i]++;
		} else if (_choice[i] < 0) {
			global.choices_done[i]--;
		}
	}	
	if (is_game_over) {
		exit;
	}
	scrWarTick();
	if (variable_global_exists("game_over") && global.game_over) exit;
	global.can_create = true;
    instance_destroy();
}
