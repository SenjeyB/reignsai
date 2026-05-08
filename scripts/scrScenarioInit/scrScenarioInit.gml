function scrScenarioInit(_multipliers){
	global.stat_maximum[RESOURCES] = floor(_multipliers[RESOURCES] * 100);
	global.stat_maximum[SUPPORT] = floor(_multipliers[SUPPORT] * 100);
	global.stat_maximum[ARMY_POWER] = floor(_multipliers[ARMY_POWER] * 100);
	global.stat_maximum[SCIENCE] = floor(_multipliers[SCIENCE] * 100);
	
	
	global.stat = [
		floor(global.stat_maximum[RESOURCES] / 2), 
		floor(global.stat_maximum[SUPPORT] / 2), 
		floor(global.stat_maximum[ARMY_POWER] / 2), 
		floor(global.stat_maximum[SCIENCE] / 2)
	];
	global.run_start_stat = [global.stat[0], global.stat[1], global.stat[2], global.stat[3]];
	global.run_stats_recorded = false;
	global.turns_timer = 0;
	global.start_month_index = irandom(11);

	var _parents_count = (variable_global_exists("selected_parents") && is_array(global.selected_parents)) ? array_length(global.selected_parents) : 0;
	if (global.player_iterations <= 2 || _parents_count < 2) {
		global.player_name = scrNamesGenerateRandom();
	} else {
		global.player_name = scrNamesGenerateInherited(global.selected_parents[0], global.selected_parents[1]);
	}
	
	global.game_over = false;
	global.game_over_ambient_played = false;
	global.game_over_card_pending = false;
	global.game_over_card_data = undefined;
	
	global.choices_done = [0, 0, 0, 0]; 
	
	instance_create_layer(x, y, "instances", objCardCreator);
	instance_create_layer(x, y, "instances", objStatsBar);
	instance_create_layer(x, y, "instances", objLoadingSpinner);
}
