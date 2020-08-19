#!/bin/bash

CARPETA_ACTUAL=$(pwd)

echo "Buscando archivos con espacios en el nombre"

find ./ -type f -name  "*" | grep " "

echo -e \n--------------------------------
echo Cambiando espacios por "-"

for i in $(find ./ -type d -name  "*"); do
	#statements
	cd $i

	ls

	for f in * ; do mv "$f" "${f// /-}" ; done

	cd $CARPETA_ACTUAL

done

echo "Buscando archivos con espacios en el nombre"

find ./ -type f -name  "*" | grep " "