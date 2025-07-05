#!/bin/bash

#Script para realizar un backup en un almacenamiento externo

#Variables
export BORG_PASSPHRASE=$(<~/.borg_pass)

#PATHS
PATH_ALM_EXTERNO="/media/$USER/Backup"
PATH_GUARDAR="/home/$USER/"
NOMBRE_BACKUP="backup-$(date +%F-%H%M%S)"
LOG="/home/$USER/backup.log"


INTENTOS_MAX=3
intento=0
DELAY=300

#Main
echo "$(date) -  Iniciando el Backup"  >> $LOG 
while [  $intento -lt  $INTENTOS_MAX ]; do
	if [ -d "$PATH_ALM_EXTERNO" ];  then
		borg info "$PATH_ALM_EXTERNO" > /dev/null 2>&1 || borg init --encryption=repokey $PATH_ALM_EXTERNO

		borg  create --stats --progress  \
        	--exclude "$PATH_GUARDAR/Downloads" \
        	--compression zstd \
       		 $PATH_ALM_EXTERNO::$NOMBRE_BACKUP \
       		 "$PATH_GUARDAR"

		#BORRAR LOS BACKUPS CON MAS DE 30 DIAS
		borg  prune --keep-within=30d $PATH_ALM_EXTERNO
		echo "Backup terminado con exito"
		break
	else
		echo "$(date) - Pendrive no conectado, esperando 5 minutos. "  >> $LOG
		notify-send "Backup" "El Pendrive no esta conectado. Intentando otra vez en 5 minutos..."
		sleep $DELAY
	fi
	intento=$((intento + 1))	
done

if [ $intento -eq $INTENTOS_MAX ]; then
	echo "$(date) -   Pendrive no  encontrado, cancelando el  backup." >> $LOG
	exit 1
fi  
echo "$(date) -  Finalizado el Backup"  >> $LOG
