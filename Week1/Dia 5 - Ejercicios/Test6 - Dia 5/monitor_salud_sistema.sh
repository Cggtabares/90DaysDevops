#!/bin/bash
TIEMPO=$(date "+%Y-%m-%d %H:%M:%S")
echo -e "Hora\t\t\tMemoria\t\tDisco (root)\tCPU"
segundos="3600"
fin=$((SECONDS+segundos))
contador=0
file_to_log="alertas_cpu.log"

touch $file_to_log

while [ $SECONDS -lt $fin ]; do
    MEMORIA=$(free -m | awk 'NR==2{printf "%.f%%\t\t", $3*100/$2 } ')
    DISCO=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
    CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf("%.f\n", 100 - $1)}')
    CPU_num=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf("%.f", 100 - $1)}')
    echo -e "$TIEMPO\t$MEMORIA$DISCO$CPU"

    if [[ $CPU_num -gt 16 ]]; then
            ((contador++))
            if [[ $contador -ge 3 ]]; then
                echo " El uso del CPU ha sido mayor a $CPU_num% - $TIEMPO" >> $file_to_log
                break
            fi
    fi
    sleep 3                                                                                                                                        

done