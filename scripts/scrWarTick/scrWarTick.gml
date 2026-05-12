function scrIsEternalWar() {
    if (!variable_global_exists("current_abilities") || !is_array(global.current_abilities)) return false;
    for (var i = 0; i < array_length(global.current_abilities); i++) {
        if (global.current_abilities[i] == ETERNAL_WAR) return true;
    }
    return false;
}

function scrWarTick() {
    if (!variable_global_exists("status")) return;
    if (global.status[IN_WAR] <= 0) return;

    var _militia_dmg = -irandom_range(1, 3);
    var _other_dmg   = -irandom_range(1, 2);
    var _other_id    = choose(RESOURCES, SUPPORT, SCIENCE);

    scrApplyWarStatChange(ARMY_POWER, _militia_dmg);
    if (variable_global_exists("game_over") && global.game_over) return;
    scrApplyWarStatChange(_other_id, _other_dmg);
    if (variable_global_exists("game_over") && global.game_over) return;

    global.status[IN_WAR] -= 1;
    if (scrIsEternalWar()) global.status[IN_WAR] = 1;
}
