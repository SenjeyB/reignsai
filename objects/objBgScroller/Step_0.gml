if (room != rmMainMenu && room != rmStatsMenu && room != rmSettingsMenu && room != rmTutorialMenu) {
    instance_destroy();
    exit;
}

var _sh = sprite_get_height(sprBgTile);
scroll_y += scroll_speed;
if (scroll_y >= _sh) scroll_y -= _sh;
