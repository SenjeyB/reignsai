global.can_create = true;
parsed = scrCardsTakeBatch();
if (variable_global_exists("cards_reseed_after_restart") && global.cards_reseed_after_restart) {
    global.cards_queue = [];
    global.cards_reseed_after_restart = false;
    scrCardsUpdateReadyFlag();
    scrCardsEnsureQueue();
}
current_card = 0;
