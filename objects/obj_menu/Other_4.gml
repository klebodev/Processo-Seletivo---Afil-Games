global.using_keyboard = false;

switch (room) {
    case rm_main_menu:
        menu = main_menu;
    break;
    
    case rm_gameplay:
        menu = in_game_menu;
    break;
}