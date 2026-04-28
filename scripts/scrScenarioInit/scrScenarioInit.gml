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
	
	global.game_over = false;
	global.game_over_ambient_played = false;
	
	global.choices_done = [0, 0, 0, 0]; 
	
	instance_create_layer(x, y, "instances", objCardCreator);
	instance_create_layer(x, y, "instances", objStatsBar);
}
