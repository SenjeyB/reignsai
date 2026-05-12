function scrUseAbility(_ability_id) {
	if (_ability_id == ETERNAL_WAR) {
		global.status[IN_WAR] = 1;
	}

	if (_ability_id == INTERVENTION) {
		scrApplyAbilityStatChange(ARMY_POWER, -15, _ability_id);
		scrApplyAbilityStatChange(SUPPORT, -15, _ability_id);
		scrApplyAbilityStatChange(RESOURCES, 30, _ability_id);
		global.status[IN_WAR] = global.ability_cooldown[INTERVENTION] - 1;
		available_turn = global.turns_timer + global.ability_cooldown[INTERVENTION];
	}

	if (_ability_id == UNEMOTIONAL_COMMUNITY) {
		global.unemotional_commumity = true;
	}

	if (_ability_id == PUBLIC_SPEECH) {
		scrApplyAbilityStatChange(SUPPORT, 15, _ability_id);
		available_turn = global.turns_timer + global.ability_cooldown[PUBLIC_SPEECH];
	}

	if (_ability_id == MANHATTAN_PROJECT) {
		scrApplyAbilityStatChange(ARMY_POWER, 10, _ability_id);
		scrApplyAbilityStatChange(SUPPORT, 10, _ability_id);
		scrApplyAbilityStatChange(SCIENCE, 10, _ability_id);
		scrApplyAbilityStatChange(RESOURCES, -25, _ability_id);
		available_turn = global.turns_timer + global.ability_cooldown[MANHATTAN_PROJECT];
	}

	if (_ability_id == SCIENTIFIC_AMBITIONS) {
		scrApplyAbilityStatChange(SCIENCE, 5, _ability_id);
		var i = irandom(2);
		if (i == 0) scrApplyAbilityStatChange(RESOURCES, 5, _ability_id);
		else scrApplyAbilityStatChange(RESOURCES, -5, _ability_id);
	}

	if (_ability_id == PAY_TAXES) {
		scrApplyAbilityStatChange(SUPPORT, -3 * global.payed_taxes++, _ability_id);
		scrApplyAbilityStatChange(RESOURCES, 15, _ability_id);
		available_turn = global.turns_timer + global.ability_cooldown[PAY_TAXES];
	}

	if (_ability_id == BRIBERY) {
		scrApplyAbilityStatChange(SUPPORT, -10, _ability_id);
		var i = irandom(2);
		if (i == 0) scrApplyAbilityStatChange(RESOURCES, 20, _ability_id);
		else scrApplyAbilityStatChange(RESOURCES, -10, _ability_id);
		available_turn = global.turns_timer + global.ability_cooldown[BRIBERY];
	}
}
