#!/bin/bash

# Configuración: niveles de batería
LOW_BATT=20
CRITICAL_BATT=10

while true; do
    # Obtener capacidad y estado (BAT0 o BAT1 dependiendo de tu laptop)
    BATTERY_PATH=$(ls /sys/class/power_supply/ | grep BAT | head -n 1)
    CAPACITY=$(cat /sys/class/power_supply/$BATTERY_PATH/capacity)
    STATUS=$(cat /sys/class/power_supply/$BATTERY_PATH/status)

    if [ "$STATUS" = "Discharging" ]; then
        if [ "$CAPACITY" -le "$CRITICAL_BATT" ]; then
            notify-send -u critical -i battery-empty -h string:x-dunst-stack-tag:battery "BATERÍA CRÍTICA" "Conecta el cargador inmediatamente: $CAPACITY%"
        elif [ "$CAPACITY" -le "$LOW_BATT" ]; then
            notify-send -u normal -i battery-low -h string:x-dunst-stack-tag:battery "Batería Baja" "Te queda el $CAPACITY%"
        fi
    fi

    # Si se acaba de conectar el cargador y está lleno (opcional)
    if [ "$STATUS" = "Full" ]; then
         notify-send -u low -i battery-full -h string:x-dunst-stack-tag:battery "Batería Cargada" "Ya puedes desconectar el cable"
    fi

    sleep 60 # Revisa cada minuto
done
