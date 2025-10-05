#macro SET_FULLSCREEN if (window_get_fullscreen() != global.fullscreen) window_set_fullscreen(global.fullscreen)

// checando se o mouse está em uma área
function mouse_gui_hover_range (_pos_x, _pos_y, _range_x, _range_y) {
    var _m_pos_x = MOUSE_GUI_X;
    var _m_pos_y = MOUSE_GUI_Y;
    
    var _m_hover_x = _m_pos_x == clamp(_m_pos_x, _pos_x - _range_x, _pos_x + _range_x);
    var _m_hover_y = _m_pos_y == clamp(_m_pos_y, _pos_y - _range_y, _pos_y + _range_y);  
    
    return _m_hover_x and _m_hover_y;
}
// botoes
function GUIElement () constructor { // clase abstrata que todos elementos da gui possuem!

    menu = noone;
    selected = false;
    
    reset = function () {

    }
    
    run = function () { // step
        
    }
    
    draw = function () {
        
    }
}

#region GUI GERAL


// botões

function Button (_xx, _yy, _text = "", _sprite = spr_button, _trigger = function () { }, _par_menu = noone) : GUIElement() constructor {
    menu = _par_menu;
    sprite = _sprite;
    image_index = 0;
    image_timer = 0;
    text = _text;
    text_info = "";
    
    x = _xx;
    y = _yy;
    
    pos_angle = 0;
    angle_to = 0;
    angle = 0;
    hovered = false;
    
    pos_scale = new Vector2(0, 0);
    scale_to = new Vector2(1, 1);
    scale = new Vector2(1, 1);
    
    selected = false;
    trigger = _trigger;  
    
    static add_to_menu = function () {
        if !(is_instanceof(menu, Menu)) {
            menu = noone;
            return;
        }    
        
        menu.add_button(self);
    }
    
    add_to_menu();
    
    reset = function () {
        scale.set(scale_to.x, scale_to.y);
        angle = angle_to;
        pos_angle = 0;
        image_timer = 0;
    }
    
    on_hover = function () {
        var _sprite_w = sprite_get_width(sprite) * .5;
        var _sprite_h = sprite_get_height(sprite) * .5;
        
        return mouse_gui_hover_range(x, y, _sprite_w, _sprite_h);
    }
    
    can_click = function () {
        return true;
    }
    
    //efeito que acontece quando o botao é clicado
    get_click = function () {
        
        var _angle_to = 8;
        var _scale_x_to = 1.1;
        var _scale_y_to = .9;
        var _blink_time = 10;
        
        angle = _angle_to;
        scale.x = _scale_x_to;
        scale.y = _scale_y_to;
        image_timer = _blink_time;    
    }
    
    // efeito que acontece quando o hover é ativado
    get_hover = function () {
        
        var _angle_to = 5;
        var _scale_to = 1.12;
        
        angle = _angle_to;
        scale.x = _scale_to;
        scale.y = _scale_to;   
    }
    
    // controlando sprite
    set_sprite = function () {
        image_timer = max(0, image_timer - 1);
        image_index = image_timer > 0;
        
        pos_angle = lerp(pos_angle, (angle_to - angle) * .5, .1);
        angle += pos_angle;
        
        pos_scale.x = lerp(pos_scale.x, (scale_to.x - scale.x) * .7, .3);
        pos_scale.y = lerp(pos_scale.y, (scale_to.y - scale.y) * .7, .3);        
        scale.add(pos_scale);
    }
    
    set_info = function () {
        
    }
    
    // controlando game_feel
    set_hover = function () {
        var _can_select = selected and global.using_keyboard;
        var _selected = _can_select and ENTER;
        var _clicked = MOUSE_LEFT_CLICK and on_hover();
        
        if (on_hover() or _can_select) { 
            if !(hovered) {
                get_hover();
                hovered = true;
                
                if (on_hover()) global.using_keyboard = false;
                    
                return;
            }
     
            if (_clicked or _selected) { 
                get_click(); 
                trigger();      
            }
                
            return;
        }
        
        hovered = false;
    }       
    
    // step
    run = function () {
        var _scale_to = 1 + (global.using_keyboard * selected * .2);
        scale_to.set(_scale_to, _scale_to);
        
        set_sprite();
        set_hover(); 
    }

    
    draw = function () {
        
        var _text_separator = sprite_get_height(sprite) * scale.x * .25;
        
        gpu_set_fog(image_timer > 0, c_white, 0, 1);
        draw_sprite_ext(sprite, image_index, x, y, scale.x, scale.y, angle, -1, 1);
        draw_set_halign(1);
        draw_set_valign(1);
        
        draw_set_font(fnt_default);
        draw_text_ext_transformed(x, y, text + text_info, _text_separator, sprite_get_width(spr_button), 1, 1, 0);
        draw_set_font(-1);
        
        draw_set_halign(-1);
        draw_set_valign(-1);
        gpu_set_fog(false, c_black, 0, 1);
        
        // DEBUG
    }
    
}


