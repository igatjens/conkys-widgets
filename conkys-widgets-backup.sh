#!/bin/bash

#cambiar el separador de estructuras de control de espacio a salto de línea
IFS='
'

carpeta_conky_nombre=".conky"
carpeta_respaldo_nombre=".conky-backup"
archivo_respaldo_nombre=$(date +%Y-%m-%d_%H-%M-%S)

echo -e "\n**Respaldo de widgets de conky**\n"
echo "Iniciando respaldo de pocisión, tamaño y fondo de los widgets"

for usuario in $(ls /home); do

	if [ $usuario != "lost+found" ]; then

		carpeta_widgets_conky="/home/$usuario/$carpeta_conky_nombre/"

		#comprobar si hay carpeta de conky
		if [ -d $carpeta_widgets_conky ]; then

			#crear carpeta de respaldos si no existe
			carpeta_respaldos=/home/$usuario/$carpeta_respaldo_nombre
			mkdir -p $carpeta_respaldos

			#crear archivo de respaldo
			archivo_respaldo=$carpeta_respaldos/$archivo_respaldo_nombre
			touch $archivo_respaldo
			
			for j in $(find $carpeta_widgets_conky -type f ); do
			
				widget=$(grep -E "^[\ \t]*TEXT" $j)

				#si es un widget de conky
				if [[ $widget ]]; then

					filtrar_comentados="^[\ \t]*\#.*[a-z A-Z]"

					alignment=$(grep alignment $j |  grep -v -E "$filtrar_comentados" | cut -d " " -f 2)

					gap_x=$(grep gap_x $j |  grep -v -E "$filtrar_comentados" | cut -d " " -f 2)
					gap_y=$(grep gap_y $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2)

					own_window_transparent=$(grep own_window_transparent $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2)
					own_window_colour=$(grep own_window_colour $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2)
					own_window_argb_visual=$(grep own_window_argb_visual $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2)
					own_window_argb_value=$(grep own_window_argb_value $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2)

					minimum_size=$(grep minimum_size $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2,3)
					
					echo $j\;$alignment\;$gap_x\;$gap_y\;$own_window_transparent\;$own_window_colour\;$own_window_argb_visual\;$own_window_argb_value\;$minimum_size >> $archivo_respaldo


				fi
			
			done

			respaldo_vacio=$(cat $archivo_respaldo)

			#si el respaldo está vacío, entonces borrarlo
			if [[ -z $respaldo_vacio ]]; then
				
				rm $archivo_respaldo
				echo "Error: Archivo de respaldo "$archivo_respaldo" está vacio"
				echo "No se guardó ningún respaldo de los widgets de conky en "$carpeta_widgets_conky
				echo "Resplado "$archivo_respaldo" eliminado"

			else
				echo "Respaldo de los widgets de conky en "$carpeta_widgets_conky" completado exitosamente"
				echo "Respaldado en: "$archivo_respaldo

			fi

			chown -R $usuario:$usuario $carpeta_respaldos

		else
			echo "Advertencia: $carpeta_widgets_conky no existe."
		fi

	fi

done
