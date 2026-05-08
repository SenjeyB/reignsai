function scrGameOver(){
	global.can_create = false;
	global.game_over = true;

	scrRunStatsRecordRun();
	scrSaveParent();

	var _name_str = "";
	if (variable_global_exists("player_name") && is_struct(global.player_name)) {
		_name_str = scrNamesFormat(global.player_name);
	}
	var _situation_text = (string_length(_name_str) > 0)
		? "The reign of " + _name_str + " has come to an end. The kingdom remembers."
		: "Your reign has come to an end. The kingdom remembers your rule.";

	var _go_card = {
		situation: _situation_text,
		desc_opt1: "Shut down the Module, QUICK!",
		desc_opt2: "All Cores are going down! Turn off the Module!",
		stats_opt1: [],
		stats_opt2: []
	};
	_go_card.stats_opt1[ARMY_POWER] = 0;
	_go_card.stats_opt1[SUPPORT]    = 0;
	_go_card.stats_opt1[RESOURCES]  = 0;
	_go_card.stats_opt1[SCIENCE]    = 0;
	_go_card.stats_opt2[ARMY_POWER] = 0;
	_go_card.stats_opt2[SUPPORT]    = 0;
	_go_card.stats_opt2[RESOURCES]  = 0;
	_go_card.stats_opt2[SCIENCE]    = 0;

	global.game_over_card_data = _go_card;

	if (variable_global_exists("current_card_id") && instance_exists(global.current_card_id)) {
		with (global.current_card_id) {
			is_exiting_up = true;
			exit_timer = 0;
		}
		global.game_over_card_pending = true;
	} else {
		global.game_over_card_pending = false;
		scrCreateCard(global.game_over_card_data);
	}

	if (!global.game_over_ambient_played) {
		if (!audio_is_playing(sndPeopleAmbient)) {
			scrAudioPlaySfx(sndPeopleAmbient);
		}
		global.game_over_ambient_played = true;
	}
}
