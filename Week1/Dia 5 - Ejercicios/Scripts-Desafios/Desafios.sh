!#/bin/bash

#Desafío 1: Escribe un script simple de Bash que imprima 
#Hllo DevOps" junto con la fecha y hora actual.

echo " Hello World!  $(date +'%Y-%m-%d %H:%M:%S')"

#Desafío 2: Crea un script que verifique si un sitio web (ej., https://roxs.295devops.com) 
#es accesible usando curl o ping. Imprime un mensaje de éxito o fallo.

URL="https://roxs.295devops.com"

if curl -s --head "$URL" | grep "200 OK" > /dev/null; then
    echo "El sitio web $URL es accesible."
else
    echo "El sitio web $URL no es accesible."
fi

#🔹 Desafío 3: Escribe un script que tome un nombre de archivo como argumento, 
#verifique si existe, e imprima el contenido del archivo en consecuencia.

FILENAME="archivo.txt"  
if [-f "$FILENAME"]; then
    echo "El archivo $FILENAME existe. Contenido:"
    cat "$FILENAME"
else
    echo "El archivo $FILENAME no existe."
fi

#Desafío 4: Crea un script que liste todos los procesos en ejecución 
#y escriba la salida a un archivo llamado process_list.txt.
ps aux > process_list.txt


#Desafío 5: Escribe un script que instale múltiples paquetes a la vez (ej., git, vim, curl). 
#El script debe verificar si cada paquete ya está instalado antes de intentar la instalación.
instalar=(
    "git"
    "curl"
    "wget"
    "vim"
    "htop"
)

for package in "${instalar[@]}"; do
    if ! dpkg -l | grep -q "$package"; then
        echo "Instalando $package..."
        sudo apt-get install -y "$package"
    else
        echo "$package ya está instalado."
    fi
done

#Desafío 6: Crea un script que monitoree el uso de CPU y memoria cada 5 
#segundos y registre los resultados en un archivo.
TIEMPO=$(date "+%Y-%m-%d %H:%M:%S")
echo -e "Hora\t\t\tMemoria\t\tCPU"

    MEMORIA=$(free -m | awk 'NR==2{printf "%.f%%\t\t", $3*100/$2 }')
    CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf("%.f\n", 100 - $1)}')
    echo -e "Hora\t\t\tMemoria\t\tDisco (root)\tCPU" >> uso_recursos.txt

#CRON 
5 * * * * /ruta/al/script.sh >> /ruta/al/uso_recursos.txt 2>&1

#Desafío 7: Escribe un script que elimine automáticamente archivos de 
#log mayores a 7 días desde /var/log.

find "/var/log" -type f -name "*.log" -mtime +7 -exec rm {} \;

# Desafío 8: Automatiza la creación de cuentas de usuario – Escribe un script que tome el nombre de 
#usuario como argumento, verifique si el usuario existe, dé el mensaje "el usuario ya existe", de lo 
#contrario cree un nuevo usuario, lo agregue a un grupo "devops", y configure un directorio home por 
#defecto.

crear_usuario() {
    # Comprobar si el usuario ya existe
    if id "$1" &>/dev/null; then
        echo "El usuario '$1' ya existe."
    else
        # Crear el usuario
        sudo useradd $1
        echo "Usuario '$1' creado exitosamente."
        # Registrar la acción en el log
        echo "$(date): Usuario '$1' creado." >> usuarios.log
    fi
}

read -p "Coloque el usuario que desea crear: " usuario
if [ -z "$1" ]; then
    echo "Debe proporcionar un nombre de usuario."
    exit 1
fi

crear_usuario "$1"

#Desafío 9: Usa awk o sed en un script para procesar un archivo de log y extraer solo los mensajes 
#de error.
awk '/error/ {print $0}' /var/log/syslog > errores.log

#Desafío 10: Configura un cron job que ejecute un script para hacer respaldo (zip/tar) de un 
#directorio diariamente.
DIRECTORIO="/ruta/al/directorio"
RESPALDO="/ruta/al/respaldo"
FECHA=$(date +'%Y-%m-%d')
tar -czf "$RESPALDO/respaldo_$FECHA.tar.gz" "$DIRECTORIO"   
# Agregar al cron job
# 0 0 * * * /ruta/al/script_de_respaldo.sh >> /ruta/al/cron.log 2>&1

