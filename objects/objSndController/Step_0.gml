var _fps = max(1, game_get_speed(gamespeed_fps));

if (room != rmScenario) {
	ambient_timer = _fps * 60;
	exit;
}

if (!variable_global_exists("game_over") || global.game_over) {
	ambient_timer = _fps * 60;
	exit;
}

ambient_timer -= 1;
if (ambient_timer > 0) exit;

ambient_timer = _fps * 60;
if (irandom(1) == 1) exit;
if (audio_is_playing(sndCandleAmbient) || audio_is_playing(sndPeopleAmbient)) exit;

scrAudioPlaySfx(choose(sndCandleAmbient, sndPeopleAmbient));
