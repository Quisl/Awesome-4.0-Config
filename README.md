# Awesome4.0Config

This configuration is used on a Thinkpad T410 with Debian 9. If you use any other setup you might need to change parts of this configuration.

To check all available hotkeys press [Windows Key] + [s]

# Pre setup

install required packages:

$ apt-get install xbacklight

$ apt-get install lua-socket

$ apt-get install python

$ apt-get install redshift


Also make sure the Adwaita icons are installed. If you want to use other icons you will need to edit the .lua files manually:

$ apt-get install gnome-themes-standard



# Setup

$ git clone https://github.com/Quisl/Awesome4.0Config.git ~/.config/awesome

$ cd ~/.config/awesome/


Then edit the first lines in ~/.config/awesome/rc.lua to configurate. You can get an openweathermap key from https://openweathermap.org/. If you don't want to use the weather widget just leave the concerning lines empty.

Finally hit [Windows Key] + [CTRL] + [r] to reload.


This Theme uses following commands in the command line. So make sure these work:

$ import -window root screenshot.png

$ python

$ xbacklight -dec 5

$ xbacklight -inc 5

$ pactl set-sink-volume 0 -10%

$ pactl set-sink-volume 0 +10%

$ amixer set Master +1 toggle

$ amixer sset Master 5%+

$ amixer sset Master 5%-

$ amixer sget Master

$ redshift

$ acpi

$ bash

$ xbacklight -get

Screenshots:

![alt tag](https://quisl.files.wordpress.com/2017/03/screenshot.png)
