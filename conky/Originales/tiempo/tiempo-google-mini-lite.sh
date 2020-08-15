#!/bin/sh
ubicacion_consulta=$(cat ubicacion.txt  | sed -e 's/\ \ */\ /g' -e 's/^\ *//g' -e 's/\ *$//g' -e 's/[,.;]//g' -e 's/[Ññ]/n/g' -e 's/\ /+/g' -e 's/^/+/g')

html_crudo=$(tclsh obtener_tiempo_google_lite.tcl $ubicacion_consulta)

ubicacion=$(echo $html_crudo | sed -e 's/BNeawe\ tAd8D\ AP7Wnd/>\n\n<encontrado/g' -e 's/<\/span>/<\/span>\n\n/g' | grep encontrado | sed '2,$d' | sed -e 's/<[^>]*>//g')

echo $html_crudo | sed -e 's/data:image\/png;base64,/\n\nencontrado,/g' -e 's/;/\n\n/g' | grep encontrado | sed -e 's/.$//g' -e 's/encontrado,//' > tiempo-lite0.base64

base64 -d -i tiempo-lite0.base64 > tiempo-lite0.png

temperatura_actual=$(echo $html_crudo | sed -e 's/BNeawe\ iBp4i\ AP7Wnd/>\n\n<encontrado/g' -e 's/<\/div>/<\/div>\n\n/g' | grep encontrado | sed '1d' | sed -e 's/<[^>]*>//g')

condicion_actual=$(echo $html_crudo | sed -e 's/BNeawe\ tAd8D\ AP7Wnd/>\n\n<encontrado/g' -e 's/<\/div>/<\/div>\n\n/g'| grep encontrado | sed -e '1,2d' -e '4,$d' | sed -e 's/<[^>]*>//g' | cut -d " " -f 3-15)

actualizacion=$(date +"%A %H:%M")

echo "\t\t"$temperatura_actual"\n\t\t"$condicion_actual"\n"
echo $ubicacion
echo $actualizacion