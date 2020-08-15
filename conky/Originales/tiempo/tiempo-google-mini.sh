#!/bin/sh

ubicacion_consulta=$(cat ubicacion.txt  | sed -e 's/\ \ */\ /g' -e 's/^\ *//g' -e 's/\ *$//g' -e 's/[,.;]//g' -e 's/[Ññ]/n/g' -e 's/\ /+/g' -e 's/^/+/g')

html_crudo=$(tclsh obtener_tiempo_google.tcl $ubicacion_consulta)

ubicacion=$(echo $html_crudo | sed -e 's/wob_loc/>\n\n<wob_loc/g' -e 's/<\/div>/<\/div>\n\n/g' | grep wob_loc | sed -e 's/<[^>]*>//g')

imagen0=$(echo $html_crudo | sed -e 's/wob_tci/wob_tci>\n\n</g' -e 's/<img/\n\n<img/g' | grep wob_tci | sed -e 's/src="/\nhttps:/' -e 's/png"/png\n/' | sed -e '1d' -e '3d')

#echo $imagen0

wget -O tiempo-mini0.png $imagen0

temperatura_actual=$(echo $html_crudo | sed -e 's/wob_tm/>\n\n<wob_tm/g' -e 's/<\/span>/<\/span>\n\n/g' | grep wob_tm | sed -e 's/<[^>]*>//g')

condicion_actual=$(echo $html_crudo | sed -e 's/wob_dc/>\n\n<wob_dc/g' -e 's/<\/div>/<\/div>\n\n/g' | grep wob_dc | sed '1d' | sed -e 's/<[^>]*>//g')

viento_actual=$(echo $html_crudo | sed -e 's/wob_ws/>\n\n<wob_ws/g' -e 's/<\/span>/<\/span>\n\n/g' | grep wob_ws | sed -e 's/<[^>]*>//g')

humedad_actual=$(echo $html_crudo | sed -e 's/wob_hm/>\n\n<wob_hm/g' -e 's/<\/span>/<\/span>\n\n/g' | grep wob_hm | sed -e 's/<[^>]*>//g')

precipitacion_actual=$(echo $html_crudo | sed -e 's/wob_pp/>\n\n<wob_pp/g' -e 's/<\/span>/<\/span>\n\n/g' | grep wob_pp | sed -e 's/<[^>]*>//g')

actualizacion=$(date +"%A %H:%M")

echo "\t\t\t"$temperatura_actual ºC"\n\n"$condicion_actual"\n"
echo "Viento:            \t   "$viento_actual
echo "Humedad:           \t"$humedad_actual
echo "Prob. de lluvia:   \t "$precipitacion_actual
ubicacion_etiqueta=$(echo $ubicacion | sed -e 's/,\ /\\n/g')
echo "\n"$ubicacion_etiqueta
echo $actualizacion