#!/bin/bash

NOMBRE_PAQUETE=conkys-widgets
VERSION_PAQUETE=2.3
ARQUITECTURA_PAQUETE=all

CARPETA_DE_TRABAJO=$NOMBRE_PAQUETE_$VERSION_PAQUETE_$ARQUITECTURA_PAQUETE

# Crear carpeta si no exite
#mkdir -p $CARPETA_DE_TRABAJO

echo Copiar código al instalador
RESPUESTA=""

echo "Abortar = Ctrl+C"
read $RESPUESTA


# Copiar fuentes
rsync -ruvh --progress --delete ../fonts/ conkys-widgets_2.3_all/tmp/conkys-widgets/.fonts/

# Copiar conkys
rsync -ruvh --progress --delete ../conky/ conkys-widgets_2.3_all/tmp/conkys-widgets/.conky/


echo Comparar scripts de respaldo y restauración
RESPUESTA=""

echo "Abortar = Ctrl+C"
read $RESPUESTA



# Copiar scripts
# Revisar cambios
diffuse ../conkys-widgets-backup.sh conkys-widgets_2.3_all/tmp/conkys-widgets/conkys-widgets-backup.sh 
diffuse ../conkys-widgets-restore.sh conkys-widgets_2.3_all/tmp/conkys-widgets/conkys-widgets-restore.sh


echo Copiar scripts
RESPUESTA=""

echo "Abortar = Ctrl+C"
read $RESPUESTA



cp ../conkys-widgets-backup.sh conkys-widgets_2.3_all/tmp/conkys-widgets/
cp ../conkys-widgets-restore.sh conkys-widgets_2.3_all/tmp/conkys-widgets/


echo Actualizar registro de cambios
RESPUESTA=""

echo "Abortar = Ctrl+C"
read $RESPUESTA


# Anotar registro de cambios
gunzip conkys-widgets_2.3_all/usr/share/doc/conkys-widgets/changelog.gz
dedit conkys-widgets_2.3_all/usr/share/doc/conkys-widgets/changelog
gzip conkys-widgets_2.3_all/usr/share/doc/conkys-widgets/changelog


echo Eliminar espacios de los nombres de los archivos
RESPUESTA=""

echo "Abortar = Ctrl+C"
read $RESPUESTA


# Suma de verificación
#/deb/conkys-widgets_2.3_all/DEBIAN/md5sums

# Eliminar espacios de los nombres de los archivos
./elininar-espacios-nombres.sh



echo Crear md5sums
RESPUESTA=""

echo "Abortar = Ctrl+C"
read $RESPUESTA



# limpiar archivo

cd conkys-widgets_2.3_all

cat /dev/null > DEBIAN/md5sums


LISTA_ARCHIVOS=$(find ./ -type f -name  "*" )

for i in $LISTA_ARCHIVOS; do

	# Si no es de la carpeta ./DEBIAN
	if [[ $(echo $i | grep -v -E "^\.\/DEBIAN") ]]; then
		echo $i
		md5sum "$(echo $i | sed "s/^\.\///")" >> DEBIAN/md5sums
	fi
done


cd ..


echo Revisar scripts del .deb
RESPUESTA=""

echo "Abortar = Ctrl+C"
read $RESPUESTA


#Actualizar preinst postinst etc
#/deb/conkys-widgets_2.3_all/DEBIAN/
dde-file-manager conkys-widgets_2.3_all/DEBIAN/


echo Editar control
RESPUESTA=""

echo "Abortar = Ctrl+C"
read $RESPUESTA


#Actualizar control
#/deb/conkys-widgets_2.3_all/DEBIAN/control
dedit conkys-widgets_2.3_all/DEBIAN/control


echo Generar paquete
RESPUESTA=""

echo "Abortar = Ctrl+C"
read $RESPUESTA



dpkg-deb --build conkys-widgets_2.3_all