scrMacroInit();
window_set_size(1280, 720)
global.gamefps = game_get_speed(gamespeed_fps);
global.create_request = true;
scrGetParents();
instance_create_layer(x, y, "instances", objIterationsList)
