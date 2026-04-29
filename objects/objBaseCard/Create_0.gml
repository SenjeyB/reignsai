card_w = sprite_width;
card_h = sprite_height;
tilt_angle = 10;
tilt_offset = sprite_width / 3;
corner_w = sprite_width / 3;
corner_h = sprite_height / 3;
corner_extend = sprite_width / 3;
angle_target = 0;
offset_target = 0;
angle = 0;
offset = 0;
smooth = 0.12;


grabbed = false;
grab_offset_x = 0;
grab_offset_y = 0;
grab_local_x = 0;
grab_local_y = 0;
grab_angle_x = 0;
grab_angle_y = 0;
grab_angle_x_t = 0;
grab_angle_y_t = 0;
grab_smooth = 0.18;
grab_tilt_angle = 45;
grab_zone_mul = 1.8;
grab_move_smooth = 0.25; 

home_x = x;
home_y = y;

screen_tilt_mul = 1.6;


rendered_desc_sprite = -1;
rendered_desc_text = "";
show_desc = false;
position = 0;
opt = noone;

is_vaporizing = false;
vapor_timer = 0;
vapor_duration = 36;
vapor_choice_idx = -1;
vapor_direction = 0;

edge_glow_left = 0;
edge_glow_right = 0;
