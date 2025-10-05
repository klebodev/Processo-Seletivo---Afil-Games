#macro RES_W 480
#macro RES_H 270  

#macro MOUSE_GUI_X device_mouse_x_to_gui(0)
#macro MOUSE_GUI_Y device_mouse_y_to_gui(0)




surface_resize(application_surface, RES_W, RES_H);
display_set_gui_size(RES_W, RES_H);

