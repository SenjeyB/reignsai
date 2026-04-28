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

scrAudioEnsureDefaults();
if (!instance_exists(objMusController)) instance_create_layer(0, 0, "Instances", objMusController);
if (!instance_exists(objSndController)) instance_create_layer(0, 0, "Instances", objSndController);

title_text = "REIGNS AI";
button_start_text = "Start game";
button_exit_text = "Exit";
