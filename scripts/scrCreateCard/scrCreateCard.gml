function scrCreateCard(_card_base) {
	global.can_use_passive = true;
	
	sprBaseRect = sprCardBase;

	var final_sprite = scrCreateComposedSprite(sprBaseRect, _card_base.situation, fntPS2P_stats);
	with instance_create_layer(display_get_width()/2, display_get_height()/2, "Instances", objBaseCard) {
	    sprite_index = final_sprite;
		stat = [];
		stat[0, ARMY_POWER] = _card_base.stats_opt1[ARMY_POWER];
		stat[0, SUPPORT] = _card_base.stats_opt1[SUPPORT];
		stat[0, RESOURCES] = _card_base.stats_opt1[RESOURCES];
		stat[0, SCIENCE] = _card_base.stats_opt1[SCIENCE];
		stat[1, ARMY_POWER] = _card_base.stats_opt2[ARMY_POWER];
		stat[1, SUPPORT] = _card_base.stats_opt2[SUPPORT];
		stat[1, RESOURCES] = _card_base.stats_opt2[RESOURCES];
		stat[1, SCIENCE] = _card_base.stats_opt2[SCIENCE];
		desc_opt1 = _card_base.desc_opt1;
		desc_opt2 = _card_base.desc_opt2;
		global.current_card_id = id;

		y = home_y - 1200;
		angle = choose(-1, 1) * (6 + irandom(8));
		offset = irandom_range(-20, 20);
	}

	if (!global.game_over) {
		scrAudioPlayManChance();
	}
}
