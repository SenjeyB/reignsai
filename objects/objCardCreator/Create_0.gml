global.can_create = true;
// Use cards_path if available, otherwise start with empty array and wait
if (variable_global_exists("cards_path") && global.cards_path != "") {
    parsed = scrParseJson(global.cards_path);
} else {
    parsed = [];
}
global.create_request = true;
current_card = 0;