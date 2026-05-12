if (!mouse_check_button_released(mb_left)) exit;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (point_in_rectangle(_mx, _my, button_back_x1, button_back_y1, button_back_x2, button_back_y2)) {
    scrAudioPlayButton();
    room_goto(rmSettingsMenu);
}
