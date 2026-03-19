function scrUseAbility(_ability_id) {
	// Army abilities
	// Passive
	if (_ability_id == ETERNAL_WAR) {
		scrChangeStat(ARMY_POWER, 5);
		scrChangeStat(SUPPORT, -3);
		scrChangeStat(RESOURCES, -3);
		global.status[IN_WAR] = 1;
	}
	
	// Active
	if (_ability_id == INTERVENTION) {
		scrChangeStat(ARMY_POWER, -15);
		scrChangeStat(SUPPORT, -15);
		scrChangeStat(RESOURCES, 30);
		global.status[IN_WAR] = global.ability_cooldown[INTERVENTION] - 1;
		available_turn = global.turns_timer + global.ability_cooldown[INTERVENTION];
	}
	
	// Support abilities
	// Passive
	if (_ability_id == UNEMOTIONAL_COMMUNITY) {
		global.unemotional_commumity = true;
	}
	
	// Active
	if (_ability_id == PUBLIC_SPEECH) {
		scrChangeStat(SUPPORT, 15);
		available_turn = global.turns_timer + global.ability_cooldown[PUBLIC_SPEECH];
	}
	
	// Science abilities
	// Active
	if (_ability_id == MANHATTAN_PROJECT) {
		scrChangeStat(ARMY_POWER, 10);
		scrChangeStat(SUPPORT, 10);
		scrChangeStat(SCIENCE, 10);
		scrChangeStat(RESOURCES, -25);
		available_turn = global.turns_timer + global.ability_cooldown[MANHATTAN_PROJECT];
	}
	
	// Passive
	if (_ability_id == SCIENTIFIC_AMBITIONS) {
		scrChangeStat(SCIENCE, 5);
		var i = irandom(2);
		if (i == 0) scrChangeStat(RESOURCES, 5);
		else scrChangeStat(RESOURCES, -5);
	}
	
	// Resources abilities
	// Active
	if (_ability_id == PAY_TAXES) {
		scrChangeStat(SUPPORT, -3 * global.payed_taxes++);
		scrChangeStat(RESOURCES, 15);
		available_turn = global.turns_timer + global.ability_cooldown[PAY_TAXES];
	}
	
	// Active
	if (_ability_id == BRIBERY) {
		scrChangeStat(SUPPORT, -10);
		var i = irandom(2);
		if (i == 0) scrChangeStat(RESOURCES, 20);
		else scrChangeStat(RESOURCES, -10);
		available_turn = global.turns_timer + global.ability_cooldown[BRIBERY];
	}
	
}

