if (variable_global_exists("game_over") && global.game_over) {
	global.can_create = false;
	exit;
}

if(global.can_create) {
	global.can_create = false;
	if (current_card == array_length(parsed)) {
		var _next_batch = scrCardsTakeBatch();
		if (array_length(_next_batch) > 0) {
			parsed = _next_batch;
			current_card = 0;
		}
		global.can_create = true;
	} else {
		scrCreateCard(parsed[current_card]);
		current_card++;
		global.turns_timer++;
	}
}
	
