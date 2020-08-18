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
			
				echo $j

				filtrar_comentados="^[[:space:]]*(\#|--).*[a-z A-Z]"
				sintaxis=""

				#verificar si es nueva sintaxis de conky
				widget=$(grep -E "^[\ \t]*conky.text[\ \t]*=[\ \t]*\[\[" $j)

				#si es un widget de conky
				if [[ $widget ]]; then
					sintaxis="sintaxis_nueva"

					alignment=$(grep alignment $j |  grep -v -E "$filtrar_comentados" | sed "s|,|\n|g" | grep -E "(^|[[:space:]]+)alignment"| cut -d "=" -f 2 | sed -n '$p')

					gap_x=$(grep gap_x $j |  grep -v -E "$filtrar_comentados" | sed "s|,|\n|g" | grep -E "(^|[[:space:]]+)gap_x"| cut -d "=" -f 2 | sed -n '$p')
					gap_y=$(grep gap_y $j | grep -v -E "$filtrar_comentados" | sed "s|,|\n|g" | grep -E "(^|[[:space:]]+)gap_y"| cut -d "=" -f 2 | sed -n '$p')

					own_window_transparent=$(grep own_window_transparent $j | grep -v -E "$filtrar_comentados" | sed "s|,|\n|g" | grep -E "(^|[[:space:]]+)own_window_transparent"| cut -d "=" -f 2 | sed -n '$p')
					own_window_colour=$(grep own_window_colour $j | grep -v -E "$filtrar_comentados" | sed "s|,|\n|g" | grep -E "(^|[[:space:]]+)own_window_colour"| cut -d "=" -f 2 | sed -n '$p')
					own_window_argb_visual=$(grep own_window_argb_visual $j | grep -v -E "$filtrar_comentados" | sed "s|,|\n|g" | grep -E "(^|[[:space:]]+)own_window_argb_visual"| cut -d "=" -f 2 | sed -n '$p')
					own_window_argb_value=$(grep own_window_argb_value $j | grep -v -E "$filtrar_comentados" | sed "s|,|\n|g" | grep -E "(^|[[:space:]]+)own_window_argb_value"| cut -d "=" -f 2 | sed -n '$p')

					minimum_width=$(grep minimum_width $j | grep -v -E "$filtrar_comentados" | sed "s|,|\n|g" | grep -E "(^|[[:space:]]+)minimum_width"| cut -d "=" -f 2 | sed -n '$p')
					minimum_height=$(grep minimum_height $j | grep -v -E "$filtrar_comentados" | sed "s|,|\n|g" | grep -E "(^|[[:space:]]+)minimum_height"| cut -d "=" -f 2 | sed -n '$p')
					
					echo $j\;$sintaxis\;$alignment\;$gap_x\;$gap_y\;$own_window_transparent\;$own_window_colour\;$own_window_argb_visual\;$own_window_argb_value\;$minimum_width\;$minimum_height\
					| sed "s|[[:space:]]||g" >> $archivo_respaldo
					
				else
					widget=$(grep -E "^[\ \t]*TEXT" $j)

					#si es un widget de conky con sintaxis vieja
					if [[ $widget ]]; then

						sintaxis="sintaxis_antigua"

						alignment=$(grep alignment $j |  grep -v -E "$filtrar_comentados" | cut -d " " -f 2)

						gap_x=$(grep gap_x $j |  grep -v -E "$filtrar_comentados" | cut -d " " -f 2)
						gap_y=$(grep gap_y $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2)

						own_window_transparent=$(grep own_window_transparent $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2)
						own_window_colour=$(grep own_window_colour $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2)
						own_window_argb_visual=$(grep own_window_argb_visual $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2)
						own_window_argb_value=$(grep own_window_argb_value $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2)

						minimum_size=$(grep minimum_size $j | grep -v -E "$filtrar_comentados" | cut -d " " -f 2,3)
						
						echo $j\;$sintaxis\;$alignment\;$gap_x\;$gap_y\;$own_window_transparent\;$own_window_colour\;$own_window_argb_visual\;$own_window_argb_value\;$minimum_size >> $archivo_respaldo


					fi
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
