
//
persistent = true;

// variaveis do objeto:
menu = noone;
menu_page = noone;

// preparando as paginas do menu
initial_index = 0;
options_index = 1;
quit_index = 2;

// variáveis dos botões no geral
var _button_size_x = sprite_get_width(spr_button);
var _button_size_y = sprite_get_height(spr_button);
var _button_margin_x = RES_W * .02;
var _button_margin_y = RES_H * .05;
var _button_xo = RES_W * .5; // posicao x inicial fixa.
var _button_yo = RES_H * .5 // posicão y inicial fixa.

// iniciando o menu inicial;


var _initial_text = ["start", "options", "quit"];
var _initial_quantity = array_length(_initial_text);

var _initial_triggers = [
    function () {
        transition_create(rm_gameplay);
    },

    function () {
        menu.change_index(options_index);
    },

    function () {
      menu.change_index(quit_index); 
    },
];

var _initial_size = (_initial_quantity * _button_size_y * .5) + (_initial_quantity - 1) * _button_margin_y;
var _initial_ystart = (RES_H - _initial_size) / 2;
var _initial_buttons = [];

for (var i = 0; i < _initial_quantity; i++) {
    var _button_pos_y = _initial_ystart + i * (_button_size_y + _button_margin_y);
    _initial_buttons[i] = new Button(_button_xo, _button_pos_y, _initial_text[i], spr_button, _initial_triggers[i]);
}

initial_menu = new Menu(_initial_buttons);


// menu de opções:

// botao slider


volume_slider = new Slider(_button_xo, RES_H * .35, RES_W * .2, spr_sound_icon);
volume_slider.value = global.volume;

var _slider_size = sprite_get_height(spr_slider) + _button_margin_x;

var _options_text = ["alternar fullscreen", "voltar"];
var _options_quantity = array_length(_options_text);
var _options_size = (_options_quantity * _button_size_y * .5) + (_options_quantity - 1) * _button_margin_y;
var _options_ystart = _slider_size + (RES_H - _options_size)  / 2

var _options_triggers = [
    function () {
        global.fullscreen = !global.fullscreen
        ini_open("save");
        ini_write_real("save1", "fullscreen", global.fullscreen);
        ini_close();
    },

    function () {
        menu.change_index(initial_index);
    }
];

options_menu = new Menu();
options_menu.add_button(volume_slider)

for (var i = 0; i < _options_quantity; i++) {
    var _button_pos_y = _options_ystart + i * (_button_size_y + _button_margin_y);
    var _button = new Button(_button_xo, _button_pos_y, _options_text[i], spr_button, _options_triggers[i]);
    options_menu.add_button(_button);
}

;

// menu para quitar:

var _quit_text = ["sim", "nao"];
var _quit_quantity = array_length(_quit_text);
var _quit_size = (_quit_quantity * _button_size_y * .5) + (_quit_quantity - 1) * _button_margin_y;
var _quit_ystart = (RES_H - _quit_size) / 2;
var _quit_triggers = [
    function () {
        game_end()
    },

    function () {
        menu.change_index(initial_index);
    },
];

var _quit_buttons = [];


for (var i = 0; i < _quit_quantity; i++) {
    var _button_pos_y = _quit_ystart + i * (_button_size_y + _button_margin_y);
    _quit_buttons[i] = new Button(_button_xo, _button_pos_y, _quit_text[i]);
    _quit_buttons[i].trigger = _quit_triggers[i];
}

var _txt_pos_x = RES_W * .5;
var _txt_pos_y = RES_H * .2;
var _quit_message = new TextElement("tem certeza que deseja sair?", fnt_default, _txt_pos_x, _txt_pos_y);

quit_menu = new Menu();
quit_menu.add_button(_quit_buttons);
quit_menu.add_element(_quit_message);

// iniciando o menu da room inicial:
var _main_pages = [initial_menu, options_menu, quit_menu];
main_menu = new IndexMenu();
main_menu.add_pages(_main_pages);



// iniciando o menu in_game:
var _return_x = RES_W * .5;
var _return_y = RES_H * .5;
var _return_button = new Button(_return_x, _return_y, "return", spr_button, function () { transition_create(rm_main_menu) });
in_game_menu = new Menu();
in_game_menu.add_button(_return_button);

// aqui vamos checar se o player está fazendo uso do teclado:
keyboard_cooldown = 3 * game_get_speed(gamespeed_fps);
set_keyboard_use = function () {
    if (keyboard_check_pressed(vk_anykey)) {
        global.using_keyboard = true;
        alarm[0] = keyboard_cooldown;
    }
}

// tocando som pra mostrar q o slider funciona:
audio_play_sound(snd_music, 1, 1);
audio_sound_gain(snd_music, global.volume, 0);

// setando o volume:
set_volume = function () {
    if (global.volume != volume_slider.value) { 
        global.volume = volume_slider.value;
        audio_sound_gain(snd_music, global.volume, 1);
        ini_open("save");
        ini_write_real("save1", "volume", global.volume);
        ini_close();

    };
    
}


