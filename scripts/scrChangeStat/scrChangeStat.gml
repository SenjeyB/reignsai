function scrChangeStat(_id, choice) {
	show_debug_message(string(global.unemotional_commumity));
	if(_id == SUPPORT && global.unemotional_commumity == true) return;
	global.stat[_id] += choice * 2;
	if (global.stat[_id] >= global.stat_maximum[_id] || global.stat[_id] <= 0) {
		scrGameOver();
	}
}