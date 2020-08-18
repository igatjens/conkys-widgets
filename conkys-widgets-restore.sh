#!/bin/bash

#cambiar el separador de estructuras de control de espacio a salto de línea
IFS='
'

carpeta_conky_nombre=".conky"
carpeta_respaldo_nombre=".conky-backup"

echo -e "\n**Restauración de widgets de conky**\n"
echo "Iniciando restauración de pocisión, tamaño y fondo de los widgets"

for usuario in $(ls /home); do

	if [ $usuario != "lost+found" ]; then

		carpeta_widgets_conky="/home/$usuario/$carpeta_conky_nombre/"

		#comprobar si hay carpeta de conky
		if [ -d $carpeta_widgets_conky ]; then

			#carpeta de respaldos
			carpeta_respaldos=/home/$usuario/$carpeta_respaldo_nombre

			#comprobar si hay carpeta de respaldos
			if [[ -d $carpeta_respaldos ]]; then

				#listar sólo los archivos
				lista_respaldos=$(ls -1p $carpeta_respaldos | grep -v / )


				#si la lista no está vacía
				if [[ $lista_respaldos ]]; then
				

					respuesta_valida=0
					until ((respuesta_valida == 1)) ; do
						
						echo -e "\nRespaldos disponibles para el usuario $usuario"
						echo -e "-------------------------------------\n"
						
						contador=0
					
						for i in $lista_respaldos; do
					
							let contador+=1
							echo -e "\t"$contador\)"\t"$i
							
						done

						echo -e "\n\tC)\tCancelar restauración y aplicar la configuración por defecto"

						echo -e "\nEscriba un número entre 1 y $contador para seleccionar el respaldo, C para cancelar, en blanco para seleccionar la opción $contador."
						echo -e "\nSi no responde en 45 segundos, se seleccionará automáticamente la opción $contador"
						
						read -t 45 opcion


						if [[ -z $opcion ]]; then
							opcion=$contador
							echo "Seleccionando automáticamente el respaldo $opcion"
						fi

						if  [[ $opcion = "C" || $opcion = "c" ]]; then
							
							respuesta_valida=1
							echo "Restauración cancelada"

						elif (( 1 <= opcion && opcion <= contador)); then



							respuesta_valida=1
							respaldo_seleccionado=$carpeta_respaldos/$(echo $lista_respaldos | cut -d " " -f $opcion)

							echo -e "Restaurando desde el respaldo $opcion - $respaldo_seleccionado"

							archivo_respaldo=$(cat $respaldo_seleccionado)
							
							#si respaldo no está vacio
							if [[ archivo_respaldo ]]; then

								for widget in $archivo_respaldo; do

									echo $widget
									
									archivo_widget=$(echo $widget | cut -d ";" -f 1)

									sintaxis=$(echo $widget | cut -d ";" -f 2)

									if [[ $sintaxis = "sintaxis_nueva" ]]; then
										echo $sintaxis

										alignment=$(echo $widget | cut -d ";" -f 3)

										gap_x=$(echo $widget | cut -d ";" -f 4)
										gap_y=$(echo $widget | cut -d ";" -f 5)

										own_window_transparent=$(echo $widget | cut -d ";" -f 6)
										own_window_colour=$(echo $widget | cut -d ";" -f 7)
										own_window_argb_visual=$(echo $widget | cut -d ";" -f 8)
										own_window_argb_value=$(echo $widget | cut -d ";" -f 9)

										minimum_width=$(echo $widget | cut -d ";" -f 10)
										minimum_height=$(echo $widget | cut -d ";" -f 11)

										#echo $alignment

										sed -i "s/alignment[[:space:]]*=[[:space:]]*'[[:ascii:]]'/alignment = $alignment/" $archivo_widget

										sed -i "s/gap_x[[:space:]]*=[[:space:]]*[0-9]*/gap_x = $gap_x/" $archivo_widget
										sed -i "s/gap_y[[:space:]]*=[[:space:]]*[0-9]*/gap_y = $gap_y/" $archivo_widget

										sed -i "s/own_window_transparent[[:space:]]*=[[:space:]]*[a-zA-z]*/own_window_transparent = $own_window_transparent/" $archivo_widget
										sed -i "s/own_window_colour[[:space:]]*=[[:space:]]*'[0-9a-zA-Z]*'/own_window_colour = $own_window_colour/" $archivo_widget
										sed -i "s/own_window_argb_visual[[:space:]]*=[[:space:]]*[a-zA-z]*/own_window_argb_visual = $own_window_argb_visual/" $archivo_widget
										sed -i "s/own_window_argb_value[[:space:]]*=[[:space:]]*[0-9]*/own_window_argb_value = $own_window_argb_value/" $archivo_widget

										sed -i "s/minimum_width[[:space:]]*=[[:space:]]*[0-9]*/minimum_width = $minimum_width/" $archivo_widget
										sed -i "s/minimum_height[[:space:]]*=[[:space:]]*[0-9]*/minimum_height = $minimum_height/" $archivo_widget

									elif [[ $sintaxis = "sintaxis_antigua" ]]; then
										echo $sintaxis

										alignment=$(echo $widget | cut -d ";" -f 3)

										gap_x=$(echo $widget | cut -d ";" -f 4)
										gap_y=$(echo $widget | cut -d ";" -f 5)

										own_window_transparent=$(echo $widget | cut -d ";" -f 6)
										own_window_colour=$(echo $widget | cut -d ";" -f 7)
										own_window_argb_visual=$(echo $widget | cut -d ";" -f 8)
										own_window_argb_value=$(echo $widget | cut -d ";" -f 9)

										minimum_size=$(echo $widget | cut -d ";" -f 10)

										
										sed -i "s/alignment .*/alignment $alignment/g" $archivo_widget

										sed -i "s/gap_x .*/gap_x $gap_x/g" $archivo_widget
										sed -i "s/gap_y .*/gap_y $gap_y/g" $archivo_widget

										sed -i "s/own_window_transparent .*/own_window_transparent $own_window_transparent/g" $archivo_widget
										sed -i "s/own_window_colour .*/own_window_colour $own_window_colour/g" $archivo_widget
										sed -i "s/own_window_argb_visual .*/own_window_argb_visual $own_window_argb_visual/g" $archivo_widget
										sed -i "s/own_window_argb_value .*/own_window_argb_value $own_window_argb_value/g" $archivo_widget

										sed -i "s/minimum_size .*/minimum_size $minimum_size/g" $archivo_widget

									else

										echo formato de respaldo viejo

										alignment=$(echo $widget | cut -d ";" -f 2)

										gap_x=$(echo $widget | cut -d ";" -f 3)
										gap_y=$(echo $widget | cut -d ";" -f 4)

										own_window_transparent=$(echo $widget | cut -d ";" -f 5)
										own_window_colour=$(echo $widget | cut -d ";" -f 6)
										own_window_argb_visual=$(echo $widget | cut -d ";" -f 7)
										own_window_argb_value=$(echo $widget | cut -d ";" -f 8)

										minimum_size=$(echo $widget | cut -d ";" -f 9)

										
										sed -i "s/alignment .*/alignment $alignment/g" $archivo_widget

										sed -i "s/gap_x .*/gap_x $gap_x/g" $archivo_widget
										sed -i "s/gap_y .*/gap_y $gap_y/g" $archivo_widget

										sed -i "s/own_window_transparent .*/own_window_transparent $own_window_transparent/g" $archivo_widget
										sed -i "s/own_window_colour .*/own_window_colour $own_window_colour/g" $archivo_widget
										sed -i "s/own_window_argb_visual .*/own_window_argb_visual $own_window_argb_visual/g" $archivo_widget
										sed -i "s/own_window_argb_value .*/own_window_argb_value $own_window_argb_value/g" $archivo_widget

										sed -i "s/minimum_size .*/minimum_size $minimum_size/g" $archivo_widget
									fi

								done

								echo "Restauración completada correctamente"

							else
								echo "Error: el archivo de respaldo está vacio"
							fi

						else

							echo -e "\n---------------\nOpción inválida\n---------------\n"

						fi
					done

				else
					echo -e "\nNo se encontraron respaldos para $usuario en $carpeta_respaldos"
				fi
				
				
				
			else
				echo "Advertencia: La carpeta de respaldos $carpeta_respaldos no existe"
			fi

		else
			echo $carpeta_widgets_conky" no existe"
		fi

	fi

done
