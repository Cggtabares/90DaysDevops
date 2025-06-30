#!/bin/bash
# gestion_usuarios.sh
#  Objetivo: Crear un script llamado gestion_usuarios.sh que permita:

# Crear un nuevo usuario pasando el nombre como argumento
# Validar si el usuario ya existe
# Registrar la acción en un log (usuarios.log)
# Usar una función llamada crear_usuario definida en un archivo funciones.sh

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