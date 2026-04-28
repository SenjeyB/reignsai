if(global.can_create) {
	global.can_create = false;
	if(current_card == array_length(parsed) && global.cards_ready == 1){
		parsed = scrParseJson(global.cards_path);
		current_card = 0;
		global.create_request = true;
		global.can_create = true;
	} else if (current_card == array_length(parsed) && global.cards_ready == 0) {
		global.can_create = true;
	} else if(current_card != array_length(parsed)) {
		scrCreateCard(parsed[current_card]);
		current_card++;
		global.turns_timer++;
	}
}
	