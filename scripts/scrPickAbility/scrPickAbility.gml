function scrPickAbility(_type) {
	return global.ability_list[_type, irandom(array_length(global.ability_list[_type]) - 1)];
}
