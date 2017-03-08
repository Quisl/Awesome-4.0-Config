# Awesome4.0Config

This setup is used on a Thinkpad T410 with Debian 9. If you use any other setup you might need to change parts of this configuration.

To check all available hotkeys press [Windows Key] + [s]

HOW TO INSTALL:


install required packages:


$ apt-get install xbacklight

$ apt-get install lua-socket


Also make sure the Adwaita icons are installed. If you want to use other icons you will need to edit the .lua files manually:


$ apt-get install gnome-themes-standard


Type:


$ git clone https://github.com/Quisl/Awesome4.0Config.git ~/.config/awesome

$ cd ~/.config/awesome/


Then edit the first lines in ~/.config/awesome/rc.lua to configurate. You can get an openweathermap key from https://openweathermap.org/. If you don't want to use the weather widget just leave the concerning lines empty.

Finally hit [Windows Key] + [CTRL] + [r] to reload.
