#!/bin/bash
SERVICIO_List=("nginx" "mysql" "docker")

for servicio in "${SERVICIO_List[@]}";
do
        if (systemctl list-unit-files | grep -q "${servicio}.service"); then
                if ! systemctl is-active --quiet "$servicio"; then
                        systemctl start "$servicio"
                        echo "El servicio ${servicio} fue reiniciado."
                fi
        else 
                echo "$servicio no existe"
        fi
done