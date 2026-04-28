function scrGameOver(){
	if (instance_exists(global.current_card_id)) instance_destroy(global.current_card_id);
	global.can_create = false;
	global.game_over = true;
	var game_over_card = scrParseJson("game_over.json");
	scrSaveParent();
	scrCreateCard(game_over_card[0]);
	if (!global.game_over_ambient_played) {
		if (!audio_is_playing(sndPeopleAmbient)) {
			scrAudioPlaySfx(sndPeopleAmbient);
		}
		global.game_over_ambient_played = true;
	}
}
