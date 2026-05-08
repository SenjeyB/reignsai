scrScenarioInit(global.multipliers);
with instance_create_layer(96, 544, "instances", objOption) {
	option_type = 1;
}
with instance_create_layer(1824, 544, "instances", objOption) {
	option_type = 2;
}

if (global.current_abilities[0] == -1) return;
with instance_create_layer(1640, 105, "instances", objAbility) {
	ability_type = global.current_abilities[0];
	ability_mode = global.ability_mode[ability_type];
	sprite_index = sprAbilitySlot;
	image_xscale = 1.5;
	image_yscale = 1.5;
}

if (global.current_abilities[1] == -1) return;
with instance_create_layer(1810, 105, "instances", objAbility) {
	ability_type = global.current_abilities[1];
	ability_mode = global.ability_mode[ability_type];
	sprite_index = sprAbilitySlot;
	image_xscale = 1.5;
	image_yscale = 1.5;
}