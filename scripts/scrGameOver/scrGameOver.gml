function scrGameOver(){
	if (instance_exists(global.current_card_id)) instance_destroy(global.current_card_id);
	global.can_create = false;
	var game_over_card = scrParseJson("game_over.json");
	scrSaveParent();
	scrCreateCard(game_over_card[0]);
	global.game_over = true;
}