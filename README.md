# Borg Backup Script

Este script en Bash automatiza la creación de backups cifrados utilizando [BorgBackup](https://borgbackup.readthedocs.io/), junto con notificaciones, logs, limpieza de backups viejos y soporte para ejecución programada con `cron`.

## Requisitos

- Linux (Debian, Ubuntu o derivados)
- [BorgBackup](https://www.borgbackup.org/)
- libnotify (Para  el  envio de notificaciones)
- Cron (para automatización)

## Características

- Cifrado seguro con `--encryption=repokey`
- Eliminación automática de backups viejos (más de 30 días)
- Soporte para almacenamiento externo (pendrive)
- Notificaciones de éxito o falla con `notify-send`
- Log de cada ejecución
- Contraseña almacenada de forma segura en archivo protegido

## Dependencias

```
sudo apt update
sudo apt install borgbackup libnotify-bin cron
```

## Configuración Inicial

1. Creá el archivo ".borg_pass" con tu contraseña
```
echo "mi_contraseña_segura" > ~/.borg_pass
chmod 600 ~/.borg_passphrase
```

2. Preparar el Almacenamiento externo:
- Conectá el USB y ejecutá:
```lsblk -f```
Analiza la salida  y copia la ruta del alcenamiento para el próximo comando

- Desmontar el  pendrive:
```sudo umount /ruta/almacenamiento```

- Crear sistema de archivos ext4 con label "Backup":
```sudo mkfs.ext4 -L Backup /dev/sdb1```

- Borrar todos los  archivos del  almacenamiento:
```sudo rm -rf /ruta/almacenamiento/Backup/*```

-  Volver a  montorla  con comando  o desonectar y conectar nuevamente:
```udisksctl mount -b  /ruta/alamcenamiento```

### A  tener en cuenta: Revisar que las rutas coincidan con las rutas correctas
PATH_ALM_EXTERNO="/media/$USER/Backup" -- Donde se almacena  el  backup
PATH_GUARDAR="/home/$USER" -- Rutas  de  los  archivos a  guardar

##  Ejecución Manual:

1. Permisos correspondientes:
```
chmod +x backup.sh
```

2. Ejecutar:
```
./backup.sh
```

## Automatización con  Cron:

- Edita tu crontab:
```crontab -e```

- Línea para ejecutar el script todos los domingos a las 00:00:
```
0 0 * * 0 /ruta/completa/a/backup.sh
```

## Funcionalidades:

- Backup cifrado con Borg (repokey)
- Limpieza automática con prune (mantiene solo los backups de los últimos 30 días)
- Logs en /home/$USER/backup.log
- Notificaciones en escritorio con notify-send
- Reintentos si el pendrive no está conectado (hasta 3 veces)
