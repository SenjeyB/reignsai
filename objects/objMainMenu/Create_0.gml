button_width = 360;
button_height = 62;
button_gap = 18;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _center_x = _gw * 0.5;
var _stack_h = (button_height * 4) + (button_gap * 3);
var _start_y = (_gh * 0.7) - (_stack_h * 0.5);

button_start_x1 = _center_x - (button_width * 0.5);
button_start_y1 = _start_y;
button_start_x2 = button_start_x1 + button_width;
button_start_y2 = _start_y + button_height;

button_stats_x1 = button_start_x1;
button_stats_y1 = button_start_y2 + button_gap;
button_stats_x2 = button_stats_x1 + button_width;
button_stats_y2 = button_stats_y1 + button_height;

button_settings_x1 = button_start_x1;
button_settings_y1 = button_stats_y2 + button_gap;
button_settings_x2 = button_settings_x1 + button_width;
button_settings_y2 = button_settings_y1 + button_height;

button_exit_x1 = button_start_x1;
button_exit_y1 = button_settings_y2 + button_gap;
button_exit_x2 = button_exit_x1 + button_width;
button_exit_y2 = button_exit_y1 + button_height;

start_transition_active = false;
start_transition_timer = 0;
start_transition_duration = max(1, ceil(game_get_speed(gamespeed_fps) * 0.15));
start_glitch_instance = -1;

if (!variable_global_exists("menu_reveal_active")) global.menu_reveal_active = false;
if (!variable_global_exists("menu_reveal_timer")) global.menu_reveal_timer = 0;
if (!variable_global_exists("menu_reveal_duration")) global.menu_reveal_duration = max(1, ceil(game_get_speed(gamespeed_fps) * 0.5));

scrAudioEnsureDefaults();
if (!instance_exists(objBgScroller)) instance_create_layer(0, 0, "Instances", objBgScroller);
if (!instance_exists(objMenuCore)) instance_create_layer(0, 0, "Instances", objMenuCore);
if (!instance_exists(objMusController)) instance_create_layer(0, 0, "Instances", objMusController);
if (!instance_exists(objSndController)) instance_create_layer(0, 0, "Instances", objSndController);
if (!instance_exists(objCardRequester)) instance_create_layer(0, 0, "Instances", objCardRequester);
scrCardsEnsureState();
if (!variable_global_exists("cards_bootstrap_done")) global.cards_bootstrap_done = false;
if (!variable_global_exists("cards_refresh_on_mainmenu")) global.cards_refresh_on_mainmenu = false;
if (string_length(global.api_last_error) > 0) {
    global.cards_bootstrap_done = false;
    global.api_session_init_attempted = false;
    global.api_session_init_pending = false;
    scrApiClearError();
}
var _need_cards_bootstrap = (!global.cards_bootstrap_done) || global.cards_refresh_on_mainmenu;
if (_need_cards_bootstrap) {
    global.cards_prefetch_enabled = true;
    scrCardsEnsureQueue();
    global.cards_bootstrap_done = true;
    global.cards_refresh_on_mainmenu = false;
}
scrGetParents();
scrRunStatsLoad();

title_text = "MODULE WATCHER";
if (variable_global_exists("parents") && ds_exists(global.parents, ds_type_map) && ds_map_size(global.parents) > 0) {
    button_start_text = "Restart the Module";
    start_is_restart = true;
} else {
    button_start_text = "Start the Module";
    start_is_restart = false;
}
button_stats_text = "Statistics";
button_settings_text = "Settings";
button_exit_text = "Exit";
