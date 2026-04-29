button_width = 320;
button_height = 64;
button_gap = 24;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _center_x = _gw * 0.5;
var _start_y = _gh * 0.5 - button_height - (button_gap * 0.5);

button_start_x1 = _center_x - (button_width * 0.5);
button_start_y1 = _start_y;
button_start_x2 = button_start_x1 + button_width;
button_start_y2 = _start_y + button_height;

button_exit_x1 = _center_x - (button_width * 0.5);
button_exit_y1 = button_start_y2 + button_gap;
button_exit_x2 = button_exit_x1 + button_width;
button_exit_y2 = button_exit_y1 + button_height;

slider_width = button_width;
slider_height = 24;
slider_gap = 64;
slider_label_offset = 22;

slider_music_x1 = _center_x - (slider_width * 0.5);
slider_music_y1 = button_exit_y2 + 72;
slider_music_x2 = slider_music_x1 + slider_width;
slider_music_y2 = slider_music_y1 + slider_height;

slider_sfx_x1 = slider_music_x1;
slider_sfx_y1 = slider_music_y1 + slider_gap;
slider_sfx_x2 = slider_music_x2;
slider_sfx_y2 = slider_sfx_y1 + slider_height;

drag_music_slider = false;
drag_sfx_slider = false;
start_transition_active = false;
start_transition_timer = 0;
start_transition_duration = max(1, ceil(game_get_speed(gamespeed_fps) * 0.15));
start_glitch_instance = -1;

scrAudioEnsureDefaults();
if (!instance_exists(objMusController)) instance_create_layer(0, 0, "Instances", objMusController);
if (!instance_exists(objSndController)) instance_create_layer(0, 0, "Instances", objSndController);
scrInitApiSession();
scrGetParents();

title_text = "REIGNS AI";
if (variable_global_exists("parents") && ds_exists(global.parents, ds_type_map) && ds_map_size(global.parents) > 0) {
    button_start_text = "Restart the Module";
} else {
    button_start_text = "Start the Module";
}
button_exit_text = "Exit";
