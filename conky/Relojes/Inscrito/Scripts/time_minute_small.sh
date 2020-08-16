#!/bin/bash
#Match time to an image by blitz http://blitz-bomb.deviantart.com/

Time=$(date +'%M')
ImageSize="65x42" #Image size
ImagePos="80,56" #Image position
ImageLocation="~/.conky/Relojes/Inscrito/Scripts/images/small" #Where the clock numbers are
echo "\${image $ImageLocation/b$Time.png -p $ImagePos -s $ImageSize}"