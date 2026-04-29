global.can_create = true;
if (variable_global_exists("cards_path") && global.cards_path != "") {
    parsed = scrParseJson(global.cards_path);
} else {
    parsed = [];
}
global.create_request = true;
current_card = 0;