scrAudioEnsureDefaults();
ambient_timer = max(1, game_get_speed(gamespeed_fps)) * 60;
visible = true;

if (!variable_global_exists("glitch_transition_active")) global.glitch_transition_active = false;
if (!variable_global_exists("glitch_transition_timer")) global.glitch_transition_timer = 0;
if (!variable_global_exists("glitch_transition_duration")) global.glitch_transition_duration = 0;
if (!variable_global_exists("glitch_transition_visual_duration")) global.glitch_transition_visual_duration = 0;
if (!variable_global_exists("glitch_transition_target_room")) global.glitch_transition_target_room = -1;
if (!variable_global_exists("glitch_transition_instance")) global.glitch_transition_instance = -1;
if (!variable_global_exists("glitch_transition_sound")) global.glitch_transition_sound = -1;
if (!variable_global_exists("glitch_stripes_on")) global.glitch_stripes_on = true;
if (!variable_global_exists("glitch_stripes_timer")) global.glitch_stripes_timer = 0;
if (!variable_global_exists("glitch_stripes_phase_frames")) global.glitch_stripes_phase_frames = max(1, ceil(game_get_speed(gamespeed_fps) * 0.5));
