if (available_turn < global.turns_timer) {
	if (ability_mode == PASSIVE && global.can_use_passive == true) {
		scrUseAbility(ability_type);
	}
}