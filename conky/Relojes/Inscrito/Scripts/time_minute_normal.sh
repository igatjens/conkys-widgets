#!/bin/bash
#Match time to an image by blitz http://blitz-bomb.deviantart.com/

Time=$(date +'%M')
ImageSize="190x120" #Image size
ImagePos="244,171" #Image position
ImageLocation="~/.conky/Relojes/Inscrito/Scripts/images" #Where the clock numbers are
echo "\${image $ImageLocation/b$Time.png -p $ImagePos -s $ImageSize}"