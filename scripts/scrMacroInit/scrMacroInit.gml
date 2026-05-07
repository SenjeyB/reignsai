function scrMacroInit() {
	randomize();

	global.stat_name = [];
	
	#macro RESOURCES 0
	global.stat_name[RESOURCES] = "Coffers";
	
	#macro SUPPORT 1
	global.stat_name[SUPPORT] = "Support";
	
	#macro ARMY_POWER 2
	global.stat_name[ARMY_POWER] = "Militia";
	
	#macro SCIENCE 3
	global.stat_name[SCIENCE] = "Science";
	
	global.start_room = rmMainMenu;
	global.current_abilities = [-1, -1, -1, -1];
	global.ability_mode = [];
	global.ability_name = [];
	global.ability_descripton = [];
	global.ability_cooldown = [];
	global.status = [];
	global.status_name = [];
	
	// Statuses
	#macro IN_WAR 0
	global.status[IN_WAR] = 0;
	global.status_name[IN_WAR] = "In War";
	
	// Abilities globals
	global.can_use_passive = false;
	global.unemotional_commumity = false;
	global.payed_taxes = 0;
	global.turns_timer = 0;
	
	#macro PASSIVE 0
	#macro ACTIVE 1
	
	
	// Abilities
	#macro ETERNAL_WAR 0
	global.ability_mode[ETERNAL_WAR] = PASSIVE;
	global.ability_name[ETERNAL_WAR] = "Eternal War";
	global.ability_descripton[ETERNAL_WAR] = "You are in the constant war! Brace yourself!";
	global.ability_cooldown[ETERNAL_WAR] = 0;
	
	#macro UNEMOTIONAL_COMMUNITY 1
	global.ability_mode[UNEMOTIONAL_COMMUNITY] = PASSIVE;
	global.ability_name[UNEMOTIONAL_COMMUNITY] = "Unemotional Community";
	global.ability_descripton[UNEMOTIONAL_COMMUNITY] = "1984";
	global.ability_cooldown[UNEMOTIONAL_COMMUNITY] = 0;
	
	#macro MANHATTAN_PROJECT 2
	global.ability_mode[MANHATTAN_PROJECT] = ACTIVE;
	global.ability_name[MANHATTAN_PROJECT] = "MANHATTAN PROJECT";
	global.ability_descripton[MANHATTAN_PROJECT] = "Investing in science for war purposes!";
	global.ability_cooldown[MANHATTAN_PROJECT] = 5;
	
	#macro PAY_TAXES 3
	global.ability_mode[PAY_TAXES] = ACTIVE;
	global.ability_name[PAY_TAXES] = "Pay taxes";
	global.ability_descripton[PAY_TAXES] = "Time to pay taxes! People won't like it";
	global.ability_cooldown[PAY_TAXES] = 2;
	
	#macro BRIBERY 4
	global.ability_mode[BRIBERY] = ACTIVE;
	global.ability_name[BRIBERY] = "Bribery";
	global.ability_descripton[BRIBERY] = "Corruption practices are condemned, but we cannot ban it...";
	global.ability_cooldown[BRIBERY] = 1;
	
	#macro PUBLIC_SPEECH 5
	global.ability_mode[PUBLIC_SPEECH] = ACTIVE;
	global.ability_name[PUBLIC_SPEECH] = "Public Speech";
	global.ability_descripton[PUBLIC_SPEECH] = "Some pep talk to throw dust in the eyes";
	global.ability_cooldown[PUBLIC_SPEECH] = 5;
	
	#macro SCIENTIFIC_AMBITIONS 6
	global.ability_mode[SCIENTIFIC_AMBITIONS] = PASSIVE;
	global.ability_name[SCIENTIFIC_AMBITIONS] = "Scientific ambitions";
	global.ability_descripton[SCIENTIFIC_AMBITIONS] = "Put your life on scientific progress!";
	global.ability_cooldown[SCIENTIFIC_AMBITIONS] = 0;
	
	#macro INTERVENTION 7
	global.ability_mode[INTERVENTION] = ACTIVE;
	global.ability_name[INTERVENTION] = "Intervention";
	global.ability_descripton[INTERVENTION] = "Diplomatic is not an option. Declare a new war!";
	global.ability_cooldown[INTERVENTION] = 10;
	
	global.ability_list = [];
	global.ability_list[ARMY_POWER] = [ETERNAL_WAR, INTERVENTION];
	global.ability_list[RESOURCES] = [PAY_TAXES, BRIBERY];
	global.ability_list[SCIENCE] = [MANHATTAN_PROJECT, SCIENTIFIC_AMBITIONS];
	global.ability_list[SUPPORT] = [UNEMOTIONAL_COMMUNITY, PUBLIC_SPEECH];

	scrNamesLoad();
}
