function scrCardChoice(_choice) {
	var is_game_over = false;
	for (i = 0; i < 4; i++) {
		scrChangeStat(i,  _choice[i]);
		if (_choice[i] > 0) {
			global.choices_done[i]++;
		} else if (_choice[i] < 0) {
			global.choices_done[i]--;
		}
	}	
	if (is_game_over) {
		scrGameOver();
	}
	global.can_create = true;
    instance_destroy();
}