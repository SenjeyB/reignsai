function scrPickAbility(_type) {
	if (random(1) < 0.10) {
		var _total = 0;
		for (var i = 0; i < array_length(global.ability_list); i++) {
			_total += array_length(global.ability_list[i]);
		}
		var _pick = irandom(_total - 1);
		for (var j = 0; j < array_length(global.ability_list); j++) {
			var _len = array_length(global.ability_list[j]);
			if (_pick < _len) return global.ability_list[j, _pick];
			_pick -= _len;
		}
	}
	return global.ability_list[_type, irandom(array_length(global.ability_list[_type]) - 1)];
}