// slider
function Slider (_xx, _yy, _size_x, _icon, _par_menu) : Button (_xx, _yy, "", spr_slider,, _par_menu) constructor  {
    value = 1;
    size = _size_x;
    
    x = _xx;
    y = _yy;
    
    icon = _icon;
    holding = false;
    
    bar = spr_slider;
    button = spr_slider_button;
    spr_width = sprite_get_width(bar)
    xscale = _size_x / spr_width;
    
    initial_x = x - (spr_width * xscale * .5);
    final_x = x + spr_width * xscale * .5;
    
    on_hover = function () {
        return mouse_gui_hover_range(x, y, size * .5, sprite_get_height(spr_slider) * .5);
    }
    
    run = function () {
        var _clicked = on_hover() and MOUSE_LEFT_CLICK;
        var _selected = global.using_keyboard and selected;
        
        if (_clicked) holding = true;
        
        if (holding) {
            set_value()
            
            if (MOUSE_LEFT_RELEASE) holding = false;
            return;
        }
            
        if (_selected) {
            var _right = keyboard_check(vk_right);
            var _left = keyboard_check(vk_left);
            value += (_right - _left) * .01;
        }
    }
    
    set_value = function () {
        value = (MOUSE_GUI_X - initial_x) / (final_x - initial_x);
        value = clamp(value, 0, 1);
    }
    
    draw = function () {
        draw_sprite(spr_sound_icon, 0, x - size * .8, y);
        draw_sprite_ext(bar, 0, x, y, xscale, 1, 0, -1 ,1);
        var _button_x = initial_x + size * value;
        draw_sprite(spr_slider_button, 0, _button_x, y);
        draw_set_color(-1); 
        
    } 
}

// tipos de menu

/// @param {Array} _buttons

function Menu (_buttons = [], _elements = []) constructor {
    
    y_off = 0;
    pos_yoff = 0;
    y_off_to = 0;
    parent = noone; // variável controla se este menu é página de outro menu
    
    buttons = _buttons;
    elements = _elements;
    total_elements = array_concat(buttons, elements);
    button_index = 0;
    // 
    for (var i = 0; i < array_length(buttons); i++) {
        buttons[i].menu = self;
    }
    
    reset = function () {
        button_index = 0;
        for (var i = 0; i < array_length(buttons); i++) {
            buttons[i].reset();
        }
    }
    
    add_button = function (_button) {
        var _index = array_length(buttons);
        if (is_array(_button)) {
            for (var i = 0; i < array_length(_button); i++) {
                _index = array_length(buttons);
                buttons[_index] = _button[i];
                buttons[_index].menu = self;
            }
            
            return;
        }
        
        buttons[_index] = _button;
        buttons[_index].menu = self;
    }
    
    add_element = function (_element) {
        
        var _index = array_length(elements);
        
        if (is_array(_element)) {
            for (var i = 0; i < array_length(_element); i++) {
                _index = array_length(elements);
                elements[_index] = _element[i];
                elements[_index].menu = self;
            }
            
            return;
        }
        
        elements[_index] = _element;
        elements[_index].menu = self;
    }
    
    run = function () {
        
        var _up = keyboard_check_pressed(vk_up);
        var _down = keyboard_check_pressed(vk_down);
        
        button_index += (_down - _up);
        button_index = max(0, min(array_length(buttons) - 1, button_index));
        
        total_elements = array_concat(buttons, elements);
        
        for (var i = 0; i < array_length(buttons); i++) {
            buttons[i].run();
            if (i == button_index) {
                buttons[i].selected = true;
                continue;
            }
          
            buttons[i].selected = false;
        }
        
        for (var i = 0; i < array_length(elements); i++) {
            elements[i].run();
        }
    }
    
    draw_elements = function () {
        for (var i = 0; i < array_length(total_elements); i++) {
            total_elements[i].draw();
        }  
    }
    
    draw = function () {
        draw_elements();
    }
}


/// @param {Array} _pages Uma lista de menus que será anexada como páginas.
function IndexMenu (_pages = [], _buttons = []) : Menu (_buttons) constructor {
    index = 0;
    menus = _pages;
    buttons = _buttons; // botoes permanentes

    change_index = function (_index) {
        index = _index;
        if (is_instanceof(menus[index], Menu)) {
            menus[index].reset();
        }
    }
    
    // setando os botoes
    
    // setando os menus:
    for (var i = 0; i < array_length(menus); i++) {
        if (menus[i] != noone) menus[i].parent = self;
    }
    
    add_pages = function (_pages) {
        if (is_array(_pages)) {
            for (var i = 0; i < array_length(_pages); i++) {
                _pages[i].parent = self;
                menus[array_length(menus)] = _pages[i];
            }
            
            return;
        }
        
        _pages.parent = self;
        menus[array_length(menus)] = _pages;
    }
    
    run = function () {
        if (is_instanceof(menus[index], Menu)) {
            menus[index].run();
        }
    }
    
    draw = function () {
        draw_elements();
        
        if (index != noone) {
            menus[index].draw();
        }
    }
}

function TextElement (_text, _font, _xx, _yy) : GUIElement () constructor  {
    
    text = _text;
    font = _font;
    x = _xx;
    y = _yy;
    
    draw = function () {
        draw_set_font(font);
        draw_set_halign(1);
        draw_set_valign(1);
        draw_text(x, y, text);
        draw_set_halign(-1);
        draw_set_valign(-1);
        draw_set_font(-1);
    }
}

