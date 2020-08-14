#!/bin/bash

# 
# Name: MStyle Conky II
#
# Author: Kant-o (feedback via gnome-look).
# 
# Just comment any line to remove that block from the display
# 
# Licence: GPL
#
# 1st. Column (x = 40px)
conky -c ~/.conky/Originales/Paneles_estilo_win/time.config -x 40 -y 400 -p 10
conky -c ~/.conky/Originales/Paneles_estilo_win/time.config/kernel.config -x 40 -y 285 -p 1
conky -c ~/.conky/Originales/Paneles_estilo_win/time.config/power.config -x 40 -y 135 -p 1

# 2nd. Column (x = 275px)
conky -c ~/.conky/Originales/Paneles_estilo_win/time.config/processes.config -x 275 -y 320 -p 1
conky -c ~/.conky/Originales/Paneles_estilo_win/time.config/cpumemory.config -x 275 -y 135 -p 1

# 3rd. Column (x = 510px)
conky -c ~/.conky/Originales/Paneles_estilo_win/time.config/network.config -x 510 -y 265 -p 1
conky -c ~/.conky/Originales/Paneles_estilo_win/time.config/filesystem.config -x 510 -y 135 -p 1

# 4th. Column (x = 745px)
conky -c ~/.conky/Originales/Paneles_estilo_win/time.config/weather.config -x 745 -y 248 -p 1
conky -c ~/.conky/Originales/Paneles_estilo_win/time.config/gmail.config -x 745 -y 135 -p 1

