ini_open("save");
global.fullscreen = ini_read_real("save1", "fullscreen", 1);
global.volume = ini_read_real("save1", "volume", 1);
ini_close();