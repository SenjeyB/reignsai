function scrCalendarEnsureStart() {
    if (!variable_global_exists("start_month_index")) {
        global.start_month_index = irandom(11);
    }
}

function scrCalendarMonthIndex() {
    scrCalendarEnsureStart();
    var _turns = 0;
    if (variable_global_exists("turns_timer")) _turns = real(global.turns_timer);
    return (global.start_month_index + _turns) mod 12;
}

function scrCalendarReignYear() {
    var _turns = 0;
    if (variable_global_exists("turns_timer")) _turns = real(global.turns_timer);
    return _turns div 12;
}

function scrCalendarMonthName() {
    var _names = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ];
    return _names[scrCalendarMonthIndex()];
}

function scrCalendarMonthIndexAt(_offset) {
    scrCalendarEnsureStart();
    var _turns = 0;
    if (variable_global_exists("turns_timer")) _turns = real(global.turns_timer);
    return (((global.start_month_index + _turns + _offset) mod 12) + 12) mod 12;
}

function scrCalendarMonthNameAt(_offset) {
    var _names = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ];
    return _names[scrCalendarMonthIndexAt(_offset)];
}

function scrCalendarMonthColor() {
    var _colors = [
        make_color_rgb(110, 140, 165),
        make_color_rgb(120, 145, 160),
        make_color_rgb(105, 150, 105),
        make_color_rgb( 95, 150,  85),
        make_color_rgb(135, 160,  75),
        make_color_rgb(170, 155,  65),
        make_color_rgb(175, 140,  55),
        make_color_rgb(170, 120,  50),
        make_color_rgb(155, 100,  45),
        make_color_rgb(140,  75,  40),
        make_color_rgb(105,  60,  55),
        make_color_rgb( 90,  90, 120)
    ];
    return _colors[scrCalendarMonthIndex()];
}
