function scrGameOver(){
	if (instance_exists(global.current_card_id)) instance_destroy(global.current_card_id);
	global.can_create = false;
	global.game_over = true;

	var _name_str = "";
	if (variable_global_exists("player_name") && is_struct(global.player_name)) {
		_name_str = scrNamesFormat(global.player_name);
	}
	var _situation_text = (string_length(_name_str) > 0)
		? "The reign of " + _name_str + " has come to an end. The kingdom remembers."
		: "Your reign has come to an end. The kingdom remembers your rule.";

	var _game_over_card = {
		situation: _situation_text,
		desc_opt1: "Shut down the Module, QUICK!",
		desc_opt2: "All Cores are going down! Turn off the Module!",
		stats_opt1: [],
		stats_opt2: []
	};
	_game_over_card.stats_opt1[ARMY_POWER] = 0;
	_game_over_card.stats_opt1[SUPPORT]    = 0;
	_game_over_card.stats_opt1[RESOURCES]  = 0;
	_game_over_card.stats_opt1[SCIENCE]    = 0;
	_game_over_card.stats_opt2[ARMY_POWER] = 0;
	_game_over_card.stats_opt2[SUPPORT]    = 0;
	_game_over_card.stats_opt2[RESOURCES]  = 0;
	_game_over_card.stats_opt2[SCIENCE]    = 0;

	scrRunStatsRecordRun();
	scrSaveParent();
	scrCreateCard(_game_over_card);

	if (!global.game_over_ambient_played) {
		if (!audio_is_playing(sndPeopleAmbient)) {
			scrAudioPlaySfx(sndPeopleAmbient);
		}
		global.game_over_ambient_played = true;
	}
}
