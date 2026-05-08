if (!instance_exists(objBgScroller)) instance_create_layer(0, 0, "Instances", objBgScroller);

title_text = "MODULE GUIDE";

body_lines = [
    "> Watch the core. Keep it stable.",
    "> Each card is a request. Slide left or right to decide.",
    "> Four meters: Coffers, Support, Militia, Science.",
    "> If any meter empties or fills - the core trips.",
    "> Months pass with every decision. Years stack.",
];

lore_lines = [
    "// While the realm draws breath, its people generate Essence.",
    "// The Module harvests what living minds discard.",
    "// Reign well - there is more to extract than you know.",
];

button_back_w = 260;
button_back_h = 56;
button_back_x1 = (display_get_gui_width() - button_back_w) * 0.5;
button_back_y1 = display_get_gui_height() - button_back_h - 46;
button_back_x2 = button_back_x1 + button_back_w;
button_back_y2 = button_back_y1 + button_back_h;
