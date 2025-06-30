#!/bin/bash
USO_RAIZ=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
TAMANO_HOME=$(du -sh /home | awk '{print $1}' | sed 's/G//g')
TIEMPO=$(date "+%Y-%m-%d %H:%M:%S")

touch monitor_disco_health.log


if [ "$USO_RAIZ" -ge 90 ]; then
    echo "¡Alerta: Partición / al ${USO_RAIZ}%! ${TIEMPO}" >> monitor_disco_health.log
fi

if (( $(echo "$TAMANO_HOME > 2" | bc -l) )); then
    echo "¡Alerta: /home ocupa ${TAMANO_HOME}! ${TIEMPO}" >> monitor_disco_health.log
fi