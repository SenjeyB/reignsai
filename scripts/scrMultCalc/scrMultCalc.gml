function scrMultCalc(_struct_a, _struct_b) {
    var _stats = ["resources", "support", "army", "science"];
    var _averages = {};
    var _values = [];

    for (var i = 0; i < array_length(_stats); i++) {
        var _stat = _stats[i];
        
        var _val_a = variable_struct_exists(_struct_a.choices_done, _stat) ? _struct_a.choices_done[$ _stat] : 0;
        var _val_b = variable_struct_exists(_struct_b.choices_done, _stat) ? _struct_b.choices_done[$ _stat] : 0;
        
        var _avg = (_val_a + _val_b) / 2;
        _averages[$ _stat] = _avg;
        array_push(_values, _avg);
    }

    var _min_val = 0;
    var _max_val = 0;
    
    if (array_length(_values) > 0) {
        _min_val = _values[0];
        _max_val = _values[0];
        for (var i = 1; i < array_length(_values); i++) {
            _min_val = min(_min_val, _values[i]);
            _max_val = max(_max_val, _values[i]);
        }
    }

    var _d_total = abs(_min_val) + abs(_max_val);
    if (abs(_d_total) < 0.0001) {
        var _multipliers = {};
        for (var i = 0; i < array_length(_stats); i++) {
             _multipliers[i] = 1.0;
        }
        return _multipliers;
    }
    
    var _multipliers = {};

    var _scale_positive = 0.75 / _d_total; 
    var _scale_negative = 0.50 / _d_total; 
    
    for (var i = 0; i < array_length(_stats); i++) {
        var _stat = _stats[i];
        var _avg = _averages[$ _stat];
        var _multiplier = 1.0;
        
        if (_avg > 0) {
            _multiplier = 1.0 + (_avg * _scale_positive);
        } else if (_avg < 0) {
            _multiplier = 1.0 - (abs(_avg) * _scale_negative);
        }
        
        _multiplier = clamp(_multiplier, 0.5, 1.75);
        
        _multipliers[i] = _multiplier;
    }
    
    return _multipliers;
}